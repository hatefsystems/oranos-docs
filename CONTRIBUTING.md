# Contributing to Oranos

Thank you for supporting Oranos. The project is in early architecture and bootstrap.

## Language

Use **English** for documentation, code comments, issues, commit messages, pull requests, and security documentation. Product UI localization will be handled separately.

## Changes

1. Open an issue or design discussion for non-trivial changes.
2. Create a focused feature branch from the Oranos integration repository default branch.
3. Keep each change limited in scope with a rationale, tests, and an upstream compatibility note.
4. For Chromium patches, record the reviewed upstream base revision and export a numbered `git format-patch` series.
5. Open a pull request describing scope, risk, verification, and platform effects.
6. Do not merge changes with failing required checks or unresolved security concerns.

## Pull request template

- **Purpose:** What user or engineering problem does this solve?
- **Upstream base:** Which Chromium SHA or stable tag was used?
- **Changes:** Which Oranos-specific files or patches changed?
- **Security/privacy:** Does this affect TLS, secrets, passwords, permissions, telemetry, or updates?
- **Tests:** What was run and on which platforms?
- **Rollout:** How can the change be disabled or rolled back?

## Code quality and legal compliance

Respect upstream license notices, do not copy restricted Chrome-only services or proprietary assets, and keep new integrations modular. Do not commit signing keys, personal data, access tokens, or real certificates containing private keys.
