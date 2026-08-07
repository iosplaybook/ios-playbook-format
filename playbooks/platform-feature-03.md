## platform-feature-03

### Description

The iOS platform provides HTTP proxy configuration feature.

### Additional Context

HTTP proxy configuration is a feature that allows network traffic from a physical iOS device to be routed through a tester-controlled proxy server, enabling authorised security testers to inspect HTTP requests and responses, observe backend endpoints, validate transport security behaviour, and identify sensitive data exposure during dynamic analysis. 

### Demonstration

Set up a physical iOS device with the following configuration:

| Configuration  | Detail         |
| -------------- | -------------- |
| Device Model   | iPhone 15      |
| iOS Version    | 17.6           |
| Device State   | Non-Jailbroken |
| Tools Required | `BurpSuite`    |

Perform the following steps to enable HTTP proxy:

1. Connect the iPhone and the macOS workstation to the same Wi-Fi network. This allows the iPhone to reach the Burp Suite proxy listener running on the workstation. 

2. Identify the IP address of the macOS workstation by running the following command in Terminal: `ipconfig getifaddr en0`. Use the returned IP address as the proxy server address on the iPhone.

<img src="attachments/feature3_ss1.png" width="400" alt="Alt text">

*Screenshot shows IP Address identified to be used for proxy*

3. On the macOS workstation, open Burp Suite and navigate to `Settings > Tools > Proxy > Proxy listeners`. Edit the active listener or click `Add`. Set Bind to port to `8080` and Bind to IP to `All interfaces`, or select the Mac's local IP address. This allows Burp Suite to accept network traffic from the iPhone.

<img src="attachments/feature3_ss2.png" width="400" alt="Alt text">

*Screenshot shows proxy listener set up on 10.132.0.31:8080*

4. On the iPhone, go to `Settings > Wi-Fi` and tap the `(i)` icon next to the connected network. Select Configure `Proxy > Manual`. Enter the macOS workstation's IP address as the server and `8080` as the port. This configures the iPhone to route network traffic through the Burp Suite proxy.

<img src="attachments/feature3_ss3.png" width="400" alt="Alt text">

*Screenshot shows step1 of configuring a manual proxy*

<img src="attachments/feature3_ss4.png" width="400" alt="Alt text">

*Screenshot shows step2 of configuring a manual proxy*

<img src="attachments/feature3_ss5.png" width="400" alt="Alt text">

*Screenshot shows step3 of configuring a manual proxy*

5. Browse to the URL `http://burpsuite` to download the CA certificate.

6. Install the CA certificate profile on the iPhone.

7. Under settings 

Because the iOS platform provides HTTP Proxy Configuration feature, your app is at risk of:
- [platform-feature-03-risk-01](platform-feature-03-risk-01.md)
