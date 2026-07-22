## platform-feature-01-risk-01

### Description

Because the iOS platform provides IPA acquisition feature, your application is at risk of an attacker analyzing the application's IPA file.

### Goal

As a result, this could lead to _**Discovery**_ - attackers finding out the IPA's vulnerabilities.

### Demonstration

Set up a workstation with the following configuration:

| Configuration | Detail |
| -------- | ------- |
| Prerequisite | platform-feature-01 |
| Workstation | Web browser installed |

Perform the following steps to demonstrate the risk of an attacker analyzing the application's IPA file:

1. Set up a mobile application analyzer like Mobile Security Framework (MobSF) to listen on `http://localhost:8000` and perform static analysis on IPAs. Ensure Docker is running and confirm that the MobSF web interface loads before uploading the target IPA.

```shell
docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf
```

2. Upload a target IPA to initiate the analysis and review the generated report for exposed strings, bundled resources, Info.plist values, permissions, entitlements, embedded URLs, hardcoded credentials, and other sensitive information. Treat the report as a starting point because tool coverage depends on the IPA contents, app obfuscation, and MobSF configuration. Below shows an example of exposed hardcoded secrets within an IPA file (screenshot 1).

<img src="attachments/feature1_Risk1_ss1.png" width="400" alt="Alt text">

Feature-01-Risk-01 control measures:

- [platform-feature-01-risk-01-control-01](platform-feature-01-risk-01-control-01.md)
- [platform-feature-01-risk-01-control-02](platform-feature-01-risk-01-control-02.md)

References:

- https://mas.owasp.org/MASTG/techniques/ios/MASTG-TECH-0058/
