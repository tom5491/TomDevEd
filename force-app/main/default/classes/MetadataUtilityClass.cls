/**
 * @description       :
 * @author            : Tom Philippou
 * @last modified on  : 17-05-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 0.1   24-04-2021   Tom Philippou   Initial Version
 **/
public class MetadataUtilityClass {
    /*public static void testGetReportDateFilters() {
        MetadataService.MetadataPort service = createService();

        service.
    }*/

    public static void buildCustomMetadata(Map<String, String> fieldMap, String label, String description, String operation) {
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomMetadata customMetadata = new MetadataService.CustomMetadata();
        customMetadata.fullName = 'Record_Search_Setting__mdt.' + label.replace(' ', '_');
        customMetadata.label = label;
        customMetadata.description = description;
        customMetadata.protected_x = false;

        List<MetadataService.CustomMetadataValue> mdtFieldValues = new List<MetadataService.CustomMetadataValue>();

        for (String key : fieldMap.keySet()) {
            MetadataService.CustomMetadataValue customField = new MetadataService.CustomMetadataValue();
            customField.field = key;
            customField.value = fieldMap.get(key);

            mdtFieldValues.add(customField);
        }

        customMetadata.values = mdtFieldValues;

        if (operation == 'insert') {
            List<MetadataService.SaveResult> results = service.createMetadata(new List<MetadataService.Metadata>{ customMetadata });
            handleSaveResults(results[0]);
        } else if (operation == 'update') {
            List<MetadataService.SaveResult> results = service.updateMetadata(new List<MetadataService.Metadata>{ customMetadata });
            handleSaveResults(results[0]);
        }
    }

    public static void deleteCustomMetadata(String recordToDelete) {
        MetadataService.MetadataPort service = createService();
        List<MetadataService.DeleteResult> results = service.deleteMetadata(
            'CustomMetadata',
            new List<String>{ 'Record_Search_Setting__mdt.' + recordToDelete }
        );
        handleDeleteResults(results[0]);
    }

    public class MetadataServiceExamplesException extends Exception {
    }

    /**
     * Example helper method to interpret a SaveResult, throws an exception if errors are found
     **/
    public static void handleSaveResults(MetadataService.SaveResult saveResult) {
        // Nothing to see?
        if (saveResult == null || saveResult.success) {
            return;
        }
        // Construct error message and throw an exception
        if (saveResult.errors != null) {
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size() == 1 ? 'Error ' : 'Errors ') +
                'occured processing component ' +
                saveResult.fullName +
                '.'
            );
            for (MetadataService.Error error : saveResult.errors) {
                messages.add(
                    error.message +
                    ' (' +
                    error.statusCode +
                    ').' +
                    (error.fields != null && error.fields.size() > 0 ? ' Fields ' + String.join(error.fields, ',') + '.' : '')
                );
            }
            if (messages.size() > 0) {
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
            }
        }
        if (!saveResult.success) {
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
        }
    }

    /**
     * Example helper method to interpret a SaveResult, throws an exception if errors are found
     **/
    public static void handleDeleteResults(MetadataService.DeleteResult deleteResult) {
        // Nothing to see?
        if (deleteResult == null || deleteResult.success) {
            return;
        }
        // Construct error message and throw an exception
        if (deleteResult.errors != null) {
            List<String> messages = new List<String>();
            messages.add(
                (deleteResult.errors.size() == 1 ? 'Error ' : 'Errors ') +
                'occured processing component ' +
                deleteResult.fullName +
                '.'
            );
            for (MetadataService.Error error : deleteResult.errors) {
                messages.add(
                    error.message +
                    ' (' +
                    error.statusCode +
                    ').' +
                    (error.fields != null && error.fields.size() > 0 ? ' Fields ' + String.join(error.fields, ',') + '.' : '')
                );
            }
            if (messages.size() > 0) {
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
            }
        }
        if (!deleteResult.success) {
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
        }
    }

    /**
     * Example helper method to interpret a UpsertResult, throws an exception if errors are found
     **/
    public static void handleUpsertResults(MetadataService.UpsertResult upsertResult) {
        // Nothing to see?
        if (upsertResult == null || upsertResult.success) {
            return;
        }
        // Construct error message and throw an exception
        if (upsertResult.errors != null) {
            List<String> messages = new List<String>();
            messages.add(
                (upsertResult.errors.size() == 1 ? 'Error ' : 'Errors ') +
                'occured processing component ' +
                upsertResult.fullName +
                '.'
            );
            for (MetadataService.Error error : upsertResult.errors) {
                messages.add(
                    error.message +
                    ' (' +
                    error.statusCode +
                    ').' +
                    (error.fields != null && error.fields.size() > 0 ? ' Fields ' + String.join(error.fields, ',') + '.' : '')
                );
            }
            if (messages.size() > 0) {
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
            }
        }
        if (!upsertResult.success) {
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
        }
    }

    public static MetadataService.MetadataPort createService() {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
}