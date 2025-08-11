@isTest
public with sharing class ContactSelectorTest {

    @TestSetup
    static void makeData(){
        Product2 newProduct = new Product2();
        newProduct.Name = 'Standard';
        newProduct.Country__c = 'DE';
        newProduct.Currencies_Fees__c = 1.7;
        newProduct.Card_Replacement_Cost__c = 0;
        newProduct.Monthly_cost__c = 0;
        insert newProduct;
    }

    @isTest
    static void getIntanceTest(){
        ContactSelectorI contactSelector = ContactSelector.getInstance();
        System.assert(contactSelector instanceof ContactSelector);
    }

    @isTest
    static void givenUUID_whenCallGetContactByUUID_thenContactIsReturned(){

        Product2 product = [SELECT Id FROM Product2];

        Contact newContact = new Contact();
        newContact.LastName = 'Monzonis';
        newContact.Product__c = product.Id;
        newContact.Home_Country__c = 'DE';
        newContact.UUID__c = 'UWHUDEIhiahiedu';
        insert newContact;

        ContactSelectorI contactSelector = ContactSelector.getInstance();
        Contact currentContact = contactSelector.getContactByExternalID('UWHUDEIhiahiedu');

        System.assertEquals('Standard', currentContact.Product__r.Name);
    }

    @isTest
    static void givenContactId_whenCallGetContactByID_thenContactIsReturned(){

        Product2 product = [SELECT Id FROM Product2];

        Contact newContact = new Contact();
        newContact.LastName = 'Monzonis';
        newContact.Product__c = product.Id;
        newContact.Home_Country__c = 'DE';
        newContact.UUID__c = 'UWHUDEIhiahiedu';
        insert newContact;

        ContactSelectorI contactSelector = ContactSelector.getInstance();
        Contact currentContact = contactSelector.getContactById(newContact.id);

        System.assertEquals('Standard', currentContact.Product__r.Name);
    }
}