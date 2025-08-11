public with sharing class CaseProductInfoController {
   
    @AuraEnabled(cacheable=true)
    public static Product2 getProductInfoFromCase(Id caseId) {
        if (caseId == null) {
            return null;
        }

        CaseSelectorI caseSelector = CaseSelector.getInstance();
        Case c = caseSelector.getCaseByStringID(caseId);

        if(c.Contact != null && c.Contact.Product__c != null){
            return c.Contact.Product__r;
        }
        return null;
    }
}