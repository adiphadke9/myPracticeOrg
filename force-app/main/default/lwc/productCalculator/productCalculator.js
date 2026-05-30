import { LightningElement } from 'lwc';

export default class ProductCalculator extends LightningElement {
    price = 199;
    quantity = 1;
    taxRate = 0.15;

    handleClick(){
        this.quantity += 1;
    }

    get price(){
        return this.price;
    }

    get quantity(){
        return this.quantity;
    }

    set quantity(value){
        if(parseInt(value) >= 1){
            this.quantity = parseInt(value);
        }else{
            this.quantity = 1;
        }
    }

    get subTotal(){
        return this.price * this.quantity;
    }

    get tax(){
        return this.subTotal * this.taxRate;
    }

    get total(){
        return this.subTotal + this.tax;
    }

    get formattedTotal(){
        return `${this.total.toFixed(2)}`;
    }
}