/**
 * Interface of Contact selector layer.
 */
public interface ContactSelectorI {

    /**
     * @description Method to get instance of the selector.
     * 
     * @return intance of ContactSelectorI
     */
    ContactSelectorI getInstance();

    /**
     * @description Method to get the contact by Salesforce ID.
     * 
     * @param Contact salesforce ID
     * @return Contact related to the ID.
     */
    Contact getContactById(Id contactId);
    
    /**
     * @description Method to get the contact by UUID.
     * 
     * @param UUID internal id.
     * 
     * @return contact related to the UUID.
     */
    Contact getContactByExternalID(String UUID);
}