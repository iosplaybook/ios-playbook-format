## platform-feature-01

### Description

The iOS platform provides IPA acquisition feature.

### Additional context

IPA acquisition is a feature that allows an IPA file to be obtained from [iMazing](https://imazing.com/guides/how-to-manage-apps-without-itunes?utm_medium=app) on macOS, enabling security testers to inspect the application's structure, configuration, permissions, and entitlements.

### Demonstration

Set up a physical iOS device with the following configuration:

| Configuration | Detail         |
| ------------- | -------------- |
| Device model  | iPhone 15      |
| iOS Version   | 17.6           |
| Device State  | Non-Jailbroken |
| App Used      | HealthHub      |

Perform the following steps to enable IPA acquisition:

1. Install and Start iMazing. iMazing provides the tools required to manage apps on the connected iPhone and export the IPA file.
2. Select `Devices` and select the connected iPhone. Selecting the device allows iMazing to display the apps and management options for that iPhone.

<img src="attachments/feature1_ss1.png" width="500" alt="Alt text">

*Select `Devices > CSEC's iPhone (Connected iPhone)`*

5. Select `Manage Apps` to list the apps available on the connected iPhone and provides access to installation and export controls.

<img src="attachments/feature1_ss2.png" width="500" alt="Alt text">

*Select `Manage Apps`*

6. Install the app that you want to export. Wait for iMazing to complete the installation before continuing. Installing the app ensures that iMazing has access to the app package required for export.

<img src="attachments/feature1_ss3.png" width="500" alt="Alt text">

*Install the HealthHub app*

7. Select the More Options (`...`) button on the bottom right of iMazing and select `Export .IPA`. This creates an IPA file from the selected app package.

<img src="attachments/feature1_ss4.png" width="500" alt="Alt text">

*Export the IPA*

Because the iOS platform provides IPA acquisition feature, your app is at risk of:
- [platform-feature-01-risk-01](platform-feature-01-risk-01.md)
