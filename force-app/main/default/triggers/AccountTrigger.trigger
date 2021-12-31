/**
 * @description       : Account Trigger utilising ITriggerHandler Interface
 * @author            : Tom Philippou
 * @group             : 
 * @last modified on  : 31-08-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   31-08-2021   Tom Philippou   Initial Version
**/
trigger AccountTrigger on Account(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    // Call the trigger dispatcher and pass it an instance of the AccountTriggerHandler and Trigger.opperationType
    TriggerDispatcher.Run(new AccountTriggerHandler(), Trigger.operationType);
}