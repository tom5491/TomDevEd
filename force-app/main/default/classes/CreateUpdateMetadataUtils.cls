/**
 * @description       :
 * @author            : Tom Philippou
 * @last modified on  : 02-05-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   22-04-2021   Tom Philippou   Initial Version
 **/
public class CreateUpdateMetadataUtils implements Metadata.DeployCallback {
  public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
    if (result.status == Metadata.DeployStatus.Succeeded) {
      System.debug(' success : ' + result);
    } else {
      System.debug(' fail : ' + result);
    }
  }

  public static void createUpdateMetadata(String fullName, String label, Map<String, Object> fieldWithValuesMap) {
    Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
    customMetadata.fullName = fullName;
    customMetadata.label = label;

    for (String key : fieldWithValuesMap.keySet()) {
      Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
      customField.field = key;
      customField.value = fieldWithValuesMap.get(key);
      customMetadata.values.add(customField);
    }

    Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
    mdContainer.addMetadata(customMetadata);
    CreateUpdateMetadataUtils callback = new CreateUpdateMetadataUtils();
    Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
  }

  public static void deleteMetadata(String objectName, STring recordApiName) {
    List<Record_Search_Setting__mdt> recordSearchDeleteList = [
      SELECT DeveloperName
      FROM Record_Search_Setting__mdt
      WHERE DeveloperName = :recordApiName
    ];

    MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    //List<String> recordsToDelete = new List<String>();
    //recordsToDelete.add('My_Custom_Type.record1');

    //Metadata.DeleteResult[] results = service.deleteMetadata('Record_Search_Setting__mdt', recordSearchDeleteList);
  }
}