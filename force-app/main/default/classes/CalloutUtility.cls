public with sharing class CalloutUtility {
    public static HttpRequest prepareRequest(String endPoint, String method, String body, String accept, String contentType) {
            HttpRequest httpreq = new HttpRequest();
            httpreq.setEndpoint(endPoint);
            httpreq.setMethod(method);
            if (!String.isBlank(body)) {
                httpreq.setBody(body);
            }
            httpreq.setHeader('Content-Type', contentType);
            if (!String.isBlank(accept)) {
                httpreq.setHeader('Accept', 'application/json');
            }
           return httpreq;
    }
}