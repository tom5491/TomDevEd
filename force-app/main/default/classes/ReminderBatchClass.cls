/**
 * @description       : 
 * @author            : Tom Philippou
 * @group             : 
 * @last modified on  : 10-01-2022
 * @last modified by  : Tom Philippou 
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   10-01-2022   Tom Philippou   Initial Version
**/
global class DealCloseReminderBatch implements Database.batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date dateToday = Date.today();
        
        String query = 'SELECT Id, OwnerId, Owner.Email, Owner.Name, Name, Expected_Close_Date__c, Stage__c FROM Pipeline__c Where Stage__c != \'5-Won / PO\' AND Stage__c != \'0-Lost\' AND Expected_Close_Date__c <= :dateToday ORDER BY Expected_Close_Date__c ASC';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Pipeline__c> scope){
        
        Set<Id> ownerIds = new Set<Id>();
        for(Pipeline__c deal : scope) {
            if(deal.Owner.Email != null){
                ownerIds.add(deal.OwnerId);
            }
            else{
                if(Test.isRunningTest()){
                    ownerIds.add(deal.OwnerId);
                }
            }
        }
        
        Map<Id, List<Pipeline__c>> ownerPipelineMap = new Map<Id, List<Pipeline__c>>();
        for(Id owner : ownerIds) {
            List<Pipeline__c> tempList = new List<Pipeline__c>();
            for(Pipeline__c deal : scope) {
                if(owner == deal.OwnerId){
                    tempList.add(deal);
                }
            }
            ownerPipelineMap.put(owner, tempList);
        }
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        // Construct the list of emails we want to send
        List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        for (Id owner : ownerPipelineMap.keySet()) {
            List<Pipeline__c> dealList = ownerPipelineMap.get(owner);
            
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setTargetObjectId(owner);
            msg.setSaveAsActivity(false);
            msg.setToAddresses(new List<String>{dealList.get(0).Owner.Email});
            msg.setSubject('Overdue Deal Reminder');
            
            String html = '<html><head><style>table {font-family: arial, sans-serif;border-collapse: collapse;width: 100%;}td, th {border: 1px solid #dddddd;text-align: left;padding: 8px;}tr:nth-child(even) {background-color: #dddddd;}</style></head><body>';
            html += '<p>Dear ' + dealList.get(0).Owner.Name + '</p>';
            html += '<p>The following deals are now overdue, please update them.</p>';
            html += '<table><tr><th>Deal Name</th><th>Expected Close Date</th><th>Stage</th><th>Link</th></tr>';

            for(Pipeline__c deal : dealList) {
                html += '<tr><td>' + deal.Name + '</td><td>' + String.valueOf(deal.Expected_Close_Date__c) + '</td><td>' + deal.Stage__c + '</td><td><a href="' + baseUrl + deal.Id + '">View Record</a></td></tr>';
            }
            
            html += '</table></body></html>';
            
			msg.setHTMLBody(html);
            lstMsgsToSend.add(msg);
        }
        
        if(!Test.isRunningTest()){
            Messaging.sendEmail(lstMsgsToSend);
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}