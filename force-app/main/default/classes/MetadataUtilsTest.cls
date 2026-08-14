@isTest
public with sharing class MetadataUtilsTest {
    @isTest
    public static void listMetadataTest(){
        Test.setMock(WebServiceMock.class, new MetadataUtilsMock());
        Test.startTest();
        MetadataUtils.listmetadata();
        Test.stopTest();
    }

    @isTest
    public static void readMetadataTest(){
        Test.setMock(WebServiceMock.class, new MetadataUtilsMock());
        Test.startTest();
        MetadataUtils.readMetadata();
        Test.stopTest();
    }

    @isTest
    public static void createObjectTest(){
        Test.setMock(WebServiceMock.class, new MetadataUtilsMock());
        Test.startTest();
        MetadataUtils.createObject();
        Test.stopTest();
    }
}