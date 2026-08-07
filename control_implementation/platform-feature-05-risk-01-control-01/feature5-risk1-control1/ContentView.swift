import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var pin = ""
    @State private var apiKey = ""
    @State private var status = "Enter secrets using secure text fields."

    var body: some View {
        NavigationStack {
            Form {
                Section("Regular Input") {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                }

                Section("Secret Input") {
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    SecureField("PIN", text: $pin)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)

                    SecureField("API Key", text: $apiKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Secret Status") {
                    LabeledContent("Password", value: password.isEmpty ? "Missing" : "Protected")
                    LabeledContent("PIN", value: pin.isEmpty ? "Missing" : "Protected")
                    LabeledContent("API Key", value: apiKey.isEmpty ? "Missing" : "Protected")
                }

                Section("Sensitive Action") {
                    Button("Validate") {
                        status = secretsReady
                            ? "Secrets accepted without exposing their values."
                            : "All secret fields are required."
                    }
                    .disabled(username.isEmpty)

                    Text(status)
                        .foregroundStyle(secretsReady ? Color.green : Color.secondary)
                }
            }
            .navigationTitle("feature5-risk1-control1")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var secretsReady: Bool {
        !password.isEmpty && !pin.isEmpty && !apiKey.isEmpty
    }
}
