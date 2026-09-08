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

    public static void uploadFile(String recordId, String endPoint){
        ContentVersion version = [SELECT Id, Title, FileExtension, VersionNumber, FileType, VersionData FROM ContentVersion 
        WHERE Id = :recordId];
        
        HttpRequest httpreq = new HttpRequest();
        httpreq.setMethod('PUT');
        String filename = version.Title+'.'+version.FileExtension;
        httpreq.setEndpoint('callout:AWSS3Cred'+'/'+endPoint+'/'+filename);
        httpreq.setBodyAsBlob(version.VersionData);
        try {
            HttpResponse httpresp = (new Http()).send(httpreq);
            if (httpresp.getStatusCode() == 200 || httpresp.getStatusCode() == 201) {

            }else {
                System.debug('Failed: ' + httpresp.getBody());
            }
        } catch (System.Exception ex) {
            System.debug(''+ex.getMessage());
        }
    }

    public static void listBucketItems(String endpoints){
        HttpRequest httpreq = new HttpRequest();
        httpreq.setMethod('GET');
        httpreq.setEndpoint('callout:AWSS3Cred'+'/'+endpoints+'/');
        try {
            HttpResponse httpresp = (new Http()).send(httpreq);
            String ns = 'http://s3.amazonaws.com/doc/2006-03-01/';
            if (httpresp.getStatusCode() == 200 || httpresp.getStatusCode() == 201) {
               System.debug('Result: ' + httpresp.getBody());
               Dom.Document doc = httpresp.getBodyDocument();
               Dom.XmlNode rootNode = doc.getRootElement();
               Dom.XmlNode nameNode = rootNode.getChildElement('Name', ns);
               String bucketName = '';
               if (nameNode!=null) {
                bucketName = nameNode.getText();
                System.debug('bucketName: '+bucketName);
               }
               ListBucketResult itemWrapper = new ListBucketResult();
               itemWrapper.name = bucketName;
               itemWrapper.items = new List<ListBucketResult.Contents>();
               for (Dom.XmlNode root: rootNode.getChildElements()) {
                 if (root.getName() == 'Contents') {
                    ListBucketResult.Contents item = new ListBucketResult.Contents();
                    for (Dom.XmlNode contentNode: root.getChildElements()) {
                        String nodeName = contentNode.getName();
                        String nodeValue = contentNode.getText();
                        switch on nodeName {
                            when 'Key'  {
                               item.key = nodeValue;
                            }
                            when 'Size'  {
                                item.size = nodeValue;
                            }
                        }
                    }
                    itemWrapper.items.add(item);
                 }              
               }
               System.debug('Wrapper: '+itemWrapper);
            }else {
                System.debug('Failed: ' + httpresp.getBody());
            }
        } catch (System.Exception ex) {
            System.debug(''+ex.getMessage());
        }
    }
}