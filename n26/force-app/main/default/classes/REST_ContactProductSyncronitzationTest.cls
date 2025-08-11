@isTest
public with sharing class REST_ContactProductSyncronitzationTest {

    private static final String CONTACT_IDENTIFIER = 'UWHUDEIhiahiedu';

    @TestSetup
    static void makeData(){
        Product2 newProduct = new Product2();
        newProduct.Name = 'Standard';
        newProduct.Country__c = 'DE';
        newProduct.Currencies_Fees__c = 1.7;
        newProduct.Card_Replacement_Cost__c = 0;
        newProduct.Monthly_cost__c = 0;
        insert newProduct;

        Contact newContact = new Contact();
        newContact.LastName = 'Monzonis';
        newContact.Product__c = newProduct.Id;
        newContact.Home_Country__c = 'DE';
        newContact.UUID__c = CONTACT_IDENTIFIER;
        insert newContact;
    }

    @isTest
    public static void givenValidUUID_whenGetProductInformationIsCall_thenReturnProductInformation(){

        RestRequest request = new RestRequest();
        request.requestURI = '/contact/v0/*';
        request.params.put('UUID', CONTACT_IDENTIFIER);
        request.httpMethod = 'GET';

        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;

        Test.startTest();
        REST_ContactProductSyncronitzation.getProductInformation();
        Test.stopTest();

        REST_ContactProductSyncronitzation.ProductWrapper responseBody = (REST_ContactProductSyncronitzation.ProductWrapper) JSON.deserialize(response.responseBody.toString(), REST_ContactProductSyncronitzation.ProductWrapper.class);

        System.assertEquals(CONTACT_IDENTIFIER, responseBody.contactIdentifier);
        System.assertEquals('Standard', responseBody.productInformation.product);
    }

    @isTest
    public static void givenNonParameter_whenGetProductInformationIsCall_thenReturnError(){
        RestRequest request = new RestRequest();
        request.requestURI = '/contact/v0/*';
        request.httpMethod = 'GET';

        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;

        Test.startTest();
        REST_ContactProductSyncronitzation.getProductInformation();
        Test.stopTest();

        System.assertEquals(400, response.statusCode);
    }

    @isTest
    public static void givenInvalidUUID_whenGetProductInformationIsCall_thenReturnError(){
        RestRequest request = new RestRequest();
        request.requestURI = '/contact/v0/*';
        request.params.put('UUID', 'non-exist');
        request.httpMethod = 'GET';

        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;

        Test.startTest();
        REST_ContactProductSyncronitzation.getProductInformation();
        Test.stopTest();

        System.assertEquals(404, response.statusCode);
    }
}