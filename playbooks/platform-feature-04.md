## platform-feature-04
### Description

The iOS platform provides screen capture feature.

### Additional Context

Screen capture and screen mirroring allow the device screen to be captured or displayed on another device through screenshots, screen recording, or AirPlay screen mirroring. This may expose sensitive information shown on the screen, such as usernames, email addresses, or other personal identifiable information.

### Demonstration

Set up a physical iOS device with the following configuration:

| Configuration | Detail         |
| ------------- | -------------- |
| Device Model  | iPhone 15      |
| iOS Version   | 17.6           |
| Device State  | Non-Jailbroken |

Perform the following steps to enable screen capture:

1. Open the target app on the iPhone and capture the app interface using one of the following methods:

| Action            | Method                                                                                                                                                                                                                                                                                                                    |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Screenshot        | Press the `Volume Up` button and the `Side` button at the same time, then quickly release both buttons.                                                                                                                                                                                                                   |
| Screen Recording  | Swipe down from the top-right corner of the screen to open `Control Centre`, then tap the Screen Recording button (a solid dot inside a circle).                                                                                                                                                                          |
| AirPlay Mirroring | On a macOS workstation, open `System Settings` and search for `AirPlay Receiver`. Turn `AirPlay Receiver` on and set `Allow AirPlay` for `to Everyone`. On the iPhone, open `Control Centre`, tap `Screen Mirroring`, and select the macOS workstation. View and capture the mirrored display from the macOS workstation. |

<img src="attachments/feature4_ss1.png" width="400" alt="Alt text">

*Screenshot shows the correct setting configured for Airplay*

<img src="attachments/feature4_ss2.png" width="400" alt="Alt text">

*Screenshot highlights the screen mirroring icon*

<img src="attachments/feature4_ss3.png" width="400" alt="Alt text">

*Screenshot shows list of targets for screen mirroring*

Because the iOS platform provides Screenshot feature, your app is at risk of:
- [platform-feature-04-risk-01](platform-feature-04-risk-01.md)
