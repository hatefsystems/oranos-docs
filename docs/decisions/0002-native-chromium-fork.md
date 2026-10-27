# ADR-0002: Separate Native Chromium Fork from Oranos Documentation

**Status:** Superseded in branch policy by [ADR-0003](0003-upstream-mirror-and-product-main.md)

**Date:** 2026-10-26

**Supersedes:** [ADR-0001](0001-source-strategy.md)

## Context

The initial Oranos repository was created independently and used for English documentation, integration scripts, and an upstream patch workflow. It has since been renamed to `hatefsystems/oranos-docs`. A new, genuine GitHub-native fork of `chromium/chromium` was created at `hatefsystems/oranos`. The fork has a `main` branch and retains the GitHub upstream relationship.

## Decision

- `hatefsystems/oranos` owns the Chromium-based browser source and downstream product branches.
- `hatefsystems/oranos-docs` owns high-level architecture, maintenance guidance, source pin configuration, and supporting integration scripts.
- Keep the browser fork's `main` aligned with Chromium upstream using GitHub's Sync fork or GitHub CLI.
- Develop and release Oranos from separate, reviewed branches based on explicit **stable** upstream tags or SHAs.
- For Android builds, fetch Chromium source with official `depot_tools` and synchronize matching `DEPS`; a GitHub fork by itself is not a complete local build environment.

## Rationale

A native fork preserves visible GitHub ancestry and first-class upstream sync. The separate documentation repository avoids mixing broad product strategy with a giant source history. Reviewed release branches protect product stability from unchecked upstream `main` changes.

## Risks and mitigations

- **Upstream `main` is not a release:** base product branches on reviewed stable tags.
- **Dependency drift:** run `gclient sync` after every Chromium source revision change.
- **Patch conflicts:** isolate downstream changes and test each upgrade.
- **Documentation drift:** link to release-specific source revisions and update documentation alongside product changes.
- **Large CI cost:** use appropriate self-hosted builders, caching, and controlled signing.

## Next actions

Pin a supported Chromium release, complete one baseline Android build, ship a small reviewed Oranos branding patch, and demonstrate a second-revision upgrade. No production Oranos APK has been built or published by this decision alone.
