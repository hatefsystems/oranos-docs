# Chromium Upstream Tracking and Upgrade Policy

## What this repository is

`hatefsystems/oranos` is currently an **upstream-tracked integration and documentation repository**, not a GitHub-native fork of `chromium/chromium`. No Chromium source or history has been copied here. GitHub's **Sync fork** control is not available unless GitHub recognizes an actual fork relationship.

Use the official Chromium checkout workflow for the source and dependencies. Maintain independent, reviewable Oranos patches in this repository.

## Creating a genuine GitHub fork

**Important:** This existing `hatefsystems/oranos` repository was created independently, so it does **not** have GitHub's native fork relationship to Chromium. Fetching or cloning Chromium into a workspace does not change that relationship. GitHub does not offer a normal in-place "convert this independent repository to a fork" operation.

For a genuine GitHub fork, create a **separate** repository within Hatef Systems:

### GitHub web interface

1. Visit https://github.com/chromium/chromium.
2. Select **Fork**.
3. Set **Owner** to `hatefsystems`.
4. Set a repository name that is not taken, such as `oranos-chromium` (the name `oranos` is already occupied).
5. If appropriate, check **Copy the main branch only**. This copies the current default development branch, **not** a reviewed stable release.
6. Select **Create fork**. GitHub will record the upstream relationship.

### GitHub CLI alternative

Authenticate GitHub CLI first using `gh auth login`. From outside an unrelated local Git repository:

```bash
gh repo fork chromium/chromium \
  --org hatefsystems \
  --fork-name oranos-chromium \
  --clone=false
```

Do not run this when a repository with that name already exists. The fork will appear at `https://github.com/hatefsystems/oranos-chromium` **only after creation succeeds**.

### Synchronize the actual fork

On GitHub, visit the actual fork, select its default branch, then choose **Sync fork -> Update branch**. Alternatively:

```bash
gh repo sync hatefsystems/oranos-chromium --branch main
```

This synchronizes the fork's `main` branch with Chromium's upstream `main` branch. It **does not** automatically adopt a stable release, update your Oranos product branch, or synchronize the Chromium `DEPS` dependencies. Do not use `--force` to discard downstream commits. Keep product-specific work on separate branches based on reviewed upstream releases.

### Which repository should contain Oranos documentation?

For now, keep `hatefsystems/oranos` as the Oranos integration, documentation, and downstream patch repository. Optionally create `hatefsystems/oranos-chromium` as a GitHub-native upstream fork later. These repositories have different purposes and should not be confused.

If the goal is to use the exact name `hatefsystems/oranos` for the native fork, the existing independent repository must first be renamed or otherwise relocated, with its documentation retained. The native fork must then be created under the available name. **Do not delete the existing repository as a shortcut.**

Official references:
- https://docs.github.com/en/pull-requests/how-tos/work-with-forks/fork-a-repo
- https://cli.github.com/manual/gh_repo_fork

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
