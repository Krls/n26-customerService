@RestResource(urlMapping='/contact/v0/*')
global without sharing class REST_ContactProductSyncronitzation {
    @TestVisible
    private static final String ERROR_MESSAGE = 'An error occurred while retrieving contact information.';
    @TestVisible
    private static final String ERROR_STATUS = 'Failure';

    @HttpGet
    webservice static void getProductInformation(){

        RestRequest request = RestContext.request;
        String contactIdentifier = request.params.get('UUID');

        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');

        if(contactIdentifier != null &&
            !String.isEmpty(contactIdentifier)){
            try{
                ContactSelectorI contactSelector = ContactSelector.getInstance();
                Contact currentContact = contactSelector.getContactByExternalID(contactIdentifier);
                
                ProductWrapper productList = generateResponse(currentContact);
                response.statusCode = 200;
                response.responseBody = Blob.valueOf(JSON.serialize(productList));
            } catch (QueryException ex){
                response.statusCode = 404;
                response.responseBody = Blob.valueOf(JSON.serialize(new Error(ERROR_STATUS, ERROR_MESSAGE)));                
            }
        } else {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf(JSON.serialize(new Error(ERROR_STATUS, ERROR_MESSAGE)));
        }
    }

    private static ProductWrapper generateResponse(Contact contact){
        ProductWrapper result = new ProductWrapper();
        result.contactIdentifier = contact.UUID__c;

        ProductInformationWrapper piWrapperList = new ProductInformationWrapper(contact.product__r.Name,  
                                                                            contact.product__r.Monthly_cost__c, 
                                                                            contact.product__r.Currencies_Fees__c, 
                                                                            contact.product__r.Card_Replacement_Cost__c);

        result.productInformation = piWrapperList;
        return result;
    }

    public class Error{
        public String status;
        public String message;
        
        public Error(String status, String message){
            this.status = status;
            this.message = message;
        }
    }

    public class ProductWrapper{
        public String contactIdentifier;
        public ProductInformationWrapper productInformation;
    }

    public class ProductInformationWrapper{
        public String product;
        public Decimal monthlyCost;
        public Decimal currencyFees;
        public Decimal cardReplacementCost;

        public ProductInformationWrapper(String product, Decimal monthlyCost, Decimal currencyFees, Decimal cardReplacementCost){
            this.product = product;
            this.monthlyCost = monthlyCost;
            this.currencyFees = currencyFees;
            this.cardReplacementCost = cardReplacementCost;
        }
    }
}