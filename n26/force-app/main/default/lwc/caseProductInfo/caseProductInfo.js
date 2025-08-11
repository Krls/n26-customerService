import { LightningElement, api, wire, track } from 'lwc';
import getProductInfoFromCase from '@salesforce/apex/CaseProductInfoController.getProductInfoFromCase';
import productMonthlyCost from '@salesforce/label/c.Product_MonthlyCost_Label';
import productCurrenciesFees from '@salesforce/label/c.Product_CurrenciesFees_Label';
import productCardReplacement from '@salesforce/label/c.Product_CardReplacementCost_Label';
import genericError from '@salesforce/label/c.Generic_Error';
import contactWithoutProductError from '@salesforce/label/c.Contact_Without_Product_Error';
import spinnerLabel from '@salesforce/label/c.Spinner_Label';
import productIformation from '@salesforce/label/c.Product_Information_Label';

export default class CaseProductInfo extends LightningElement {
    @api recordId;
    @track product;
    @track errorMessage;
    isLoading = true;

    labels = {
        productMonthlyCost,
        productCurrenciesFees,
        productCardReplacement,
        contactWithoutProductError,
        spinnerLabel,
        productIformation,
        genericError
    };

    @wire(getProductInfoFromCase, { caseId: '$recordId' })
    wiredProduct({ error, data }) {
        this.isLoading = false;

        if (data) {
            if(data === null){
                this.product = undefined;
                this.errorMessage = undefined;
            }else {
                this.product = {
                    ...data,
                    Monthly_cost__c: this.formatCurrency(data.Monthly_cost__c),
                    Currencies_Fees__c: this.formatPercentage(data.Currencies_Fees__c),
                    Card_Replacement_Cost__c: this.formatCurrency(data.Card_Replacement_Cost__c)
                };
                this.errorMessage = undefined;
            }
        } else if (error) {
            this.errorMessage = error;
            console.error('Error Apex:', error);
        }
    }

    formatCurrency(value) {
        if (value === null || value === undefined) {
            return '—';
        }
        return new Intl.NumberFormat('es-ES', {
            style: 'currency',
            currency: 'EUR'
        }).format(value);
    }

    formatPercentage(value) {
        if (value === null || value === undefined) {
            return '—';
        }
        return new Intl.NumberFormat('es-ES', {
            style: 'percent',
            minimumFractionDigits: 2
        }).format(value / 100);
    }

    get hasProduct() {
        return this.product !== null && this.product !== undefined;
    }

    get showNoProductMessage() {
        return !this.hasProduct && !this.isLoading && this.errorMessage != null && this.errorMessage != undefined;
    }

    get hasError() {
        return !!this.errorMessage;
    }
}