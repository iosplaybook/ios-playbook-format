## platform-feature-01-risk-01-control-02

Your app can prevent the risk of an attacker analyzing the application's IPA file by taking the following steps:

1. Prevent hardcoded credential exposure by removing plaintext credentials from bundled `.plist` files, because `.plist` files are packaged as application resources and can be extracted directly from the IPA using static analysis tools. In this implementation, `Bandit.plist`, which contained plaintext credentials, was removed from the app bundle (screenshot 1 - 3). After removal, confirm with MobSF, IPA string analysis, manual resource review, and targeted searches for known credential values because automated tools can miss obfuscated, encoded, encrypted, or dynamically generated values.

<img src="attachments/feature1_risk1_control2_ss1.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control2_ss2.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control2_ss3.png" width="400" alt="Alt text">

2. Prevent exposure of sensitive data such as hardcoded secrets by replacing plaintext credentials with salted hash values or moving authentication secrets to server-side logic (screenshot 4). During authentication, the submitted username and password are combined with their respective salts and passed through the hashing function before comparison (screenshot 5 - 6). Server-side handling reduces bundled-secret exposure only when paired with secure transmission, secure server-side storage, backend validation, and appropriate access controls.

<img src="attachments/feature1_risk1_control2_ss4.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control2_ss5.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control2_ss6.png" width="400" alt="Alt text">

3. Detect whether plaintext credentials are still exposed by first confirming that all known bundled sources have been updated, including `.plist` files, Swift source, generated files, cached resources, test fixtures, and build artifacts, then rebuilding the IPA and scanning it with an updated MobSF instance and IPA string analysis tools.

4. Prevent remaining plaintext credential exposure by reviewing sensitive values detected by MobSF, IPA string analysis, manual resource review, and targeted searches for known credential values. Check usernames, passwords, API keys, tokens, backend URLs, private keys, salts, and test credentials, then remove confirmed plaintext secrets from bundled application resources, rebuild the IPA, and repeat the scan after each removal until the original plaintext credentials are no longer detected by the configured checks.

### References

The IPA with the implemented control can be found [here](implemented_controls/platform-feature-01-risk-01-control-02.zip).
