public with sharing class ZendeskTicketUtils {

    /*ZendeskTicketUtils.TicketWrapper wrapper = new ZendeskTicketUtils.TicketWrapper();
    wrapper.body = 'This is a test ticket';
    wrapper.subject = 'Test Ticket';
    wrapper.priority = 'High';
    wrapper.requester = 'Test User';
    wrapper.email = 'A@b.com';

    ZendeskTicketUtils.createTicket(wrapper);*/

    public class TicketWrapper{
        public String body;
        public String subject;
        public String priority;
        public String requester;
        public String email;
    }

    public static void createTicket(TicketWrapper wrapper, Id caseId){
        String header = System.Label.Zendesk_Username+':'+System.Label.ZendeskAPIToken;
        String body=		'{'+
		'    "ticket": {'+
		'        "comment": {'+
		'            "body": "'+wrapper.body+'"'+
		'        },'+
		'        "priority": "'+wrapper.priority+'",'+
		'        "subject": "'+wrapper.subject+'",'+
		'        "requester": {'+
		'            "locale_id": 8,'+
		'            "name": "'+wrapper.requester+'",'+
		'            "email": "'+wrapper.email+'"'+
		'        }'+
		'    }'+
		'}';
        HttpRequest httpreq = new HttpRequest();
        httpreq.setEndpoint('https://salesforcepractice.zendesk.com/api/v2/tickets');
        httpreq.setMethod('POST');
        httpreq.setBody(body);
        httpreq.setHeader('Content-Type', 'application/json');
        httpreq.setHeader('Accept', 'application/json');
        httpreq.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(header)));
        Http http = new Http();
        try {
            HttpResponse httpresp = http.send(httpreq);
            if (httpresp.getStatusCode() == 201) {
                System.debug('Response: '+httpresp.getBody());
                Map<String,Object> responseMap =
                (Map<String,Object>) JSON.deserializeUntyped(httpresp.getBody());

                Map<String,Object> ticket =
                (Map<String,Object>) responseMap.get('ticket');

                Integer zendeskTicketId = Integer.valueOf(ticket.get('id'));

                Case c = new Case(Id = caseId);
                c.Zendesk_Ticket_Id__c = zendeskTicketId;
                System.debug('Zendesk Ticket Id: '+zendeskTicketId);
                update c;
            }
        }catch(System.Exception e){

        }
    }
}