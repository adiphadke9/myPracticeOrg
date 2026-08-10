@isTest
public with sharing class MetadataUtilsMock implements WebServiceMock {
    public Void doInvoke(Object stub, Object soapRequest, Map<String,Object> responseMap, String endpoint, String soapAction, 
    String requestName, String responseNamespace, String responseName, String responseType){
        MetadataService.listMetadataResponse_element response_x = new MetadataService.listMetadataResponse_element();
        responseMap.put('response_x', response_x);
    }
}