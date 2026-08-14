#!/usr/bin/env bash
# Updates defaultShellVersion in build.yaml to TAG.
#
# Required env vars:
#   TAG          - shell tag (e.g. v0.8.1)
#   RANCHER_DIR  - path to rancher/rancher clone

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

require_var TAG
require_rancher_dir

BUILD_YAML="$RANCHER_DIR/build.yaml"

if [ ! -f "$BUILD_YAML" ]; then
  echo "ERROR: build.yaml not found at $BUILD_YAML" >&2
  exit 1
fi

TAG_NORMALIZED="$TAG"
if [[ "$TAG_NORMALIZED" != v* ]]; then
  TAG_NORMALIZED="v${TAG_NORMALIZED}"
fi

yq eval ".defaultShellVersion = \"rancher/shell:${TAG_NORMALIZED}\"" -i "$BUILD_YAML"

summary "  - Updated build.yaml: \`defaultShellVersion: rancher/shell:${TAG_NORMALIZED}\`"
