public with sharing class PKCEAuthController {
    public static List<String> getDetails(){
        String code_verifier = System.UUID.randomUUID().toString();
        Blob sha256 = Crypto.generateDigest('SHA-256', Blob.valueOf(code_verifier));
        String code_challenge = SFDC_BASE_64_URLENCODE(sha256);
        System.debug('code_verifier: ' + code_verifier + ', code_challenge: ' + code_challenge);
        return new List<String> {code_verifier,code_challenge};
    }

    private static String SFDC_BASE_64_URLENCODE(Blob input){
        if (input == null) {
            return null;
        }

        return EncodingUtil.base64Encode(input).replace('+','-').replace('/','_').replaceAll('=+$','');
    }
}