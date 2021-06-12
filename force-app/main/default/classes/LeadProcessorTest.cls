@isTest
public class LeadProcessorTest {
    @testSetup static void createTestData(){
        List<Lead> lead_lst = TestDataFactory.createLeads(200);
        
    }
    
    static testmethod void test(){
    
    	test.startTest();
    	LeadProcessor leadPro = new LeadProcessor();
    	Id batchId = Database.executeBatch(leadPro);
    	test.stopTest();
    
        System.assertEquals(200, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
}