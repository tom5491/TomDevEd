@isTest
public class FirstNameBatchUpdaterTest {

    @testSetup static void createTestData(){
        List<Contact> finalList =new List<Contact>();
        Contact con = new Contact();
        con.LastName = 'Test';
        finalList.add(con);
        
        Contact con2 = new Contact();
        con2.LastName = 'Test 2';
        finalList.add(con2);
        
        insert finalList;
        
    }
    static testMethod void batchUpdaterTest1(){
        
        Test.startTest();
        FirstNameBatchUpdater Tester = new FirstNameBatchUpdater();
        Id jobId = Database.executeBatch(Tester);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM Contact WHERE LastName = 'Batch Test']);
        System.assertEquals(1, [SELECT count() FROM Contact WHERE LastName = 'Batch Test 2']);
    }
}