@isTest
public with sharing class CaseTriggerTest {
    @isTest
    public static void createTest(){
        Account acc = new Account(Name='Salesforce.com');
        insert acc;
        Contact con = new Contact(
            FirstName = 'Aditya',
            LastName = 'Phadke',
            Email = 'a@b.com',
            Phone = '123456789',
            AccountId = acc.Id
        );
        insert con;
        Case caseRecord = new Case(
            ContactId = con.Id,
            Subject = 'Test Class',
            Description = 'Test Class',
            Status = 'New',
            Priority = 'High',
            Origin = 'Web'
        );
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CaseTriggerMock());
        insert caseRecord;
        Test.stopTest();
    }
}