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
}