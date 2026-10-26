# Oranos Architecture

**Status:** Proposed, not implemented. **Primary platform:** Android. **Upstream:** Chromium.

## Product boundary

Oranos is a downstream browser product built on the open-source Chromium codebase. It is not a separate rendering engine or an operating system. The current `hatefsystems/oranos` repository holds integration guidance and future product-specific patches, rather than a complete Chromium source checkout.

### Logical components

| Component | Responsibility | Boundary |
| --- | --- | --- |
| Chromium engine | Rendering, networking, sandboxing, web standards, navigation | Keep as close to upstream as practical |
| Oranos browser shell | Branding, onboarding, settings, search defaults | Product-specific UI and configuration |
| Oranos Identity client | Sign-in with Hatef accounts and device management | Explicitly authorized tokens and sessions |
| Oranos Sync client | Incremental encrypted bookmarks, later password vault | Device-side cryptography, server stores ciphertext |
| Oranos Notification client | Notifications from Hatef services | OS-appropriate background execution |
| Oranos Trust policy | Scoped certificate trust for eligible Hatef endpoints | Never suppress general TLS verification |
| Hatef services | Search, identity, sync, push, public/private PKI | Independently deployable backend APIs |

All components are proposals and must undergo platform compatibility testing.

## Target platforms

Android is first because it provides a clear APK milestone. Linux and Windows follow, then macOS. iOS is a separate feasibility track because browser engine entitlements and distribution rules vary by market and OS release. Platform support must be assessed independently; shared C++ code is not a guarantee of identical shipping capabilities.

## Chromium integration

Prefer small isolated changes and wrappers over broad changes in `content/`, `net/`, `chrome/`, or BoringSSL. Every modification must have a clear upstream base, a test plan, and an owner. Review impacts on multi-process sandboxing, process privileges, enterprise policy, and site isolation.

## Browser trust and TLS

Oranos must remain compatible with the public Web PKI. Public Hatef endpoints must continue to offer certificates trusted by ordinary browsers. A private Hatef CA is an additional, narrowly scoped capability for eligible Hatef-controlled endpoints.

### One-domain, one-IP hybrid certificate selection

Certificate selection happens **during the TLS handshake**, before an HTTP User-Agent is available. A server cannot select between the public and private certificate for the same SNI solely from HTTP headers.

A future proof of concept may inspect a client-visible signal in the TLS ClientHello and route TCP to two internal TLS listeners that terminate to the same application backend. A private-use TLS extension is a research option, **not** an implemented or standardized Oranos feature. ALPN-based signaling is suitable only as an interoperability experiment because ALPN advertises application protocols, not brands.

For any such design:

- The marker selects a route, **not** authenticated identity. Treat it as spoofable.
- Use the exact HTTPS hostname in SNI and certificate SAN verification.
- Accept only complete, valid certificate chains and normal hostname, validity, and key-usage checks.
- Never grant broad trust in a Hatef CA for unrelated domains.
- Plan separately for HTTP/3 over QUIC, ECH, proxies, connection reuse, and session resumption.
- Make updates to the trust bundle signed, rollback-resistant, and recoverable.
- Retain a public-certificate path for web compatibility and third-party integrations.
- Test failure and recovery before making a private path the default.

A minimal system can use a public CA for all production HTTPS endpoints while private trust and routing experiments are developed separately.

## Sync architecture

Sync is **incremental**, authenticated, and resilient to disconnection:

1. A client edits local state.
2. It encrypts sensitive data before upload.
3. The server stores versioned records, cursors, and encrypted payloads.
4. Another authorized device fetches deltas and decrypts locally.
5. Conflicts, tombstones, retries, and key recovery follow explicit policies.

Bookmarks and passwords have different threat models. Password sync is blocked on a reviewed E2EE and recovery design. An HTTP API or an AccountManager integration alone does not deliver end-to-end encryption.

## Notification architecture

Server-side event -> Hatef push broker -> reachable Oranos client -> local notification -> optional delta sync. Android Doze, battery optimization, and force-stop behavior can delay or prevent delivery. A persistent socket is **not** a guarantee of always-on delivery. General website Web Push support is a separate project.

## Cross-repository ownership

The browser repository coordinates the client and its Chromium changes. Hatef service implementations may remain in independently versioned backend repositories. No dependency on private backend source is required to build a baseline open-source Chromium browser.
