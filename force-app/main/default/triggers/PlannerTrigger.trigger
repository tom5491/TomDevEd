/**
 * @description       :
 * @author            : Tom Philippou
 * @last modified on  : 27-06-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   27-06-2021   Tom Philippou   Initial Version
 **/
trigger PlannerTrigger on Planner__c(before insert, after insert) {
    new PlannerTriggerHandler().run();
}
