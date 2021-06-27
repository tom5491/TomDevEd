/**
 * @description       :
 * @author            : Tom Philippou
 * @last modified on  : 27-06-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   27-06-2021   Tom Philippou   Initial Version
 **/
public class PlannerTriggerHandler extends TriggerHandler {
    private List<Planner__c> newList;

    public PlannerTriggerHandler() {
        this.newList = (List<Planner__c>) Trigger.new;
    }

    public override void beforeInsert() {
        List<Planner__c> planList = [SELECT Study_Date__c FROM Planner__c];
        List<Date> dateList = new List<Date>();
        for (Planner__c nlp : newList) {
            for (Planner__c plp : planList) {
                if (nlp.Study_Date__c == plp.Study_Date__c) {
                    nlp.addError('Only one can be created per day');
                }
            }
        }
        //Add revision start date
        Date startDate = Date.newInstance(2020, 6, 29);

        //Loop through new records
        for (Planner__c nlp : newList) {
            //Find difference between new record date and start date
            Integer noOfDays = (startDate.daysBetween(nlp.Study_Date__c)) + 1;

            //Create new Datetime variable of Study Date and then turn into String to format
            Datetime dt = nlp.Study_Date__c;
            String formatDate = dt.format('dd/MM/YYYY');

            //Convert Integer difference between dates to String and pad with zeros
            String strNoOfDays = String.valueOf(noOfDays).leftPad(3, '0');

            //Name Syntax
            nlp.Name = 'Day-' + strNoOfDays + '-' + formatDate;
        }
    }
    public override void afterInsert() {
        WeatherTodayCallout.methodName();
    }
}
