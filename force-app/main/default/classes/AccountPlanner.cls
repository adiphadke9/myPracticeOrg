global with sharing class AccountPlanner {
    webservice static String helloWorld(String name){
        return 'Hello, ' + name + '!';
    }

    webservice static String createAccount(String name,String industry){
        Account acc = new Account();
        acc.Name = name;
        acc.Industry= industry;
        insert acc;
        return acc.Id;
    }
}