public class JWT {
    
    private static final String JWT_HEADER = '{"alg":"RS256"}';

    public static String retrievePrivateKey(){
        ContentVersion base64Content = [SELECT VersionData FROM ContentVersion where Title='server' ORDER BY Title LIMIT 1];
        String keyContents = base64Content.VersionData.tostring();
        keyContents = keyContents.replace('-----BEGIN PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');
        return keyContents;
    }

    public static void run(){
        DateTime rightNow = System.now();
        rightNow = rightNow.addMinutes(3);
        Long expiry = rightNow.getTime();

        String claims = '{'+
            '"iss": "' + Label.SalsforceJWTOrgClientId + '",'+
            '"sub": "adi.phadke9@empathetic-hawk-32don4.com",'+
           ' "aud": "https://login.salesforce.com",'+
            '"exp": '+expiry+
       '}';

        String base64UrlJWTHeader = SFDC_BASE64_URLENCODE(Blob.valueOf(JWT_HEADER));
        String base64UrlJWTClaims = SFDC_BASE64_URLENCODE(Blob.valueOf(claims ));
        String combinedHeaderClaim =base64UrlJWTHeader+'.'+base64UrlJWTClaims;
        System.debug('combinedHeaderClaim \n'+combinedHeaderClaim);
        String jwtAssertion =shaSignPrivateKey(combinedHeaderClaim);
        System.debug('jwtstr \n '+ jwtAssertion);
        getAccessToken(jwtAssertion);
    }

    public static String shaSignPrivateKey(String combinedHeaderClaim){
        // base64Decode the Private key Content
        Blob privateKey = EncodingUtil.base64Decode(retrievePrivateKey() );
        // Sign the private Key using rsa-sha256 Algorithm
        Blob signature = Crypto.sign('rsa-sha256',Blob.valueOf(combinedHeaderClaim), privateKey);
        // Add the signature into the assertion
        combinedHeaderClaim += '.' +SFDC_BASE64_URLENCODE(signature);
        return combinedHeaderClaim;
    }

    public static String base64UrlEncode(String header){
        String base64UrlEncode = SFDC_BASE64_URLENCODE(Blob.valueOf(header) );
        return base64UrlEncode;
    }

    private static String SFDC_BASE64_URLENCODE( Blob input){
        if(input == null) {
            return null;
        }

        return EncodingUtil.base64Encode(input).replace('+','-').replace('/','_').replaceAll('=+$','');
    }

    private static void getAccessToken(String assertionValue){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token?grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion='+assertionValue);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        String response = res.getBody();
    }
//for testing purpose
}