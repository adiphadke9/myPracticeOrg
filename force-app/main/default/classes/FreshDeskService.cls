public with sharing class FreshDeskService {
    public static String ENDPOINT = 'https://aphadke.freshdesk.com';
    public static HttpResponseWrapper createTicket(Map<String,Object> valueMap){
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
        HttpResponseWrapper wrapper = new HttpResponseWrapper();
        try{
            HttpResponse httpresp = http.send(httpreq);
            System.debug('FreshDesk Response: '+httpresp.getBody());
            System.debug('Status: '+httpresp.getStatus());
            System.debug('Status Code: '+httpresp.getStatusCode());
            if(httpresp.getStatusCode() == 201 || httpresp.getStatusCode() == 200){
                System.debug('Ticket created successfully.');
                wrapper.isSuccess = true;     
                wrapper.message = 'Ticket has been created Successfuly';
            }else{
                System.debug('Failed to create ticket.');
                wrapper.isSuccess = false;
                wrapper.stautsCode = httpresp.getStatusCode();
                wrapper.errorMessage = 'Error while creating ticket';
            }
        }catch(System.CalloutException ce){
            System.debug('CalloutException in FreshDeskService.createTicket: ' + ce.getMessage());
            wrapper.isSuccess = false;
            wrapper.stautsCode = 400;
            wrapper.errorMessage = 'Error'+ ce.getCause();
        }catch(System.Exception e){
            System.debug('Exception in FreshDeskService.createTicket: ' + e.getMessage());
            wrapper.isSuccess = false;
            wrapper.stautsCode = 400;
            wrapper.errorMessage = 'Error'+ e.getCause();
        }
        return wrapper;
    }

    public static void listallContacts(){
        String header = System.Label.FreshDeskAPIKey+':'+'X';
        String authHeader = EncodingUtil.base64Encode(Blob.valueOf(header));
        HttpRequest httpreq = new HttpRequest();
        httpreq.setEndpoint(ENDPOINT+'/api/v2/contacts');
        httpreq.setHeader('Authorization', 'Basic '+authHeader);
        httpreq.setHeader('Content-Type', 'application/json');
        httpreq.setMethod('GET');
        Http http = new Http();
         try{
            HttpResponse httpresp = http.send(httpreq);
            System.debug('FreshDesk Response: '+httpresp.getBody());
            System.debug('Status: '+httpresp.getStatus());
            System.debug('Status Code: '+httpresp.getStatusCode());
            if(httpresp.getStatusCode() == 201 || httpresp.getStatusCode() == 200){
                List<FreshDeskContactWrapper> listcontacts = (List<FreshDeskContactWrapper>) System.JSON.deserialize(httpresp.getBody(), List<FreshDeskContactWrapper>.class);
                List<Contact> contactList = new List<Contact>();
                for (FreshDeskContactWrapper con : listcontacts) {
                    String lastName = con.last_name ?? con.first_name;
                    if (String.isBlank(lastName)) {
                        lastName = 'No Last Name';
                    }
                    Contact contactRec = new Contact(
                        LastName = lastName,
                        FirstName = con.first_name,
                        Phone = con.phone,
                        Email = con.email,
                        Title = con.job_title,
                        Freshdesk_Id__c = con.id
                    );
                    contactList.add(contactRec);
                }
                upsert contactList Freshdesk_Id__c;
            }else{
                
            }
        }catch(System.CalloutException ce){
            System.debug('CalloutException in FreshDeskService.createTicket: ' + ce.getMessage());
        }catch(System.Exception e){
            System.debug('Exception in FreshDeskService.createTicket: ' + e.getMessage());
        }
    }
}