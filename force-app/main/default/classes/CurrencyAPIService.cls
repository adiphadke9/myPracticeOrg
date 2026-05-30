public with sharing class CurrencyAPIService {
    public static void getExchangeRates(){
        //Callout Example
        HttpRequest httpreq = new HttpRequest();
        httpreq.setEndpoint('https://open.er-api.com/v6/latest/USD');
        httpreq.setHeader('Content-Type', 'application/json');
        httpreq.setHeader('Accept', 'application/json');
        httpreq.setMethod('GET');
        Http http = new Http();
        try {
        HttpResponse httpresp = http.send(httpreq);
        System.debug('Response: '+httpresp.getBody());
        System.debug('Status Code: '+httpresp.getStatusCode());
        System.debug('Status: '+httpresp.getStatus());
        } catch (System.CalloutException ce) {
            
        }catch (System.Exception e) {
            
        }
    }
}