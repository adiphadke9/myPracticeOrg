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
    }
}