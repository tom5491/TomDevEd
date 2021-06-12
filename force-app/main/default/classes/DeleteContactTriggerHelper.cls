public class DeleteContactTriggerHelper {
    
    public static void deleteRecords(List<Contact> conList){
        
        for(Contact iterator: conList){
            if(iterator.LastName == 'DeleteBatch') {
                DeleteContacts dc = new DeleteContacts();
                Database.executeBatch(dc);
            }
        }
        
    }

}