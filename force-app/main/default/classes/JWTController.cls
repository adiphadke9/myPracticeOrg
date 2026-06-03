public with sharing class JWTController {
    public static void run() {
        Auth.JWT jwt = new Auth.JWT();
        jwt.setSub('adi.phadke9@empathetic-hawk-32don4.com'); 
        jwt.setAud('https://login.salesforce.com'); 
        jwt.setIss(Label.SalsforceJWTOrgClientId);

        Auth.JWS jws = new Auth.JWS(jwt, 'integrationcert');

        String tokenEndpoint = 'https://login.salesforce.com/services/oauth2/token';
        Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(tokenEndpoint, jws);
        String accessToken = bearer.getAccessToken();
        System.debug('accessToken: ' + accessToken);
        userinfo(accessToken);
    }

    public static void userinfo(String accesstoken){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://empathetic-hawk-32don4-dev-ed.trailblaze.my.salesforce.com/services/oauth2/userinfo');
        req.setHeader('Authorization', 'Bearer ' + accesstoken);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        Http http = new Http();
        HttpResponse resp = http.send(req);
        System.debug('UserInfo Response: ' + resp.getBody());
    }
}