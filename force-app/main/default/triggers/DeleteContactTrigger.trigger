trigger DeleteContactTrigger on Contact (after insert) {
    
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            DeleteContactTriggerHelper.deleteRecords(trigger.new);
        }
    }

}