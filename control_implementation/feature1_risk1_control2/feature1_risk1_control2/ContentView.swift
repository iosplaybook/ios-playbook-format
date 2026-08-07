import SwiftUI
import CryptoKit
import Foundation

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var result = LoginResult.idle

    var body: some View {
        NavigationStack {
            Form {
                Section("Salted Hash Authentication") {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .textContentType(.username)
                        .autocorrectionDisabled()

                    SecureField("Password", text: $password)
                        .textContentType(.password)

                    Button("Verify", action: verify)
                        .buttonStyle(.borderedProminent)
                }

                if let message = result.message {
                    Section {
                        Label(message, systemImage: result.systemImage)
                            .foregroundStyle(result.tint)
                    }
                }

            }
            .navigationTitle("Feature 1 Risk 1 Control 2")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func verify() {
        let normalizedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        result = CredentialVerifier.isValid(username: normalizedUsername, password: password)
            ? .success
            : .failure
    }
}

private enum CredentialVerifier {
    // Username: demo.user@example.com
    // Password: C0ntrol-2-Demo!
    private static let usernameSalt = "usalt-control2"
    private static let passwordSalt = "psalt-control2"
    private static let expectedUsernameHash = "9a22029b275e015671f75ba6875e00d14f15b94a931c3e47a7274995452fff24"
    private static let expectedPasswordHash = "36eda40967786474c386be9379f7a37a644a42beb9a949088d4e2dfcf9092494"

    static func isValid(username: String, password: String) -> Bool {
        sha256(username + usernameSalt) == expectedUsernameHash
            && sha256(password + passwordSalt) == expectedPasswordHash
    }

    private static func sha256(_ value: String) -> String {
        let digest = SHA256.hash(data: Data(value.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
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
            "Credentials matched stored salted hashes."
        case .failure:
            "Credentials do not match the stored hashes."
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
