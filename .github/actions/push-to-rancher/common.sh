#!/usr/bin/env bash
# Shared setup for push-to-rancher scripts. Source this file: source "$(dirname "$0")/common.sh"

RANCHER_DIR="${RANCHER_DIR:-}"

declare -A SHELL_MINOR_TO_RANCHER_BRANCH=(
  ["0.8"]="release/v2.15"
  ["0.7"]="release/v2.14"
  ["0.6"]="release/v2.13"
  ["0.5"]="release/v2.12"
  ["0.4"]="release/v2.11"
  ["0.3"]="release/v2.10"
)

if [ -n "${TARGET_BRANCHES:-}" ]; then
  read -ra RANCHER_BRANCHES <<< "${TARGET_BRANCHES}"
fi

IMAGE_REGISTRY="${IMAGE_REGISTRY:-docker.io}"
IMAGE_REPO="${IMAGE_REPO:-rancher/shell}"

summary() {
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    echo "$@" >> "$GITHUB_STEP_SUMMARY"
  fi
  echo "$@"
}

require_var() {
  local var="$1"
  if [ -z "${!var:-}" ]; then
    echo "ERROR: $var is required" >&2
    exit 1
  fi
}

require_rancher_dir() {
  require_var RANCHER_DIR
  if [ ! -d "$RANCHER_DIR" ]; then
    echo "ERROR: RANCHER_DIR '$RANCHER_DIR' does not exist" >&2
    exit 1
  fi
}

shell_minor() {
  local v="${1#rancher/shell:}"
  v="${v#v}"
  echo "$v" | cut -d. -f1-2
}

validate_image_exists() {
  local tag="$1"
  local full_image="${IMAGE_REGISTRY}/${IMAGE_REPO}:${tag}"

  summary "- Validating image exists: \`$full_image\`"

  if ! docker manifest inspect "$full_image" >/dev/null 2>&1; then
    echo "ERROR: Image $full_image does not exist in registry" >&2
    echo "ERROR: Cannot proceed with PR creation until image is published" >&2
    exit 1
  fi

  summary "  ✓ Image validated"
}

commit_if_changed() {
  local message="$1"
  if git -C "$RANCHER_DIR" diff --quiet --exit-code && [ -z "$(git -C "$RANCHER_DIR" status --porcelain)" ]; then
    return 1
  fi
  git -C "$RANCHER_DIR" add .
  git -C "$RANCHER_DIR" commit -m "$message"
}
