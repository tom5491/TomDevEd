global class LeadProcessor implements Database.batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
    }
    global void execute(Database.BatchableContext bc, List<Lead> lead_lst){
        List<Lead> finalList = new List<Lead>();
        
        for(Lead lead :lead_lst){
            lead.LeadSource = 'Dreamforce';
            finalList.add(lead);
        }
        update finalList;
    }
    global void finish(Database.BatchableContext bc){
        
    }

}