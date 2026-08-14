#!/usr/bin/env bash
# Entry point: orchestrates the full rancher/rancher update. Called from action.yml
# after token generation.
#
# Required env vars:
#   TAG          - shell tag (e.g. v0.8.1)
#   GH_TOKEN     - GitHub app token with access to rancher/rancher
#   SOURCE_REPO  - source repo (github.repository)
#   RANCHER_DIR  - path to clone rancher/rancher into

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

require_var TAG
require_var GH_TOKEN

export RANCHER_DIR

summary "## Push to rancher/rancher"
summary "- Tag: \`$TAG\`"
summary ""

validate_image_exists "$TAG"

NEW_MINOR="$(shell_minor "$TAG")"
TARGET_BRANCHES="${SHELL_MINOR_TO_RANCHER_BRANCH[$NEW_MINOR]:-}"
if [ -z "$TARGET_BRANCHES" ]; then
  summary "- No rancher/rancher branch maps to shell minor \`$NEW_MINOR\` - exiting"
  exit 0
fi
export TARGET_BRANCHES
summary "- Shell minor \`$NEW_MINOR\` maps to \`${TARGET_BRANCHES}\`"

git clone "https://oauth2:${GH_TOKEN}@github.com/rancher/rancher.git" "$RANCHER_DIR"

git -C "$RANCHER_DIR" config user.name "github-actions[bot]"
git -C "$RANCHER_DIR" config user.email "github-actions[bot]@users.noreply.github.com"

summary ""
summary "## Creating PRs"

export SOURCE_REPO="${SOURCE_REPO:-rancher/shell}"
bash "$SCRIPT_DIR/create-prs.sh"

summary ""
summary "## Workflow Complete"
