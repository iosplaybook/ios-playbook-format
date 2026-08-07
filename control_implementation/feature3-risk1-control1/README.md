# Feature 3 Risk 1 Control 1

This is a minimal SwiftUI app that detects system proxy settings before allowing sensitive requests.

## Implemented Controls

- Calls `CFNetworkCopySystemProxySettings().takeRetainedValue()` to read the current system proxy dictionary.
- Checks common proxy keys including `HTTPEnable`, `HTTPProxy`, `HTTPPort`, `HTTPSEnable`, `HTTPSProxy`, `HTTPSPort`, `SOCKSEnable`, `SOCKSProxy`, and `SOCKSPort`.
- Displays the detected proxy host and port when a proxy is enabled.
- Blocks the demo sensitive request while an HTTP, HTTPS, or SOCKS proxy is active.

The app is intentionally small so the control is easy to inspect.
