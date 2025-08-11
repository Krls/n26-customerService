
@isTest
private class CaseProductInfoControllerTest {
    
    @TestSetup
    static void setupData() {
        Product2 prod = new Product2(
            Name = 'Standard',
            Monthly_cost__c = 0,
            Currencies_Fees__c = 1.7,
            Card_Replacement_Cost__c = 6,
            Country__c = 'DE',
            IsActive = true
        );
        insert prod;

        Contact conWithProduct = new Contact(
            LastName = 'Monzonis',
            Product__c = prod.Id,
            UUID__c = 'dJHASKDASsASss'
        );

        Contact conWithoutProduct = new Contact(
            LastName = 'Marquez',
            UUID__c = 'DSKaasoaDOooO'
        );
        
        insert new List<Contact> {conWithProduct, conWithoutProduct};

        Case caseWithContact =  new Case(
            Subject = 'Case with contact',
            ContactId = conWithProduct.Id
        );

        Case caseWithOutProduct = new Case(
            Subject = 'Caso without product',
            ContactId = conWithoutProduct.Id
        );

        
        Case caseWithoutContact = new Case(
            Subject = 'Caso without contact'
        );
        
        insert new List<Case> {caseWithContact, caseWithOutProduct, caseWithoutContact};
    }
    
    @IsTest
    static void testCaseWithProduct() {
        Case caseWithProduct = [
            SELECT Id FROM Case WHERE Subject = 'Case with contact' LIMIT 1
        ];

        Test.startTest();
        Product2 result = CaseProductInfoController.getProductInfoFromCase(caseWithProduct.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'El producto no debería ser null.');
        System.assertEquals(0, result.Monthly_cost__c, 'Monthly Cost incorrecto.');
    }

    @IsTest
    static void testCaseWithoutProduct() {
        Case caseWithoutProduct = [
            SELECT Id FROM Case WHERE Subject = 'Caso without product' LIMIT 1
        ];

        Test.startTest();
        Product2 result = CaseProductInfoController.getProductInfoFromCase(caseWithoutProduct.Id);
        Test.stopTest();

        System.assertEquals(null, result, 'Debe devolver null si el contacto no tiene producto.');
    }

    @IsTest
    static void testCaseWithoutContact() {
        Case caseWithoutContact = [
            SELECT Id FROM Case WHERE Subject = 'Caso without contact' LIMIT 1
        ];

        Test.startTest();
        Product2 result = CaseProductInfoController.getProductInfoFromCase(caseWithoutContact.Id);
        Test.stopTest();

        System.assertEquals(null, result, 'Debe devolver null si el caso no tiene contacto.');
    }

    @IsTest
    static void testNullCaseId() {
        Test.startTest();
        Product2 result = CaseProductInfoController.getProductInfoFromCase(null);
        Test.stopTest();

        System.assertEquals(null, result, 'Debe devolver null si caseId es null.');
    }
}