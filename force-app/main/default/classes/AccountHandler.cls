public class AccountHandler {
    
    public static Account insertNewAccount(String actName){
		Account actOne = new Account();
        actOne.Name = actName;
        
        try{
        	
            insert actOne;
            
        } catch (DmlException e) {
            return null;
        }
   		return actOne;
    }
    
}