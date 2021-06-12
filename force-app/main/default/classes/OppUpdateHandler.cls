public class OppUpdateHandler {
    
    /*public static void nameFormat(List<Opportunity> oppList){
        
        
    }
    
    public static void TaskAdder(Map<Id, Opportunity> oldOpps, List<Opportunity> newOpps){
        List<Task> taskList = new List<Task>();

        for(Opportunity iterator :newOpps) {
            Opportunity tempOpp = oldOpps.get(iterator.Id);

            Boolean oldOppsBoo = tempOpp.StageName.equals('Needs Analysis');
            Boolean newOppsBoo = iterator.StageName.equals('Value Proposition');

            if(oldOppsBoo && newOppsBoo) {
                Task newTask = new Task();
                newTask.Subject = 'Call regarding ' + iterator.Name + ' opportunity';
                newTask.WhatId = iterator.id;
                newTask.Priority = 'High';
                newTask.Status = 'Not Started';
                newTask.Description = 'Made using Apex Trigger';
                taskList.add(newTask);
            }
        }
        insert taskList;
    }*/
}