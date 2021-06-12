public class reUsableMultiSelectLookupCtrl {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
        System.debug('Entered fetchLookUpValues');
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
 
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List<Account> initMethod(String recordId){
        Account a = [SELECT Id, Name, Colleague_JSON__c FROM Account WHERE Id = :recordId];
        List<Account> lstSelectedRecords = (List<Account>) JSON.deserialize(a.Colleague_JSON__c, List<Account>.class);
        Set<Id> aIdSet = new Set<Id>();
        for(Account account :lstSelectedRecords){
            aIdSet.add(account.Id);
        }
        List<Account> updatedAList = [SELECT Id, Name FROM Account WHERE Id IN :aIdSet];
        
        List<Account> updAccList = new List<Account>();
        List<Record> recordList = new List<Record>(); 
        for(Account account :updatedAList){
            Account updAcc = new Account();
            updAcc.Id = account.Id;
            updAcc.Name = account.Name;
            updAccList.add(updAcc);
            
            Record record = new Record();
            record.id = account.Id;
            record.name = account.Name;
            recordList.add(record);
        }
        
        a.Colleague_JSON__c = JSON.serialize(recordList);
        
        update a;
        return updAccList;
    }
    
    @AuraEnabled
    public static void saveMethod(List<Account> lstSelectedRecords, String recordId){
        Account a = [SELECT Id, Name, Colleague_JSON__c FROM Account WHERE Id = :recordId];
        List<Record> recordList = new List<Record>();
        
        Set<Id> accIdSet = new Set<Id>();
        for(Account linkedAcc :lstSelectedRecords){
            accIdSet.add(linkedAcc.Id);
        }
        
        lstSelectedRecords = [SELECT Id, Name, Colleague_JSON__c FROM Account WHERE Id IN :accIdSet];
        
        for(Account item :lstSelectedRecords){
            Record record = new Record();
            record.id = item.Id;
            record.name = item.Name;
            recordList.add(record);
            
            System.debug(item.Colleague_JSON__c);
            
            List<Account> currentAccountLst = new List<Account>();
            
            if(item.Colleague_JSON__c == null){
                Record newRecord = new Record();
                newRecord.id = a.Id;
                newRecord.name = a.Name;
                List<Record> newRecordLst = new List<Record>(); 
                newRecordLst.add(newRecord);
                String jsonString = JSON.serialize(newRecordLst);
                item.Colleague_JSON__c = jsonString;
                
            } else {
                currentAccountLst = (List<Account>) JSON.deserialize(item.Colleague_JSON__c, List<Account>.class);
        		if(!currentAccountLst.contains(a)){
                    currentAccountLst.add(a);
                    item.Colleague_JSON__c = JSON.serialize(currentAccountLst);
                }
            }
            
            
        }
        
        update lstSelectedRecords;
        
        String jsonString = JSON.serialize(recordList);
        a.Colleague_JSON__c = jsonString;
        
        update a;
    }
    public class Record {
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String name;
    }
}