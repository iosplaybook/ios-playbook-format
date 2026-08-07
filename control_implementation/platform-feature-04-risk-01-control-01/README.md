# Feature 4 Risk 1 Control 1

This is a minimal SwiftUI app that protects a sensitive password field during screenshots, screen recording, and screen mirroring.

## Implemented Controls

- Uses a SwiftUI `SecureFieldWrapper` backed by `UITextField`.
- Enables `isSecureTextEntry` for the password field.
- Keeps the username visible while preventing the password value from being exposed.
- Avoids showing the password character count in the visible app state.

The app is intentionally small so the control is easy to inspect.
