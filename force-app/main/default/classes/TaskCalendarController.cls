public class TaskCalendarController {
    @AuraEnabled
    public static List<Task__c> getTasks(){
        List<Task__c> result =  [Select Id, Name,Completed_Date__c,LastModifiedDate from Task__c ];
        return result ; 
    } 
}