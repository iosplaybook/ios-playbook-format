## platform-feature-01-risk-02

### Description

Because the iOS platform provides IPA acquisition feature, your app is at risk of an attacker repackaging an IPA with Frida Gadget.

### Goal

As a result, this could lead to _**Credential Access**_ - attackers reading from the device's keychain.

### Demonstration

Set up a workstation with the following configuration:

| Configuration | Detail               |
| ------------- | -------------------- |
| Prerequisite  | platform-feature-01  |
| Frida Gadget  | `Frida-Gagdet.dylib` |

Perform the following steps to demonstrate the risk of an attacker analysing the app's IPA file:

1. Follow steps under `feature-01` to obtain the IPA of the app. An IPA is basically a zip archive containing: `Payload/TargetApp.app/`. The .app bundle contains the app binary, Info.plist, embedded provisioning profile, Swift libraries, and other resources.

2. Unpack The IPA so the app bundle can be modified. Add [Frida Gadget](https://github.com/frida/frida/releases/download/17.9.10/frida-gadget-17.9.10-ios-universal.dylib.gz) to the app bundle under the `Frameworks` folder.

``` shell
gunzip frida-gadget-17.9.10-ios-universal.dylib.gz
mv frida-gadget-17.9.10-ios-universal.dylib FridaGadget.dylib

mkdir -p patched-ipa/Payload/TargetApp.app/Frameworks

cp FridaGadget.dylib patched-ipa/Payload/TargetApp.app/Frameworks/
cp FridaGadget.config patched-ipa/Payload/TargetApp.app/Frameworks/
```

4. Patch the App Binary. The app binary must be modified so iOS loads the `Frida-Gadget.dylib` when the app starts. This adds a Mach-O load command to the app binary.

``` shell
insert_dylib --strip-codesig --inplace "@executable_path/Frameworks/FridaGadget.dylib" "patched-ipa/Payload/TargetApp.app/TargetApp"
```

5. Re-sign the modified application using a valid Apple Development signing identity and compatible provisioning profile. Sign the added Frida Gadget library before signing the application bundle. Repackage the signed application into an IPA if required, then install the signed `.app` onto the device.

``` shell
codesign --force --sign "<SIGNING_IDENTITY>" \
  patched-ipa/Payload/TargetApp.app/Frameworks/FridaGadget.dylib

codesign --force --sign "<SIGNING_IDENTITY>" \
  --entitlements entitlements.plist \
  patched-ipa/Payload/TargetApp.app

mkdir -p dist
cd patched-ipa
zip -qry ../dist/TargetApp-frida.ipa Payload
cd ..

xcrun devicectl device install app \
  --device <DEVICE_UDID> \
  patched-ipa/Payload/TargetApp.app
```

6. Launch the modified application under a debugger so runtime instrumentation using Frida `Interceptor` is permitted on the non-jailbroken device. After the application starts and Frida Gadget is loaded, attach Frida from the Mac and load the hook script.

``` shell
frida -U -n Gadget -l scripts/keychain-observe.js
```

7. By hooking `SecItemCopyMatching()`, Frida can observe the Keychain retrieval operation and inspect returned data when the application requests the stored value.

Feature-01-Risk-01 control measures:

- [platform-feature-01-risk-02-control-01](platform-feature-02-risk-01-control-01.md)

References:

- https://mas.owasp.org/MASTG/techniques/ios/MASTG-TECH-0058/
