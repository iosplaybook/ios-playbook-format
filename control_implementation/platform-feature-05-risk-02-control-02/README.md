# Feature 5 Risk 2 Control 2

This is a minimal SwiftUI app that requires review and step-up authentication before a high-risk transaction is submitted.

## Implemented Controls

- Collects editable amount, recipient, and destination account suffix fields.
- Dismisses the keyboard before moving to review.
- Builds a read-only transaction summary, for example `Send SGD 500 to Alice ending 1234.`
- Requires local Face ID, Touch ID, or device passcode authentication using `LAContext.evaluatePolicy`.
- Prevents keyboard text insertion from directly completing the transaction.
- Notes that the server must verify the confirmed transaction details before accepting the request.

This keeps user-entered text separate from final transaction submission.
