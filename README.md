# Oranos

**Oranos** is a planned Chromium-based web browser developed by **Hatef Systems**. The project begins with Android and is intended to expand to Linux, Windows, and macOS. iOS requires a separate platform feasibility assessment.

> **Project status:** Architecture and repository bootstrap. No Oranos browser build has been released or validated yet.

## Vision

Build an independent, secure, maintainable browser that works with the open web and integrates with the Hatef ecosystem without requiring users to abandon other browsers.

Planned capabilities include:

- Hatef Search as the default search provider, with user choice preserved.
- A dedicated Hatef account and encrypted synchronization for bookmarks and, after security review, passwords.
- Independent notification infrastructure, subject to operating-system background execution limits.
- A hybrid certificate strategy: public Web PKI compatibility and tightly scoped, independently managed Hatef trust for eligible Hatef services.
- Reproducible, reviewed Chromium upstream upgrades and prompt security patch adoption.

These capabilities describe a roadmap, not functionality already implemented.

## Repository layout and Chromium source strategy

- **[hatefsystems/oranos](https://github.com/hatefsystems/oranos):** GitHub-native fork of [chromium/chromium](https://github.com/chromium/chromium). Its `main` branch tracks upstream and must not carry Oranos-only product modifications.
- **[hatefsystems/oranos-docs](https://github.com/hatefsystems/oranos-docs):** Architecture, development guides, release policy, integration scripts, and optional reviewed downstream patch exports.

This repository is **the documentation repository**, not a Chromium source mirror. The native fork is already established under `hatefsystems/oranos`. Chromium must still be fetched for local Android builds using its official `depot_tools` workflow, because Chromium depends on a separately pinned `DEPS` graph.

- Official source: https://chromium.googlesource.com/chromium/src
- GitHub upstream: https://github.com/chromium/chromium
- Oranos fork: https://github.com/hatefsystems/oranos
- Android build instructions: https://chromium.googlesource.com/chromium/src/+/main/docs/android_build_instructions.md

Use an independently reviewed **stable Chromium release tag/SHA** for product builds. GitHub's **Sync fork** updates the fork's upstream `main`; it does not update the release-specific Oranos branch or synchronize `DEPS`.

## Documentation

| Document | Purpose |
| --- | --- |
| [Architecture](docs/architecture.md) | Modules, platform boundaries, and trust strategy |
| [Development](docs/development.md) | Android checkout, build, and local development |
| [Upstream maintenance](docs/upstream.md) | Version pinning, patch application, and upgrades |
| [Security](docs/security.md) | Browser, certificate, sync, and release security requirements |
| [Roadmap](docs/roadmap.md) | Staged delivery and acceptance criteria |
| [ADR-0001](docs/decisions/0001-source-strategy.md) | Original bootstrap decision, superseded by ADR-0002 |
| [ADR-0002](docs/decisions/0002-native-chromium-fork.md) | Current GitHub-native fork and documentation split |
| [Contributing](CONTRIBUTING.md) | Workflow and documentation conventions |

## Initial checkout

On a supported Linux development machine, install Chromium `depot_tools` and follow [the Android development guide](docs/development.md) to fetch Chromium, select a reviewed revision, synchronize `DEPS`, and build `chrome_public_apk`.

Do not treat a successful upstream Chromium build as an Oranos release. Oranos branding, custom package identifiers, sync, push, and trust features require separate implementation and validation.

## Repository conventions

- **All code documentation, comments, issues, commit messages, and pull-request descriptions are written in English.**
- Chromium-related changes must be small, reviewable, and associated with an upstream revision.
- The `master` branch of this documentation repository holds Oranos guides and integration assets; the separate Chromium fork uses `main`.
- Release credentials, private keys, and real user data must never be committed.

## Licensing

Chromium includes code under multiple open-source licenses. Oranos must preserve applicable notices and comply with each component's terms. An explicit license for Oranos-authored files has not yet been selected; do not assume that this repository grants a new blanket license.

## Ownership

Developed by **Hatef Systems**. Oranos is a project name and is not affiliated with Google Chrome or the Chromium project maintainers.
