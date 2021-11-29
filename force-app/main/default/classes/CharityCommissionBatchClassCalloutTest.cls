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
public class CharityCommissionBatchClassCalloutTest {
    @isTest
    static void CharityCommissionBatchClassCallout() {
        TestDataFactory tdf = new TestDataFactory();
        Test.setMock(HttpCalloutMock.class, new CharityCommissionCalloutMock());

        Test.startTest();
        CharityCommissionBatchClassCallout ccbcc = new CharityCommissionBatchClassCallout();
        Database.executeBatch(ccbcc, 40);
        Test.stopTest();
    }
}