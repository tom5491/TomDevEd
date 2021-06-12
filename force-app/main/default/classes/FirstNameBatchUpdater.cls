global class FirstNameBatchUpdater implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, LastName FROM Contact WHERE LastName = 'Test' OR LastName = 'Test 2']);
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> conList) {
        List<Contact> upList = new List<Contact>();
        
        for(Contact con: conList) {
            if(con.LastName == 'Test') {
                con.LastName = 'Batch Test';
                upList.add(con);
            } else if(con.LastName == 'Test 2') {
                con.LastName = 'Batch Test 2';
                upList.add(con);
            }
        }
        if(upList.size()>0) {
        update upList;
        }
    }
    global void finish(Database.BatchableContext bc) {
        
        System.debug('Batch successfully updated');
    }
}