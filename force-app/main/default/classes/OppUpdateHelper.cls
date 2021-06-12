public class OppUpdateHelper {
    public static void OppInsert(List<Opportunity> newOpps) {
        List<Task> taskList = new List<Task>();
        
        for(Opportunity iterator :newOpps) {
            Task newTask = new Task();
            newTask.Subject = 'Call regarding ' + iterator.Name + ' opportunity';
            newTask.WhatId = iterator.id;
            newTask.Priority = 'High';
            newTask.Status = 'Not Started';
            newTask.Description = 'Made using Apex Trigger';
            taskList.add(newTask);
        }

        insert taskList;
    }

    public static void OppClosed(List<Opportunity> newOpps) {
        
        List<Task> taskList = new List<Task>();

        for(Opportunity tempOpp :newOpps) {

            if(tempOpp.StageName != 'Closed Won' || tempOpp.StageName != 'Closed Lost') {
                Task newTask = new Task();
                newTask.Subject = 'This Opportunity is still active and has been updated';
                newTask.WhatId = tempOpp.id;
                newTask.Priority = 'High';
                newTask.Status = 'Not Started';
                newTask.Description = 'Made using Apex Trigger';
                taskList.add(newTask);
            }
        }
        
        insert taskList;
    }

    public static void OppMethod3(Map<Id,Opportunity> oldOpps, List<Opportunity> newOpps) {
        List<Task> taskList = new List<Task>();

        for(Opportunity iterator :newOpps) {
            Opportunity tempOpp = oldOpps.get(iterator.Id);
            
            Boolean booOne = tempOpp.StageName.equals('Needs Analysis');
            Boolean booTwo = iterator.StageName.equals('Closed Lost');

            if(booOne && booTwo) {
                Task newTask = new Task();
                newTask.Subject = tempOpp.StageName;
                newTask.WhatId = tempOpp.id;
                newTask.Priority = 'High';
                newTask.Status = 'Not Started';
                newTask.Description = 'Made using Apex Trigger';
                taskList.add(newTask);
            }
        }
        insert taskList;
    }
}