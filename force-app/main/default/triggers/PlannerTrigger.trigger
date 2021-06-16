trigger PlannerTrigger on Planner__c (before insert, after insert) {
	
    if (Trigger.isBefore && Trigger.isInsert) {
      	PlannerTriggerHandler.beforeInsert(Trigger.new);

    } else if (Trigger.isAfter && Trigger.isInsert) {
        PlannerTriggerHandler.afterInsert();
    }
}