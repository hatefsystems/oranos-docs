# ADR-0001: Track Chromium Upstream Using an Integration Repository

**Status:** Superseded by [ADR-0002](0002-native-chromium-fork.md) after creation of the GitHub-native fork

**Date:** 2026-10-26

## Context

Oranos needs a maintainable Chromium-based browser across multiple platforms, beginning with Android. Chromium is exceptionally large and depends on a separate `DEPS` graph and the `depot_tools` workflow. The project already owns an independently created, initially empty repository at `hatefsystems/oranos`.

## Decision

Use `hatefsystems/oranos` as a lightweight integration repository for documentation, configuration, downstream patch series, and future tooling. Fetch Chromium separately from its canonical upstream using `fetch`/`gclient`. Pin reviewed release revisions before producing artifacts.

This model is **not a native GitHub fork**. It does not have GitHub's built-in Sync fork metadata, and the Chromium source does not appear directly in this repository.

## Reasons

- Avoid uploading and duplicating the entire Chromium Git history in a young product repository.
- Keep downstream changes easy to inspect and replay across upstream releases.
- Separate upstream source version selection from product release decisions.
- Make security-release adoption and patch conflicts visible.

## Tradeoffs

- GitHub cannot show Oranos changes as ordinary diffs against a complete Chromium tree without a separate checkout.
- Developers must fetch the Chromium source and dependencies themselves.
- Patches may conflict with upstream and must be maintained.
- A full GitHub-native fork could be revisited later, possibly in a newly forked repository.

## Follow-up

Select and pin the first stable upstream revision; execute an Android build; export a small branding patch; prove that the patch applies against the following upstream release. Revisit this ADR if actual development needs require hosting the entire fork source.
