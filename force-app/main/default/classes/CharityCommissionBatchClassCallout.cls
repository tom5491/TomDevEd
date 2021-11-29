/**
 * @description       : Batch class for doing a bulk callout containing multiple Charity Numbers
 * @author            : Tom Philippou
 * @last modified on  : 17-09-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   07-09-2021   Tom Philippou   Initial Version
 **/
public class CharityCommissionBatchClassCallout implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    public Integration__c integrationObject;
    public Set<Id> accountIdSet;
    public List<Account> updatedAccList;

    public CharityCommissionBatchClassCallout() {
        integrationObject = [SELECT Id, Authentication_Token__c, Base_Url__c FROM Integration__c WHERE Name = 'Charity Commission'];
    }

    public CharityCommissionBatchClassCallout(Set<Id> newAccountIdSet) {
        integrationObject = [SELECT Id, Authentication_Token__c, Base_Url__c FROM Integration__c WHERE Name = 'Charity Commission'];
        this.accountIdSet = newAccountIdSet;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        try {
            updatedAccList = new List<Account>();
            Id charityRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Charities').getRecordTypeId();
            if (accountIdSet != null && !accountIdSet.isEmpty()) {
                return Database.getQueryLocator([SELECT Charity_Number__c, Charity_Suffix__c FROM Account WHERE Id IN :accountIdSet]);
            }
            return Database.getQueryLocator([SELECT Charity_Number__c, Charity_Suffix__c FROM Account WHERE RecordTypeId = :charityRTId AND Charity_Number__c != NULL]);
        } catch (Exception ex) {
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            insert new Error_Log__c(Line_Number__c = ex.getLineNumber(), Error_Message__c = ex.getMessage(), Type__c = 'Charity Commission Batch Start()');

            throw new CharityCalloutException();
        }
    }

    public void execute(Database.BatchableContext bc, List<Account> charityRecords) {
        Map<String, Account> charityNoToAccountMap = new Map<String, Account>();
        List<String> charityRegisteredNumberList = new List<String>();
        for (Account acc : charityRecords) {
            charityRegisteredNumberList.add(acc.Charity_Number__c);
            String key = acc.Charity_Number__c + ':' + acc.Charity_Suffix__c;
            charityNoToAccountMap.put(key, acc);
        }
        String parameter = String.join(charityRegisteredNumberList, ',');
        parameter = parameter.replace(' ', '%20');

        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(integrationObject.Base_Url__c + '/charitydetailsmulti/' + parameter);
            request.setMethod('GET');
            request.setHeader('Cache-Control', 'no-cache');
            request.setHeader('Ocp-Apim-Subscription-Key', integrationObject.Authentication_Token__c);
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                String respBody = response.getBody();
                System.debug('respBody: ' + respBody);

                List<WrapperUtility.GetCharityDetailsMulti> returnedCharitiesList = (List<WrapperUtility.GetCharityDetailsMulti>) JSON.deserialize(respBody, List<WrapperUtility.GetCharityDetailsMulti>.class);
                for (WrapperUtility.GetCharityDetailsMulti wuGcdm : returnedCharitiesList) {
                    String key = wuGcdm.reg_charity_number + ':' + wuGcdm.group_subsid_suffix;
                    Date modifiedDate = Date.valueOf(wuGcdm.last_modified_time);
                    //if (modifiedDate >= System.now().addDays(-1) && charityNoToAccountMap.containsKey(key)) {
                    if (charityNoToAccountMap.containsKey(key)) {
                        System.debug('Entered charityNoToAccountMap');
                        Account acc = charityNoToAccountMap.get(key);
                        acc.CC_Last_Modified_Date__c = modifiedDate;

                        WrapperUtility.SimpleWrapperClass swc = CharityCommissionCallout.doCharityCallout(acc, integrationObject);

                        updatedAccList.add(acc);
                    } else {
                        System.debug('Valid account not found for Charity Number: ' + wuGcdm.reg_charity_number + ' and ' + wuGcdm.group_subsid_suffix);
                    }
                }
            } else if (response.getStatusCode() == 404) {
            } else {
            }
        } catch (Exception ex) {
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            insert new Error_Log__c(Line_Number__c = ex.getLineNumber(), Error_Message__c = ex.getMessage(), Type__c = 'Charity Commission - CharityCommissionBatchClassCallout');

            //throw new CharityCalloutException();
            // System.debug('Message: ' + ex.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc) {
        try {
            System.debug('UpdatedAccountList: ' + JSON.serialize(updatedAccList));
            if (!updatedAccList.isEmpty()) {
                Database.SaveResult[] srList = Database.update(updatedAccList, false);
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        System.debug('Account with Id: ' + sr.getId() + 'updated successfully.');
                    } else {
                        for (Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Account fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('CharityCommissionBatchClassCallout Finish Method!');
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            insert new Error_Log__c(Line_Number__c = ex.getLineNumber(), Error_Message__c = ex.getMessage(), Type__c = 'Charity Commission - CharityCommissionBatchClassCallout');

            //throw new CharityCalloutException();
            // System.debug('Message: ' + ex.getMessage());
        }
    }
}