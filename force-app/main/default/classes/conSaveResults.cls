public class conSaveResults {

    public static void conSRMethod(){
        
        List<Contact> conList = new List<Contact>();
        
        Contact con = new Contact();
		con.FirstName = 'John';
        con.LastName = 'Smith';
        conList.add(con);
        
        Contact failCon = new Contact();
        failCon.FirstName = 'Frank';
        conList.add(failCon);
        
        Database.SaveResult[] resultList = Database.insert(conList, False);
        
        for(Database.SaveResult iterator: resultList){
            if(iterator.isSuccess()){
                System.debug('Successfully inserted: ' + iterator.getID());
            } else {
                System.debug(iterator);
            }
        }
        
    }
}