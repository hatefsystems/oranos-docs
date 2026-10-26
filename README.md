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

## Source strategy

**This repository is currently an Oranos integration and documentation repository, not a GitHub-native fork of Chromium and not a full copy of Chromium source.** Chromium must be fetched separately using its official `depot_tools` workflow. Oranos-specific patches can then be applied on top of a reviewed Chromium revision.

- Official source: https://chromium.googlesource.com/chromium/src
- GitHub mirror: https://github.com/chromium/chromium
- Source browser: https://source.chromium.org/chromium/chromium/src
- Chromium checkout and build instructions: https://chromium.googlesource.com/chromium/src/+/main/docs/android_build_instructions.md

The workflow deliberately keeps upstream code and product-specific changes separate. Simply synchronizing this GitHub repository does **not** update the Chromium source tree.

## Documentation

| Document | Purpose |
| --- | --- |
| [Architecture](docs/architecture.md) | Modules, platform boundaries, and trust strategy |
| [Development](docs/development.md) | Android checkout, build, and local development |
| [Upstream maintenance](docs/upstream.md) | Version pinning, patch application, and upgrades |
| [Security](docs/security.md) | Browser, certificate, sync, and release security requirements |
| [Roadmap](docs/roadmap.md) | Staged delivery and acceptance criteria |
| [ADR-0001](docs/decisions/0001-source-strategy.md) | Source-management decision and tradeoffs |
| [Contributing](CONTRIBUTING.md) | Workflow and documentation conventions |

## Initial checkout

On a supported Linux development machine, install Chromium `depot_tools` and follow [the Android development guide](docs/development.md) to fetch Chromium, select a reviewed revision, synchronize `DEPS`, and build `chrome_public_apk`.

Do not treat a successful upstream Chromium build as an Oranos release. Oranos branding, custom package identifiers, sync, push, and trust features require separate implementation and validation.

## Repository conventions

- **All code documentation, comments, issues, commit messages, and pull-request descriptions are written in English.**
- Chromium-related changes must be small, reviewable, and associated with an upstream revision.
- The `main` branch of this repository holds Oranos integration assets, **not** a Chromium source mirror.
- Release credentials, private keys, and real user data must never be committed.

## Licensing

Chromium includes code under multiple open-source licenses. Oranos must preserve applicable notices and comply with each component's terms. An explicit license for Oranos-authored files has not yet been selected; do not assume that this repository grants a new blanket license.

## Ownership

Developed by **Hatef Systems**. Oranos is a project name and is not affiliated with Google Chrome or the Chromium project maintainers.
