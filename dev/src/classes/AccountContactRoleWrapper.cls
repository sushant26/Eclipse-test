global class AccountContactRoleWrapper implements Comparable {

    public Lookup_Contact_Roles__c acr;
    
    // Constructor 
    
    public AccountContactRoleWrapper(Lookup_Contact_Roles__c ac) {
        acr = ac;
    }
    
    // Compare opportunities based on the opportunity amount. 
    
    global public Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper 
    
        AccountContactRoleWrapper compareToAcr = (AccountContactRoleWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal. 
    
        Integer returnValue = 0;
        if (acr.name > compareToAcr.acr.name) {
            // Set return value to a positive value. 
    
            returnValue = 1;
        } else if (acr.name < compareToAcr.acr.name) {
            // Set return value to a negative value. 
    
            returnValue = -1;
        }
        
        return returnValue;       
    }
}