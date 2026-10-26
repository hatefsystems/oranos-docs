#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="${1:-$HOME/oranos-workspace}"
SOURCE="$WORKSPACE/src"

if [[ ! -d "$SOURCE/.git" ]]; then
  echo "Error: Chromium source checkout not found at $SOURCE" >&2
  exit 2
fi

if ! command -v gn >/dev/null 2>&1 || ! command -v autoninja >/dev/null 2>&1; then
  echo "Error: install depot_tools and add it to PATH." >&2
  exit 2
fi

cd "$SOURCE"
gn gen out/oranos-android --args='target_os="android" target_cpu="arm64" is_debug=false use_remoteexec=false'
autoninja -C out/oranos-android chrome_public_apk

echo "Built upstream Chromium target, NOT a branded Oranos release."
