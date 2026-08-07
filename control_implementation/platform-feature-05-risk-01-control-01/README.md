# Feature 5 Risk 1 Control 1

This is a minimal SwiftUI app that uses secure text entry for true secrets.

## Implemented Controls

- Uses normal `TextField` input for non-secret username data.
- Uses `SecureField` for password, PIN, and API key input.
- Prevents the app UI from echoing secret values after entry.
- Demonstrates that secret fields should use secure text input so iOS can prevent third-party custom keyboards from handling secret input.

Secret-style fields include passwords, PINs, recovery phrases, backup codes, private keys, API keys, payment secrets, and administrative secrets.
