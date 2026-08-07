# Confidential Control Demo

This is a minimal SwiftUI app that demonstrates moving credential string literals out of Swift source and into `confidential.yml`.

The app intentionally references generated values instead of plaintext credentials:

```swift
Secrets.$demoEmail
Secrets.$demoPassword
```

Add these packages in Xcode:

- `https://github.com/securevale/swift-confidential.git`
- `https://github.com/securevale/swift-confidential-plugin.git`

Then add the Swift Confidential build plugin to the app target. The plugin reads `confidential.yml` and generates obfuscated Swift code during the build.

`confidential.yml` is included in the project navigator only. It is not part of the app target resources, so it is not copied into the app bundle.

After archiving, extract the IPA and run `strings` against the app binary. The credential values from `confidential.yml` should not appear as direct plaintext strings in the compiled binary.
