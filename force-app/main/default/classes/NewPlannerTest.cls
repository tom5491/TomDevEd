@isTest
public class NewPlannerTest {
    
    @testSetup static void createTestData(){
        List<Topic__c> tList = new List<Topic__c>();
        
        
        for(integer i = 0; i < 5; i++){
            Topic__c t;
            t.Name = 'Test ' + i+1;
            
        }
    }
    
    static testMethod void createPlanner() {
        
    	NewPlanner.createPlannerRecord();
        List<Planner__c> pList = [SELECT Id, Name FROM Planner__c];
                
        System.assertEquals(1, pList.size());
    
    }
}