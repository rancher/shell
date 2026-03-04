#!/usr/bin/env bash
# Updates KUSTOMIZE_VERSION, the renovate-local comment tags, and both architecture
# checksums in hack/make/deps.mk.
#
# Usage:
#   ./scripts/update-kustomize.sh v5.7.0
#   ./scripts/update-kustomize.sh          # re-hashes whatever KUSTOMIZE_VERSION is already set to

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPS_MK="${SCRIPT_DIR}/../hack/make/deps.mk"

usage() {
  echo "Usage: $0 [VERSION]"
  echo "  VERSION  kustomize version to set, e.g. v5.7.0 (optional; defaults to current KUSTOMIZE_VERSION)"
  exit 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
fi

NEW_VERSION="${1:-}"

# Read current version from the file
CURRENT_VERSION="$(grep -E '^KUSTOMIZE_VERSION :=' "${DEPS_MK}" | sed 's/KUSTOMIZE_VERSION := //')"

if [[ -z "${NEW_VERSION}" ]]; then
  NEW_VERSION="${CURRENT_VERSION}"
  echo "No version supplied; re-hashing current version: ${NEW_VERSION}"
else
  # Normalise: ensure leading 'v'
  [[ "${NEW_VERSION}" == v* ]] || NEW_VERSION="v${NEW_VERSION}"
fi

if [[ -z "${NEW_VERSION}" ]]; then
  echo "ERROR: Could not determine kustomize version." >&2
  exit 1
fi

echo "Updating kustomize to ${NEW_VERSION} in ${DEPS_MK}"

# ------------------------------------------------------------------
# Fetch checksums from the GitHub release assets
# ------------------------------------------------------------------
# Release URL format: https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.6.0/checksums.txt
# Checksum lines look like: <sha256>  kustomize_v5.6.0_linux_amd64.tar.gz

fetch_sha256() {
  local arch="$1"
  local url="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${NEW_VERSION}/checksums.txt"
  echo "  Fetching ${arch} checksum from ${url}" >&2
  curl --silent --fail --location "${url}" \
    | grep "kustomize_${NEW_VERSION}_linux_${arch}\.tar\.gz" \
    | awk '{print $1}'
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
#   KUSTOMIZE_VERSION := <old>
#   # renovate-local: kustomize-arm64=<old>
#   KUSTOMIZE_SUM_arm64 := <old>
#   # renovate-local: kustomize-amd64=<old>
#   KUSTOMIZE_SUM_amd64 := <old>

# Use a temp file so we can validate before overwriting
TMP="$(mktemp)"
trap 'rm -f "${TMP}"' EXIT

sed \
  -e "s|^KUSTOMIZE_VERSION :=.*|KUSTOMIZE_VERSION := ${NEW_VERSION}|" \
  -e "s|^# renovate-local: kustomize-arm64=.*|# renovate-local: kustomize-arm64=${NEW_VERSION}|" \
  -e "s|^KUSTOMIZE_SUM_arm64 :=.*|KUSTOMIZE_SUM_arm64 := ${SHA256_ARM64}|" \
  -e "s|^# renovate-local: kustomize-amd64=.*|# renovate-local: kustomize-amd64=${NEW_VERSION}|" \
  -e "s|^KUSTOMIZE_SUM_amd64 :=.*|KUSTOMIZE_SUM_amd64 := ${SHA256_AMD64}|" \
  "${DEPS_MK}" > "${TMP}"

# Quick sanity check: the new version string must appear in the output
if ! grep -q "${NEW_VERSION}" "${TMP}"; then
  echo "ERROR: Sanity check failed — version string not found in updated file." >&2
  exit 1
fi

cp "${TMP}" "${DEPS_MK}"
echo "Done. ${DEPS_MK} updated successfully."