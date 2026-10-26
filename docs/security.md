# Security Policy and Engineering Principles

Oranos is in a **pre-release design** stage. No formal security guarantee or audited binary is currently offered.

## Reporting

Do not post credentials, vulnerabilities affecting real users, or exploit details in public issues. Use a private vulnerability reporting channel established by the maintainers before external testing is invited. If no private channel is available, ask the maintainers to enable GitHub private vulnerability reporting rather than publishing secrets.

## Non-negotiable browser requirements

- Preserve Chromium sandboxing, site isolation, origin boundaries, Safe Browsing design decisions under explicit review, and secure updates.
- Never set an unconditional accept-all-certificate callback or disable hostname validation to work around TLS errors.
- Never ship a universal Hatef root certificate in a way that makes unrelated domains implicitly trusted.
- Keep a public Web PKI path for general web compatibility.
- Treat all custom ClientHello markers as **routing hints**, not identity proof.
- Keep browser updates and trust-bundle updates authenticated, integrity protected, and rollback resistant.
- Separate release signing keys from CI and pull-request runners, and prohibit secrets in source control.
- Maintain a vulnerability response process for upstream Chromium and all third-party components.

## Private Hatef PKI

If implemented, use an offline protected root, constrained intermediate issuing authorities, short-lived endpoint certificates, documented revocation processes, and scoped trust for explicitly approved Hatef endpoints. Build and test certificate rotation and recovery before shipping. Distinguish private PKI experiments from public CA issuance; inclusion in third-party root stores is not assumed.

The planned single-IP hybrid certificate gateway must be tested against forged routing markers, ECH, QUIC/HTTP3, session resumption, proxy setups, and certificate mismatch errors. A TLS routing marker cannot justify privileged access.

## Encrypted sync and password vault

Bookmark sync and password management have different risk levels. The future password vault requires a reviewed end-to-end encryption design including modern authenticated encryption, device key protection, robust derivation where passwords are used, multi-device enrollment, recovery key policy, replay/conflict handling, and independent testing. The server should not receive plaintext vault contents or decryption secrets under a zero-knowledge design.

Do not equate server-side disk encryption or ordinary TLS with end-to-end encryption.

## Push infrastructure

An independent push gateway can avoid a mandatory FCM dependency on supported paths, but it cannot override Android force-stop, Doze, or background execution restrictions. Delivery claims must be based on measured device and OS behavior.

## Release gates

Before public beta: verify baseline upstream revision, passing builds, HTTPS negative tests, sandbox behavior, patch delta review, binary signing, dependency notices, and safe update/rollback. Additional cryptographic features require focused external review before handling real credentials.
