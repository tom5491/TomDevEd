public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer no, String s){
        List<Contact> finalList = new List<Contact>();
        
        for(Integer i = 0; no > i; i++){
            Contact c = new Contact();
            c.FirstName = 'Test ' + i; 
            c.LastName = s;
            finalList.add(c);
        }
        
        return finalList;
    }	
}