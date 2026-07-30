## platform-feature-03-risk-01-control-01

Your app can prevent the risk of an attacker monitoring data between applications:

1. By calling `CFNetworkCopySystemProxySettings()`, the current system-wide internet proxy configuration can be retrieved. 

<img src="../attachments/feature3_risk1_control1_ss1.png" width="400" alt="Alt text">

*Screenshot shows the source code calling `CFNetworkCopySystemProxySettings()` to retrieve the proxy configuration*

2. The returned dictionary can contain keys such as `HTTPEnable`, `HTTPProxy`, `HTTPPort`, `HTTPSEnable`, `HTTPSProxy`, `HTTPSPort`, `SOCKSEnable`, `SOCKSProxy`, and `SOCKSPort`. If a proxy is configured, the dictionary may contain a value similar to the following:

```
[ "HTTPEnable": 1, "HTTPProxy": "192.168.1.10", "HTTPPort": 8080 ]
```

3. Create a warning to the user when a proxy configured. This alerts the user to be careful when sending high-risk requests.

<img src="../attachments/feature3_risk1_control1_ss2.png" width="400" alt="Alt text">

*Screenshot shows source code for proxy configuration check*

<img src="../attachments/feature3_risk1_control1_ss3.png" width="400" alt="Alt text">

*Screenshot shows warning to user that proxy is configured*

### References

- https://developer.apple.com/documentation/cfnetwork/cfnetworkcopysystemproxysettings()

The IPA with the implemented control can be found [here](../steps/feature3_risk1_control1.zip).