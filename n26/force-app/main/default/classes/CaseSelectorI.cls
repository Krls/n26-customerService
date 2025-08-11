/**
 * Interface for Case Selector layer.
 */
public interface CaseSelectorI {
    /**
     * @description Method to get instance of the selector.
     * 
     * @return intance of CaseSelectorI
     */
    CaseSelectorI getInstance();

    /**
     * @description Method to get the case by ID.
     * 
     * @param caseId Salesforce case ID.
     * @return Return the case.
     */
    Case getCaseByStringID(Id caseId);
}