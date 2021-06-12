@isTest
private class TestRestrictContactByName {
    @isTest static void TestAddOneContact() {
        Contact c = new Contact();
        c.LastName = 'INVALIDNAME';
    }
}