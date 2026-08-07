# Feature 1 Risk 1 Control 2

This is a minimal SwiftUI app that demonstrates removing plaintext credentials from bundled property list resources and replacing direct credential comparison with salted hash comparison.

## Implemented Controls

- `Bandit.plist` is not present in the project and is not copied into the app bundle.
- The demo stores only salts and SHA-256 hash values in code.
- During verification, the submitted username and password are combined with their salts, hashed, and compared with the stored hash values.
- The UI includes a simple static-analysis checklist for rebuilding the IPA, scanning with MobSF, and reviewing IPA strings for remaining plaintext secrets.

## Verification

Build and archive the app, then extract the IPA and review the app resources:

```sh
unzip App.ipa -d extracted-ipa
find extracted-ipa -name '*.plist' -print
strings extracted-ipa/Payload/*.app/* | sort -u
```

The removed plaintext credential values should not appear in bundled `.plist` files or IPA string output. If MobSF or string analysis still reports sensitive values, remove those values from bundled resources and rebuild the IPA.

For a production app, prefer moving authentication decisions to server-side logic. Salted hashes in the client are used here only to demonstrate the control without bundling original credential values.
