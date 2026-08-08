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
        RestResponse res = new RestResponse();
        RestContext.response = res;
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

    @isTest
    public static void updateAccountTest(){
        Account acc = new Account(Name = 'Salesforce.com');
        insert acc;
        RestRequest req = new RestRequest();
        req.addHeader('X-API-KEY', 'api_key_uuu678');
        req.addParameter('FirstName', 'Amit Singh');
        String requestBody = '''
            {
                "Name":"PantherSchools.com",
                "Rating":"Hot",
                "Industry":"Education",
                "AnnualRevenue":88999.33
            }''';
        req.requestBody = Blob.valueOf(requestBody);
        req.requestURI = '/v1/AccountManager/' + acc.Id;
        RestContext.request = req;
        Test.startTest();
        Account accRecord = AccountManager.updateAccount();
        Test.stopTest();
    }
}