import { api, LightningElement, wire } from 'lwc';
import queryLineItemRecords from '@salesforce/apex/addProductsService.queryLineItemRecords';
import fetchPricebook from '@salesforce/apex/addProductsService.fetchPricebook';
import updatePriceBook2 from '@salesforce/apex/addProductsService.updatePriceBook2';
import getPriceBookEntries from '@salesforce/apex/addProductsService.getPriceBookEntries';
import submitProducts from '@salesforce/apex/addProductsService.submitProducts';
import listLineItems from '@salesforce/apex/addProductsService.listLineItems';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AddProducts extends LightningElement {
    @api recordId;
    @api objectApiName;
    records = [];

    fields = ["Name","ProductCode","Family"];
    displayFields = 'Name,ProductCode,Family';
    query = '';
    priceBookQuery = '';
    isLoading = false;
    showmodal = false;
    errorMessage = '';
    priceBook2Id;
    priceBookEntryMap = {};
    objectApiNameMap={
        'Opportunity':'OpportunityId',
        'Order':'OrderId',
        'Quote':'QuoteId'
    }

    connectedCallback(){
       this.isLoading = true;
       this.priceBookQuery = `SELECT Id, Pricebook2Id FROM ${this.objectApiName} WHERE Id = '${this.recordId}' LIMIT 1`;
       if(this.objectApiName === 'Opportunity'){
        this.query = `SELECT Id, Product2.Name,Quantity,UnitPrice,ServiceDate,Description FROM OpportunityLineItem  WHERE OpportunityId = '${this.recordId}'`; 
       }
       else if(this.objectApiName === 'Quote'){
        this.query = `SELECT Id FROM QuoteLineItem WHERE QuoteId = '${this.recordId}'`;
       }
       else if(this.objectApiName === 'Order'){
        this.query = `SELECT Id FROM OrderItem  WHERE OrderId = '${this.recordId}'`;
       }
       console.log(this.query);
       
    }

    @wire(queryLineItemRecords, {
        query: '$query'
    })
    wiredLineItems({error,data}){
        if(data){
            console.log(data);
            //this.records = [...data];
            this.records = JSON.parse(JSON.stringify(data));
        }
        else if(error){
            console.log(error);
        }
        this.isLoading = false;
        this.addRow();
    }

    @wire(getPriceBookEntries, {
        priceBook2Id: '$priceBook2Id'
    })
    wiredEntries({ error, data }) {
        console.log('wire triggered with priceBook2Id:', this.priceBook2Id);
        if (data) {
            console.log('Returned Data:', data);
            data.forEach(entry => {
                this.priceBookEntryMap[entry.Product2Id] = entry.Id;
            });
            console.log('Pricebook Entry Map:', this.priceBookEntryMap);
        } else {
            console.log('Error:', error);
        }
    }

    @wire(fetchPricebook,{
        query: '$priceBookQuery'
    })
    wiredPriceBook({error,data}){
        if(data){
            if(data.length > 0){
                console.log('pricebook',data);
                this.priceBook2Id = data[0].Pricebook2Id;
                if(this.priceBook2Id){
                    this.showmodal = false;
                }else{
                    this.showmodal = true;
                }
                
            }else{
                this.showmodal = true;
            }
        }else if(error){
            console.log('Error while fetching pricebook',error);
        }
    }

    handleLookup(event) {
        let detail = event.detail;
        this.records[detail.data.index][detail.data.parentAPIName] = detail.data.recordId;
        console.log('parentapi name',this.records[detail.data.index][detail.data.parentAPIName]);
        
        console.log('Lookup event.detail:', detail);
    
        let index = detail.data.index;
        let parentApiName = detail.data.parentAPIName;
        let recordId = detail.data.recordId;
    
        console.log('index:', index, 'parentApiName:', parentApiName, 'recordId:', recordId);
    
        if (parentApiName) {
            this.records[index][parentApiName] = recordId;
            console.log('Updated record:', this.records[index]);
            this.records = [...this.records];
        } else {
            console.error('⚠️ parentApiName is undefined in Lookup output!');
        }

    }

    addRow() {
        this.records = [
            ...this.records,
            {
                Quantity: null,
                Description: '',
                UnitPrice: null,
                ServiceDate: null
            }
        ];
    }

    handleDetailPage(event){
        event.preventDefault();
        let recordId = event.currentTarget.dataset.recordId;
        if(recordId){
           let recordUrl = 'https://'+location.host+'/lightning/r/OpportunityLineItem/'+recordId+'/view';
           location.href=recordUrl;
        }
    }

    handleChange(event){
        event.preventDefault();
        let index = event.currentTarget.dataset.index;
        let name = event.currentTarget.name;
        let value = event.currentTarget.value;
        console.log(index,name,value);
        this.records[index][name] = value;
    }

    handleSave(event){
        event.preventDefault();
        this.showmodal = false;
        this.priceBook2Id = event.detail.priceBook2Id;
    }

    handleRemove(event) {
        event.preventDefault();
        const index = Number(event.target.dataset.index);
        let recordId = event.target.dataset.recordId;
        if(recordId){
            deleteRecord(recordId)
            .then(()=>{
                this.records = this.records.filter((_, i) => i !== index);
            })
            .catch(error => {
                console.log(error);
            })
            .finally(()=>{
                this.records = this.records.filter((_, i) => i !== index);
                this.isLoading = false;
            });
        }else{
            this.records = this.records.filter((_, i) => i !== index);
        }
        console.log('Removing index:', index);
    }

    handleCancel(event){
        this.showmodal = false;
    }

    handleChoosePriceBook(event){
        this.showmodal = true;
    }

    /*submitRecords(event){
        this.isLoading=true;
        event.preventDefault();
        this.records.forEach(line=>{
                line.PricebookEntryId = this.priceBookEntryMap[line.Product2Id];
                let parentApiName = this.objectApiNameMap[this.objectApiName];
                line[parentApiName] = this.recordId;
                line.Product2Id = undefined;
        });
        console.log(this.records);
        submitProducts({
            objectApiName: this.objectApiName,
            records : JSON.stringify(this.records)
        })
        .then((result)=>{
            console.log('success',result);
        })
        .catch((error)=>{
            console.log('error',error);
        })
        .finally(()=>{
            this.isLoading=false;
        })
    }*/
      
    submitRecords(event){
        event.preventDefault();

        let allValid = this.validateInput();
        if(!allValid){
            return;
        }

        //lookup validation
        this.records.forEach(line=>{
            if(!line.Product2Id && !line.Id){
                allValid = false;
                this.errorMessage = 'Please select Product for all Line Items';
                return;
            }
        });

        if(!allValid){
            return;
        }

        this.isLoading=true;
        this.records.forEach(line=>{
            if(!line.Id){
                line.PricebookEntryId = this.priceBookEntryMap[line.Product2Id];
                let parentApiName = this.objectApiNameMap[this.objectApiName];
                line[parentApiName] = this.recordId;
                line.Product2Id = undefined; 
            }
        });
        console.log(JSON.stringify(this.records)); 

        submitProducts({
            objectApiName: this.objectApiName,
            records : JSON.stringify(this.records)
        })
        .then((result)=>{
            console.log('success',result);
            let successEvent = new ShowToastEvent({
                title: 'Success',
                message: 'Products Added Successfully',
                variant: 'success'
            });
            this.dispatchEvent(successEvent);

            listLineItems({
                query:this.query
            })
            .then((result)=>{
                this.records = JSON.parse(JSON.stringify(result));
                this.addRow();
            })
            .catch((error)=>{
                this.errorMessage = JSON.stringify(error.message);
            })
            .finally(()=>{
                this.isLoading=false;
            });
        })
        .catch((error)=>{
            console.log('error',error);
            let errorEvent = new ShowToastEvent({
                title: 'Error',
                message: JSON.stringify(error.message),
                variant: 'error'
            });
            this.errorMessage = JSON.stringify(error.message);
            this.dispatchEvent(errorEvent);
        })
        .finally(()=>{
            this.isLoading=false;
        })
    }

    validateInput(){
        const allValid = [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        return allValid;
    }
    
}