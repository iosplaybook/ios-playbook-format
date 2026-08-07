# Feature 5 Risk 2 Control 1

This is a minimal SwiftUI app that treats keyboard-supplied text as untrusted input.

## Implemented Controls

- Normalizes text before validation.
- Uses a multiline text box where Return can insert a newline but cannot auto-submit.
- Enforces a 40 character length limit.
- Allows only letters, numbers, spaces, dot, underscore, and hyphen.
- Rejects newlines and hidden control characters.
- Rejects command-style prefixes such as `/`, `!`, `:`, `#`, `$`, `sudo `, and `cmd:`.
- HTML-encodes accepted output before display or downstream use.

Server-side validation should repeat the same rules before storing, rendering, or executing any request data.
