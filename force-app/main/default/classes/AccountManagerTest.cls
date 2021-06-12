@isTest
public class AccountManagerTest {
    @isTest static void testGetAccount() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://https://tomstesting-dev-ed.my.salesforce.com/services/apexrest/Accounts/'
            + recordId + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAcc = AccountManager.getAccount();
        // Verify results
        System.assert(thisAcc != null);
        System.assertEquals('Test record', thisAcc.Name);
    }
    // Helper method
    static Id createTestRecord() {
        // Create test record
        Account accTest = new Account(
            Name='Test record'
            );
        insert accTest;
        
        Contact con1 = new Contact(
        	FirstName='Test',
        	LastName='Contact',
        	AccountId=accTest.Id);
        Contact con2 = new Contact(
        	FirstName='Test',
        	LastName='Contact 2',
            AccountId=accTest.Id);
        List<Contact> conList = new List<Contact>{con1, con2};
            insert conList;
        return accTest.Id;
    }     
}