# Developer Setup: Android

**Status:** Instructions for building a baseline upstream Chromium APK. These steps do not yet produce a branded Oranos APK.

Reference: https://chromium.googlesource.com/chromium/src/+/main/docs/android_build_instructions.md

## Requirements

Use a supported x86-64 Linux machine with ample SSD space, RAM, disk I/O, and bandwidth. Chromium checkouts, their dependencies, and their build outputs are large. These instructions assume Ubuntu with standard build dependencies and Git available. A build runner is not a substitute for reproducible source pinning.

## Install depot_tools

```bash
mkdir -p "$HOME/dev"
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git "$HOME/dev/depot_tools"
export PATH="$HOME/dev/depot_tools:$PATH"
```

Persist the PATH setting in your shell configuration. Confirm `fetch`, `gclient`, `gn`, and `autoninja` can be found as appropriate.

## Choose a reviewed upstream revision

Edit `config/chromium-revision.env` in this Oranos repository. Set `CHROMIUM_REVISION` to a **real reviewed Chromium release tag** or exact **40-character upstream commit SHA**. This repository deliberately does not pin an arbitrary version before a supported baseline is chosen.

## Download and pin Chromium

From the Oranos repository checkout:

```bash
./scripts/bootstrap-android.sh "$HOME/oranos-workspace"
```

The script performs the first `fetch --nohooks android` if needed, checks out the selected revision, and runs `gclient sync --nohooks`. It does not modify the tracked Oranos repository or apply unpublished patches.

Install build prerequisites and run Chromium hooks:

```bash
cd "$HOME/oranos-workspace/src"
./build/install-build-deps.sh
gclient runhooks
```

If upstream instructions change for the pinned revision, **follow the instructions bundled with that revision**.

## Build baseline Chromium for Android ARM64

```bash
./scripts/build-android.sh "$HOME/oranos-workspace"
```

Equivalent manual commands from Chromium's `src` directory:

```bash
gn gen out/oranos-android --args='target_os="android" target_cpu="arm64" is_debug=false use_remoteexec=false'
autoninja -C out/oranos-android chrome_public_apk
```

The upstream `chrome_public_apk` target currently targets Android 10 and later. Support for earlier Android versions must not be assumed for a recent revision.

## Install a development APK

With an Android device configured for USB debugging:

```bash
cd "$HOME/oranos-workspace/src"
out/oranos-android/bin/chrome_public_apk install
```

This installs **Chromium**, not a branded or release-signed Oranos build. Confirm the exact command and target supported by the pinned source revision.

## Product implementation milestones

Implement and verify independently: product name and assets, unique Android application ID, default search provider with user choice, privacy UX, signing, update channel, and integration tests. Avoid committing signing keys, tokens, or device credentials.

## Other systems

Windows requires Windows-specific toolchains and packaging. Linux desktop can be built on Linux with Chromium's Linux guide. macOS requires macOS tools and signing/notarization planning. iOS must not be advertised as identical to Android Chromium before its engine and distribution constraints have been verified.

## Developer validation

At minimum: baseline build succeeds, APK launches, multiple HTTPS sites work, TLS failures are rejected, and basic navigation, downloads, tabs, and sandbox behavior are exercised. These validations have **not** yet been run by Oranos CI.
