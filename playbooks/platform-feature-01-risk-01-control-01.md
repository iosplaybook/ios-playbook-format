## platform-feature-01-risk-01-control-01

Your app can prevent the risk of an attacker analyzing the application's IPA file by taking the following steps:

1. Move hardcoded Swift string literals, such as usernames and passwords, into a `confidential.yml` file instead of writing the credentials directly in the Swift source file to reduce plaintext credential exposure (screenshot 1).

<img src="attachments/feature1_risk1_control1_ss1.png" width="400" alt="Alt text">

2. Add the Swift Confidential package dependency to the Xcode project, enable the Swift Confidential build plugin for the target, and process `confidential.yml` during the application build process to reduce direct plaintext credential exposure in the compiled binary (screenshot 2 - 5).

<img src="attachments/feature1_risk1_control1_ss2.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control1_ss3.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control1_ss4.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control1_ss5.png" width="400" alt="Alt text">

3. Generate obfuscated Swift code with Swift Confidential so the app reconstructs the secret values at runtime instead of leaving the original strings directly in the source file and compiled binary. This makes simple static extraction harder, but it does not make runtime secrets unrecoverable.

> ***Note**: The `confidential.yml` file should not be built into the app bundle.*

4. Update the application code to reference the generated secret values, such as `Secrets.demoEmail` and `Secrets.demoPassword`, instead of directly using plaintext credentials in source code (screenshot 6).

<img src="attachments/feature1_risk1_control1_ss6.png" width="400" alt="Alt text">

5. Configure Swift Confidential's build-time obfuscation and runtime deobfuscation process to make straightforward recovery of secret values harder. Depending on the project configuration, the plugin may use a random mix of steps: `shuffle` rearranges bytes and stores obfuscated index metadata, `encrypt` encrypts secret bytes using AES-GCM or ChaChaPoly, `compress` compresses the data and hides compression magic bytes, and `nonce` uses a random number to hide or deobfuscate metadata such as keys, indexes, and magic bytes.

6. Review the generated obfuscation code to understand how encrypted secret values are reconstructed at runtime. In this implementation, encryption keys are stored as obfuscated key bytes and recovered at runtime by XORing the key bytes with nonce bytes. This is an obfuscation mechanism rather than a standalone cryptographic guarantee. The formula used is shown below.

```
byte ^ nonceBytes[index % nonceByteWidth]
```

7. Rebuild the application, extract the IPA, and check the compiled binary using `strings`, MobSF, and other static analysis tools to detect whether the original plaintext credential values still appear directly in the binary.

8. Review any remaining values found in the compiled binary, including usernames, passwords, API keys, tokens, backend URLs, private keys, salts, and test credentials. Move eligible values into `confidential.yml`, update the code to reference the generated secret values, and rebuild the application until those plaintext values no longer appear in static analysis results.

> ***Note**: At runtime, the app must eventually reconstruct the plaintext value to compare it. Swift Confidential mainly protects against easy static extraction with tools like `strings`, but it does not stop a determined attacker from debugging the app, hooking the getter, dumping memory, or patching the login result.*

### References

- https://github.com/securevale/swift-confidential.git
- https://github.com/securevale/swift-confidential-plugin.git

The IPA with the implemented control can be found [here](implemented_controls/platform-feature-01-risk-01-control-01.zip).
