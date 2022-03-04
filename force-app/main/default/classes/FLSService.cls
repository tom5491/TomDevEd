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
public with sharing class FLSService {
  public static void doInsert(List<SObject> entities) {
    checkFls(AccessType.CREATABLE, entities);
    insert entities;
  }

  public static void doUpdate(List<SObject> entities) {
    checkFls(AccessType.UPDATABLE, entities);
    update entities;
  }

  public static void doUpsert(List<SObject> entities) {
    checkFls(AccessType.UPSERTABLE, entities);
    upsert entities;
  }

  public static void doInsert(SObject entity) {
    checkFls(AccessType.CREATABLE, entity);
    insert entity;
  }

  public static void doUpdate(SObject entity) {
    checkFls(AccessType.UPDATABLE, entity);
    update entity;
  }
  public static void doDelete(SObject entity) {
    if (!entity.getSObjectType().getDescribe().isDeletable()) {
      throw new SecurityException('No delete permission on ' + entity);
    }
    delete entity;
  }

  public static void doDelete(List<SObject> entities) {
    for (SObject entity : entities) {
      if (!entity.getSObjectType().getDescribe().isDeletable()) {
        throw new SecurityException('No delete permission on ' + entity);
      }
    }
    delete entities;
  }

  public static void doUnDelete(SObject entity) {
    if (!entity.getSObjectType().getDescribe().isUndeletable()) {
      throw new SecurityException('No undelete permission on ' + entity);
    }
    undelete entity;
  }

  public static void doUnDelete(List<SObject> entities) {
    for (SObject entity : entities) {
      if (!entity.getSObjectType().getDescribe().isUndeletable()) {
        throw new SecurityException('No undelete permission on ' + entity);
      }
    }
    undelete entities;
  }

  public static SObjectAccessDecision checkFls(
    AccessType accessType,
    List<SObject> entities
  ) {
    SObjectAccessDecision decision = Security.stripInaccessible(
      accessType,
      entities,
      true
    );
    // if (!decision.getModifiedIndexes().isEmpty()) {
    //     throw new SecurityException(JSON.serialize(decision.getRemovedFields()));
    // }
    System.debug('######decision######' + decision);
    return decision;
  }

  public static SObjectAccessDecision checkFls(
    AccessType accessType,
    SObject entity
  ) {
    return checkFls(accessType, new List<SObject>{ entity });
  }

  public class SecurityException extends Exception {
  }
}
