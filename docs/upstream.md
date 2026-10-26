# Chromium Upstream Tracking and Upgrade Policy

## What this repository is

`hatefsystems/oranos` is currently an **upstream-tracked integration and documentation repository**, not a GitHub-native fork of `chromium/chromium`. No Chromium source or history has been copied here. GitHub's **Sync fork** control is not available unless GitHub recognizes an actual fork relationship.

Use the official Chromium checkout workflow for the source and dependencies. Maintain independent, reviewable Oranos patches in this repository.

## Stable source pinning

The source of truth for a review target is `config/chromium-revision.env`. A blank revision means **no approved base version**. Production builds must be tied to a concrete tag/commit and the associated `DEPS` graph. Record both the selected tag and the resolved immutable Git SHA in release notes or build provenance.

Never use an unreviewed `main` checkout as a production release simply because it is the newest commit.

## Checkout lifecycle

```text
Oranos integration repository
      |
      | release ref + patch series
      v
Official Chromium src checkout <---- upstream releases/security fixes
      |
      +---- gclient sync: exact DEPS dependencies
      |
      +---- apply and review Oranos patches
      |
      +---- build, test, sign, release
```

## Upgrade procedure

1. Review Chromium stable releases, upstream security notes, Android minimum version, and toolchain changes.
2. Choose an actual upstream tag or SHA and update `config/chromium-revision.env` in a feature branch.
3. Fetch the new source revision and synchronize `DEPS` with `gclient sync`.
4. Create a new downstream integration branch from the **new** base revision in the Chromium checkout.
5. Apply all approved Oranos `.patch` files in order using `git am --3way`. Resolve conflicts explicitly and regenerate patches from reviewed commits.
6. Build supported platforms, run unit/integration/security tests, and compare capabilities with the prior release.
7. Review the upgrade as a pull request, then publish a signed release after approval.

Example patch export after Oranos commits have been made on top of the pinned base:

```bash
git format-patch <base-commit-sha>..HEAD --output-directory /path/to/oranos/patches
```

Example application on a **clean** new Chromium integration branch:

```bash
git am --3way /path/to/oranos/patches/*.patch
```

Do not blindly reapply patches that are already present. If no patches exist, build the upstream baseline and do not claim Oranos modifications are included.

## Git remotes for source checkout

The official `fetch android` command normally creates an `origin` pointing to Chromium's canonical Git host. Keep that source remote separate from this small Oranos integration repository; do **not** push the unrelated full Chromium history into `hatefsystems/oranos`.

A possible later migration to a full GitHub-native fork is a distinct repository-management decision and may require a new fork rather than converting this existing repository in place.

## Release policy

Track upstream security releases frequently. Treat urgent upstream fixes as an expedited review/build/release process, not a scheduled monthly backlog item. The browser is safe only when its fork-specific changes can be rebased and shipped quickly.

Record for every release: source SHA, DEPS revision context, patch-list revision, toolchain, platform, artifact hashes, signing identity, tests, and known deviations.

## Failure handling

Patch conflict -> stop and repair. Failed critical regression -> do not publish. Missing dependency -> repair the checkout and repeat sync. Broken private CA path -> follow an explicitly approved fallback policy without skipping HTTPS verification. Compromised signing key -> suspend publication and follow incident response.
