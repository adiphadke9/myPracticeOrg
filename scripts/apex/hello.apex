// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//AccountUtility.createAccount('New Test Account Created From Integration Oauth 2.0 PKCE Flow','Hot');
//QB_Customers.testCreateCustomer();
String loggedInUserInfo ='/services/oauth2/userinfo';
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:JWTSF'+loggedInUserInfo);
req.setMethod('GET');
req.setHeader('Content-Type', 'application/json');
req.setHeader('Accept', 'application/json');
HTTPResponse res = (new Http()).send(req);
System.debug(res.getstatuscode());
System.debug(res.getBody());