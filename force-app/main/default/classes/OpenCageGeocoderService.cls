//SalesforcePractice
//Token - KKOboVSENkMjkSwKJsVCoINMNgwXaJ7TmoCpzUZn
public with sharing class OpenCageGeocoderService {
    public static void reverseGeoCoding(String accountId){
        Account acc = [Select Id, Location__latitude__s, Location__longitude__s 
                        from Account where Id =: accountId 
                        and Location__latitude__s!=null 
                        and Location__longitude__s!=null limit 1];
        String queryParams = acc.Location__latitude__s+','+acc.Location__longitude__s;
        //Callout Example
        HttpRequest httpreq = new HttpRequest();
        httpreq.setEndpoint(System.Label.Opencage_API_URL+'?key='+System.Label.Opencage_API_Key+'&q='+queryParams+'&pretty=1');
        httpreq.setHeader('Content-Type', 'application/json');
        httpreq.setHeader('Accept', 'application/json');
        httpreq.setMethod('GET');
        Http http = new Http();
        try {
        HttpResponse httpresp = http.send(httpreq);
        String responseBody = httpresp.getBody();
        Integer StatusCode = httpresp.getStatusCode();
        if (StatusCode == 200) {
            OpenCageReverseResponseWrapper wrapper = (OpenCageReverseResponseWrapper) System.JSON.deserialize(responseBody, OpenCageReverseResponseWrapper.class);
            if (wrapper?.results?.size()>0) {
                OpenCageReverseResponseWrapper.results rslt = wrapper.results.get(0);
                acc.BillingStreet = rslt?.components?.road;
                acc.BillingCity = rslt?.components?.city;
                acc.BillingState = rslt?.components?.state;
                acc.BillingPostalCode = rslt?.components?.postcode;
                acc.BillingCountry = rslt?.components?.country;

                acc.ShippingStreet = rslt?.components?.road;
                acc.ShippingCity = rslt?.components?.city;
                acc.ShippingState = rslt?.components?.state;
                acc.ShippingPostalCode = rslt?.components?.postcode;
                acc.ShippingCountry = rslt?.components?.country;
                update acc; 
            }
        }else {
            
        }
        } catch (System.CalloutException ce) {
            
        }catch (System.Exception e) {
            
        }
    }
}