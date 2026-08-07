import SwiftUI

struct ContentView: View {
    @State private var rawInput = ""
    @State private var submittedText = "Nothing submitted."
    @State private var validationMessages = ["Waiting for keyboard input."]
    @State private var isAccepted = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Keyboard Input") {
                    TextEditor(text: $rawInput)
                        .frame(minHeight: 96)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .overlay(alignment: .topLeading) {
                            if rawInput.isEmpty {
                                Text("Display name")
                                    .foregroundStyle(.tertiary)
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }
                        }

                    Button("Validate and Submit", action: validateAndSubmit)
                        .buttonStyle(.borderedProminent)
                }

                Section("Validation Result") {
                    Label(isAccepted ? "Accepted" : "Blocked", systemImage: isAccepted ? "checkmark.seal.fill" : "xmark.octagon.fill")
                        .foregroundStyle(isAccepted ? Color.green : Color.red)

                    ForEach(validationMessages, id: \.self) { message in
                        Text(message)
                    }
                }

                Section("Safe Output") {
                    Text(submittedText)
                        .font(.body.monospaced())
                        .textSelection(.enabled)
                }
            }
            .navigationTitle("feature5-risk2-control1")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func validateAndSubmit() {
        let result = KeyboardInputValidator.validate(rawInput)
        validationMessages = result.messages
        isAccepted = result.isAccepted
        submittedText = result.isAccepted ? result.encodedText : "Rejected before use."
    }
}

private enum KeyboardInputValidator {
    private static let maximumLength = 40
    private static let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ._-")
    private static let hiddenCommandPrefixes = ["/", "!", ":", "#", "$", "sudo ", "cmd:"]

    static func validate(_ input: String) -> ValidationResult {
        var messages: [String] = []
        let normalized = input.precomposedStringWithCanonicalMapping.trimmingCharacters(in: .whitespaces)

        guard !normalized.isEmpty else {
            return ValidationResult(isAccepted: false, encodedText: "", messages: ["Input is required."])
        }

        if normalized.count > maximumLength {
            messages.append("Blocked: input is longer than \(maximumLength) characters.")
        }

        if normalized.rangeOfCharacter(from: .newlines) != nil {
            messages.append("Blocked: newlines are not allowed.")
        }

        if normalized.rangeOfCharacter(from: .controlCharacters) != nil {
            messages.append("Blocked: hidden control characters are not allowed.")
        }

        if normalized.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            messages.append("Blocked: only letters, numbers, spaces, dot, underscore, and hyphen are allowed.")
        }

        let lowercased = normalized.lowercased()
        if hiddenCommandPrefixes.contains(where: { lowercased.hasPrefix($0) }) {
            messages.append("Blocked: command-style prefixes are not allowed.")
        }

        if messages.isEmpty {
            messages.append("Accepted: input was normalized, length-limited, allowlisted, and encoded.")
        }

        return ValidationResult(
            isAccepted: messages.count == 1 && messages[0].hasPrefix("Accepted"),
            encodedText: htmlEncoded(normalized),
            messages: messages
        )
    }

    private static func htmlEncoded(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}

private struct ValidationResult {
    let isAccepted: Bool
    let encodedText: String
    let messages: [String]
}
