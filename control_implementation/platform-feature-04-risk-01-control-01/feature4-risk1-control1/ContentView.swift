import SwiftUI
import UIKit

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var status = "Sensitive field is protected."

    var body: some View {
        NavigationStack {
            Form {
                Section("Login") {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)

                    SecureFieldWrapper("Password", text: $password)
                        .frame(height: 44)
                }

                Section("Visible State") {
                    LabeledContent("Username", value: username.isEmpty ? "Empty" : username)
                    LabeledContent("Password", value: password.isEmpty ? "Empty" : "Protected")
                }

                Section("Sensitive Action") {
                    Button("Submit") {
                        status = password.isEmpty
                            ? "Password is required."
                            : "Password accepted without exposing its value."
                    }
                    .disabled(username.isEmpty)

                    Text(status)
                        .foregroundStyle(password.isEmpty ? Color.secondary : Color.green)
                }
            }
            .navigationTitle("feature4-risk1-control1")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct SecureFieldWrapper: UIViewRepresentable {
    let placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = context.coordinator
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textDidChange(_:)),
            for: .editingChanged
        )
        return textField
    }

    func updateUIView(_ textField: UITextField, context: Context) {
        if textField.text != text {
            textField.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        private let text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        @objc func textDidChange(_ textField: UITextField) {
            text.wrappedValue = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
