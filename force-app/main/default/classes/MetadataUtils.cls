public with sharing class MetadataUtils {
    public static MetadataService.MetadataPort createService(){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = getSessionId();
        return service;
    }

    public static void listmetadata(){
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        
        MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
        query.type_x = 'CustomObject';

        MetadataService.ListMetadataQuery query_profile = new MetadataService.ListMetadataQuery();
        query_profile.type_x = 'Profile';
        queries.add(query);
        queries.add(query_profile);

        List<MetadataService.FileProperties> properties = service.listMetadata(queries, 60);
        System.debug(System.JSON.serializePretty(properties));
    }

    public static void readMetadata(){
        MetadataService.MetadataPort service = createService();
        List<String> itemList = new String[]{'Admin'};
        MetadataService.Profile profiledetails = (MetadataService.Profile) service.readMetadata('Profile', itemList).getRecords()[0];
        MetadataService.ProfileLoginHours loginhours = profiledetails.loginHours;
        MetadataService.ProfileLoginIpRange[] loginIpRanges = profiledetails.loginIpRanges;
        System.debug('loginhours \n'+ loginhours);
        System.debug('loginIpRanges \n'+ loginIpRanges);
    }

    public static void createObject(){
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomObject customobject = new MetadataService.CustomObject();
        MetadataService.CustomField namefield = new MetadataService.CustomField();
        customobject.label = 'Stripe Invoice';
        customobject.pluralLabel = 'Stripe Invoices';
        customobject.fullName = 'StripeInvoice__c';
        customobject.enableHistory = true;
        customobject.enableActivities = true;
        customobject.enableSearch = true;
        customobject.enableReports = true;

        namefield.type_x = 'Text';
        namefield.label = 'Stripe Invoice Id';
        customobject.deploymentStatus = 'Deployed';
        customobject.sharingModel = 'ReadWrite';
        customobject.nameField = namefield;

        List<MetadataService.Metadata> customObjectList = new List<MetadataService.Metadata>();
        customObjectList.add(customobject);

        List<MetadataService.SaveResult> saveResult = service.createMetadata(customObjectList);
        System.debug(System.JSON.serializePretty(saveResult));
    }

    public static void createFields(){
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = 'StripeInvoice__c.StripeUUID__c';
        customField.label = 'StripeUUID';
        customField.type_x = 'Text';
        customField.description = 'This is the field created from Custom Metadata API';
        customField.inlineHelpText = 'This is the field created from Custom Metadata API';
        customField.length = 120;
        customField.required = false;
        customField.unique = false;
        customField.externalId = true;
        customField.caseSensitive = false;

        List<MetadataService.Metadata> customFieldList = new List<MetadataService.Metadata>();
        customFieldList.add(customField);
        List<MetadataService.SaveResult> saveResult = service.createMetadata(customFieldList);
        System.debug(System.JSON.serializePretty(saveResult));
    }

    public static void createLookupFields(){
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = 'StripeInvoice__c.StripeCustomer__c';
        customField.label = 'Stripe Customer';
        customField.type_x = 'Lookup';
        customField.description = 'This is the Lookup field created from Custom Metadata API';
        customField.inlineHelpText = 'This is the Lookup field created from Custom Metadata API';
        customField.referenceTo =
        customField.relationshipLabel = 'Stripe Invoices';
        customField.relationshipName = 'StripeInvoices';
        customField.referenceTo = 'Account';

        List<MetadataService.Metadata> customFieldList = new List<MetadataService.Metadata>();
        customFieldList.add(customField);
        List<MetadataService.SaveResult> saveResult = service.createMetadata(customFieldList);
        System.debug(System.JSON.serializePretty(saveResult));
    }

    public static void createPicklistField(List<String> options){
        
        MetadataService.MetadataPort service 	= createService();
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName 		= 'StripeInvoice__c.InvoiceStatus__c';
        customField.label 			= 'Invoice Status';
        customField.type_x 			= 'Picklist';
        customField.description 	= 'This is the picklist field created from Custom Metadata while recording UDEMY INTEGRATION';
        customField.inlineHelpText	= 'This is the picklist field created from Custom Metadata while recording UDEMY INTEGRATION';
        
        MetadataService.ValueSet valueSetDef 		 = new MetadataService.ValueSet();
        
        MetadataService.ValueSetValuesDefinition valueDefinition = new MetadataService.ValueSetValuesDefinition();
        
        List<MetadataService.CustomValue> values 	 = new List<MetadataService.CustomValue>();        
        for(String value : options){
            MetadataService.CustomValue customValue = new MetadataService.CustomValue();
            customValue.fullName  = value; 
            customValue.default_x = false;
            customValue.isActive  = true;
            customValue.label     = value;
            values.add(customValue);
        }
        valueDefinition.value  			= values;
        valueDefinition.sorted 			= true;
        
        valueSetDef.valueSetDefinition  = valueDefinition;
        valueSetDef.restricted			= true;
        
        customField.valueSet 		    = valueSetDef;
        customField.required			= true;
        List<MetadataService.SaveResult> results = service.createMetadata( new MetadataService.Metadata[] { customField } );
        System.debug(System.JSON.serializePretty(results));
    }

    public static void deleteMetadataRecords(String metadataType,List<String> names){
        MetadataService.MetadataPort service = createService();
        List<String>recordsToDelete = new List<String>();
        for(String name : names){
            recordsToDelete.add(metadataType+'.'+name);
        }
        List<MetadataService.DeleteResult> deleteResults = service.deleteMetadata('CustomMetadata', recordsToDelete);
        System.debug(System.JSON.serializePretty(deleteResults));
    }

    public static String getSessionId(){
        String sessionId = '';
        PageReference sessionPage = Page.SessionId;
        String vfContent = sessionPage.getContent().toString();
        Integer startP = vfContent.indexOf('Start_of_Session_Id') + 'Start_of_Session_Id'.length();
        Integer endP = vfContent.indexOf('End_of_Session_Id');
        sessionId = vfContent.substring(startP, endP);
        return sessionId;
    }
}