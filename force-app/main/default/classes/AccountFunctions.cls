/**
 * @description       : Method to
 * @author            : Tom Philippou
 * @last modified on  : 11-01-2022
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   01-09-2021   Tom Philippou   Initial Version
 **/
public class AccountFunctions {
    public static void getCharities(List<Account> accList) {
        try {
            String charityRT = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Charities').getRecordTypeId();

            Set<Id> newAccountIdSet = new Set<Id>();

            for (Account acc : accList) {
                if (acc.RecordTypeId == charityRT && !String.isBlank(acc.Charity_Number__c) && !String.isBlank(acc.Charity_Suffix__c)) {
                    newAccountIdSet.add(acc.Id);
                }
            }

            System.debug('newAccountIdSet: ' + JSON.serialize(newAccountIdSet));
            if (!newAccountIdSet.isEmpty()) {
                CharityCommissionBatchClassCallout ccbcc = new CharityCommissionBatchClassCallout(newAccountIdSet);
                Database.executeBatch(ccbcc, 40);
            } else {
                return;
            }

            // TODO: do something with accNoCharityNumberList - error log? email?
        } catch (Exception ex) {
            System.debug('AccountFunctions - getCharities');
            System.debug('Error has occurred: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            insert new Error_Log__c(Line_Number__c = ex.getLineNumber(), Error_Message__c = ex.getMessage(), Type__c = 'AccountFunctions - getCharities');
        }
    }
    // test
}