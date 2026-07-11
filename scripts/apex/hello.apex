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
EventBus.publish(event);*/
//Database.executeBatch(new AccountBatchHandler());
//OpportunityBulkCreator.createOpportunities(120);
//MetadataUtils.createLookupFields();
List<String> options = new List<String> {
    'Subject'
};
MetadataUtils.deleteMetadataRecords('ChildFieldDetails', options);