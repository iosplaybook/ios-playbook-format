## platform-feature-03-risk-01

### Description

Because the iOS platform provides HTTP Proxy configuration feature, your application is at risk of an attacker monitoring data between applications.

### Goal

As a result, this could lead to ***Collection*** - attackers being able to monitor data between applications.

### Demonstration

Set up physical iOS device and macOS workstation with the following configuration:

| Configuration | Detail              |
| ------------- | ------------------- |
| Prerequisite  | platform-feature-03 |

Perform the following steps to demonstrate the risk of an attacker monitoring data between applications:

1. Use BurpSuite to intercept a request. The intercepted request with data that can be studied to give the attack an idea on how to craft a payload for their attacks

<img src="../attachments/feature3_risk1_ss1.png" width="400" alt="Alt text">

*Screenshot shows intercepted packet containing data*

Feature-03-Risk-01 Control Measures:
- [Platform_Feature-03-Risk-01-Control-01](Platform_Feature-03-Risk-01-Control-01.md)
