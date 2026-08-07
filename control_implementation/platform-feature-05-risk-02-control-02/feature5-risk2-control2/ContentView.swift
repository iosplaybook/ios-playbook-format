import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @FocusState private var focusedField: Field?
    @State private var amount = "500"
    @State private var recipient = "Alice"
    @State private var accountSuffix = "1234"
    @State private var pendingTransaction: Transaction?
    @State private var status = "Enter transaction details."
    @State private var isSubmitted = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Transaction Details") {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .amount)

                    TextField("Recipient", text: $recipient)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .recipient)

                    TextField("Account ending", text: $accountSuffix)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .accountSuffix)

                    Button("Review Transaction", action: reviewTransaction)
                        .buttonStyle(.borderedProminent)
                }

                if let pendingTransaction {
                    Section("Read-Only Summary") {
                        Text(pendingTransaction.summary)
                            .font(.body.weight(.semibold))
                            .textSelection(.disabled)

                        Button("Confirm with Face ID / Passcode") {
                            Task {
                                await confirmTransaction(pendingTransaction)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isSubmitted)
                    }
                }

                Section("Status") {
                    Label(status, systemImage: isSubmitted ? "checkmark.seal.fill" : "lock.shield")
                        .foregroundStyle(isSubmitted ? Color.green : Color.secondary)
                }
            }
            .navigationTitle("feature5-risk2-control2")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func reviewTransaction() {
        focusedField = nil
        isSubmitted = false

        guard let transaction = Transaction(amount: amount, recipient: recipient, accountSuffix: accountSuffix) else {
            pendingTransaction = nil
            status = "Transaction details are invalid."
            return
        }

        pendingTransaction = transaction
        status = "Review the read-only summary before confirmation."
    }

    @MainActor
    private func confirmTransaction(_ transaction: Transaction) async {
        do {
            try await LocalAuthenticator.authenticate(reason: "Confirm \(transaction.summary)")
            isSubmitted = true
            status = "Submitted after local authentication. Server must verify the same details."
        } catch {
            isSubmitted = false
            status = error.localizedDescription
        }
    }
}

private enum Field {
    case amount
    case recipient
    case accountSuffix
}

private struct Transaction {
    let amount: Decimal
    let recipient: String
    let accountSuffix: String

    init?(amount: String, recipient: String, accountSuffix: String) {
        let normalizedAmount = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedRecipient = recipient.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedSuffix = accountSuffix.trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            let amountValue = Decimal(string: normalizedAmount),
            amountValue > 0,
            (1...30).contains(normalizedRecipient.count),
            normalizedRecipient.rangeOfCharacter(from: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ._-").inverted) == nil,
            normalizedSuffix.count == 4,
            normalizedSuffix.rangeOfCharacter(from: .decimalDigits.inverted) == nil
        else {
            return nil
        }

        self.amount = amountValue
        self.recipient = normalizedRecipient
        self.accountSuffix = normalizedSuffix
    }

    var summary: String {
        "Send SGD \(amountText) to \(recipient) ending \(accountSuffix)."
    }

    private var amountText: String {
        NSDecimalNumber(decimal: amount).stringValue
    }
}

private enum LocalAuthenticator {
    static func authenticate(reason: String) async throws {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            throw AuthenticationError.unavailable(error?.localizedDescription ?? "Local authentication is unavailable.")
        }

        let success = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
        guard success else {
            throw AuthenticationError.failed
        }
    }
}

private enum AuthenticationError: LocalizedError {
    case unavailable(String)
    case failed

    var errorDescription: String? {
        switch self {
        case .unavailable(let message):
            "Authentication unavailable: \(message)"
        case .failed:
            "Authentication failed."
        }
    }
}
