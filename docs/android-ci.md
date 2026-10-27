# Oranos Android APK CI

The Android APK workflow and build script have moved **from this documentation repository** into the Oranos browser source fork:

- **Workflow:** https://github.com/hatefsystems/oranos/blob/main/.github/workflows/android-apk.yml
- **Build script:** https://github.com/hatefsystems/oranos/blob/main/.github/oranos-ci/build-android.sh
- **Build guide:** https://github.com/hatefsystems/oranos/blob/main/.github/oranos-ci/README.md
- **Run workflow:** https://github.com/hatefsystems/oranos/actions/workflows/android-apk.yml

The Oranos source repository uses `main` for the product and `chromium-upstream` for a clean Chromium mirror. Do not synchronize GitHub's upstream `main` directly over the product branch.

The workflow uses the standard GitHub-hosted `ubuntu-24.04` runner. GitHub's published standard-runner table lists 14 GB SSD, but an actual Oranos workflow run on 2026-10-27 reported a 145 GB root filesystem with approximately 87 GB initially free. Removing unrelated preinstalled SDKs raised free disk to approximately 110 GB, passing the Chromium Android 100 GB capacity preflight. These observed values are not contractual guarantees for future runners. The workflow still checks free disk and fails early if insufficient; complete Chromium APK compilation has not yet been demonstrated.

GitHub Actions may need manual activation for a new fork. Once enabled, the `workflow_dispatch` trigger allows launching the CI manually from the Oranos repository Actions tab.

This docs repository retains only repository/documentation checks. No browser APK is built from `oranos-docs`.
