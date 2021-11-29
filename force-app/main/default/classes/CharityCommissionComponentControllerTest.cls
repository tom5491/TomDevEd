/**
 * @description       :
 * @author            : Tom Philippou
 * @last modified on  : 16-09-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   16-09-2021   Tom Philippou   Initial Version
 **/
@isTest
public class CharityCommissionComponentControllerTest {
    @isTest
    static void getAccountDetailsTest() {
        TestDataFactory tdf = new TestDataFactory();

        Test.startTest();
        Account acc = CharityCommissionComponentController.getAccountDetails(tdf.testAccount.Id);

        System.assertEquals('Test Charity', acc.Name, 'Account Name doesn\'t match');
        Test.stopTest();
    }

    @isTest
    static void getAccountDetailsTestNegative() {
        TestDataFactory tdf = new TestDataFactory();

        Test.startTest();
        try {
            Account acc = CharityCommissionComponentController.getAccountDetails('23132165484');
        } catch (Exception ex) {
            System.assertEquals('Error has occurred: List has no rows for assignment to SObject', ex.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void getSearchByNameCalloutTest() {
        TestDataFactory tdf = new TestDataFactory();

        Test.setMock(HttpCalloutMock.class, new CharityCommissionCalloutMock());

        Test.startTest();
        String returnedCharitiesString = CharityCommissionComponentController.getSearchByNameCallout('Marie Curie');

        System.assert(returnedCharitiesString.contains('"reg_charity_number":508665'), 'Test Failed: wrong JSON retrieved from Mock Callout Class');
        Test.stopTest();
    }

    @isTest
    static void getSearchByNameCalloutTestNegative() {
        //TODO: negative test
    }

    @isTest
    static void getAllCharityDataCalloutTest() {
        TestDataFactory tdf = new TestDataFactory();
        String accountString = JSON.serialize(tdf.testAccount);

        Test.setMock(HttpCalloutMock.class, new CharityCommissionCalloutMock());

        Test.startTest();
        String iawString = CharityCommissionComponentController.getAllCharityDataCallout(accountString);

        System.debug(iawString);
        Test.stopTest();
    }

    @isTest
    static void getAllCharityDataCalloutTestNegative() {
        //TODO: negative test
    }

    @isTest
    static void updateCharityFieldsTest() {
        TestDataFactory tdf = new TestDataFactory();

        String fieldMapString = '{"Phone":"CC_Phone__c","Registration_Status":"CC_Registration_Status__c","Date_of_Removal":"Date_of_Removal__c","Trustees":"CC_Trustees__c","Reporting_Period_Year_End":"Reporting_Period_Year_End__c","Income":"Income__c","Charity_Type":"CC_Charity_Type__c","Email":"CC_Email__c","Charitable_Object":"CC_Charitable_Object__c","Date_of_Registration":"CC_Date_of_Registration__c","Charity_Reg_Co_Number":"Charity_Reg_Co_Number__c","Website":"CC_Website__c","Other_Names":"CC_Other_Names__c","Name":"CC_Full_Charity_Name__c"}';
        Map<String, Object> mapping = (Map<String, Object>) JSON.deserializeUntyped(fieldMapString);
        Map<String, String> stringMap = new Map<String, String>();
        for (String key : mapping.keySet()) {
            String value = String.valueOf(mapping.get(key));
            stringMap.put(key, value);
        }

        Test.startTest();
        WrapperUtility.CharityCommissionComponentWrapper wuCccw = CharityCommissionComponentController.updateCharityFields(tdf.testAccountCharityFields.Id, stringMap);

        System.assertEquals(true, wuCccw.isSuccess, 'Set fields not successful.');
        Test.stopTest();
    }
}