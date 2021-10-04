/**
 * @description       :
 * @author            : Tom Philippou
 * @group             :
 * @last modified on  : 26-08-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   26-08-2021   Tom Philippou   Initial Version
 **/
public class UkGovCharityComponentController {
    @AuraEnabled
    public static Account getRecordData(String recordId) {
        try {
            List<Account> accList = [SELECT Id, Name, Organisation_Number__c, Registration_Number__c, Suffix__c, Registration_Date__c, Removal_Date__c FROM Account WHERE Id = :recordId];

            Account account = accList[0];

            return account;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static WrapperUtility.SimpleWrapperClass fetchCharities(String parameter, String apiService) {
        try {
            WrapperUtility.SimpleWrapperClass swc = UkGovCharityCallout.doCharityCallout(parameter, apiService);
            return swc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}