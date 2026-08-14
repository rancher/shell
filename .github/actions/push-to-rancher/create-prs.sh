#!/usr/bin/env bash
# Creates PRs to rancher/rancher branches with the updated shell image tag.
#
# Required env vars:
#   TAG          - shell tag (e.g. v0.8.1)
#   RANCHER_DIR  - path to rancher/rancher clone
#   GH_TOKEN     - GitHub token for PR creation
#   SOURCE_REPO  - source repo for PR body (e.g. rancher/shell)
#
# RANCHER_BRANCHES (from common.sh) must already be populated - see run.sh.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

require_var TAG
require_var GH_TOKEN
require_rancher_dir

SOURCE_REPO="${SOURCE_REPO:-rancher/shell}"

if [ "${#RANCHER_BRANCHES[@]:-0}" -eq 0 ]; then
  summary "- No target branches selected - nothing to do"
  exit 0
fi

summary ""
summary "## Processing branches"

FAILED_BRANCHES=()

for TARGET_BRANCH in "${RANCHER_BRANCHES[@]}"; do
  summary ""
  summary "### Branch: \`$TARGET_BRANCH\`"

  if ! git -C "$RANCHER_DIR" fetch origin "$TARGET_BRANCH" 2>&1; then
    summary "  ⚠️  Failed to fetch branch \`$TARGET_BRANCH\` - skipping"
    FAILED_BRANCHES+=("$TARGET_BRANCH (fetch failed)")
    continue
  fi

  if ! git -C "$RANCHER_DIR" checkout -B "$TARGET_BRANCH" "origin/$TARGET_BRANCH" 2>&1; then
    summary "  ⚠️  Failed to checkout branch \`$TARGET_BRANCH\` - skipping"
    FAILED_BRANCHES+=("$TARGET_BRANCH (checkout failed)")
    continue
  fi

  TARGET_SUFFIX="${TARGET_BRANCH#release/}"
  BRANCH_NAME="bot/shell-${TAG}-${TARGET_SUFFIX}-$(date +%s)"
  if ! git -C "$RANCHER_DIR" checkout -b "$BRANCH_NAME" 2>&1; then
    summary "  ⚠️  Failed to create branch \`$BRANCH_NAME\` - skipping"
    FAILED_BRANCHES+=("$TARGET_BRANCH (branch creation failed)")
    continue
  fi

  export TAG RANCHER_DIR
  if ! bash "$SCRIPT_DIR/update-build-yaml.sh"; then
    summary "  ⚠️  Failed to update build.yaml - skipping"
    FAILED_BRANCHES+=("$TARGET_BRANCH (update failed)")
    git -C "$RANCHER_DIR" checkout "$TARGET_BRANCH"
    git -C "$RANCHER_DIR" branch -D "$BRANCH_NAME" || true
    continue
  fi

  # go generate regenerates pkg/buildconfig/constants.go and chart/values.yaml's
  GENERATE_FILE="$RANCHER_DIR/generate.go"
  if [ ! -f "$GENERATE_FILE" ]; then
    summary "  ⚠️  generate.go not found - skipping"
    FAILED_BRANCHES+=("$TARGET_BRANCH (no generate.go)")
    git -C "$RANCHER_DIR" checkout "$TARGET_BRANCH"
    git -C "$RANCHER_DIR" branch -D "$BRANCH_NAME" || true
    continue
  fi

  GENERATE_CMD=$(grep -m 1 '^//go:generate' "$GENERATE_FILE" | sed 's|^//go:generate ||')
  if [ -z "$GENERATE_CMD" ]; then
    summary "  ⚠️  No go:generate directive found in generate.go - skipping"
    FAILED_BRANCHES+=("$TARGET_BRANCH (no generate directive)")
    git -C "$RANCHER_DIR" checkout "$TARGET_BRANCH"
    git -C "$RANCHER_DIR" branch -D "$BRANCH_NAME" || true
    continue
  fi

  summary "  - Running: \`$GENERATE_CMD\`"
  if ! (cd "$RANCHER_DIR" && eval "$GENERATE_CMD"); then
    summary "  ⚠️  go generate failed - skipping"
    FAILED_BRANCHES+=("$TARGET_BRANCH (go generate failed)")
    git -C "$RANCHER_DIR" checkout "$TARGET_BRANCH"
    git -C "$RANCHER_DIR" branch -D "$BRANCH_NAME" || true
    continue
  fi

  COMMIT_MSG="Update shell to ${TAG}

Automated update from ${SOURCE_REPO} release ${TAG}

Automation: push-to-rancher
Created-by: shell-release-integration"

  if ! commit_if_changed "$COMMIT_MSG"; then
    exit_code=$?
    if [ "$exit_code" -eq 1 ]; then
      summary "  ℹ️  No changes detected - skipping"
    else
      summary "  ⚠️  Failed to commit changes - skipping"
      FAILED_BRANCHES+=("$TARGET_BRANCH (commit failed)")
    fi
    git -C "$RANCHER_DIR" checkout "$TARGET_BRANCH"
    git -C "$RANCHER_DIR" branch -D "$BRANCH_NAME" || true
    continue
  fi

  summary "  - Pushing branch \`$BRANCH_NAME\`"
  if ! git -C "$RANCHER_DIR" push -u origin "$BRANCH_NAME"; then
    summary "  ⚠️  Failed to push branch - skipping PR creation"
    FAILED_BRANCHES+=("$TARGET_BRANCH (push failed)")
    git -C "$RANCHER_DIR" checkout "$TARGET_BRANCH"
    continue
  fi

  summary "  - Creating PR..."

  BRANCH_LABEL="${TARGET_BRANCH#release/}"

  PR_BODY="## Summary
Update shell image to [\`${TAG}\`](https://github.com/${SOURCE_REPO}/releases/tag/${TAG})

## Changes
- Updated \`defaultShellVersion\` in \`build.yaml\`
- Ran \`go generate\` to update generated files (\`pkg/buildconfig/constants.go\`, \`chart/values.yaml\`)"

  if gh pr create \
    --repo rancher/rancher \
    --base "$TARGET_BRANCH" \
    --head "$BRANCH_NAME" \
    --title "[${BRANCH_LABEL}] Update shell to ${TAG}" \
    --body "$PR_BODY" \
    --label "status/auto-created" 2>&1; then
    summary "  ✓ PR created successfully"
  else
    summary "  ⚠️  Failed to create PR"
    FAILED_BRANCHES+=("$TARGET_BRANCH (PR creation failed)")
  fi

  git -C "$RANCHER_DIR" checkout "$TARGET_BRANCH"
done

summary ""
summary "## Summary"

if [ ${#FAILED_BRANCHES[@]} -eq 0 ]; then
  summary "✅ All branches processed successfully"
else
  summary "⚠️  Some branches failed:"
  for branch in "${FAILED_BRANCHES[@]}"; do
    summary "  - $branch"
  done
  exit 1
fi
