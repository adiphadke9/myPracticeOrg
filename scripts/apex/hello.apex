// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

/*SAP_Account__e event = (SAP_Account__e) SAP_Account__e.sObjectType.newSObject(null, true);
System.debug('EventUUID'+event.EventUuid);
event.AccountId__c = '001Ie000009aWH2IAM';
event.AccountNumber__c = '2123232';
event.Name__c = 'Test Account for Debug log';
EventBus.publish(event);
//Database.executeBatch(new AccountBatchHandler());
//OpportunityBulkCreator.createOpportunities(120);
//MetadataUtils.createLookupFields();
List<String> options = new List<String> {
    'Subject'
};
MetadataUtils.deleteMetadataRecords('ChildFieldDetails', options);
CustomerWrapper customer = new CustomerWrapper();
customer.name = 'Aditya';
customer.age = '22';
customer.email = 'adi@gmail.com';
customer.phone = null;
String requestBody = JSON.serializePretty(customer);
System.debug(requestBody);
// Input JSON
// JSON array
String jsonStr = '[' +
  '{"Name":"Acme Corp","Industry":"Technology","AnnualRevenue":5000000},' +
  '{"Name":"Globex Inc","Industry":"Manufacturing","AnnualRevenue":12000000},' +
  '{"Name":"Initech","Industry":"Finance","AnnualRevenue":3500000}' +
']';

// deserialize to List<Account>
List<Account> accounts = (List<Account>) JSON.deserialize(jsonStr, List<Account>.class);
System.debug(accounts.size());            // 3
System.debug(accounts[0].Name);          // Acme Corp
System.debug(accounts[1].Industry);      // Manufacturing
System.debug(accounts[2].AnnualRevenue); // 3500000*/
FreshDeskService.createTicket();