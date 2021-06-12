@isTest
public class FirstNameHelperTest{
    static testMethod void replaceNameTestSetup(){
        List<Contact> conList = new List<Contact>();
        for(Integer i = 0; i < 3; i++) {
            Contact con = new Contact();
            con.FirstName = 'John';
            con.LastName = 'Test';
			conList.add(con);            
        }
        insert conList;
                
        Test.startTest();
        FirstNameHelper.ReplaceName(conList);
        Test.stopTest();
        
        System.assertEquals(3, [SELECT count() FROM Contact WHERE LastName = 'Test'], 'Last Name Error');
        System.assertEquals(3, [SELECT count() FROM Contact WHERE FirstName = 'Smith'], 'First Name Error');
        System.assertEquals(3, [SELECT count() FROM Contact WHERE FirstName = 'Smith' AND LastName = 'Test'], 'Name Not Corrected');
        
    }
}