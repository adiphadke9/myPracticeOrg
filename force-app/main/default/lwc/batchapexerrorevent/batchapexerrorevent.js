import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError} from "lightning/empApi";

export default class Batchapexerrorevent extends LightningElement {
    
    subscription;
    eventName='/event/SAP_Account__e';
    eventMessage='';
    connectedCallback(){
        this.registerErrorHandler();
        this.handleSubscribe();
    }

    disconnectedCallback(){
        this.handleUnsubscribe();
    }

    registerErrorHandler(){
        onError(()=>{
            console.error(error);
        });
    }

    handleUnsubscribe(){
        unsubscribe(this.subscription,(response)=>{
            console.log(response);
        })
    }

    handleSubscribe(){
        this.subscription = subscribe(this.eventName,-2, this.handleSuccessErrorMessage.bind(this));
        console.log(this.subscription);
    }

    handleSuccessErrorMessage(message){
        console.log("Message Received");
        this.eventMessage = JSON.stringify(message);
    }
}