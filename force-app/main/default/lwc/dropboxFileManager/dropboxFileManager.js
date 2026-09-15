import { api, LightningElement } from 'lwc';

export default class DropboxFileManager extends LightningElement {
    @api recordId;
    @api objectApiName;

    handleUploadFinished(event){
        const uploadedFiles = event.detail.files;
        console.log(uploadedFiles);
    }
}