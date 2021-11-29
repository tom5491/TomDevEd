/**
 * @description       : 
 * @author            : Tom Philippou
 * @last modified on  : 23-09-2021
 * @last modified by  : Tom Philippou 
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   23-09-2021   Tom Philippou   Initial Version
**/
public class CharityCommissionScheduler implements Schedulable {
    public void execute(SchedulableContext SC) {
        CharityCommissionBatchClassCallout ccbcc = new CharityCommissionBatchClassCallout();
        Database.executeBatch(ccbcc, 40);
    }
}