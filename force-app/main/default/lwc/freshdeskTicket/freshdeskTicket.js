import { LightningElement } from 'lwc';
import createTicket from '@salesforce/apex/FreshDeskTicketController.createTicket';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class FreshdeskTicket extends LightningElement {
    isLoading = false;
    ticketInformation = {
        "status":'2'
    };
    get statusoptions(){
        return [
            {label:'Open',value:'2'}
        ]
    }

    get typeoptions(){
        return [
            {label:'Incident',value:'Incident'},
            {label:'Problem',value:'Problem'}
        ]
    }

    get sourceoptions(){
        return [
            {label:'Email',value:'1'},
            {label:'Portal',value:'2'},
            {label:'Phone',value:'3'},
            {label:'Chat',value:'7'}
        ]
    }

        get priorityoptions(){
        return [
            {label:'Low',value:'1'},
            {label:'Medium',value:'2'},
            {label:'High',value:'3'},
            {label:'Urgent',value:'4'}
        ]
    }

    handleClick(event){
        event.preventDefault();
         const allInputs = this.template.querySelectorAll(
            'lightning-input, lightning-combobox, lightning-textarea, lightning-radio-group');

        // 2. Reduce the collection to a single boolean
        const allValid = [...allInputs].reduce((validSoFar, field) => {
            // Trigger the UI error message display
            field.reportValidity();
            
            // Check its current validity status
            return validSoFar && field.checkValidity();
        }, true);

        // 3. Process form data if everything passes
        if (allValid) {
            this.isLoading = true;
            console.log('All fields are valid. Ready to submit!');
            console.log(JSON.stringify(this.ticketInformation));
            createTicket({inputMap : this.ticketInformation})
            .then(result=>{
                 console.log('result',result);
                 if(result.isSuccess){
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Success!',
                        message: result.message,
                        variant: 'success',
                        mode: 'dismissable'
                    }));
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Error!',
                        message: result.errorMessage,
                        variant: 'error',
                        mode: 'dismissable'
                    }));
                }    
            })
            .catch(error=>{
                console.log('Error',error);
                this.dispatchEvent(
                    new ShowToastEvent({
                    title: 'Error!',
                    message: JSON.stringify(error),
                    variant: 'error',
                    mode: 'dismissable'
                }));
            })
            .finally(()=>{
                this.isLoading = false;
            })
            // Proceed with Apex call or navigation
        } else {
            console.log('Validation failed. Review the UI errors.');
        }
    }

    handleInputChange(event){
        event.preventDefault();
        let name = event.target.name;
        let value = event.target.value;
        this.ticketInformation[name] = value;
    }
}