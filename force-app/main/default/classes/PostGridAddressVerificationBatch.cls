public with sharing class PostGridAddressVerificationBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext batchContext){
        return Database.getQueryLocator('''
        SELECT Id, Name, BillingStreet, BillingCity, BillingState,
               BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState,
               ShippingPostalCode, ShippingCountry
                FROM Account
                WHERE CreatedDate = TODAY
                AND (AddressVerificationStatus__c = 'FAILED' OR AddressVerificationStatus__c = NULL)
        ''');
    }

    public void execute(Database.BatchableContext batchContext, List<Account> accountList){
        List<AddressVerifyRequest.Addresses> addressList = new List<AddressVerifyRequest.Addresses>();
        for (Account acc : accountList) {
            AddressVerifyRequest.Addresses address = new AddressVerifyRequest.Addresses();
            address.line1 = acc.BillingStreet;
            address.city = acc.BillingCity;
            address.postalOrZip = acc.BillingPostalCode;
            address.country = acc.BillingCountry;
            address.provinceOrState = acc.BillingState;
            addressList.add(address);
        }

        AddressVerifyRequest requestBody = new AddressVerifyRequest();
        requestBody.addresses = addressList;

        HttpRequest httpreq = new HttpRequest();
        httpreq.setEndpoint('https://api.postgrid.com/v1/addver/verifications/batch?geocode=true');
        httpreq.setMethod('POST');
        httpreq.setHeader('x-api-key', System.Label.postgrid_apikey);
        httpreq.setHeader('Content-Type', 'application/json');
        httpreq.setBody(System.JSON.serializePretty(requestBody));
        Http http = new Http();
        try {
            HttpResponse httpresp = http.send(httpreq);
            if(httpresp.getStatusCode() == 201 || httpresp.getStatusCode() == 200){
                AddressBatchWrapper wrapper = (AddressBatchWrapper)System.JSON.deserialize(httpresp.getBody(), AddressBatchWrapper.class);
                List<AddressBatchWrapper.Results> results = wrapper.data?.results;
                for (Integer i=0; i<results.size();i++) {
                    AddressBatchWrapper.Results result = results.get(i);
                    Account acc = accountList.get(i);
                    acc.AddressVerificationStatus__c = result?.verifiedAddress?.status?.toUpperCase();
                    acc.AddressVerificationError__c = System.JSON.serializePretty(result?.verifiedAddress?.errors);
                    acc.BillingCity = result?.verifiedAddress?.city;
                }
                update accountList;
                System.debug(httpresp.getBody());              
            }
        }catch(System.CalloutException ce){
            System.debug('CalloutException in FreshDeskService.createTicket: ' + ce.getMessage());
        }catch(System.Exception e){
            System.debug('Exception in FreshDeskService.createTicket: ' + e.getMessage());
        }
    }

    public void finish(Database.BatchableContext batchContext){

    } 
}