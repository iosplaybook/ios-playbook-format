## platform-feature-03-risk-01

### Description

Because the iOS platform provides HTTP Proxy configuration feature, your app is at risk of an attacker monitoring data between apps.

### Goal

As a result, this could lead to ***Collection*** - attackers being able to monitor data between apps.

### Demonstration

Set up physical iOS device and macOS workstation with the following configuration:

| Configuration | Detail              |
| ------------- | ------------------- |
| Prerequisite  | platform-feature-03 |

Perform the following steps to demonstrate the risk of an attacker monitoring data between apps:

1. Launch the target app on the iPhone and use the features to be tested. In Burp Suite, go to `Proxy > HTTP history` and turn off Intercept to allow the app to run without interruption. Verify that Burp Suite captures the app's `HTTP` and `HTTPS` traffic.

<img src="attachments/feature3_risk1_ss1.png" width="400" alt="Alt text">

*Screenshot shows intercepted packet containing data*

Feature-03-Risk-01 Control Measures:
- [platform-feature-03-risk-01-control-01](platform-feature-03-risk-01-control-01.md)
