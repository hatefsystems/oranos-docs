#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# This is a repository-maintained configuration file, not untrusted user input.
# shellcheck source=../config/chromium-revision.env
source "$REPO_ROOT/config/chromium-revision.env"

if [[ -z "${CHROMIUM_REVISION:-}" ]]; then
  echo "Error: set CHROMIUM_REVISION in config/chromium-revision.env to a reviewed stable tag or full SHA." >&2
  exit 2
fi

if [[ ! "$CHROMIUM_REVISION" =~ ^([0-9a-f]{40}|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  echo "Error: expected a 40-character lowercase SHA or four-part Chromium version tag." >&2
  exit 2
fi

if ! command -v fetch >/dev/null 2>&1 || ! command -v gclient >/dev/null 2>&1; then
  echo "Error: install depot_tools and add it to PATH before running this script." >&2
  exit 2
fi

WORKSPACE="${1:-$HOME/oranos-workspace}"
mkdir -p "$WORKSPACE"
cd "$WORKSPACE"

if [[ ! -d src/.git ]]; then
  if [[ -e src ]]; then
    echo "Error: src exists but is not a Git checkout; refusing to overwrite it." >&2
    exit 2
  fi
  fetch --nohooks android
fi

cd src
if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: Chromium checkout has local changes; use a clean checkout for source upgrades." >&2
  exit 2
fi

git fetch origin --tags
git checkout --detach "$CHROMIUM_REVISION"
gclient sync --nohooks

echo "Chromium source pinned at: $(git rev-parse HEAD)"
echo "Next: run ./build/install-build-deps.sh and gclient runhooks from $WORKSPACE/src"
echo "No Oranos patches have been applied."
