trigger OpportunityTrigger on Opportunity (before insert, after insert, after update, before update){
    
    if(trigger.isBefore) {
        if(trigger.isUpdate) {
            OpportunityTriggerHandler.nameUpdate(trigger.new);
        }
    }
    if(trigger.isAfter) {
        if(trigger.isInsert) {
                        
            OpportunityTriggerHandler.nameFormat(trigger.new);
        }
        
    }
        
}