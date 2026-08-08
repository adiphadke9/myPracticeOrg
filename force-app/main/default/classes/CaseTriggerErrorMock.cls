@isTest
public with sharing class CaseTriggerErrorMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req){
        HttpResponse response = new HttpResponse();
        String json= '{"errorMessage":"This is an Error Message"}';
        response.setBody(json);
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(403);
        response.setStatus('ERROR');
        return response;
    }
}