public with sharing class Dropbox {

    public static void testUploadFile(){
        Id fileId = '0687F00000q1AXyQAM';
        ContentVersion cv = [
            SELECT Id, Title, FileExtension, VersionData, ContentSize, PathOnClient
            FROM ContentVersion
            WHERE Id = :fileId
            LIMIT 1
        ];

        // Determine file name - use PathOnClient if available, otherwise build from Title and FileExtension
        String fileName = cv.Title;
        if (String.isNotBlank(cv.FileExtension)) {
            fileName += '.' + cv.FileExtension;
        }

        // Get the file content as Blob
        Blob fileContent = cv.VersionData;
        uploadFile(fileContent, fileName, '/Salesforce/');
    }

    public static void uploadFile(Blob fileContent, String fileName, String filePath){
        HttpRequest httpreq = new HttpRequest();
        httpreq.setEndpoint('callout:DropBoxContent'+'/2/files/upload');
        httpreq.setMethod('POST');
        httpreq.setHeader('Content-Type', 'application/octet-stream');
        fileName = EncodingUtil.urlEncode(fileName.replace(' ', '_'), 'UTF=8');
        System.debug('fileName'+fileName);
        if (filePath.startsWith('/') && filePath.endsWith('/')) {
            filePath = filePath + fileName;
        }else if(filePath.startsWith('/') && !filePath.endsWith('/')){
            filePath = filePath + '/'+ fileName;
        }else if(!filePath.startsWith('/') && filePath.endsWith('/')) {
            filePath = '/' + filePath + '/' + fileName;
        }else{
            filePath = '/' + filePath +  '/' + fileName;
        }
         System.debug('filePath'+filePath);
        //{"path":"","mode":{".tag":"add"},"autorename":false}
        Map<String, Object> argumentMap = new Map<String, Object>{
            'path' => filePath,
            'mode' =>  new Map<String, Object>{'.tag' => 'add'},
            'autorename' => false,
            'mute' => false
        };
        httpreq.setHeader('Dropbox-API-Arg', JSON.serialize(argumentMap));
        httpreq.setBodyAsBlob(fileContent);
        try {
            HttpResponse httpresp = (new Http()).send(httpreq);
            if (httpresp.getStatusCode() == 200 || httpresp.getStatusCode() == 201) {
                System.debug('File uploaded successfully: ' + httpresp.getBody());
            }else{
                System.debug('Upload failed: ' + httpresp.getBody());
            }
        } catch (System.CalloutException ex) {
            System.debug('Callout error: ' + ex.getMessage());
        }catch (System.Exception e) {
            System.debug('Exception error: ' + e.getMessage());
        }
    }
}