# Oranos Android APK CI

The Android APK workflow and build script have moved **from this documentation repository** into the Oranos browser source fork:

- **Workflow:** https://github.com/hatefsystems/oranos/blob/main/.github/workflows/android-apk.yml
- **Build script:** https://github.com/hatefsystems/oranos/blob/main/.github/oranos-ci/build-android.sh
- **Build guide:** https://github.com/hatefsystems/oranos/blob/main/.github/oranos-ci/README.md
- **Run workflow:** https://github.com/hatefsystems/oranos/actions/workflows/android-apk.yml

The Oranos source repository uses `main` for the product and `chromium-upstream` for a clean Chromium mirror. Do not synchronize GitHub's upstream `main` directly over the product branch.

The workflow uses the standard GitHub-hosted `ubuntu-24.04` runner. GitHub standard runners have around 14 GB of SSD; Chromium requires at least 100 GB free for an Android build. A runner capacity check deliberately fails before the large source download when disk space is inadequate. This validates the practical limit without exhausting the runner.

GitHub Actions may need manual activation for a new fork. Once enabled, the `workflow_dispatch` trigger allows launching the CI manually from the Oranos repository Actions tab.

This docs repository retains only repository/documentation checks. No browser APK is built from `oranos-docs`.
