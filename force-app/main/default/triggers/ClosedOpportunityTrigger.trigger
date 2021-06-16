trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
	
    List<Task> taskList = new List<Task>();
    
    for(Opportunity iterator : [SELECT Id, StageName FROM Opportunity WHERE Id IN :Trigger.new AND StageName = 'Closed Won']) {
        
        taskList.add(new Task(Subject = 'Follow Up Test Task',
                              whatID = iterator.Id,
                              Priority = 'High',
                              Status = 'In Progress'));
        
    }
    
    insert taskList;
    
}