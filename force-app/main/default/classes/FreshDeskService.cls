public with sharing class FreshDeskService {
    public static String ENDPOINT = 'https://aphadke.freshdesk.com';
    public static void createTicket(Map<String,Object> valueMap){
        String header = System.Label.FreshDeskAPIKey+':'+'X';
        String authHeader = EncodingUtil.base64Encode(Blob.valueOf(header));
        HttpRequest httpreq = new HttpRequest();
        httpreq.setEndpoint(ENDPOINT+'/api/v2/tickets');
        httpreq.setHeader('Authorization', 'Basic '+authHeader);
        httpreq.setHeader('Content-Type', 'application/json');
        httpreq.setMethod('POST');

        //String requestBody = '{ "description": "Details about the issue...", "subject": "Urgent Support Needed...","email": "tom@outerspace.com","priority": 4,"status": 2,"source":1,"cc_emails": ["ram@freshdesk.com","diana@freshdesk.com"]}';
        String requestBody = '''
            {
                "description": "${Description}",
                "subject": "${Subject}",
                "email": "${Contactemail}",
                "priority": ${Priority},
                "status": ${status},
                "source":${Source},
                "type":"${Typex}",
                "cc_emails": [
                    "ram@freshdesk.com",
                    "diana@freshdesk.com"
                ]
            } '''.template(valueMap);
        httpreq.setBody(requestBody);
        Http http = new Http();
        try{
            HttpResponse httpresp = http.send(httpreq);
            System.debug('FreshDesk Response: '+httpresp.getBody());
            System.debug('Status: '+httpresp.getStatus());
            System.debug('Status Code: '+httpresp.getStatusCode());
            if(httpresp.getStatusCode() == 201 || httpresp.getStatusCode() == 200){
                System.debug('Ticket created successfully.');
            }else{
                System.debug('Failed to create ticket.');
            }
        }catch(System.CalloutException ce){
            System.debug('CalloutException in FreshDeskService.createTicket: ' + ce.getMessage());
        }catch(System.Exception e){
            System.debug('Exception in FreshDeskService.createTicket: ' + e.getMessage());
        }
    }
}