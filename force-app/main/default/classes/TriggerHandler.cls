/**
 * @description       :
 * @author            : Tom Philippou
 * @group             :
 * @last modified on  : 04-03-2022
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   04-03-2022   Tom Philippou   Initial Version
 **/
public virtual class TriggerHandler {
  // Static Map of handlername, times run() was invoked
  private static Map<String, LoopCount> loopCountMap;
  private static Set<String> bypassedHandlers;

  // The current context of the trigger, overridable in tests
  @TestVisible
  private TriggerContext context;

  // The current context of the trigger, overridable in tests
  @TestVisible
  private Boolean isTriggerExecuting;

  // Static Initailization
  static {
    loopCountMap = new Map<String, LoopCount>();
    bypassedHandlers = new Set<String>();
  }

  // No Argument Constructor
  public TriggerHandler() {
    this.setTriggerContext();
  }

  /**
   * Public instance methods
   **/
  // main method that will be called during exeuction
  public void run() {
    if (!validateRun())
      return;

    addToLoopCount();

    // dispatch to the correct handler method
    if (this.context == TriggerContext.BEFORE_INSERT) {
      this.beforeInsert();
    } else if (this.context == TriggerContext.BEFORE_UPDATE) {
      this.beforeUpdate();
    } else if (this.context == TriggerContext.BEFORE_DELETE) {
      this.beforeDelete();
    } else if (this.context == TriggerContext.AFTER_INSERT) {
      this.afterInsert();
    } else if (this.context == TriggerContext.AFTER_UPDATE) {
      this.afterUpdate();
    } else if (this.context == TriggerContext.AFTER_DELETE) {
      this.afterDelete();
    } else if (this.context == TriggerContext.AFTER_UNDELETE) {
      this.afterUndelete();
    }
  }

  public void setMaxLoopCount(Integer max) {
    String handlerName = getHandlerName();
    if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
      TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
    } else {
      TriggerHandler.loopCountMap.get(handlerName).setMax(max);
    }
  }

  public void clearMaxLoopCount() {
    this.setMaxLoopCount(-1);
  }

  /**
   * public static methods
   **/

  public static void bypass(String handlerName) {
    TriggerHandler.bypassedHandlers.add(handlerName);
  }

  public static void clearBypass(String handlerName) {
    TriggerHandler.bypassedHandlers.remove(handlerName);
  }

  public static Boolean isBypass(String handlerName) {
    return TriggerHandler.bypassedHandlers.contains(handlerName);
  }

  public static void clearAllBypasses() {
    TriggerHandler.bypassedHandlers.clear();
  }

  /**
   * Private Instance Methods
   **/

  @TestVisible
  private void setTriggerContext() {
    this.setTriggerContext(null, false);
  }

  @TestVisible
  private void setTriggerContext(String ctx, Boolean testMode) {
    if (!Trigger.isExecuting && !testMode) {
      this.isTriggerExecuting = false;
      return;
    } else {
      this.isTriggerExecuting = true;
    }

    if (
      (Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
      (ctx != null &&
      ctx == 'before insert')
    ) {
      this.context = TriggerContext.BEFORE_INSERT;
    } else if (
      (Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
      (ctx != null &&
      ctx == 'before update')
    ) {
      this.context = TriggerContext.BEFORE_UPDATE;
    } else if (
      (Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
      (ctx != null &&
      ctx == 'before delete')
    ) {
      this.context = TriggerContext.BEFORE_DELETE;
    } else if (
      (Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
      (ctx != null &&
      ctx == 'after insert')
    ) {
      this.context = TriggerContext.AFTER_INSERT;
    } else if (
      (Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
      (ctx != null &&
      ctx == 'after update')
    ) {
      this.context = TriggerContext.AFTER_UPDATE;
    } else if (
      (Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
      (ctx != null &&
      ctx == 'after delete')
    ) {
      this.context = TriggerContext.AFTER_DELETE;
    } else if (
      (Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
      (ctx != null &&
      ctx == 'after undelete')
    ) {
      this.context = TriggerContext.AFTER_UNDELETE;
    }
  }

  // increment the loop count
  @TestVisible
  private void addToLoopCount() {
    String handlerName = getHandlerName();
    if (TriggerHandler.loopCountMap.containsKey(handlerName)) {
      Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName)
        .increment();
      if (exceeded) {
        Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
        throw new TriggerHandlerException(
          'Maximum loop count of ' +
          String.valueOf(max) +
          ' reached in ' +
          handlerName
        );
      }
    }
  }

  // Make sure this trigger should continue to run
  @TestVisible
  private Boolean validateRun() {
    if (!this.isTriggerExecuting || this.context == null) {
      throw new TriggerHandlerException(
        'Trigger handler called outside of Trigger execution'
      );
    }

    if (TriggerHandler.bypassedHandlers.contains(getHandlerName())) {
      return false;
    }

    return true;
  }

  @TestVisible
  private String getHandlerName() {
    return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
  }

  /**
   * Context Methods
   **/
  // context-spesific methods for override
  @TestVisible
  protected virtual void beforeInsert() {
  }

  @TestVisible
  protected virtual void beforeUpdate() {
  }

  @TestVisible
  protected virtual void beforeDelete() {
  }

  @TestVisible
  protected virtual void afterInsert() {
  }

  @TestVisible
  protected virtual void afterUpdate() {
  }

  @TestVisible
  protected virtual void afterDelete() {
  }

  @TestVisible
  protected virtual void afterUndelete() {
  }

  /**
   * Inner Classes
   **/
  // Inner Class for managing the loop count per handler

  @TestVisible
  private class LoopCount {
    private Integer max;
    private Integer count;

    public LoopCount() {
      this.max = 5;
      this.count = 0;
    } // end no argument constructor

    public LoopCount(Integer max) {
      this.max = max;
      this.count = 0;
    }

    public Boolean increment() {
      this.count++;
      return this.exceeded();
    }

    public Boolean exceeded() {
      if (this.max < 0) {
        return false;
      }

      if (this.count > this.max) {
        return true;
      }

      return false;
    }

    public Integer getMax() {
      return this.max;
    }

    public Integer getCount() {
      return this.count;
    }

    public void setMax(Integer max) {
      this.max = max;
    }
  } // end LoopCount Inner class

  // Possible Trigger Contexts
  @TestVisible
  private enum TriggerContext {
    BEFORE_INSERT,
    BEFORE_UPDATE,
    BEFORE_DELETE,
    AFTER_INSERT,
    AFTER_UPDATE,
    AFTER_DELETE,
    AFTER_UNDELETE
  }

  // Exception Class
  public class TriggerHandlerException extends Exception {
  }
} // end TriggerHandler Class
