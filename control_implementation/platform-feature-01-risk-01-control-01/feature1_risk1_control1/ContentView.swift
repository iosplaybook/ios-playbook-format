import SwiftUI
import ConfidentialKit

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var result = LoginResult.idle

    var body: some View {
        NavigationStack {
            Form {
                Section("Demo Sign In") {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()

                    SecureField("Password", text: $password)

                    Button("Sign In", action: signIn)
                        .buttonStyle(.borderedProminent)
                }

                if let message = result.message {
                    Section {
                        Label(message, systemImage: result.systemImage)
                            .foregroundStyle(result.tint)
                    }
                }
            }
            .navigationTitle("Feature 1 Risk 1 Control 1 Demo")
        }
    }

    private func signIn() {
        // Secrets is generated from confidential.yml by the Swift Confidential build plugin.
        let expectedEmail = Secrets.$demoEmail
        let expectedPassword = Secrets.$demoPassword
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        result = normalizedEmail == expectedEmail && password == expectedPassword
            ? .success
            : .failure
    }
}

private enum LoginResult {
    case idle
    case success
    case failure

    var message: String? {
        switch self {
        case .idle:
            nil
        case .success:
            "Signed in with generated secret values."
        case .failure:
            "Credentials do not match."
        }
    }

    var systemImage: String {
        switch self {
        case .idle:
            "lock"
        case .success:
            "checkmark.seal.fill"
        case .failure:
            "xmark.octagon.fill"
        }
    }

    var tint: Color {
        switch self {
        case .idle:
            .secondary
        case .success:
            .green
        case .failure:
            .red
        }
    }
}

#Preview {
    ContentView()
}
