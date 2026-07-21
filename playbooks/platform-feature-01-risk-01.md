## platform-feature-01-risk-01

### Description

Because the iOS platform provides IPA acquisition feature, your application is at risk of an attacker analysing the application's IPA file.

### Goal

As a result, this could lead to _**Discovery**_ - attackers finding out the IPA's vulnerabilities.

### Demonstration

Set up a workstation with the following configuration:

| Configuration | Detail |
| -------- | ------- |
| Prerequisite | platform-feature-01 |
| Workstation | Web browser installed |

Perform the following steps to demonstrate the risk of an attacker analysing the application's IPA file:

1. Set up a mobile application analyser like Mobile Security Framework (MobSF) to perform analysis on IPAs.

```shell
docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf
```

2. Upload a target IPA to initiate the analysis. Look through the generated report to look for vulnerabilities and sensitive information. Below shows an example of exposed hardcoded secrets within an IPA file (screenshot 1).

<img src="attachments/feature1_Risk1_ss1.png" width="400" alt="Alt text">

Feature-01-Risk-01 control measures:

- [platform-feature-01-risk-01-control-01](platform-feature-01-risk-01-control-01.md)
- [platform-feature-01-risk-01-control-02](platform-feature-01-risk-01-control-02.md)

References:

- https://mas.owasp.org/MASTG/techniques/ios/MASTG-TECH-0058/
