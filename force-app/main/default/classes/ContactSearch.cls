public class ContactSearch {
    
    public static List<Contact> searchForContacts(String ln, String m) {
        
        Contact[] ccts = [SELECT ID, Name FROM Contact WHERE LASTNAME = :ln AND MailingPostalCode = :m];
        
        return ccts;
        
    } 

}