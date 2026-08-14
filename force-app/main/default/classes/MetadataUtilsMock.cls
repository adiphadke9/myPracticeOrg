@isTest
public with sharing class MetadataUtilsMock implements WebServiceMock {
    public Void doInvoke(Object stub, Object soapRequest, Map<String,Object> responseMap, String endpoint, String soapAction, 
    String requestName, String responseNamespace, String responseName, String responseType){
        if(soapRequest instanceOf MetadataService.listMetadata_element){
            MetadataService.listMetadataResponse_element response_x = new MetadataService.listMetadataResponse_element();
            responseMap.put('response_x', response_x);  
        }else if(soapRequest instanceOf MetadataService.readMetadata_element) {
            MetadataService.Profile profile = new MetadataService.Profile();
            profile.fullName = 'Admin';
            profile.loginHours = null;
            MetadataService.ReadProfileResult result = new MetadataService.ReadProfileResult();
            result.records = new MetadataService.Profile[] {profile};
            
            MetadataService.readProfileResponse_element responseElement = new MetadataService.readProfileResponse_element();
            responseElement.result = result;
            responseMap.put('response_x', responseElement);
        }else if (soapRequest instanceOf MetadataService.createMetadata_element) {
            MetadataService.createMetadataResponse_element response_x = new MetadataService.createMetadataResponse_element();
            responseMap.put('response_x', response_x);
        }
    }
}