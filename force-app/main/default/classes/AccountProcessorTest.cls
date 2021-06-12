@isTest
public class AccountProcessorTest {
    static testmethod void createTestData() {
        
        //create accounts with cons
        List<Account> account_lst = TestDataFactory.createAccountsWithCons(1, 2);
        List<Id> idList = new List<Id>();
        
        for(account a : account_lst){
            idList.add(a.Id);
        }
        
        test.startTest();
        AccountProcessor.countContacts(idList);
        test.stopTest();
        
        List<Account> assertList = new List<Account>([SELECT Number_of_contacts__c FROM Account WHERE Id IN :idList]);
        system.assertEquals(2, account_lst[0].Number_of_Contacts__c);
    }
}