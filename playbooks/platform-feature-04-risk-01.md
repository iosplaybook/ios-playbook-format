## platform-feature-04-risk-01

### Description

Because the iOS platform provides screen capture feature, your application is at risk of an attacker an attacker capturing sensitive information displayed on the screen.

### Goal

As a result, this could lead to ***Collection*** - attackers capturing sensitive information displayed on screen.

### Demonstration

Set up physical iOS device and macOS workstation with the following configuration:

| Configuration | Detail                               |
| ------------- | ------------------------------------ |
| Prerequisite  | platform-feature-04                  |
| Malicious App | `feature4_risk1_bg-ss_malicious.zip` |

Perform the following steps to demonstrate the risk of an attacker capturing sensitive information displayed on the screen:

1. Enter information into the application interface. If not configured correctly, sensitive information can appear during screen capture.  

<img src="../attachments/feature4_risk1_ss1.png" width="400" alt="Sensitive information visible in screenshot">

*Screenshot shows visible username and blanked out password fields when both fields are filled*

2. Install and launch the malicious app. Tap on "`Start App Screen Recording`" to start the screen recording. The malicious app can automatically take screenshots during the screen recording even when it is moved to the background, potentially exposing sensitive information shown on screen. 

<img src="../attachments/feature4_risk1_ss2.png" width="400" alt="Replay Recorder application login screen">

*Screenshot shows notification from the app of the last screenshot saved*

3. Start screen recording when prompted. The screen recording feature displays a system popup and requires the user to press the `Start Broadcast` button before recording begins.

<img src="../attachments/feature4_risk1_ss3.png" width="400" alt="Screen recording start broadcast prompt">

*Screenshot shows screen mirroring popup*

4. The captured images and videos are stored in the app container instead of the local Photos album and remain persistent even when the application is force closed. This allows malicious actors to capture sensitive information outside of the malicious app. 

<img src="../attachments/feature4_risk1_ss4.png" width="400" alt="Captured screenshots and recordings saved in app container">

*Screenshot shows list of screen recording and screenshots taken by the malicious app*

Feature-04-Risk-01 Control Measures:
- [Platform_Feature-04-Risk-01-Control-01](Platform_Feature-04-Risk-01-Control-01.md)
