global class DeleteContacts implements database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, LastName FROM Contact WHERE LastName LIKE 'Batch%']);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> conList) {
        for(Contact iterator: conList){
            system.debug('Contact to be deleted: ' + iterator.LastName);
        }
		system.debug('Total records to be deleted: ' + conList.Size());        
        delete conList;
    }
    
    global void finish(Database.BatchableContext bc) {
        
        List<Contact> finalList = new List<Contact>();
        List<Contact> con = ([SELECT Id, LastName, Description FROM Contact WHERE LastName = 'DeleteBatch' LIMIT 1]);
        for(Contact iterator: con) {
            iterator.Description = 'Deleted records with ID ' + bc.getJobID();
            finalList.add(iterator);
        }
        
        update finalList;
    }
}