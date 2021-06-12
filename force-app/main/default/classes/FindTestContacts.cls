public class FindTestContacts {
    
    public static List<Contact> testContacts(String s) {
    	
        List<Contact> searchList = [SELECT ID, LastName FROM Contact WHERE LastName LIKE :s];
        List<Contact> resultList = new List<Contact>();
        
        System.debug(searchList);
                
        integer i = 0;
        
        for(Contact iterator: searchList) {
        
        	iterator.LastName = 'Test ' + i;
            i += 1;
            resultList.add(iterator);
        
    	}
    	
        update resultList;
        
        return resultList;
        		        
    }

}