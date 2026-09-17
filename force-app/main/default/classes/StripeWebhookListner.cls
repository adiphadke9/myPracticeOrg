@RestResource(urlMapping='/v1/webhook/stripe/*')
global class StripeWebhookListner {
    private static final String SIGNATURE_HEADER = '';
    private static final String ALGORITHM = 'HmacSHA256';
    private static final String webhookSecret = System.Label.webhookSecret;

    @HttpPost
    global static void handleStripeWebhook() {
        RestRequest req = RestContext.request;
        String jsonBody = req.requestBody.toString();
        System.debug('Received Stripe webhook: \n' + jsonBody);
        // Get headers for signature verification
        Map<String, String> headers = req.headers;
        //https://adityaphadke-dev-ed.my.site.com/lwcCourse/services/apexrest/v1/webhook/stripe/
        System.debug('Headers: \n' + JSON.serializePretty(headers));
        if (!isRequestValid(headers, jsonBody)) {
            RestContext.response.statusCode = 401;
            RestContext.response.responseBody = Blob.valueOf('{"status":"error"}');       
        }
        RestContext.response.statusCode = 200;
        RestContext.response.responseBody = Blob.valueOf('{"status":"success"}');
    }

    public static Boolean isRequestValid(Map<String, String> headers,String payload){
        String signatures = headers.get('Stripe-Signature');
        Map<String,String> parts = parseStripeSignature(signatures);
        String timestamp = parts.get('t');
        String expectedSignature = parts.get('v1');
        if (String.isBlank(timestamp) || String.isBlank(expectedSignature)) {
            return false;
        }

        String finalpayload = timestamp+'.'+payload;
        Blob hash = Crypto.generateMac(ALGORITHM, Blob.valueOf(finalpayload), Blob.valueOf(webhookSecret));
        String actualSignature = EncodingUtil.convertToHex(hash);
        return actualSignature.equals(expectedSignature);
    }

    private static Map<String, String> parseStripeSignature(String signature) {
        Map<String, String> parts = new Map<String, String>();
        String[] elements = signature.split(',');

        for (String element : elements) {
            String[] keyValue = element.split('=');
            if (keyValue.size() == 2) {
                parts.put(keyValue[0], keyValue[1]);
            }
        }
        return parts;
    }
}