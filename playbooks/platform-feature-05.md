## platform-feature-05

### Description

The iOS platform provides Custom Keyboard feature.

### Additional context

Custom Keyboard is a feature that allows users to install and use third-party keyboards from an app, select them for text input across supported apps, and grant additional access when Allow Full Access is enabled.

### Demonstration

Set up a physical iOS device with the following configuration:

| Configuration | Detail                        |
| ------------- | ----------------------------- |
| Device Model  | iPhone 15                     |
| iOS Version   | 17.6                          |
| Device State  | Non-Jailbroken                |
| Apps Used     | `feature5-local_keyboard.zip` |

Perform the following steps to enable Custom Keyboard:

1. Download and install the `feature5-local_keyboard.zip` app to provide the custom keyboard.

2. Navigate `Settings > General > Keyboard > Keyboards > Add New Keyboard > Third-Party Keyboards` to add another keyboard. Select the custom keyboard from the app to add it and start using it.

<img src="attachments/feature5_ss1.png" width="400" alt="Alt text">

*Screenshot shows step1 of adding a third-party keyboard*

<img src="attachments/feature5_ss2.png" width="400" alt="Alt text">

*Screenshot shows step2 of adding a third-party keyboard*

<img src="attachments/feature5_ss3.png" width="400" alt="Alt text">

*Screenshot shows step3 of adding a third-party keyboard*

<img src="attachments/feature5_ss4.png" width="400" alt="Alt text">

*Screenshot shows step4 of adding a third-party keyboard*

<img src="attachments/feature5_ss5.png" width="400" alt="Alt text">

*Screenshot shows step5 of adding a third-party keyboard*

3. Select the newly added keyboard to open its settings. Enable `Allow Full Access` for the third-party keyboard to grant additional keyboard access.

<img src="attachments/feature5_ss6.png" width="400" alt="Alt text">

*Screenshot shows how to access custom keyboard permissions*

<img src="attachments/feature5_ss7.png" width="400" alt="Alt text">

*Screenshot shows enabling full access to custom keyboard*

Because the iOS platform provides Custom Keyboard feature, your app is at risk of:

- [platform-feature-05-risk-01](platform-feature-05-risk-01.md)
- [platform-feature-05-risk-02](platform-feature-05-risk-02.md)
