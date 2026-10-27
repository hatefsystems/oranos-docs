# ADR-0003: Product Main and Independent Chromium Upstream Mirror

**Status:** Accepted

**Date:** 2026-10-27

**Supersedes:** The upstream-on-main branch policy in [ADR-0002](0002-native-chromium-fork.md)

## Context

Oranos is a real GitHub-native fork of Chromium. We want source history, pull requests, Android build workflows, and release automation close to the Oranos product code while retaining a clean upstream mirror.

## Decision

- `hatefsystems/oranos:main` is the product integration branch and holds Oranos code, CI/CD, tests, and release work.
- `hatefsystems/oranos:chromium-upstream` is a pristine tracking branch of `chromium/chromium:main`.
- `hatefsystems/oranos-docs:master` contains architecture and long-lived documentation; its CI only validates documentation/scripts.
- Avoid running GitHub's native fork synchronization command against `oranos:main`, which is not an upstream mirror.
- Update `chromium-upstream` using a checked fast-forward update. Adopt tested stable Chromium releases into the product through reviewed upgrade PRs.
- Use standard GitHub-hosted Ubuntu runners for the initial CI probe. A full Chromium Android build has higher resource requirements; preflight failure is expected on standard runners.

## Consequences

The GitHub default branch displays Oranos integration rather than raw upstream. Upstream sync requires deliberate scripting. Every Chromium security update must be applied to the product branch separately, with regressions tested. Development documentation must distinguish CI validation, resource probing, and actual APK compilation.

## Follow-up

Enable GitHub Actions in the Chromium fork, run the Android workflow, inspect the preflight result, and select a build environment meeting Chromium's documented resource requirements before claiming an APK build.
