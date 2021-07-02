/**
 * @description       :
 * @author            : Tom Philippou
 * @last modified on  : 28-06-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   27-06-2021   Tom Philippou   Initial Version
 **/
global class BadgePlannerSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        moveIncompleteBadges();
    }

    private static void moveIncompleteBadges() {
        Date todaysDate = System.today().addDays(-1);
        String plannerNameQuery = '%' + String.valueOf(todaysDate.day()).leftPad(2, '0') + '/' + String.valueOf(todaysDate.month()).leftPad(2, '0') + '/' + String.valueOf(todaysDate.year());
        System.debug(plannerNameQuery);
        List<Planner_Badge__c> planBadgeList = [SELECT Id, Name, Planner__c, Badge__c, Badge__r.trailheadapp__Total_Badges_Awarded__c FROM Planner_Badge__c WHERE Planner__r.Name LIKE :plannerNameQuery];

        Date tomorrowDate = System.today();
        Planner__c newPb;

        try {
            newPb = [SELECT Id, Name FROM Planner__c WHERE Study_Date__c = :tomorrowDate];
        } catch (NullPointerException npe) {
            newPb = new Planner__c(Name = 'default', Study_Date__c = tomorrowDate);
            insert newPb;
        }

        List<Planner_Badge__c> newPbList = new List<Planner_Badge__c>();
        for (Planner_Badge__c pb : planBadgeList) {
            if (pb.Badge__r.trailheadapp__Total_Badges_Awarded__c == 0) {
                pb.Planner__c = newPb.Id;
                newPbList.add(pb);
            }
        }

        if (!newPbList.isEmpty()) {
            update newPbList;
        }
    }
}
