@isTest
public with sharing class MetadataUtilsTest {
    @isTest
    public static void listMetadataTest(){
        Test.setMock(WebServiceMock.class, new MetadataUtilsMock());
        Test.startTest();
        MetadataUtils.listmetadata();
        Test.stopTest();
    }
}