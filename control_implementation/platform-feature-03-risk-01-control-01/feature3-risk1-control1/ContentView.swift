import SwiftUI
import CFNetwork
import Foundation

struct ContentView: View {
    @State private var proxyStatus = ProxyStatus.unknown
    @State private var requestStatus = "Sensitive request not started."

    var body: some View {
        NavigationStack {
            Form {
                Section("Proxy Detection") {
                    Button("Check Proxy", action: checkProxy)
                        .buttonStyle(.borderedProminent)

                    Label(proxyStatus.summary, systemImage: proxyStatus.systemImage)
                        .foregroundStyle(proxyStatus.tint)
                }

                if !proxyStatus.proxies.isEmpty {
                    Section("Detected Proxy") {
                        ForEach(proxyStatus.proxies) { proxy in
                            LabeledContent(proxy.kind, value: proxy.endpoint)
                        }
                    }
                }

                Section("Sensitive Request") {
                    Button("Send Request", action: sendSensitiveRequest)
                        .disabled(proxyStatus.isProxyEnabled)

                    Text(requestStatus)
                        .foregroundStyle(proxyStatus.isProxyEnabled ? .red : .secondary)
                }
            }
            .navigationTitle("feature3-risk1-control1")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: checkProxy)
        }
    }

    private func checkProxy() {
        proxyStatus = ProxyDetector.currentStatus()
        requestStatus = proxyStatus.isProxyEnabled
            ? "Blocked while a system proxy is active."
            : "No proxy detected. Sensitive request can continue."
    }

    private func sendSensitiveRequest() {
        let latestStatus = ProxyDetector.currentStatus()
        proxyStatus = latestStatus

        guard !latestStatus.isProxyEnabled else {
            requestStatus = "Sensitive request blocked because proxy traffic interception is possible."
            return
        }

        requestStatus = "Sensitive request allowed."
    }
}

private enum ProxyDetector {
    static func currentStatus() -> ProxyStatus {
        guard let retainedSettings = CFNetworkCopySystemProxySettings() else {
            return .clear
        }

        let settings = retainedSettings.takeRetainedValue() as NSDictionary
        let proxySettings = settings as? [String: Any] ?? [:]
        let proxies = [
            proxy(for: "HTTP", enabledKey: "HTTPEnable", hostKey: "HTTPProxy", portKey: "HTTPPort", in: proxySettings),
            proxy(for: "HTTPS", enabledKey: "HTTPSEnable", hostKey: "HTTPSProxy", portKey: "HTTPSPort", in: proxySettings),
            proxy(for: "SOCKS", enabledKey: "SOCKSEnable", hostKey: "SOCKSProxy", portKey: "SOCKSPort", in: proxySettings)
        ].compactMap { $0 }

        return proxies.isEmpty ? .clear : .detected(proxies)
    }

    private static func proxy(
        for kind: String,
        enabledKey: String,
        hostKey: String,
        portKey: String,
        in settings: [String: Any]
    ) -> ProxyEndpoint? {
        guard intValue(settings[enabledKey]) == 1 else {
            return nil
        }

        let host = settings[hostKey] as? String ?? "unknown"
        let port = intValue(settings[portKey])

        return ProxyEndpoint(kind: kind, host: host, port: port)
    }

    private static func intValue(_ value: Any?) -> Int {
        if let value = value as? Int {
            return value
        }

        if let value = value as? NSNumber {
            return value.intValue
        }

        if let value = value as? String {
            return Int(value) ?? 0
        }

        return 0
    }
}

private enum ProxyStatus {
    case unknown
    case clear
    case detected([ProxyEndpoint])

    var isProxyEnabled: Bool {
        !proxies.isEmpty
    }

    var proxies: [ProxyEndpoint] {
        switch self {
        case .unknown, .clear:
            []
        case .detected(let proxies):
            proxies
        }
    }

    var summary: String {
        switch self {
        case .unknown:
            "Proxy status unknown."
        case .clear:
            "No system proxy detected."
        case .detected(let proxies):
            "Proxy detected: \(proxies.map(\.endpoint).joined(separator: ", "))"
        }
    }

    var systemImage: String {
        switch self {
        case .unknown:
            "questionmark.circle"
        case .clear:
            "checkmark.seal.fill"
        case .detected:
            "exclamationmark.triangle.fill"
        }
    }

    var tint: Color {
        switch self {
        case .unknown:
            .secondary
        case .clear:
            .green
        case .detected:
            .red
        }
    }
}

private struct ProxyEndpoint: Identifiable {
    let kind: String
    let host: String
    let port: Int

    var id: String {
        "\(kind)-\(host)-\(port)"
    }

    var endpoint: String {
        "\(host):\(port)"
    }
}
