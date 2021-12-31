public class NASAPicOfDayController {
    @AuraEnabled(cacheable=true)
    public static Integration__c getNasaApiKey(){
        return [SELECT Id, Authentication_Token__c, Base_Url__c FROM Integration__c WHERE Name = 'NASA API'];
    }
}
