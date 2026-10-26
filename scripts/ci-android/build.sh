#!/usr/bin/env bash
# Build the official Chromium Android public APK from a selected Oranos fork
# branch on a suitably provisioned GitHub-hosted Ubuntu larger runner.
set -Eeuo pipefail

WORKSPACE="${1:?Usage: build.sh WORKSPACE ORANOS_SOURCE_BRANCH}"
SOURCE_BRANCH="${2:?Usage: build.sh WORKSPACE ORANOS_SOURCE_BRANCH}"

# Only accept ordinary branch names, never arbitrary Git fetch options.
if [[ ! "$SOURCE_BRANCH" =~ ^[a-zA-Z0-9][a-zA-Z0-9._/-]{0,100}$ ]] ||
   [[ "$SOURCE_BRANCH" == *..* ]] ||
   [[ "$SOURCE_BRANCH" == *///* ]] ||
   [[ "$SOURCE_BRANCH" == */ ]] ||
   [[ "$SOURCE_BRANCH" == *.lock ]]; then
  echo "::error::Invalid source branch name."
  exit 2
fi
git check-ref-format --branch "$SOURCE_BRANCH" >/dev/null

mkdir -p "$WORKSPACE"
cd "$WORKSPACE"
if [[ -e src || -e .gclient ]]; then
  echo "::error::Workspace is not empty. Refusing to reuse an unknown Chromium checkout."
  exit 2
fi

export PATH="$PATH:$RUNNER_TEMP/depot_tools"
git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git "$RUNNER_TEMP/depot_tools"

# Chromium's official bootstrap configures its Android DEPS solution and
# downloads the source checkout, not just the GitHub fork's Git tree.
fetch --nohooks --no-history android
cd "$WORKSPACE/src"

git remote add oranos https://github.com/hatefsystems/oranos.git
git fetch --no-tags --depth=1 oranos "refs/heads/$SOURCE_BRANCH"
git checkout --detach FETCH_HEAD
SOURCE_SHA="$(git rev-parse HEAD)"
echo "Oranos source revision: $SOURCE_SHA"

# Sync Chromium dependency revisions matching this exact source checkout.
# A consistency check protects us from accidentally building a moving HEAD.
gclient sync --nohooks
if [[ "$(git rev-parse HEAD)" != "$SOURCE_SHA" ]]; then
  echo "::error::gclient changed the source checkout unexpectedly; refusing to build a different revision."
  exit 1
fi

./build/install-build-deps.sh --no-prompt
gclient runhooks

gn gen out/oranos-android --args='target_os="android" target_cpu="arm64" is_debug=false is_component_build=false symbol_level=0 use_remoteexec=false is_java_debug=true'
autoninja -C out/oranos-android -j 8 chrome_public_apk

APK_PATH="$WORKSPACE/src/out/oranos-android/apks/ChromePublic.apk"
if [[ ! -s "$APK_PATH" ]]; then
  echo "::error::Expected nonempty APK not found: $APK_PATH"
  find out/oranos-android -type f -name '*.apk' -print || true
  exit 1
fi

ARTIFACTS="$WORKSPACE/artifacts"
mkdir -p "$ARTIFACTS"
cp "$APK_PATH" "$ARTIFACTS/ChromePublic-arm64.apk"
cat > "$ARTIFACTS/build-info.txt" <<EOF
source_repository=https://github.com/hatefsystems/oranos
source_branch=$SOURCE_BRANCH
source_commit=$SOURCE_SHA
target_cpu=arm64
build_target=chrome_public_apk
build_type=development
release_signed=false
oranos_branding_verified=false
EOF
(
  cd "$ARTIFACTS"
  sha256sum ChromePublic-arm64.apk > SHA256SUMS.txt
)
echo "Built APK: $ARTIFACTS/ChromePublic-arm64.apk"
