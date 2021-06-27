/**
 * @description       : 
 * @author            : Tom Philippou
 * @last modified on  : 27-06-2021
 * @last modified by  : Tom Philippou
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   27-06-2021   Tom Philippou   Initial Version
**/
public class NewPlanner {
    @invocableMethod
    public static void createPlannerRecord() {
        // create new Planner record with todays date and add to List
        List<Planner__c> newList = new List<Planner__c>();
        Planner__c p = new Planner__c();
        p.Study_Date__c = System.TODAY();
        newList.add(p);

        // if Planner record created successfully, collect Topic records with Learnt__c unchecked from yesterday using SOQL query
        Database.SaveResult[] resultList = Database.insert(newList, false);
        for (Database.SaveResult iterator : resultList) {
            if (iterator.isSuccess()) {
                Date yesterday = System.TODAY() - 1;
                List<Topic__c> topList = [SELECT ID, Name, Planner__c, Learnt__c, Planner__r.Study_Date__c, Linked_Objective__r.Name__c, Component__r.Name FROM Topic__c WHERE Learnt__c = FALSE AND Planner__r.Study_Date__c = yesterday];

                List<Topic__c> finalList = new List<Topic__c>();
                String body;

                // if Topic List is larger than 0, loop through topic records and change the Topic Planner Master record to today's record and add details to body String
                // add updated Topic records to finalList
                if (topList.size() > 0) {
                    for (Topic__c iterator2 : topList) {
                        iterator2.Planner__c = p.Id;
                        body += iterator2.Name + '<br/>' + iterator2.Linked_Objective__r.Name__c + '<br/>' + iterator2.Component__r.Name + '<br/><br/>';
                        finalList.add(iterator2);
                    }

                    // update
                    update finalList;
                    //EmailManager.sendMail('tom5491@googlemail.com', 'A new study Plan has been created for: ' + System.Datetime.now().format('dd-MM-YYYY'),
                    //'Please fill in the relevant Topics, Objectives and Resources <br/><br/>' + body);
                }
            } else {
                System.debug('No record to update');
            }
        }
    }
}
