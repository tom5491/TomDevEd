public class AccountProcessor {
    
    @future
    public static void countContacts(List<Id> accountId_lst) {
        
        Map<Id,Integer> account_cno = new Map<Id,Integer>(); 
        List<Account> account_lst_all = new List<Account>([SELECT Id, (SELECT Id FROM Contacts) FROM Account]);
        for(Account a:account_lst_all) {
            account_cno.put(a.Id,a.Contacts.size()); //populate the map
            
        }
            		
        List<Account> account_lst = new List<Account>(); // list of account that we will upsert
        	
        for(Id accountId : accountId_lst) {
            if(account_cno.containsKey(accountId)) {
                Account acc = new Account();
                acc.Id = accountId;
                acc.Number_of_Contacts__c = account_cno.get(accountId);
                account_lst.add(acc);
            }
            
        }
        upsert account_lst;
    }

}