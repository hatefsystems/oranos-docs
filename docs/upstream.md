# Chromium Upstream Tracking and Upgrade Policy

## Repository roles: current state

The active repository split is:

- **Browser source fork:** https://github.com/hatefsystems/oranos, a genuine GitHub fork of `chromium/chromium` with upstream tracking on `main`.
- **Documentation and integration:** https://github.com/hatefsystems/oranos-docs, the repository containing this file, source pin configuration, development scripts, and optional patch exports.

The actual fork has already been created. **Do not create `oranos-chromium` or re-run a fork command.**

## Synchronize the native GitHub fork

From a terminal authenticated with GitHub CLI:

```bash
gh repo sync hatefsystems/oranos --branch main
```

Or open https://github.com/hatefsystems/oranos and choose **Sync fork -> Update branch** on `main`.

This updates the development-trunk mirror, **not** any downstream Oranos release branch and **not** the Chromium `DEPS` dependencies. Do not use `--force` to overwrite product commits. Keep downstream modifications separate from the fork's `main`.

## Local Chromium checkout connected to the Oranos fork

```bash
# After installing depot_tools and running 'fetch --nohooks android':
cd "$HOME/oranos-workspace/src"
git remote -v
git remote add oranos https://github.com/hatefsystems/oranos.git
git fetch origin --tags
```

If an `oranos` remote already exists, review it instead of adding a duplicate. Select a **real stable release tag** after review, then create a local branch based on that tag:

```bash
git switch -c oranos/upgrade-<reviewed-version> <reviewed-version-tag>
gclient sync --with_branch_heads --with_tags
```

Angle-bracketed placeholders must be replaced by actual values before executing the command. Build/test the release and push only approved Oranos branches to the fork. Keep `main` synchronized with upstream without committing product changes there.

Official references:
- https://docs.github.com/en/pull-requests/how-tos/work-with-forks/syncing-a-fork
- https://www.chromium.org/developers/how-tos/get-the-code/working-with-release-branches/
- https://chromium.googlesource.com/chromium/src/+/main/docs/android_build_instructions.md

## Stable source pinning

The source of truth for a review target is `config/chromium-revision.env`. A blank revision means **no approved base version**. Production builds must be tied to a concrete tag/commit and the associated `DEPS` graph. Record both the selected tag and the resolved immutable Git SHA in release notes or build provenance.

Never use an unreviewed `main` checkout as a production release simply because it is the newest commit.

## Checkout lifecycle

```text
Oranos documentation and source pin
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

The official `fetch android` command normally creates an `origin` pointing to Chromium's canonical Git host. Add a separate `oranos` remote pointing to the GitHub-native fork at `hatefsystems/oranos`. Push downstream branches to the Oranos fork after review, never rewriting its upstream-tracking `main` branch. Keep standalone architecture documents, configuration, and optional patch exports in `hatefsystems/oranos-docs`.

## Release policy

Track upstream security releases frequently. Treat urgent upstream fixes as an expedited review/build/release process, not a scheduled monthly backlog item. The browser is safe only when its fork-specific changes can be rebased and shipped quickly.

Record for every release: source SHA, DEPS revision context, patch-list revision, toolchain, platform, artifact hashes, signing identity, tests, and known deviations.

## Failure handling

Patch conflict -> stop and repair. Failed critical regression -> do not publish. Missing dependency -> repair the checkout and repeat sync. Broken private CA path -> follow an explicitly approved fallback policy without skipping HTTPS verification. Compromised signing key -> suspend publication and follow incident response.
