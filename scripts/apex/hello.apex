// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//AccountUtility.createAccount('New Test Account Created From Integration Oauth 2.0 PKCE Flow','Hot');
//QB_Customers.testCreateCustomer();
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:OpenCage/json?q=52.5432379%2C+13.4142133&key=22405b5b97dc4263829408528a118ef7');
req.setHeader('Content-Type','application/json');
req.setHeader('Accept','application/json');
req.setMethod('GET');

Http http = new Http();
HttpResponse res = http.send(req);
System.debug('Body'+res.getBody());
System.debug('Body'+res.getStatusCode());