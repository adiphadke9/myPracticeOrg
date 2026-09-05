public with sharing class AWSS3Manager {
    public static void createBucket(String bucketName,String recordId,String region){
        bucketName =bucketName.toLowerCase().replaceAll(' ', '-') + '-' + recordId.toLowerCase();
        System.debug(bucketName);
        HttpRequest httpreq = new HttpRequest();
        httpreq.setMethod('PUT');
        String requestBody = '<CreateBucketConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">'+
                                '<LocationConstraint>'+region+'</LocationConstraint>'+
                                '</CreateBucketConfiguration>';
        if (String.isNotBlank(region) && !region.equalsIgnoreCase('us-east-1')) {
            httpreq.setBody(requestBody);
        }
        httpreq.setEndpoint('callout:AWSS3Cred'+'/'+EncodingUtil.urlEncode(bucketName, 'UTF-8'));
        try {
            HttpResponse httpresp = (new Http()).send(httpreq);
            if (httpresp.getStatusCode() == 200 || httpresp.getStatusCode() == 201) {
                System.debug('Bucket created successfully: ' + bucketName);
                createFolderInsideBucket(bucketName, 'opportunities');
                createFolderInsideBucket(bucketName, 'orders');
                Account acc = new Account(Id = recordId, S3BucketName__c= bucketName);
                update acc;   
            }else {
                System.debug('Failed to create bucket: ' + httpresp.getBody());
            }
        } catch (System.Exception ex) {
            System.debug(''+ex.getMessage());
        }
    }

    public static void createFolderInsideBucket(String bucketName, String folderName){
        HttpRequest httpreq = new HttpRequest();
        httpreq.setMethod('PUT');
        httpreq.setEndpoint('callout:AWSS3Cred'+'/'+EncodingUtil.urlEncode(bucketName, 'UTF-8') +'/' + EncodingUtil.urlEncode(folderName, 'UTF-8')+'/');
        //httpreq.setHeader('Content-Length', '0');
        try {
            HttpResponse httpresp = (new Http()).send(httpreq);
            if (httpresp.getStatusCode() == 200 || httpresp.getStatusCode() == 201) {
                System.debug('Folder created successfully: ' + folderName);
            }else {
                System.debug('Failed to create folder: ' + httpresp.getBody());
            }
        } catch (System.Exception ex) {
            System.debug(''+ex.getMessage());
        }
    }

    public static void createFolderInsideBucketFolder(String bucketName, String folderPath, String folderName){
        HttpRequest httpreq = new HttpRequest();
        httpreq.setMethod('PUT');
        httpreq.setEndpoint('callout:AWSS3Cred'+'/'+EncodingUtil.urlEncode(bucketName, 'UTF-8') +'/' + EncodingUtil.urlEncode(folderPath, 'UTF-8')+'/'+ EncodingUtil.urlEncode(folderName, 'UTF-8')+'/');
        //httpreq.setHeader('Content-Length', '0');
        try {
            HttpResponse httpresp = (new Http()).send(httpreq);
            if (httpresp.getStatusCode() == 200 || httpresp.getStatusCode() == 201) {
                System.debug('Folder created successfully: ' + folderName);
            }else {
                System.debug('Failed to create folder: ' + httpresp.getBody());
            }
        } catch (System.Exception ex) {
            System.debug(''+ex.getMessage());
        }
    }
}