/**
 * @description       : class containing methods used to callout to CHarity Commission
 * @author            : Tom Philippou
 * @last modified on  : 17-09-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   31-08-2021   Tom Philippou   Initial Version
 * 1.1   17-09-2021   Tom Philippou   Added error handling by having SimpleWrapperClass returned to Aura Component and batch class
 **/
public class CharityCommissionCallout {
    public static Integration__c integrationObject;

    public CharityCommissionCallout(Integration__c integrationObj) {
        integrationObject = integrationObj;
    }

    /**
     * @description -
     * @param - parameter - Search name to send to Charity Commission
     * @return
     */
    @AuraEnabled
    public static WrapperUtility.SimpleWrapperClass getSearchCharityByName(String parameter, Integration__c integrationObject) {
        try {
            parameter = parameter.replace(' ', '%20');

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(integrationObject.Base_Url__c + '/searchCharityName/' + parameter);
            System.debug('Endpoint: ' + request.getEndpoint());
            request.setMethod('GET');
            request.setHeader('Cache-Control', 'no-cache');
            request.setHeader('Ocp-Apim-Subscription-Key', integrationObject.Authentication_Token__c);
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            System.debug('getSearchCharityByName response: ' + response);
            WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
            if (response.getStatusCode() == 200) {
                String respBody = response.getBody();
                System.debug('respBody: ' + respBody);

                swc.success = true;
                // swc.statusCode = response.getStatusCode();
                // swc.scbnList = (List<WrapperUtility.SearchByCharityName>) JSON.deserialize(respBody, List<WrapperUtility.SearchByCharityName>.class);
                swc.result = respBody;

                return swc;
            } else if (response.getStatusCode() == 404) {
                // swc.isSuccess = false;
                // swc.statusCode = response.getStatusCode();
                System.debug('getSearchCharityByName failed, Status Code: ' + response.getStatusCode());

                String message = 'No results have been found for this search term';
                AuraHandledException ex = new AuraHandledException(message);
                ex.setMessage(message);
                throw ex;
                // return swc;
            } else {
                String message = 'An error has occurred. Please contact your System Administrator';
                AuraHandledException ex = new AuraHandledException(message);
                ex.setMessage(message);
                throw ex;
            }
        } catch (Exception ex) {
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            insert new Error_Log__c(Line_Number__c = ex.getLineNumber(), Error_Message__c = ex.getMessage(), Type__c = 'Charity Commission');

            throw new AuraHandledException(ex.getMessage());
            // System.debug('Message: ' + ex.getMessage());
        }
    }

    /**
     * @description - method to get bulk of data back from Charity Commission
     * @param - Account - account passed in from Batch
     * @return Account - account updated with data from the AllCharityDetailsCallout
     */
    @AuraEnabled
    public static WrapperUtility.SimpleWrapperClass doCharityCallout(Account acc, Integration__c integrationObject) {
        try {
            WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
            swc = getAllCharityDetailsCallout(acc, integrationObject);
            System.debug('acc Callout 1: ' + Json.serialize(swc.account));
            swc = getCharityAccountArInformationCallout(swc.account, integrationObject);
            System.debug('acc Callout 2: ' + Json.serialize(swc.account));
            swc = getCharityGoverningDocumentCallout(swc.account, integrationObject);
            System.debug('acc Callout 3: ' + Json.serialize(swc.account));
            return swc;
        } catch (Exception ex) {
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            insert new Error_Log__c(Line_Number__c = ex.getLineNumber(), Error_Message__c = ex.getMessage(), Type__c = 'Charity Commission');

            throw new AuraHandledException(ex.getMessage());
            // System.debug('Message: ' + ex.getMessage());
        }
    }

    /**
     * @description - method to get bulk of data back from Charity Commission
     * @param - Account - account passed in from Batch
     * @return WrapperUtility.SimpleWrapperClass - account updated with data from the AllCharityDetailsCallout
     */
    public static WrapperUtility.SimpleWrapperClass getAllCharityDetailsCallout(Account account, Integration__c integrationObject) {
        try {
            System.debug('Parameter: ' + JSON.serialize(account));

            String parameter = String.valueOf(account.get('Charity_Number__c')) + '/' + String.valueOf(account.get('Charity_Suffix__c'));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(integrationObject.Base_Url__c + '/allcharitydetails/' + parameter);
            System.debug('Endpoint: ' + request.getEndpoint());
            request.setMethod('GET');
            request.setHeader('Cache-Control', 'no-cache');
            request.setHeader('Ocp-Apim-Subscription-Key', integrationObject.Authentication_Token__c);
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                String respBody = response.getBody();
                System.debug('respBody: ' + respBody);

                WrapperUtility.AllCharityDetailsWrapperClass returnedCharity = (WrapperUtility.AllCharityDetailsWrapperClass) JSON.deserialize(respBody, WrapperUtility.AllCharityDetailsWrapperClass.class);

                // charity_name
                account.CC_Full_Charity_Name__c = returnedCharity.charity_name;

                // charity_type - TODO: need field in SF
                account.CC_Charity_Type__c = returnedCharity.charity_type;

                // reg_status - TODO: need field in SF
                if (returnedCharity.reg_status == 'R') {
                    account.CC_Registration_Status__c = 'Registered';
                } else if (returnedCharity.reg_status == 'RM') {
                    account.CC_Registration_Status__c = 'Removed';
                }

                account.CC_Date_of_Registration__c = date.valueOf(returnedCharity.date_of_registration);
                account.CC_Income__c = returnedCharity.latest_income;
                String addressStreet = returnedCharity.address_line_one + '\r\n' + returnedCharity.address_line_two + '\r\n' + returnedCharity.address_line_three + '\r\n' + returnedCharity.address_line_four;
                account.CC_Address_Street__c = addressStreet;

                // address_line_five
                //account.Address_Line_5__c = returnedCharity.address_line_five;

                account.CC_Address_Post_Code__c = returnedCharity.address_post_code;
                account.CC_Phone__c = returnedCharity.phone;
                account.CC_Email__c = returnedCharity.email;
                account.CC_Website__c = returnedCharity.web;
                account.CC_Charity_Reg_Co_Number__c = returnedCharity.charity_co_reg_number;
                if (!String.isBlank(returnedCharity.date_of_removal)) {
                    account.CC_Date_of_Removal__c = date.valueOf(returnedCharity.date_of_removal);
                }

                if (!returnedCharity.trustee_names.isEmpty()) {
                    String body = '';
                    body += '<ul>';
                    for (WrapperUtility.Trustee_names trustee : returnedCharity.trustee_names) {
                        String trusteeName = capitalizeWords(trustee.trustee_name);
                        body += '<li>' + trusteeName + '</li>';
                    }
                    body += '</ul>';
                    account.CC_Trustees__c = body;
                }

                if (!returnedCharity.other_names.isEmpty()) {
                    String body = '';
                    body += '<ul>';
                    for (WrapperUtility.Other_names name : returnedCharity.other_names) {
                        String nameType;
                        if (name.name_type == 'O') {
                            nameType = 'Old';
                        } else {
                            nameType = 'Working';
                        }
                        body += '<li><b>' + name.other_name + '</b> (' + nameType + ')' + '</li>';
                    }
                    body += '</ul>';
                    account.CC_Other_Names__c = body;
                }

                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.success = true;
                swc.account = account;
                return swc;
            } else if (response.getStatusCode() == 404) {
                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.account = account;
                swc.success = false;
                swc.result = 'Record not found';
                return swc;
            } else {
                String respStatus = response.getStatus();
                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.account = account;
                swc.success = false;
                swc.result = respStatus;
                return swc;
            }
        } catch (Exception ex) {
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            insert new Error_Log__c(Line_Number__c = ex.getLineNumber(), Error_Message__c = ex.getMessage(), Type__c = 'Charity Commission');

            // throw new CharityCalloutException();

            WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
            swc.account = account;
            swc.success = false;
            swc.result = 'An error has occurred' + ex.getMessage();
            return swc;
        }
    }

    /**
     * @description - method to get bulk of data back from Charity Commission
     * @param - Account - account passed in from Batch
     * @return WrapperUtility.SimpleWrapperClass - account updated with data from the AllCharityDetailsCallout
     */
    public static WrapperUtility.SimpleWrapperClass getCharityAccountArInformationCallout(Account account, Integration__c integrationObject) {
        try {
            String parameter = String.valueOf(account.get('Charity_Number__c')) + '/' + String.valueOf(account.get('Charity_Suffix__c'));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(integrationObject.Base_Url__c + '/charityaraccounts/' + parameter);
            request.setMethod('GET');
            request.setHeader('Cache-Control', 'no-cache');
            request.setHeader('Ocp-Apim-Subscription-Key', integrationObject.Authentication_Token__c);
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                String respBody = response.getBody();
                System.debug('respBody: ' + respBody);

                List<String> regNumberList = new List<String>();

                List<WrapperUtility.Charityaraccounts> returnedCharitiesList = (List<WrapperUtility.Charityaraccounts>) JSON.deserialize(respBody, List<WrapperUtility.Charityaraccounts>.class);
                Integer listSize = returnedCharitiesList.size();
                if (!returnedCharitiesList.isEmpty()) {
                    account.CC_Reporting_Period_Year_End__c = Date.valueOf(returnedCharitiesList[listSize - 1].reporting_period_year_end);
                }

                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.success = true;
                swc.account = account;
                return swc;
            } else if (response.getStatusCode() == 404) {
                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.account = account;
                swc.success = false;
                swc.result = 'Record not found';
                return swc;
            } else {
                String respStatus = response.getStatus();
                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.account = account;
                swc.success = false;
                swc.result = respStatus;
                return swc;
            }
        } catch (Exception ex) {
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            insert new Error_Log__c(Line_Number__c = ex.getLineNumber(), Error_Message__c = ex.getMessage(), Type__c = 'Charity Commission');

            WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
            swc.account = account;
            swc.success = false;
            swc.result = 'An error has occurred' + ex.getMessage();
            return swc;
        }
    }

    /**
     * @description - method to get bulk of data back from Charity Commission
     * @param - Account - account passed in from Batch
     * @return WrapperUtility.SimpleWrapperClass - account updated with data from the AllCharityDetailsCallout
     */
    public static WrapperUtility.SimpleWrapperClass getCharityGoverningDocumentCallout(Account account, Integration__c integrationObject) {
        try {
            String parameter = String.valueOf(account.get('Charity_Number__c')) + '/' + String.valueOf(account.get('Charity_Suffix__c'));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(integrationObject.Base_Url__c + '/charitygoverningdocument/' + parameter);
            request.setMethod('GET');
            request.setHeader('Cache-Control', 'no-cache');
            request.setHeader('Ocp-Apim-Subscription-Key', integrationObject.Authentication_Token__c);
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                String respBody = response.getBody();
                System.debug('respBody: ' + respBody);

                WrapperUtility.Charitygoverningdocument returnedCharity = (WrapperUtility.Charitygoverningdocument) JSON.deserialize(respBody, WrapperUtility.Charitygoverningdocument.class);
                account.CC_Charitable_Object__c = returnedCharity.charitable_objects;

                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.success = true;
                swc.account = account;
                return swc;
            } else if (response.getStatusCode() == 404) {
                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.account = account;
                swc.success = false;
                swc.result = 'Record not found';
                return swc;
            } else {
                String respStatus = response.getStatus();
                WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
                swc.account = account;
                swc.success = false;
                swc.result = respStatus;
                return swc;
            }
        } catch (Exception ex) {
            System.debug('Message: ' + ex.getMessage());
            System.debug('Line Number: ' + ex.getLineNumber());
            System.debug('Cause: ' + ex.getCause());

            insert new Error_Log__c(Line_Number__c = ex.getLineNumber(), Error_Message__c = ex.getMessage(), Type__c = 'Charity Commission');

            WrapperUtility.SimpleWrapperClass swc = new WrapperUtility.SimpleWrapperClass();
            swc.account = account;
            swc.success = false;
            swc.result = 'An error has occurred' + ex.getMessage();
            return swc;
        }
    }

    private static String capitalizeWords(String input) {
        input = input.toLowercase();
        String output = '';
        Matcher m = Pattern.compile('(\\w+|\\W+)').matcher(input);
        while (m.find())
            output += m.group().capitalize();
        return output;
    }
}