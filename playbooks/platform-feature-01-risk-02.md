## platform-feature-01-risk-02

### Description

Repackage the IPA

### Goal

As a result, this could lead to **_Persistence_** - attackers making a permanent modification to IPAs.

### Demonstration

#### 01. Prepare the environment

Set up the required environment with:

- A physical iPhone 15 running iOS 17.6
- A physical macOS workstation with Apple Configurator and Terminal
- A target app installed on the iPhone
- Frida Gadget, saved as `FridaGadget.dylib`
- A valid Apple Development signing identity and compatible provisioning profile

#### 02. Provide access to app

Sign in to the same Apple ID on both the physical iOS device and the macOS workstation. This ensures Apple Configurator can access the app licenses and deploy apps associated with the Apple ID.

#### 03. Trigger IPA download

Connect the iPhone to the macOS workstation and open Apple Configurator. Select the connected device, open the Apps tab, click Add, and search for the target app. Adding the app causes Apple Configurator to download the current production package from Apple's servers and temporarily store it in the local cache.

<img src="attachments/feature1_ss1_apple_config.png" width="500" alt="Alt text">

_Screenshot shows connected device in Apple Configurator._

<img src="attachments/feature1_ss2_apple_config.png" width="500" alt="Alt text">

_Screenshot shows the_ `_Apps_` _tab on the connected device._

<img src="attachments/feature1_ss3_apple_config.png" width="500" alt="Alt text">

_Screenshot shows the_ `_+ > Apps_` _selection in Apple Configurator._

<img src="attachments/feature1_ss4_apple_config.png" width="500" alt="Alt text">

_Screenshot shows the list of available apps._

#### 04. Save IPA

On the macOS workstation, open Terminal and navigate to the Apple Configurator temporary cache directory for the newly created IPA file. Copy the file to a designated analysis workspace for modification.

``` shell
~/Library/Group\ Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Assets/TemporaryItems/MobileApps/
```

<img src="attachments/feature1_ss5_apple_config.png" width="500" alt="Alt text">

_Screenshot shows the target app IPA in the Apple Configurator cache directory._

#### 05. Add Frida Gadget to the app bundle

An IPA is a ZIP archive containing `Payload/TargetApp.app/`. The `.app` bundle contains the app binary, `Info.plist`, embedded provisioning profile, Swift libraries, and other resources.

Unpack the IPA so the app bundle can be modified. Add [Frida Gadget](https://github.com/frida/frida/releases/download/17.9.10/frida-gadget-17.9.10-ios-universal.dylib.gz) to the app bundle under the `Frameworks` folder.

``` shell
unzip <TARGET_APP>.ipa -d patched-ipa

gunzip frida-gadget-17.9.10-ios-universal.dylib.gz
mv frida-gadget-17.9.10-ios-universal.dylib FridaGadget.dylib

mkdir -p patched-ipa/Payload/TargetApp.app/Frameworks

cp FridaGadget.dylib patched-ipa/Payload/TargetApp.app/Frameworks/
cp FridaGadget.config patched-ipa/Payload/TargetApp.app/Frameworks/
```

*Code block shows commands used to add Frida Gadget to the target IPA.*

#### 06. Patch the application binary

Patch the app binary so iOS loads `FridaGadget.dylib` when the app starts.

``` shell
insert_dylib --strip-codesig --inplace "@executable_path/Frameworks/FridaGadget.dylib" "patched-ipa/Payload/TargetApp.app/TargetApp"
```

*Code block shows command used to patch binary in IPA.*

#### 07. Re-sign and install the modified application

Re-sign the modified application using a valid Apple Development signing identity and compatible provisioning profile. Sign the added Frida Gadget library before signing the application bundle. Repackage the signed application into an IPA if required, then install the signed `.app` onto the device.

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

*Code block shows commands used to resign and reinstall repackaged IPA.*

#### 08. Attach Frida to the modified application

Launch the modified application under a debugger so runtime instrumentation using Frida `Interceptor` is permitted on the non-jailbroken device. After the application starts and Frida Gadget is loaded, attach Frida from the Mac and load the hook script. This allows attackers to manipulate application functions.

``` shell
frida -U -n Gadget -l <FRIDA_SCRIPT>
```

*Command shows how to run Frida with script to hook onto function within app.*

Feature-01-Risk-02 control measures:

- [platform-feature-01-risk-02-control-01](app://-/platform-feature-01-risk-02-control-01.md)

References:

- [https://mas.owasp.org/MASTG/techniques/ios/MASTG-TECH-0058/](https://mas.owasp.org/MASTG/techniques/ios/MASTG-TECH-0058/)

