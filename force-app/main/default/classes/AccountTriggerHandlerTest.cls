/**
 * @description Example test class for AccountTriggerHandler class.
 *              These tests cover the AccountTrigger, AccountTriggerHandler, and TriggerDispatcher
 *              You will need to implement similar tests in your triggers to get proper code coverage
 * @author Mark H. Morrison, https://github.com/MarkHMorrison/Lightweight-Trigger-Framework
 * @date Sat Dec 29 2018
 */
@isTest
private class AccountTriggerHandlerTest {
    @testSetup
    static void setup() {
        Account testAccount = new Account(Name = 'New Account');
        insert testAccount;
        System.assertNotEquals(null, testAccount.Id, 'Failed to insert testAccount');
    }

    @isTest
    static void testAccountTriggerHandler() {
        Account[] preAccounts = [SELECT Id, Name FROM Account];
        preAccounts[0].Name = 'Test Account';
        Account testAccount = new Account(Name = 'Test Account');

        Test.startTest();
        Boolean[] exceptions = new List<Boolean>{};
        try {
            insert testAccount;
        } catch (Exception e) {
            exceptions.add(true);
        }
        try {
            update preAccounts;
        } catch (Exception e) {
            exceptions.add(true);
        }
        Test.stopTest();

        System.assertEquals(0, exceptions.size());
        for (Boolean exceptionThrown : exceptions) {
            System.assert(exceptionThrown);
        }
        Account[] postAccounts = [SELECT Id, Name FROM Account];
        System.assertEquals(2, postAccounts.size());
        System.assertEquals('Test Account', postAccounts[0].Name);
    }

    @isTest
    static void testAccountTriggerHandlerUpdate() {
        Account[] preAccounts = [SELECT Id, Name FROM Account];
        preAccounts[0].Name = 'Old Account';

        Test.startTest();
        update preAccounts;
        Test.stopTest();

        Account[] postAccounts = [SELECT Id, Name FROM Account];
        System.assertEquals('Old Account', postAccounts[0].Name);
    }

    @isTest
    static void testAccountTriggerHandlerDisabled() {
        Account[] preAccounts = [SELECT Id, Name FROM Account];
        preAccounts[0].Name = 'Test Account';

        Test.startTest();
        AccountTriggerHandler.TriggerDisabled = true;
        update preAccounts;
        Test.stopTest();

        Account[] postAccounts = [SELECT Id, Name FROM Account];
        System.assertEquals('Test Account', postAccounts[0].Name);
    }

    @isTest
    static void testAccountTriggerHandlerDelete() {
        Account[] preAccounts = [SELECT Id, Name FROM Account];

        Test.startTest();
        delete preAccounts;
        undelete preAccounts;
        Test.stopTest();

        Account[] postAccounts = [SELECT Id, Name FROM Account];
        System.assertEquals('New Account', postAccounts[0].Name);
    }
}