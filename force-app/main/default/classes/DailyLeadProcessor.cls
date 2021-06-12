global class DailyLeadProcessor implements schedulable {
    
    global void execute(SchedulableContext ctx) {
        List<Lead> finalList = new List<Lead>();
        List<Lead> lead_lst = [SELECT Id, Name, LeadSource FROM Lead WHERE LeadSource = Null LIMIT 200];
        for(Lead l : Lead_lst) {
            l.LeadSource = 'Dreamforce';
            finalList.add(l);
        }
        
        if(finalList.size()>0){
        	update finalList;
        }
        
    }
}