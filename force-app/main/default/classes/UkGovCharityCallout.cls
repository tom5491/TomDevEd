/**
 * @description       :
 * @author            : Tom Philippou
 * @group             :
 * @last modified on  : 27-08-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   25-08-2021   Tom Philippou   Initial Version
 **/
public class UkGovCharityCallout {
    // public static Integration__c integrationObject = new Integration__c();

    // public UkGovCharityCallout() {
    //     System.debug('Entered Constructor!');
    // }

    @AuraEnabled
    public static WrapperUtility.SimpleWrapperClass doCharityCallout(String parameter, String apiService) {
        // System.debug(json.serialize(integrationObject));

        parameter = parameter.replace(' ', '%20');
        Integration__c integrationObject = [SELECT Id, Authentication_Token__c, Base_Url__c FROM Integration__c WHERE Name = 'Charity Integration'];

        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(integrationObject.Base_Url__c + '/' + apiService + '/' + parameter);
            request.setMethod('GET');
            request.setHeader('Cache-Control', 'no-cache');
            request.setHeader('Ocp-Apim-Subscription-Key', integrationObject.Authentication_Token__c);
            request.setTimeout(40000);
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, String> newObjectMap = new Map<String, String>();
                // if (apiService == 'allcharitydetails') {
                //     Map<String, object> objectMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                //     // for (String key : objectMap.keySet()) {
                //     //     String newKey = key.replace('_', ' ');
                //     //     List<String> words = newKey.split(' ');
                //     //     List<String> newWordList = new List<String>();
                //     //     for (String word : words) {
                //     //         word = word.capitalize();
                //     //         newWordList.add(word);
                //     //         System.debug('word: ' + word);
                //     //     }
                //     //     newKey = String.join(newWordList, ' ');
                //     //     newKey += ': ';
                //     //     System.debug('Key: ' + newKey);
                //     //     System.debug('Object: ' + String.valueOf(objectMap.get(key)));

                //     //     newObjectMap.put(newKey, String.valueOf(objectMap.get(key)));
                //     // }

                //     WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                //     swc.resultMap = newObjectMap;
                //     swc.success = true;
                //     swc.result = 'Successfully Retrieved';
                //     return swc;
                // } else {
                List<WrapperUtility.SearchCharityName> wuScnList = (List<WrapperUtility.SearchCharityName>) JSON.deserialize(response.getBody(), List<WrapperUtility.SearchCharityName>.class);

                List<Account> acctList = new List<Account>();
                for (WrapperUtility.SearchCharityName wuscn : wuScnList) {
                    Account acc = new Account();
                    acc.Name = wuscn.charity_name;
                    acc.Organisation_Number__c = wuscn.organisation_number;
                    acc.Registration_Number__c = wuscn.reg_charity_number;
                    //acc.Type__c = wuscn.charity_type;
                    acc.Registration_Status__c = wuscn.reg_status;
                    acctList.add(acc);
                }

                System.debug('AcctList: ' + Json.serialize(acctList));

                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.resultList = acctList;
                swc.success = true;
                swc.result = 'Successfully Retrieved';
                if (newObjectMap == null) {
                    throw new AuraHandledException('Results Map is Null.');
                }
                return swc;

                // List<Map<String, String>> resultMapList = new List<Map<String, String>>();

                // for (WrapperUtility.SearchCharityName wuScn : wuScnList) {
                //     Map<String, String> tempObjectMap = new Map<String, String>();
                //     tempObjectMap.put('Organisation Number:', String.valueOf(wuScn.organisation_number));
                //     tempObjectMap.put('Registered Number:', String.valueOf(wuScn.reg_charity_number));
                //     tempObjectMap.put('Group Subsidiary Suffix:', String.valueOf(wuScn.group_subsid_suffix));
                //     tempObjectMap.put('Charity Name:', wuScn.charity_name);
                //     tempObjectMap.put('Registration Status:', wuScn.reg_status);
                //     tempObjectMap.put('Date Of Registration:', wuScn.date_of_registration);

                //     String dateObjectString = String.valueOf(wuScn.date_of_registration);
                //     Date regDate = date.valueOf(dateObjectString);

                //     // dateObjectString = dateObjectString.substringBefore('T');
                //     // dateObjectString = dateObjectString.replace('-', '/');
                //     // Date regDate = Date.parse(dateObjectString);

                //     tempObjectMap.put('Date of Removal:', String.valueOf(regDate));
                //     resultMapList.add(tempObjectMap);
                // }

                // System.debug('resultMapList: ' + Json.serialize(resultMapList));
                // WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                // swc.resultMapList = resultMapList;
                // swc.success = true;
                // swc.result = 'Successfully Retrieved';
                // if (newObjectMap == null) {
                //     throw new AuraHandledException('Results Map is Null.');
                // }
                // return swc;
                // }
            } else if (response.getStatusCode() == 404) {
                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.resultList = null;
                swc.success = false;
                swc.result = 'Record not found';
                return swc;
            } else {
                String respStatus = response.getStatus();
                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.resultList = null;
                swc.success = false;
                swc.result = respStatus;
                return swc;
            }
        } catch (Exception ex) {
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            throw new AuraHandledException(ex.getMessage());
            // System.debug('Message: ' + ex.getMessage());
        }
    }

    public class SimpleWrapperClass {
        @AuraEnabled
        public String result;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public List<Account> resultMapList;
    }
}