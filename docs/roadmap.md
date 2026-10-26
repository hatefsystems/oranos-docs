# Oranos Roadmap

This roadmap is a proposed sequence, not a committed release schedule. Milestones close on measured acceptance criteria rather than calendar dates.

## Phase 0: Project and upstream baseline

- [x] Establish the Oranos repository and English documentation.
- [x] Document the upstream-tracked patch model.
- [ ] Select and pin a reviewed Chromium stable revision.
- [ ] Build and launch upstream `chrome_public_apk` on Android.
- [ ] Demonstrate a patch rebased successfully onto a newer Chromium stable tag.
- [ ] Establish build provenance and basic CI checks.

**Exit:** two reproducible baseline builds on named revisions with an upgrade record.

## Phase 1: Branded Android browser

- [ ] Product name, icons, Android application ID, onboarding, settings.
- [ ] Hatef Search default with user-controlled choice.
- [ ] Tabs, navigation, bookmarks, history, private browsing regression tests.
- [ ] Signed development artifacts and a secure update design.

**Exit:** installs and navigates reliably, without relying on Chrome-only proprietary services.

## Phase 2: Identity and secure bookmarks

- [ ] Hatef account integration and device enrollment.
- [ ] Local bookmark storage with incremental sync.
- [ ] Threat model, encryption, recovery, conflict and offline tests.
- [ ] Server-side cursor/tombstone and retry behavior.

**Exit:** two devices converge correctly after disconnection and key rotation testing.

## Phase 3: Hybrid trust proof of concept

- [ ] Public certificate path for all standard browsers.
- [ ] Private Hatef CA hierarchy and scoped trust in Oranos.
- [ ] Evaluate ClientHello routing without User-Agent dependence.
- [ ] Test certificate mismatches, ECH/HTTP3 handling, proxies, and fallback policy.

**Exit:** negative TLS verification tests pass and the public browsing experience remains unaffected.

## Phase 4: Notification and password security

- [ ] Independent push delivery prototype across Android background states.
- [ ] Web Push standards compatibility assessment.
- [ ] Password vault design, independent security review, and recovery testing.
- [ ] Password autofill phishing defenses and verified-origin matching.

**Exit:** security review and realistic background-delivery results precede user-facing claims.

## Phase 5: Desktop and distribution

- [ ] Linux and Windows builds and secure auto-updaters.
- [ ] macOS packaging, signing, notarization, and updater.
- [ ] Evaluate iOS engine/distribution constraints separately.
- [ ] Harden CI/CD, supply-chain provenance, telemetry privacy, and crash reporting.

**Exit:** documented platform-specific release process and reproducible upgrade path.

## Metrics

Monitor Chromium security patch lag, patch-conflict rate, build success rate, browser crash-free sessions, update adoption, TLS handshake success, sync convergence, and push-delivery latency where measurable.
