public with sharing class MetadataUtils {
    public static MetadataService.MetadataPort createService(){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
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
}