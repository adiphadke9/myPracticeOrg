import { api, LightningElement, wire } from 'lwc';
import uploadFile from '@salesforce/apex/DropboxFileManagerHandler.uploadFile';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Opportunity.Name';

export default class DropboxFileManager extends LightningElement {
    @api recordId;
    @api objectApiName;

    connectedCallback(){
        console.log(JSON.stringify(NAME_FIELD));
    }

    @wire(getRecord, {
        recordId: "$recordId",
        fields:[NAME_FIELD]
    })
    record;

    get name() {
        return getFieldValue(this.record.data, NAME_FIELD);
    }

    handleUploadFinished(event){
        const uploadedFiles = event.detail.files;
        console.log(uploadedFiles);
        for(let i=0;i<uploadedFiles.length;i++){
            const file = uploadedFiles[i];
            uploadFile({
                fileId : file.contentVersionId,
                filePath:this.name,
                recordId:this.recordId
            }).then(result=>{
                console.log('result',result);
            }).catch(error=>{
                console.log('error',error);
            })
        }
    }
}