import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError} from "lightning/empApi";

export default class Batchapexerrorevent extends LightningElement {
    
    subscription;
    eventName='/event/BatchApexErrorEvent';
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
        this.subscription = subscribe(this.eventName,-2, (message)=>{
            console.log('Event Subscription');
            console.log(JSON.stringify(message));
        });
        console.log(this.subscription);
    }
}