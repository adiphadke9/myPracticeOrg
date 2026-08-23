global with sharing class AccountPlanner {
    webservice static String helloWorld(String name){
        return 'Hello, ' + name + '!';
    }

    webservice static String createAccount(InputWrapper input){
        Account acc = new Account();
        acc.Name = input.name;
        acc.Industry= input.industry;
        insert acc;
        return acc.Id;
    }

    global class InputWrapper{
        webservice String name;
        webservice String industry;
    }
}