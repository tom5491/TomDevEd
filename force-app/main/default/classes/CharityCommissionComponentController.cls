/**
 * @description       :
 * @author            : Tom Philippou
 * @group             :
 * @last modified on  : 17-09-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   26-08-2021   Tom Philippou   Initial Version
 **/
public class CharityCommissionComponentController {
    @AuraEnabled
    public static Account getAccountDetails(String recordId) {
        try {
            Account acc = [SELECT Id, Name, Charity_Number__c, Charity_Suffix__c FROM Account WHERE Id = :recordId];

            return acc;
        } catch (Exception ex) {
            System.debug('Error has occurred: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());

            string errorMessage = 'Error has occurred: ' + ex.getMessage();
            AuraHandledException auraEx = new AuraHandledException(errorMessage);
            auraEx.setMessage(errorMessage);
            throw auraEx;
        }
    }

    @AuraEnabled
    public static WrapperUtility.SimpleWrapperClass getSearchByNameCallout(String parameter) {
        Integration__c integrationObject = new Integration__c();
        try {
            integrationObject = [SELECT Id, Authentication_Token__c, Base_Url__c FROM Integration__c WHERE Name = 'Charity Commission'];
        } catch (QueryException ex) {
            String errorMessage = 'Error has occurred: ' + ex.getMessage();
            AuraHandledException auraEx = new AuraHandledException(errorMessage);
            auraEx.setMessage(errorMessage);
            throw auraEx;
        } catch (Exception ex) {
            String errorMessage = 'Error has occurred: ' + ex.getMessage();
            AuraHandledException auraEx = new AuraHandledException(errorMessage);
            auraEx.setMessage(errorMessage);
            throw auraEx;
        }
        WrapperUtility.SimpleWrapperClass swc = CharityCommissionCallout.getSearchCharityByName(parameter, integrationObject);
        return swc;
    }

    @AuraEnabled
    public static WrapperUtility.SimpleWrapperClass getAllCharityDataCallout(String accountString) {
        Account account = (Account) JSON.deserialize(accountString, Account.class);

        Integration__c integrationObject = [SELECT Id, Authentication_Token__c, Base_Url__c FROM Integration__c WHERE Name = 'Charity Commission'];

        WrapperUtility.SimpleWrapperClass swc = CharityCommissionCallout.doCharityCallout(account, integrationObject);

        if (!swc.success) {
            return swc;
        } else {
            update swc.account;
            swc = getRecordData(swc.account.Id);

            return swc;
        }
    }

    @AuraEnabled
    public static WrapperUtility.SimpleWrapperClass getRecordData(Id recordId) {
        try {
            List<Charity_Commission_Mapping__mdt> ccmMdtList = [SELECT Label, Account_Field_Name__c, Charity_Commission_Field_Name__c, Field_Type__c, Order__c FROM Charity_Commission_Mapping__mdt ORDER BY Order__c ASC];
            Map<String, String> fieldMap = new Map<String, String>();
            String fieldsToGet = '';
            fieldsToGet += 'Charity_Number__c,Charity_Suffix__c,';
            Boolean isFirst = true;
            for (Charity_Commission_Mapping__mdt ccmMdt : ccmMdtList) {
                if (isFirst) {
                    isFirst = false;
                } else {
                    fieldsToGet += ',';
                }
                fieldsToGet += ccmMdt.Account_Field_Name__c + ',' + ccmMdt.Charity_Commission_Field_Name__c;
            }
            System.debug('fieldsToGet: ' + fieldsToGet);
            List<Account> accList = Database.query('SELECT ' + fieldsToGet + ' FROM Account WHERE Id = :recordId');
            Account account = accList[0];

            List<WrapperUtility.RadioEntry> radioEntryList = new List<WrapperUtility.RadioEntry>();
            for (Charity_Commission_Mapping__mdt ccmMdt : ccmMdtList) {
                WrapperUtility.RadioEntry re = new WrapperUtility.RadioEntry();
                re.rowTitle = ccmMdt.label.toUppercase();
                if (ccmMdt.Field_Type__c == 'Date') {
                    String dateStringAcc = String.valueOf(account.get(ccmMdt.Account_Field_Name__c));
                    if (String.isNotBlank(dateStringAcc)) {
                        re.accLabel = dateStringAcc.left(10);
                    }
                    String dateStringCC = String.valueOf(account.get(ccmMdt.Charity_Commission_Field_Name__c));
                    if (String.isNotBlank(dateStringCC)) {
                        re.ccLabel = dateStringCC.left(10);
                    }
                } else {
                    re.accLabel = String.valueOf(account.get(ccmMdt.Account_Field_Name__c));
                    re.ccLabel = String.valueOf(account.get(ccmMdt.Charity_Commission_Field_Name__c));
                }
                re.accValue = ccmMdt.Account_Field_Name__c;
                re.ccValue = ccmMdt.Charity_Commission_Field_Name__c;
                re.fieldType = ccmMdt.Field_Type__c;
                radioEntryList.add(re);
            }

            WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
            swc.account = account;
            swc.radioEntryList = radioEntryList;

            return swc;
        } catch (Exception ex) {
            System.debug('Method: getRecordData');
            System.debug('Error has occurred: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static WrapperUtility.CharityCommissionComponentWrapper updateCharityFields(String recordId, Map<String, String> fieldMap) {
        try {
            List<Charity_Commission_Mapping__mdt> ccmMdtList = [SELECT Label, Account_Field_Name__c, Charity_Commission_Field_Name__c, DeveloperName, Field_Type__c FROM Charity_Commission_Mapping__mdt ORDER BY Order__c ASC];
            Map<String, Charity_Commission_Mapping__mdt> ccmMdtMap = new Map<String, Charity_Commission_Mapping__mdt>();
            List<String> fieldToUpdateList = new List<String>();

            String fieldsToGet = '';
            Boolean isFirst = true;
            for (Charity_Commission_Mapping__mdt ccmMdt : ccmMdtList) {
                ccmMdtMap.put(ccmMdt.DeveloperName, ccmMdt);
                if (isFirst) {
                    isFirst = false;
                } else {
                    fieldsToGet += ',';
                }
                fieldsToGet += ccmMdt.Account_Field_Name__c + ',' + ccmMdt.Charity_Commission_Field_Name__c;

                System.debug('fieldMap.get(ccmMdt.DeveloperName): ' + fieldMap.get(ccmMdt.DeveloperName));
                System.debug('ccmMdt.Charity_Commission_Field_Name__c: ' + ccmMdt.Charity_Commission_Field_Name__c);

                if (fieldMap.get(ccmMdt.DeveloperName) == ccmMdt.Charity_Commission_Field_Name__c) {
                    fieldToUpdateList.add(ccmMdt.DeveloperName);
                }
            }

            // System.debug('fieldToUpdateList: ' + JSON.serialize(fieldToUpdateList));
            // System.debug('fieldsToGet: ' + fieldsToGet);
            List<Account> accList = Database.query('SELECT ' + fieldsToGet + ' FROM Account WHERE Id = :recordId');
            Account account = accList[0];

            List<String> updatedFields = new List<String>();
            for (String devName : fieldToUpdateList) {
                Charity_Commission_Mapping__mdt ccmMdt = ccmMdtMap.get(devName);
                String fieldToUpdate = ccmMdt.Account_Field_Name__c;
                String fieldToUpdateWith = ccmMdt.Charity_Commission_Field_Name__c;
                account.put(fieldToUpdate, account.get(fieldToUpdateWith));

                updatedFields.add(devName.replace('_', ' '));
            }

            Database.SaveResult sr = Database.update(account, false);

            WrapperUtility.CharityCommissionComponentWrapper wuCccw = new WrapperUtility.CharityCommissionComponentWrapper();
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully updated account. Account ID: ' + sr.getId());
                wuCccw.isSuccess = true;
                wuCccw.fieldsToUpdate = updatedFields;
            } else {
                String errorMessage;
                // Operation failed, so get all errors
                for (Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());

                    wuCccw.errorMessage = err.getStatusCode() + ': ' + err.getMessage();
                }
            }

            return wuCccw;
        } catch (Exception e) {
            System.debug('Error has occurred: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());
            System.debug('Cause: ' + e.getCause());

            throw new AuraHandledException(e.getMessage());
        }
    }
}