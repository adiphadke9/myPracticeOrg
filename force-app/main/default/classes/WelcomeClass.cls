public with sharing class WelcomeClass {
    @InvocableMethod(label='Welcome Message' 
                     description='This method will return Welcome Message to Salesforce Org'
                     category='pantherschools')
    public static List<String> welcomemessage(List<String> inputs){
        //If you want to return String retrun type will be List<String>.
        //If you want to return a sObject, return type will be List<List<sObject>>.
        //If you want to return List<Id> , return type will be List<List<Id>>
        //Invocable method can only return List and Not Set or Map.
        String username = inputs.get(0);
        List<String> welcomemessageList = new List<String>{'Hi '+username+',Welcome to Salesforce Flows Leraning, message coming from Apex!'};
        return welcomemessageList;
    }
}