/**
 * ContactSelectorI implementation.
 */
public with sharing class ContactSelector implements ContactSelectorI{
    private static ContactSelectorI instance;

    public static ContactSelectorI getInstance(){
        if(instance == null){
            instance = new ContactSelector();
        }
        return instance;
    }

    public Contact getContactById(Id contactId){
        return [SELECT Product__c, Product__r.Name, 
                        Product__r.Monthly_cost__c, Product__r.Currencies_Fees__c, 
                        Product__r.Card_Replacement_Cost__c, Home_Country__c 
                    FROM Contact WHERE id = :contactId];
    }

    public Contact getContactByExternalID(String UUID){
        return [SELECT UUID__c, Product__c, Product__r.Name, 
                        Product__r.Monthly_cost__c, Product__r.Currencies_Fees__c, 
                        Product__r.Card_Replacement_Cost__c, Home_Country__c 
                    FROM Contact WHERE UUID__c = :UUID];
    }
}