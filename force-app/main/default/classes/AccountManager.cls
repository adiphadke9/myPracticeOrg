@RestResource(urlMapping='/v1/AccountManager/*')
global with sharing class AccountManager {

    @httpDelete
    global static void deleteAccounts(){
        RestRequest req = RestContext.request;
        String accountId = req.requestURI.substringAfterLast('/');
        Database.delete(accountId);
    }

    @httpGet
    global static AccountWrapper getAccountList(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substringAfterLast('/');
        Account acc = [
            SELECT Id, Name,
                BillingStreet, BillingCity, BillingState,
                BillingPostalCode, BillingCountry
            FROM Account
            WHERE Id = :accountId
        ];
        AccountWrapper wrapper = new AccountWrapper();
        wrapper.id = acc.Id;
        wrapper.name = acc.Name;

        BillingAddress addr = new BillingAddress();
        addr.street = acc.BillingStreet;
        addr.city = acc.BillingCity;
        addr.state = acc.BillingState;
        addr.postalCode = acc.BillingPostalCode;
        addr.country = acc.BillingCountry;

        wrapper.billingAddress = addr;

        return wrapper;
    }

    @httpPost
    global static Account createAccount(){
        Account acc = new Account();
        acc.Name = '';
        acc.Rating = '';
        acc.Phone = '';

        //insert acc;

        return acc;
    }

    @httpPatch
    global static Account updateAccount(){
        RestRequest req = RestContext.request;
        String accountId = req.requestURI.substringAfterLast('/');
        String request = req.requestBody.toString();
        Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(request);
        Account accToUpadte = new Account(Id=accountId);
        accToUpadte.Name= (String)data.get('Name');
        accToUpadte.Rating = (String)data.get('Rating');
        accToUpadte.Industry = (String)data.get('Industry');
        accToUpadte.AnnualRevenue= (Decimal)data.get('AnnualRevenue');
        Database.update(accToUpadte);
        return accToUpadte;
    }

    global class AccountWrapper {
        global String id;
        global String name;
        global BillingAddress billingAddress;
    }

    global class BillingAddress {
        global String street;
        global String city;
        global String state;
        global String postalCode;
        global String country;
    }
}