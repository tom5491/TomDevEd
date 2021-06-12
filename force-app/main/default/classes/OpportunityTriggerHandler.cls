public class OpportunityTriggerHandler{
    public static integer oppCount = 0;
    public static void nameFormat(List<Opportunity> oppList){
        
        List<Opportunity> finalList = new List<Opportunity>();
		
		List<Opportunity> oppListNew = [SELECT Id, Name, Amount, AccountId FROM Opportunity WHERE Id IN : oppList];
        Map<Id, Account> acctMap = accountMap(oppListNew);
		        
        for(Opportunity opp :oppListNew){
            String acctName = accountName(acctMap, opp);
            String lpOppCount = String.valueOf(oppCount).leftPad(5, '0');
            opp.Name = 'Opp-' + lpOppCount + '-' + opp.Amount + '-' + acctName + '-' + System.Datetime.now().format('YYYYMMdd');
            finalList.add(opp);
            oppCount =+1;
        }
        if(finalList.size()>0){
        update finalList;
        } else {
            System.debug('Size of finalList: 0');
        }
    }
    
    public static void nameUpdate(List<Opportunity> updList){
        
        Map<Id, Account> acctMap = accountMap(updList);
        
        for(Opportunity opp :updList){
            String acctName = accountName(acctMap, opp);
            opp.Name = 'Opp-' + opp.Amount + '-' + acctName + '-' + opp.CreatedDate.format('YYYYMMdd');
        }
    }
    
    private static Map<Id, Account> accountMap(List<Opportunity> oppList){
        Set<Id> accountIds = new Set<Id>();
        
        for(Opportunity opp :oppList){
            accountIds.add(opp.AccountId);
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN : accountIds]);
        
        return accountMap;
    }
    
    private static String accountName(Map<Id, Account> acctMap, Opportunity opp){
        String acctName;
        acctName = opp.AccountId;
        acctName = acctMap.get(opp.AccountId).Name;
        return acctName;
    }
}