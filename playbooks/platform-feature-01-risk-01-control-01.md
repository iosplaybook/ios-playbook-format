## platform-feature-01-risk-01-control-01

Your app can prevent the risk of an attacker analyzing the application's IPA file by taking the following steps:

1. Prevent plaintext credential exposure by moving hardcoded Swift string literals, such as usernames and passwords, into a `confidential.yml` file instead of writing the credentials directly in the Swift source file (screenshot 1).

<img src="attachments/feature1_risk1_control1_ss1.png" width="400" alt="Alt text">

2. Prevent direct plaintext credential exposure in the compiled binary by adding the Swift Confidential package dependency in Xcode through **File > Add Package Dependencies**, selecting the Swift Confidential package, enabling the Swift Confidential build plugin for the app target, and processing `confidential.yml` during the application build process (screenshot 2 - 5). This reduces direct plaintext exposure only when the original strings are removed from source and the generated secret references are used consistently.

<img src="attachments/feature1_risk1_control1_ss2.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control1_ss3.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control1_ss4.png" width="400" alt="Alt text">

<img src="attachments/feature1_risk1_control1_ss5.png" width="400" alt="Alt text">

3. Prevent simple static extraction by generating obfuscated Swift code with Swift Confidential, such as generated `Secrets.demoEmail` and `Secrets.demoPassword` accessors that reconstruct secret values at runtime instead of leaving the original strings directly in the source file and compiled binary. This obfuscation raises the effort for string-based extraction, but it does not make runtime secrets unrecoverable.

> ***Note**: The `confidential.yml` file should not be built into the app bundle.*

4. Prevent direct use of plaintext credentials in source code by updating the application code to reference the generated secret values, such as `Secrets.demoEmail` and `Secrets.demoPassword`, instead of directly using plaintext credentials in source code (screenshot 6).

<img src="attachments/feature1_risk1_control1_ss6.png" width="400" alt="Alt text">

5. Prevent straightforward recovery of secret values by configuring Swift Confidential's build-time obfuscation and runtime deobfuscation process after reviewing whether the selected obfuscation methods fit the app's threat model. Depending on the project configuration, the plugin may use a random mix of steps: `shuffle` rearranges bytes and stores obfuscated index metadata, `encrypt` encrypts secret bytes using AES-GCM or ChaChaPoly, `compress` compresses the data and hides compression magic bytes, and `nonce` uses a random number to hide or deobfuscate metadata such as keys, indexes, and magic bytes.

6. Detect weak assumptions in the generated obfuscation code by reviewing how encrypted secret values are reconstructed at runtime. In this implementation, encryption keys are stored as obfuscated key bytes and recovered at runtime by XORing the key bytes with nonce bytes. This XOR operation is part of the obfuscation scheme and should not be treated as a standalone cryptographic control or as adequate protection against debugging, hooking, or memory inspection. The formula used is shown below.

```
byte ^ nonceBytes[index % nonceByteWidth]
```

7. Detect remaining plaintext credential exposure by rebuilding the application, extracting the IPA, and checking the compiled binary using `strings`, MobSF, and other static analysis tools to identify whether the original plaintext credential values still appear directly in the binary.

8. Prevent remaining plaintext credential exposure by reviewing any remaining values found in the compiled binary, including usernames, passwords, API keys, tokens, backend URLs, private keys, salts, and test credentials. Move only eligible values into `confidential.yml`, verify that the move does not break application logic or server-side validation, update the code to reference the generated secret values, and rebuild the application until those plaintext values no longer appear in static analysis results.

> ***Note**: At runtime, the app must eventually reconstruct the plaintext value to compare it. Swift Confidential mainly protects against easy static extraction with tools like `strings`, but it does not stop a determined attacker from debugging the app, hooking the getter, dumping memory, or patching the login result.*

### References

- https://github.com/securevale/swift-confidential.git
- https://github.com/securevale/swift-confidential-plugin.git

The IPA with the implemented control can be found [here](implemented_controls/platform-feature-01-risk-01-control-01.zip).
