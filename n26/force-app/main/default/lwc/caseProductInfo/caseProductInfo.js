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
    @track statusMessage;
    isLoading = true;;

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

        if (data === null) {
            this.product = undefined;
            this.statusMessage = this.labels.contactWithoutProductError;
            this.errorMessage = undefined;
            return;
        }

        if (data) {
            const currencyCode = data.CurrencyIsoCode || 'EUR';
            this.product = {
                ...data,
                Monthly_cost__c: this.formatCurrency(data.Monthly_cost__c, currencyCode),
                Currencies_Fees__c: this.formatPercentage(data.Currencies_Fees__c),
                Card_Replacement_Cost__c: this.formatCurrency(data.Card_Replacement_Cost__c, currencyCode)
            };
            this.statusMessage = undefined;
            this.errorMessage = undefined;
            return;
        }

        if (error) {
            this.product = undefined;
            this.statusMessage = undefined;
            this.errorMessage = error;
            console.error('Error Apex:', error);
        }
    }

    // Getter booleano para la plantilla
    get hasError() {
        return !!this.errorMessage;
    }

    get hasStatusMessage() {
        return !!this.statusMessage;
    }

    get hasProduct() {
        return this.product !== undefined && this.product !== null;
    }

    formatCurrency(value, currencyCode) {
        if (value === null || value === undefined) {
            return '—';
        }
        return new Intl.NumberFormat('es-ES', {
            style: 'currency',
            currency: currencyCode
        }).format(value);
    }

    formatPercentage(value) {
        if (value === null || value === undefined) {
            return '—';
        }
        const numeric = Number(value);
        if (isNaN(numeric)) return '—';
        return new Intl.NumberFormat('es-ES', {
            style: 'percent',
            minimumFractionDigits: 2
        }).format(numeric / 100);
    }
}