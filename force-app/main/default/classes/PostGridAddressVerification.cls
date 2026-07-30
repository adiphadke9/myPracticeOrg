public with sharing class PostGridAddressVerification {
    public static void verifyStructuredAddresses(String line1, String line2, String city, String state, String postalCode, String country, String recipient){
        HttpRequest httpreq = new HttpRequest();
        httpreq.setEndpoint('https://api.postgrid.com/v1/addver/verifications?geocode=true');
        httpreq.setMethod('POST');
        httpreq.setHeader('x-api-key', System.Label.postgrid_apikey);
        httpreq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
       /* String requestBody = 
            'address[line1]=' + line1 +
            '&address[line2]=' + line2 +
            '&address[city]=' + city +
            '&address[provinceOrState]=' + state +
            '&address[postalOrZip]=' + postalCode +
            '&address[country]=' + country +
            '&address[recipient]=' + recipient;*/

        Map<String, Object> valueMap = new Map<String, Object>{
            'addressLine1'    => line1,
            'line2'           => line2,
            'city'            => city,
            'provinceOrState' => state,
            'postalOrZip'     => postalCode,
            'country'         => country,
            'recipient'       => recipient
        };

        String requestBody = '''
            address[line1]=${addressLine1}&
            address[line2]=${line2}&
            address[city]=${city}&
            address[provinceOrState]=${provinceOrState}&
            address[postalOrZip]=${postalOrZip}&
            address[country]=${country}&
            address[recipient]=${recipient}
        '''.replace('\n','').template(valueMap);

        httpreq.setBody(requestBody.trim());
        Http http = new Http();
        try {
            HttpResponse httpresp = http.send(httpreq);
            if(httpresp.getStatusCode() == 201 || httpresp.getStatusCode() == 200){
                System.debug(httpresp.getBody());              
            }
        }catch(System.CalloutException ce){
            System.debug('CalloutException in FreshDeskService.createTicket: ' + ce.getMessage());
        }catch(System.Exception e){
            System.debug('Exception in FreshDeskService.createTicket: ' + e.getMessage());
        }
    }
}