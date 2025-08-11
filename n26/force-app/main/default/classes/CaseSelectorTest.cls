@isTest
public with sharing class CaseSelectorTest {

    @isTest
    static void getIntanceTest(){
        CaseSelectorI caseSelector = CaseSelector.getInstance();
        System.assert(caseSelector instanceof CaseSelector);
    }

    @isTest
    static void givenStringCaseID_whenGetCaseByID_thenCaseIsReturned(){
        Case newCase = new Case();
        newCase.status = 'New';
        newCase.origin = 'Email';
        insert newCase;
        
        CaseSelectorI caseSelector = CaseSelector.getInstance();
        Case currentCase = caseSelector.getCaseByStringID(newCase.id);

        System.assertEquals(newCase.status, currentCase.status);
    }
}