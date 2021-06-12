@isTest
public class AddPrimaryContactTest {
    @testSetup static void createTestData() {
    	List<Account> allCons = new List<Account>();
        
    	List<Account> accNY = TestDataFactory.createAccountsWithOpps(50, 0);
    	for(Account a : accNY) {
        	a.BillingState = 'NY';
            allCons.add(a);
    	}
    
    	List<Account> accCA = TestDataFactory.createAccountsWithOpps(50, 0);
    	for(Account a : accCA) {
        	a.BillingState = 'CA';
            allCons.add(a);
    	}
        
        update allCons;
        
        
    }
    static testMethod void callQueueable() {
        
        Contact con = new Contact(LastName = 'ConTest');
        insert con;
        String state = 'CA';
        
        AddPrimaryContact apc = new AddPrimaryContact(con, state);
		Test.startTest();
		system.enqueueJob(apc);
		Test.stopTest();   
        
        system.assertEquals(50, [SELECT count() FROM Contact WHERE AccountId IN (SELECT Id FROM Account WHERE BillingState = 'CA')]);
    }
}