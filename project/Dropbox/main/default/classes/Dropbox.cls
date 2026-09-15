public with sharing class Dropbox {

    public static void testUploadFile(){
        Id fileId = '0687F00000q0ndtQAA';
        ContentVersion cv = [
            SELECT Id, Title, ContentDocumentId, FileExtension, VersionData, ContentSize, PathOnClient
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
        DropboxFile file = uploadFile(fileContent, fileName, '/Salesforce/');
        if(!String.isBlank(file.id)){
            DropboxFile__c dropboxfile = new DropboxFile__c();
            dropboxfile.Name = fileName;
            dropboxfile.Dropbox_Path__c = file.path;
            dropboxfile.File_Size__c = file.size;
            //dropboxfile.RecordId__c = file.recordId;
            dropboxfile.Content_Document_Id__c = cv.ContentDocumentId;
            dropboxfile.ServerUrl__c = 'https://www.droropbox.com/home'+file.path;
            insert as system dropboxfile;
        }
    }

    public static DropboxFile uploadFile(Blob fileContent, String fileName, String filePath){
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
        DropboxFile file = new DropboxFile();
        try {
            HttpResponse httpresp = (new Http()).send(httpreq);
            if (httpresp.getStatusCode() == 200 || httpresp.getStatusCode() == 201) {
                System.debug('File uploaded successfully: ' + httpresp.getBody());
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(httpresp.getBody());
                file.id = (String)responseMap.get('id');
                file.name = (String)responseMap.get('name');
                file.path = (String)responseMap.get('path_display');
                file.size = (responseMap.containsKey('size') ? (Integer)responseMap.get('size') : null);
                System.debug('Upload failed: ' + httpresp.getBody());
            }
        } catch (System.CalloutException ex) {
            System.debug('Callout error: ' + ex.getMessage());
        }catch (System.Exception e) {
            System.debug('Exception error: ' + e.getMessage());
        }
        return file;
    }

    public static List<DropboxFile> listFolder(String filePath, Integer limitx){
        HttpRequest httpreq = new HttpRequest();
        httpreq.setEndpoint('callout:DropboxAPI'+'/2/files/list_folder');
        httpreq.setMethod('POST');
        httpreq.setHeader('Content-Type', 'application/json');
        //{"path":"","recursive":false,"include_media_info":true,"include_mounted_folders":true,"limit":20}
        Map<String, Object> argumentMap = new Map<String, Object>{
            'path' => filePath,
            'recursive' => false,
            'include_media_info' => true,
            'include_mounted_folders' => true,
            'limit' => limitx
        };
        httpreq.setBody(JSON.serialize(argumentMap));
        List<DropboxFile> files = new List<DropboxFile>();
        try {
            HttpResponse httpresp = (new Http()).send(httpreq);
            if (httpresp.getStatusCode() == 200 || httpresp.getStatusCode() == 201) {
                System.debug('File uploaded successfully: ' + httpresp.getBody());
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(httpresp.getBody());
                List<Object> entries = (List<Object>)responseMap.get('entries');
                for (Object entry : entries) {
                    Map<String, Object> entryMap = (Map<String, Object>)entry;
                    DropboxFile file = new DropboxFile();
                    file.id = (String)entryMap.get('id');
                    file.name = (String)entryMap.get('name');
                    file.path = (String)entryMap.get('path_display');
                    file.size = (entryMap.containsKey('size') ? (Integer)entryMap.get('size') : null);
                    file.isFolder = (entryMap.containsKey('.tag') && (String)entryMap.get('.tag') == 'folder');
                    file.modifiedTime = (String)entryMap.get('server_modified');
                    files.add(file);
                }
            }
        } catch (System.CalloutException ex) {
            System.debug('Callout error: ' + ex.getMessage());
        }catch (System.Exception e) {
            System.debug('Exception error: ' + e.getMessage());
        }
        return files;
    }
}