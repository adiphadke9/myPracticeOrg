public with sharing class FreshDeskTicketController {
    @AuraEnabled
    public static void createTicket(Map<String,Object> inputMap){
        FreshDeskService.createTicket(inputMap);
    }
}