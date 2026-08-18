## platform-feature-02-risk-01-control-01

Your app can prevent the risk of an attacker monitoring data between apps:

1. Call `CFNetworkCopySystemProxySettings()` to retrieve the iPhone's current network proxy configuration. This allows the app to detect whether a proxy is configured.

<img src="attachments/feature3_risk1_control1_ss1.png" width="400" alt="Alt text">

*Screenshot shows the source code calling `CFNetworkCopySystemProxySettings()` to retrieve the proxy configuration*

2. Inspect the returned settings and check whether `HTTPEnable`, `HTTPSEnable`, or `ProxyAutoConfigEnable` is set to 1. Checking all three settings ensures coverage for HTTP proxies, HTTPS proxies, and Proxy Auto-Configuration (PAC) scripts.

3. If any proxy setting is enabled, trigger an appropriate response. Display a warning to the user, log an alert, or stop the network request. Taking immediate action helps prevent sensitive data from passing through an unverified intermediary that could intercept or modify the traffic.

<img src="attachments/feature3_risk1_control1_ss2.png" width="400" alt="Alt text">

*Screenshot shows source code for proxy configuration check*

<img src="attachments/feature3_risk1_control1_ss3.png" width="400" alt="Alt text">

*Screenshot shows warning to user that proxy is configured*

### References

- https://developer.apple.com/documentation/cfnetwork/cfnetworkcopysystemproxysettings()

The source code with the implemented control can be found [here](implemented_controls/platform-feature-02-risk-01-control-01.zip).