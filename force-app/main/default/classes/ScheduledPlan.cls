global class ScheduledPlan implements Schedulable {
    
	global void execute(SchedulableContext SC) {
    	NewPlanner.createPlannerRecord();
   	}
}