#!/usr/bin/env bash
# Updates KUBECTL_VERSION, the renovate-local comment tags, and both architecture
# checksums in hack/make/deps.mk.
#
# Usage:
#   ./scripts/update-kubectl.sh v1.35.3
#   ./scripts/update-kubectl.sh          # re-hashes whatever KUBECTL_VERSION is already set to

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPS_MK="${SCRIPT_DIR}/../hack/make/deps.mk"

usage() {
  echo "Usage: $0 [VERSION]"
  echo "  VERSION  kubectl version to set, e.g. v1.35.3 (optional; defaults to current KUBECTL_VERSION)"
  exit 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
fi

NEW_VERSION="${1:-}"

# Read current version from the file
CURRENT_VERSION="$(grep -E '^KUBECTL_VERSION :=' "${DEPS_MK}" | sed 's/KUBECTL_VERSION := //')"

if [[ -z "${NEW_VERSION}" ]]; then
  NEW_VERSION="${CURRENT_VERSION}"
  echo "No version supplied; re-hashing current version: ${NEW_VERSION}"
else
  # Normalise: ensure leading 'v'
  [[ "${NEW_VERSION}" == v* ]] || NEW_VERSION="v${NEW_VERSION}"
fi

if [[ -z "${NEW_VERSION}" ]]; then
  echo "ERROR: Could not determine kubectl version." >&2
  exit 1
fi

echo "Updating kubectl to ${NEW_VERSION} in ${DEPS_MK}"

# ------------------------------------------------------------------
# Fetch checksums from the official Kubernetes release CDN
# ------------------------------------------------------------------
fetch_sha256() {
  local arch="$1"
  local url="https://dl.k8s.io/release/${NEW_VERSION}/bin/linux/${arch}/kubectl.sha256"
  echo "  Fetching ${arch} checksum from ${url}" >&2
  curl --silent --fail --location "${url}" | awk '{print $1}'
}

SHA256_AMD64="$(fetch_sha256 amd64)"
SHA256_ARM64="$(fetch_sha256 arm64)"

if [[ -z "${SHA256_AMD64}" || -z "${SHA256_ARM64}" ]]; then
  echo "ERROR: Failed to retrieve one or both checksums." >&2
  exit 1
fi

echo "  amd64: ${SHA256_AMD64}"
echo "  arm64: ${SHA256_ARM64}"

# ------------------------------------------------------------------
# Update the file with a single sed invocation (BSD + GNU compat)
# ------------------------------------------------------------------
# We target exactly the lines Renovate mis-manages:
#   KUBECTL_VERSION := <old>
#   # renovate-local: kubectl-arm64=<old>
#   KUBECTL_SUM_arm64 := <old>
#   # renovate-local: kubectl-amd64=<old>
#   KUBECTL_SUM_amd64 := <old>

# Use a temp file so we can validate before overwriting
TMP="$(mktemp)"
trap 'rm -f "${TMP}"' EXIT

sed \
  -e "s|^KUBECTL_VERSION :=.*|KUBECTL_VERSION := ${NEW_VERSION}|" \
  -e "s|^# renovate-local: kubectl-arm64=.*|# renovate-local: kubectl-arm64=${NEW_VERSION}|" \
  -e "s|^KUBECTL_SUM_arm64 :=.*|KUBECTL_SUM_arm64 := ${SHA256_ARM64}|" \
  -e "s|^# renovate-local: kubectl-amd64=.*|# renovate-local: kubectl-amd64=${NEW_VERSION}|" \
  -e "s|^KUBECTL_SUM_amd64 :=.*|KUBECTL_SUM_amd64 := ${SHA256_AMD64}|" \
  "${DEPS_MK}" > "${TMP}"

# Quick sanity check: the new version string must appear in the output
if ! grep -q "${NEW_VERSION}" "${TMP}"; then
  echo "ERROR: Sanity check failed — version string not found in updated file." >&2
  exit 1
fi

cp "${TMP}" "${DEPS_MK}"
echo "Done. ${DEPS_MK} updated successfully."