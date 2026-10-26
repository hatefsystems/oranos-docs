# Android APK Build on GitHub-hosted Runners

**Status:** Workflow implemented. Full Chromium APK build **has not yet been verified**.

## Locations and ownership

- Browser GitHub fork: https://github.com/hatefsystems/oranos
- CI configuration: [`.github/workflows/android-apk.yml`](../.github/workflows/android-apk.yml)
- Build script: [`scripts/ci-android/build.sh`](../scripts/ci-android/build.sh)
- This workflow lives in **`hatefsystems/oranos-docs`**, to keep the browser fork's `main` branch identical to upstream Chromium.

The job downloads Chromium through the official `depot_tools` workflow, fetches the requested branch from the **Oranos GitHub fork**, synchronizes Chromium's `DEPS`, generates Android ARM64 build files, runs `autoninja`, and uploads the generated development APK, SHA-256 digest, and source revision.

## GitHub-hosted runner prerequisite

**Do not select a standard `ubuntu-24.04` runner for a full Chromium Android build.** The standard public GitHub-hosted runner typically has 14 GB SSD, whereas Chromium documents **at least 100 GB** of free disk space as a build requirement. The workflow performs a preflight check and stops if insufficient space is available.

Provision a GitHub-hosted **larger runner** in the Hatef Systems GitHub organization's Actions settings. A practical initial size is **8 vCPU, 32 GB RAM, and 300 GB SSD** on Ubuntu (x64). Assign its runner group to **`hatefsystems/oranos-docs`**.

1. In GitHub, open the **hatefsystems** organization Settings and locate **Actions > Runners** (the exact menu may vary by plan).
2. Provision an eligible **GitHub-hosted larger runner**, not a self-hosted machine. Use Ubuntu x64 with 8 cores, 32 GB RAM, and 300 GB SSD or better.
3. Record the runner's **exact GitHub Actions label**. A possible name is `ubuntu-latest-8-cores`, but the actual assigned label depends on the configuration.
4. Make that runner available to the `oranos-docs` repository.
5. Open `oranos-docs > Settings > Secrets and variables > Actions > Variables` and set the repository variable `ORANOS_ANDROID_RUNNER` to that exact label.

GitHub-hosted larger runners are subject to account eligibility, organization configuration, and **usage-based billing**. Their availability should not be assumed from the public repository or default Actions enablement. Standard hosted runners can validate the CI scripts, but do not have enough disk for this full-source build.

Official references:

- https://docs.github.com/en/actions/reference/runners/github-hosted-runners
- https://docs.github.com/en/actions/reference/runners/larger-runners
- https://chromium.googlesource.com/chromium/src/+/main/docs/android_build_instructions.md

## Execute the build

The full build is **manual only**. This avoids large unplanned billing from every upstream commit. It supports either upstream `main` for a baseline or a dedicated Oranos branch when one exists.

GitHub UI:

1. Visit https://github.com/hatefsystems/oranos-docs/actions/workflows/android-apk.yml.
2. Select **Run workflow**, choose `master` for this CI repository.
3. Enter `source_branch=main` for an upstream baseline, or a real branch such as `oranos/android-alpha` once created in `hatefsystems/oranos`.
4. Start the workflow.
5. After a successful run, download **`chromium-android-arm64-<run_number>`** from the run's **Artifacts** section.

GitHub CLI:

```bash
gh workflow run android-apk.yml \
  --repo hatefsystems/oranos-docs \
  --ref master \
  -f source_branch=main
```

Monitor the run:

```bash
gh run list --repo hatefsystems/oranos-docs --workflow android-apk.yml
```

A `push` modifying the workflow, this build script, or this document automatically runs the **lightweight validation** job only. It does **not** start a full Chromium build.

## What success means

A successful Android job produces:

- `ChromePublic-arm64.apk`: locally generated Chromium public development APK
- `SHA256SUMS.txt`: SHA-256 checksum of the APK
- `build-info.txt`: selected fork branch, full source commit, target and signing status

The APK is **not** a release-signed or renamed Oranos product. It is not suitable for publication as Oranos without branding, package ID, signing, privacy/legal review, and device regression testing. Do not upload signing keys into source control or untrusted workflows.

## Limitations

- An initial full Chromium build downloads a large source tree and dependencies, and can be slow or exceed the configured six-hour job timeout even on a larger runner.
- The workflow does not provide a cross-run Chromium build cache; repeated builds download and compile source again. Introduce a reviewed cache or remote build system only after the baseline works.
- Network failures, upstream changes, missing Ubuntu build packages, toolchain regressions, or runner eligibility can prevent a successful APK.
- The source branch is explicitly selected at run time. If `main` is used, it is upstream Chromium development code, **not** an approved stable product release.
- Android signing, device testing, and auto-release are deliberately out of scope for the initial CI implementation.

## Next milestone

Create a branch based on a reviewed Chromium stable tag in `hatefsystems/oranos`; apply a small, independently reviewable Oranos branding patch; build it with the same workflow and verify the generated APK on a real Android device.
