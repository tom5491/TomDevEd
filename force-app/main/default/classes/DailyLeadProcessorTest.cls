@isTest
private class DailyLeadProcessorTest {
    // dummy CRON expression
    // as this is a test, job will execute after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testMethod void testScheduledJob() {
        List<Lead> lead_lst = new List<Lead>();
        for(Integer i = 0; i<200; i++) {
            Lead l = new Lead(LastName = 'Test ' + i,
                              Company = 'Test Company',
                              Status = 'Open - Not Contacted');
            lead_lst.add(l);
        }
        insert lead_lst;
		
        Map<Id, Lead> lead_map = new Map<Id, Lead>(lead_lst);
        List<Id> leadId_lst = new List<Id>(lead_map.keySet());
		        
        Test.startTest();
		String jobId = system.schedule('DailyLeadScheduleTest', CRON_EXP, new DailyLeadProcessor());
        
        List<Lead> lead_count = [SELECT Id, LeadSource FROM Lead WHERE Id IN :leadId_lst AND LeadSource = 'Dreamforce'];
        system.assertEquals(0, lead_count.size(), 'Leads updated too early');
        Test.stopTest();
        
        List<Lead> updLead_lst = [SELECT Id, LastName, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(lead_lst.size(), updLead_lst.size(), 'LeadSource for created Leads was not updated');
    }
    

}