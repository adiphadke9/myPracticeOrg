public with sharing class DropboxFileManagerHandler {
    @AuraEnabled
    public static void uploadFile(String fileId, String filePath, String recordId){
        try {
            if (String.isBlank(filePath)) {
                filePath = '/';
            }

            ContentVersion cv = [
                SELECT Id, Title, ContentDocumentId, FileExtension, VersionData, ContentSize, PathOnClient
                FROM ContentVersion
                WHERE Id = :fileId
                LIMIT 1
            ];

            String fileName = cv.Title;
            if (String.isNotBlank(cv.FileExtension)) {
                fileName += '.'+cv.FileExtension;
            }

            Blob fileContent = cv.VersionData;
            DropboxFile file = Dropbox.uploadFile(fileContent, fileName, filePath);
            if(!String.isBlank(file.id)){
                DropboxFile__c dropboxfile = new DropboxFile__c();
                dropboxfile.Name = fileName;
                dropboxfile.Dropbox_Path__c = file.path;
                dropboxfile.File_Size__c = file.size;
                dropboxfile.RecordId__c = recordId;
                dropboxfile.Content_Document_Id__c = cv.ContentDocumentId;
                dropboxfile.ServerUrl__c = 'https://www.dropbox.com/home'+file.path;
                insert as system dropboxfile;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}