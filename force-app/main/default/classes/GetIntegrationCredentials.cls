/**
 * @description       : 
 * @author            : Tom Philippou
 * @last modified on  : 10-01-2022
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   10-01-2022   Tom Philippou   Initial Version
**/
public class GetIntegrationCredentials {
    @AuraEnabled(cacheable=true)
    public static Integration__c getCredentials(String integrationName){
        return [SELECT Id, Authentication_Token__c, Base_Url__c FROM Integration__c WHERE Name = :integrationName];
    }
}