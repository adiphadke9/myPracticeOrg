public with sharing class FreshDeskTicketController {
    @AuraEnabled
    public static HttpResponseWrapper createTicket(Map<String,Object> inputMap){
        HttpResponseWrapper wrapper = FreshDeskService.createTicket(inputMap);
        return wrapper;
    }
}