@RestResource(urlMapping='/v1/webhooks/quickbooks/*')
global class QuickbooksWebhookListner {

    public static final String verifierToken = System.Label.Quickbooks_Verifier_Token;
    public static final String SIGNATURE_HEADER = 'intuit-signature';
    public static final String ALGORITHM = 'HnacSHA256';

    @HttpPost
    global static void doPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String requestBody = req.requestBody.toString();
        System.debug('received quickbooks webhook request'+ requestBody);
        Map<String,String> headers = req.headers;
        if (!isRequestValid(requestBody, headers)) {
            res.statuscode = 401;
            res.responseBody = Blob.valueOf('{"status":"error","message":"Invalid Request Signature"}');
            return;
        }

        //Return the response to Quickbooks
        res.statuscode = 200;
        res.responseBody = Blob.valueOf('{"status":"success}');
        //https://adityaphadke-dev-ed.my.site.com/lwcCourse/services/apexrest/v1/webhooks/quickbooks/
    }

    public static Boolean isRequestValid(String payload,Map<String,String> headers){
        Boolean isValid = false;
        String requestSignature = headers.get(SIGNATURE_HEADER);
        if (String.isBlank(requestSignature)) {
            return false;
        }
        Blob privatekey=Blob.valueOf(verifierToken);
        Blob payloadBlob = Blob.valueOf(payload);
        Blob encodedHash = Crypto.generateMac(ALGORITHM, payloadBlob, privatekey);
        String expctedSignature = EncodingUtil.base64Encode(encodedHash);
        isValid = expctedSignature.equals(requestSignature);
        return isValid;
    }
}