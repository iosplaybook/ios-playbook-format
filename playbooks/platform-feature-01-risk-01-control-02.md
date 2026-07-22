## platform-feature-01-risk-01-control-02

Your app can prevent the risk of an attacker analyzing the application's IPA file by taking the following steps:

1. Remove plaintext credentials from bundled `.plist` files to reduce hardcoded credential exposure, because `.plist` files are packaged as application resources and can be extracted directly from the IPA using static analysis tools. In this implementation, `Bandit.plist`, which contained plaintext credentials, was removed from the app bundle (screenshot 1 - 3). After removal, confirm with MobSF and IPA string analysis that the original plaintext credentials are no longer detected.

<img src="attachments/feature1_risk1_control2_ss1.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control2_ss2.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control2_ss3.png" width="400" alt="Alt text">

2. Replace plaintext credentials with salted hash values or move authentication secrets to server-side logic to reduce exposure of sensitive data such as hardcoded secrets (screenshot 4). During authentication, the submitted username and password are combined with their respective salts and passed through the hashing function before comparison (screenshot 5 - 6). Server-side handling reduces bundled-secret exposure, but it still requires secure transmission, storage, and backend validation.

<img src="attachments/feature1_risk1_control2_ss4.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control2_ss5.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control2_ss6.png" width="400" alt="Alt text">

3. Rebuild the IPA after removing bundled plaintext credentials, then scan the rebuilt IPA with an updated MobSF instance and review IPA strings using static analysis tools to detect whether plaintext credentials are still exposed.

4. Review any sensitive values still detected by MobSF or IPA string analysis, including usernames, passwords, API keys, tokens, backend URLs, private keys, salts, and test credentials. Remove confirmed plaintext secrets from bundled application resources, rebuild the IPA, and repeat the scan until the original plaintext credentials are no longer detected by the configured tools.

### References

The IPA with the implemented control can be found [here](implemented_controls/platform-feature-01-risk-01-control-02.zip).
