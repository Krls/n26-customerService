/**
 * CaseSelectorI implementation.
 */
public with sharing class CaseSelector implements CaseSelectorI {
    
    private static CaseSelectorI instance;

    public static CaseSelectorI getInstance(){
        if(instance == null){
            instance = new CaseSelector();
        }
        return instance;
    }

    public Case getCaseByStringID(Id caseId){
        return [SELECT status, origin, 
                    contact.id, contact.Product__c, 
                    contact.Product__r.Name, contact.Product__r.Monthly_cost__c, 
                    contact.Product__r.Currencies_Fees__c, contact.Product__r.Card_Replacement_Cost__c, 
                    contact.Home_Country__c FROM case WHERE id = :caseId];
    }
}