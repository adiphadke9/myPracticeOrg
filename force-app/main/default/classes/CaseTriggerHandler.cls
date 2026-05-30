public with sharing class CaseTriggerHandler {
    public static void handleAfterInsert(List<Case> newRecords){
        for(Case c : newRecords){
            ZendeskTicketUtils.TicketWrapper wrapper = new ZendeskTicketUtils.TicketWrapper();
            wrapper.body = c.Description;
            wrapper.subject = c.Subject;
            wrapper.priority = c.Priority.toLowerCase();
            wrapper.requester = 'Aditya Phadke';
            wrapper.email = 'A@b.com';
            //Converting the object into string as future and future methods can't accept object as parameter
            //So we are passing the JSON string as parameter and converting it into object inside the future method
            makeCallout(JSON.serialize(wrapper), c.Id);
        }
    }

    @future(callout=true)
    private static void makeCallout(String params, Id caseId){
        ZendeskTicketUtils.TicketWrapper wrapper = (ZendeskTicketUtils.TicketWrapper) JSON.deserialize(params, ZendeskTicketUtils.TicketWrapper.class);
        ZendeskTicketUtils.createTicket(wrapper, caseId);
    }
}