/**
 * @description       :
 * @author            : Tom Philippou
 * @group             :
 * @last modified on  : 27-08-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   25-08-2021   Tom Philippou   Initial Version
 **/
({
    getAccountDetails: function (component, event) {
        component.set("v.showSpinner", true);

        component.set("v.columns", [
            { label: "Name", fieldName: "Name", type: "text" },
            { label: "Organisation Number", fieldName: "Organisation_Number__c", type: "text" },
            { label: "Registration Number", fieldName: "Registration_Number__c", type: "text" },
            { label: "Registration Status", fieldName: "Registration_Status__c", type: "text" }
        ]);

        var recordId = component.get("v.recordId");

        var action = component.get("c.getRecordData");

        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Entered ... success");
                var resp = response.getReturnValue();

                component.set("v.currentAccount", resp);
            } else if (state === "INCOMPLETE") {
                // do stuff
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = "Unknown error"; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }

                //this.fireToastHelper("Error!", message, "error");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    doCallout: function (component, event, helper) {
        var p = new Promise(
            $A.getCallback(function (resolve, reject) {
                try {
                    component.set("v.showSpinner", true);

                    var action = component.get("c.fetchCharities");

                    var selectedValue = component.get("v.selectedValue");
                    var parameter;

                    // if (selectedValue == "allcharitydetails") {
                    //     var registeredNumber = component.get("v.registeredNumber");
                    //     var suffix = component.get("v.suffix");
                    //     parameter = registeredNumber + "/" + suffix;
                    // } else if (selectedValue == "searchCharityName") {
                    parameter = component.get("v.currentAccount.Name");
                    console.log("parameter: " + parameter);
                    // }

                    action.setParams({
                        parameter: parameter,
                        apiService: selectedValue
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            console.log("Entered doCallout success");
                            var resp = response.getReturnValue();

                            component.set("v.charityList", resp.resultList);
                            component.set("v.isSuccess", resp.success);

                            component.set("v.showSpinner", false);

                            if (resp.success) {
                                var message = "Charity details have been retrieved.";
                                resolve(response.getReturnValue());
                                var toastEvent = $A.get("e.force:showToast");
                                console.log("message: " + message);
                                toastEvent.setParams({
                                    title: "Charity Found!",
                                    mode: "dismissible",
                                    message: message,
                                    type: "success"
                                });
                                toastEvent.fire();
                            } else {
                                var message = "Charity details have not been found for this Registered Number.";
                                reject();
                                var toastEvent = $A.get("e.force:showToast");
                                console.log("message: " + message);
                                toastEvent.setParams({
                                    title: "No Charity Found!",
                                    mode: "dismissible",
                                    message: message,
                                    type: "error"
                                });
                                toastEvent.fire();
                            }
                        } else if (state === "INCOMPLETE") {
                            // do stuff
                        } else if (state === "ERROR") {
                            let errors = response.getError();
                            let message = "Unknown error"; // Default error message
                            // Retrieve the error message sent by the server
                            if (errors && Array.isArray(errors) && errors.length > 0) {
                                message = errors[0].message;
                                console.log("Error is: " + message);
                            }

                            //helper.fireToastHelper("Error!", message, "error");
                        }
                        component.set("v.showSpinner", false);
                    });
                    $A.enqueueAction(action);
                } catch (e) {
                    console.log("Error line number: " + e.lineNumber);
                    console.log("Error line number: " + e.message);
                }
            })
        );
        return p;
    },
    fireToastHelper: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        console.log("message: " + message);
        toastEvent.setParams({
            title: title,
            mode: "dismissible",
            message: message,
            type: type
        });
        toastEvent.fire();
    }
});
