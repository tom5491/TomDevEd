public class ContactAndLeadSearch {

    public static List<List<sObject>> searchContactsAndLeads(String p) {
        
        List<List<sObject>> searchResults = [FIND :p IN NAME FIELDS RETURNING Contact(FirstName,LastName), Lead(FirstName,LastName)];
        
        return searchResults;
    }
}