/**
 * @description  This class runs the appropriate methods on the trigger handler based on the current trigger context.
 * @author Chris Aldridge, http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 * @date Dec 31, 2015
 * @author Sep 25 by krigi, https://github.com/krigi/Lightweight-Trigger-Framework ,
 *                          Updated by krigi to take advantage of Summer’18 features: Apex switch statement and Trigger.operationType context variable
 * @date Sep 25, 2018
 * @author Mark H. Morrison, https://github.com/MarkHMorrison/Lightweight-Trigger-Framework
 * @date Sat Dec 29, 2018
 */
public class TriggerDispatcher {
    /*
      Call this method from your trigger, passing in an instance of a trigger handler which implements ITriggerHandler.
      This method will fire the appropriate methods on the handler depending on the trigger context.
    */
    public static void Run(ITriggerHandler handler, System.TriggerOperation triggerEvent) {
        // Check to see if the trigger has been disabled. If it has, return
        if (handler.IsDisabled())
            return;

        // Detect the current trigger context and fire the relevant methods on the trigger handler:

        switch on triggerEvent {
            when BEFORE_INSERT {
                handler.BeforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                handler.BeforeUpdate(Trigger.newMap, Trigger.oldMap);
            }
            when BEFORE_DELETE {
                handler.BeforeDelete(Trigger.oldMap);
            }
            when AFTER_INSERT {
                handler.AfterInsert(Trigger.newMap);
            }
            when AFTER_UPDATE {
                handler.AfterUpdate(Trigger.newMap, Trigger.oldMap);
            }
            when AFTER_DELETE {
                handler.AfterDelete(Trigger.oldMap);
            }
            when AFTER_UNDELETE {
                handler.AfterUndelete(Trigger.oldMap);
            }
        }
    }
}