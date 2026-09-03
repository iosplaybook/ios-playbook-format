## platform-feature-03-risk-01

### Description

Because the iOS platform provides screen capture feature, your app is at risk of an attacker an attacker capturing sensitive information displayed on the screen.

### Goal

As a result, this could lead to ***Collection*** - attackers capturing sensitive information displayed on screen.

### Demonstration

Set up physical iOS device and macOS workstation with the following configuration:

| Configuration | Detail                             |
| ------------- | ---------------------------------- |
| Prerequisite  | platform-feature-03                |
| Malicious App | `feature4-replay_consent_recorder` |

Perform the following steps to demonstrate the risk of an attacker capturing sensitive information displayed on the screen:

1. Install the malicious app on the iPhone. Use Xcode to open the [feature4-replay_consent_recorder](https://github.com/zhiyi-school/iosplaybook_sideload/tree/main/feature4) project, then build and run the app on the iPhone. 

``` swift
// Opens Apple's screen-recording consent picker
BroadcastPickerView(isEnabled: true, activationID: phoneRecordingRequestID)

// Receives screen frames from iOS and saves into file
override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
    if sampleBufferType == .video {
        videoInput?.append(sampleBuffer)
    }
}
```

2. Tap `Start App Screen Recording`. When the system prompt appears, tap `Start Broadcast` to authorise and begin the recording.

<img src="attachments/feature4_risk1_ss1.png" width="400" alt="Replay Recorder app login screen">

*Screenshot shows notification from the app of the last screenshot saved*

<img src="attachments/feature4_risk1_ss2.png" width="400" alt="Screen recording start broadcast prompt">

*Screenshot shows screen mirroring popup*

3. Switch to the target app and enter or display information while the recording continues. This tests whether an authorised recording session from another malicious app can capture information displayed in the target app.

4. Stop the recording and review the recorded images and videos. Check whether the captured content includes sensitive information displayed in the target app.

<img src="attachments/feature4_risk1_ss3.png" width="400" alt="Sensitive information visible in screenshot">

*Screenshot shows visible username and blanked out password fields when both fields are filled*

<img src="attachments/feature4_risk1_ss4.png" width="400" alt="Captured screenshots and recordings saved in app container">

*Screenshot shows list of screen recording and screenshots taken by the malicious app*

Feature-03-Risk-01 control measures:

- [platform-feature-03-risk-01-control-01](platform-feature-03-risk-01-control-01.md)
