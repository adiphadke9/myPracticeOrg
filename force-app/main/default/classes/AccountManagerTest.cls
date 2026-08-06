@isTest
public with sharing class AccountManagerTest {
    @isTest
    public static void deleteRecordsTest(){
        Account acc = new Account(Name = 'Salesforce.com');
        insert acc;

        RestRequest req = new RestRequest();
        req.requestURI = '/v1/AccountManager/'+acc.Id;
        RestContext.request = req;
        Test.startTest();
        AccountManager.deleteAccounts();
        Test.stopTest();
    }

    @isTest
    public static void getAccountListTest(){
        Account acc = new Account(Name = 'Salesforce.com');
        insert acc;

        RestRequest req = new RestRequest();
        req.requestURI = '/v1/AccountManager/'+acc.Id;
        RestContext.request = req;
        Test.startTest();
        AccountManager.getAccountList();
        Test.stopTest();
        Assert.areEqual('Salesforce.com', acc.Name,'The account name does not match!');
    }

    @isTest
    public static void createAccountTest(){
        RestRequest req = new RestRequest();
        req.requestURI = '/v1/AccountManager/';
        String requestBody = '''
        {
            "Name":"Salesforce.com",
            "Rating":"Hot",

        }''';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        Test.startTest();
        AccountManager.createAccount();
        Test.stopTest();
    }

    @isTest
    public static void createAccountErrorTest(){
        RestRequest req = new RestRequest();
        req.requestURI = '/v1/AccountManager/';
        RestContext.request = req;
        Test.startTest();
        AccountManager.createAccount();
        Test.stopTest();
    }
}