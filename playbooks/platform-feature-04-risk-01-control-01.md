## platform-feature-04-risk-01-control-01

Your app can prevent the risk of an attacker capturing sensitive information displayed on the screen:

1. Implement the `SecureField` wrapper for sensitive fields such as the `Password` field. This ensures that the field is treated as sensitive instead of being displayed as normal plaintext content.

<img src="attachments/feature4_risk1_control1_ss1.png" width="400" alt="Alt text">

*Screenshot shows implementation of `SecureField` on the `Password` input*

2. The placeholder for the `Password` field is also no longer shown, indicating that some input exists without revealing the actual value or the number of characters entered. 

<img src="attachments/feature4_risk1_control1_ss2.png" width="400" alt="Alt text">

*Screenshot shows the username being captured but not the password, even when both fields are filled*

References:
- [https://medium.com/@lakshimi.cg/screenshot-prevention-in-ios-f059dc82b046](https://medium.com/@lakshimi.cg/screenshot-prevention-in-ios-f059dc82b046)

The IPA with the implemented control can be found [here](../steps/feature4_risk1_control1.zip).
