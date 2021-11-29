/**
 * @description       :
 * @author            : Tom Philippou
 * @last modified on  : 24-09-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   25-08-2021   Tom Philippou   Initial Version
 **/
({
    getAccountData: function (component, event) {
        var action = component.get("c.getRecordData");

        var recordId = component.get("v.recordId");

        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Entered getAccountData success");
                var resp = response.getReturnValue();
                console.log("resp: " + response.getReturnValue());

                if (resp.account.Charity_Number__c != null && resp.account.Charity_Suffix__c != null) {
                    component.set("v.data", resp.radioEntryList);
                    console.log("resp.RadioEntryList: " + resp.radioEntryList);
                    component.set("v.pageNumber", 3);
                } else {
                    console.log("resp.account.Charity_Number__c: " + resp.account.Charity_Number__c);
                    console.log("resp.account.Charity_Suffix__c: " + resp.account.Charity_Suffix__c);
                    component.set("v.pageNumber", 1);
                }

                console.log("init account: " + JSON.stringify(resp.account));

                component.set("v.currentAccount", resp.account);
            } else if (state === "INCOMPLETE") {
                // do stuff
            } else if (state === "ERROR") {
                throw new Error("Error: Please contact your Salesforce Administrator.");
            }
        });
        $A.enqueueAction(action);
    },

    getChangedFields: function (component, event) {
        component.set("v.showSpinner", true);
        var fieldMap = component.get("v.fieldMap");

        var name = document.querySelector('input[name="NAME"]:checked').value;
        fieldMap["Name"] = name;
        var othernames = document.querySelector('input[name="OTHER NAMES"]:checked').value;
        fieldMap["Other_Names"] = othernames;
        var website = document.querySelector('input[name="WEBSITE"]:checked').value;
        fieldMap["Website"] = website;
        var charityRegCoNumber = document.querySelector('input[name="CHARITY REG CO. NUMBER"]:checked').value;
        fieldMap["Charity_Reg_Co_Number"] = charityRegCoNumber;
        var dateOfReg = document.querySelector('input[name="DATE OF REGISTRATION"]:checked').value;
        fieldMap["Date_of_Registration"] = dateOfReg;
        var charitableObj = document.querySelector('input[name="CHARITABLE OBJECT"]:checked').value;
        fieldMap["Charitable_Object"] = charitableObj;
        var email = document.querySelector('input[name="EMAIL"]:checked').value;
        fieldMap["Email"] = email;
        var charityType = document.querySelector('input[name="CHARITY TYPE"]:checked').value;
        fieldMap["Charity_Type"] = charityType;
        var income = document.querySelector('input[name="INCOME"]:checked').value;
        fieldMap["Income"] = income;
        var yearEnd = document.querySelector('input[name="REPORTING PERIOD YEAR END"]:checked').value;
        fieldMap["Reporting_Period_Year_End"] = yearEnd;
        var trustees = document.querySelector('input[name="TRUSTEES"]:checked').value;
        fieldMap["Trustees"] = trustees;
        var dateOfRemoval = document.querySelector('input[name="DATE OF REMOVAL"]:checked').value;
        fieldMap["Date_of_Removal"] = dateOfRemoval;
        var regStatus = document.querySelector('input[name="REGISTRATION STATUS"]:checked').value;
        fieldMap["Registration_Status"] = regStatus;
        var phone = document.querySelector('input[name="PHONE"]:checked').value;
        fieldMap["Phone"] = phone;

        console.log("fieldMap: " + JSON.stringify(fieldMap));
        console.log("Name: " + name);
        console.log("website: " + website);

        var action = component.get("c.updateCharityFields");
        var recordId = component.get("v.recordId");

        action.setParams({
            recordId: recordId,
            fieldMap: fieldMap
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Entered updateCharityFields success");
                var resp = response.getReturnValue();

                component.set("v.isSuccess", resp.isSuccess);
                component.set("v.fieldUpdateList", resp.fieldsToUpdate);
                component.set("v.pageNumber", 4);

                $A.get("e.force:refreshView").fire();
            } else if (state === "INCOMPLETE") {
                // do stuff
            } else if (state === "ERROR") {
                throw new Error("Error: Please contact your Salesforce Administrator.");
            }

            component.set("v.disableNext", false);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    searchForCharities: function (component, event, helper) {
        try {
            component.set("v.showSpinner", true);

            var action = component.get("c.getSearchByNameCallout");

            // var selectedValue = component.get("v.selectedValue");
            var parameter = component.get("v.currentAccount.Name");
            console.log("parameter: " + parameter);

            action.setParams({
                parameter: parameter
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("Entered doCallout success");
                    var resp = response.getReturnValue();
                    var tableData = JSON.parse(resp.result);
                    tableData.forEach(function (item) {
                        item.id = item.reg_charity_number + "-" + item.group_subsid_suffix;
                        item.reg_status = item.reg_status == "R" ? "Registered" : "Removed";
                    });

                    console.log("resp: " + resp);
                    component.set("v.tableData", tableData);
                    if (tableData.length == 0) {
                        component.set("v.disableNext", true);
                    }
                    component.set("v.columns", [
                        { label: "Name", fieldName: "charity_name", type: "text" },
                        { label: "Registration Number", fieldName: "id", type: "text" },
                        { label: "Registration Date", fieldName: "date_of_registration", type: "date" },
                        { label: "Registration Status", fieldName: "reg_status", type: "text" }
                    ]);
                    component.set("v.pageNumber", 2);
                    component.set("v.showSpinner", false);

                    if (resp.length != 0) {
                        var message = "Charity details have been retrieved.";
                        var toastEvent = $A.get("e.force:showToast");
                        console.log("message: " + message);
                        toastEvent.setParams({
                            title: "Charity Found!",
                            mode: "dismissible",
                            message: message,
                            type: "success"
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
                        console.log(message);

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
                }

                //helper.fireToastHelper("Error!", message, "error");
                component.set("v.disableNext", false);
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log("Error line number: " + e.lineNumber);
            console.log("Error line number: " + e.message);
        }
    },

    searchForAllCharityData: function (component, event, helper) {
        try {
            component.set("v.showSpinner", true);

            var action = component.get("c.getAllCharityDataCallout");

            var account = JSON.stringify(component.get("v.currentAccount"));

            action.setParams({
                accountString: account
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("Entered doCallout success");
                    var resp = response.getReturnValue();
                    // console.log("resp: " + resp);

                    // var parsedResp = JSON.parse(resp);

                    component.set("v.data", resp.radioEntryList);
                    console.log("resp.RadioEntryList: " + resp.radioEntryList);
                    component.set("v.pageNumber", 3);
                    // component.set("v.disableNext", false);

                    component.set("v.showSpinner", false);

                    // if (resp.length != 0) {
                    var message = "Charity details have been retrieved.";
                    var toastEvent = $A.get("e.force:showToast");
                    console.log("message: " + message);
                    toastEvent.setParams({
                        title: "Charity Found!",
                        mode: "dismissible",
                        message: message,
                        type: "success"
                    });
                    toastEvent.fire();

                    // }
                    // else {
                    //     var message = "Charity details have not been found for this Registered Number.";
                    //     reject();
                    //     var toastEvent = $A.get("e.force:showToast");
                    //     console.log("message: " + message);
                    //     toastEvent.setParams({
                    //         title: "No Charity Found!",
                    //         mode: "dismissible",
                    //         message: message,
                    //         type: "error"
                    //     });
                    //     toastEvent.fire();
                    // }
                } else if (state === "INCOMPLETE") {
                    // do stuff
                } else if (state === "ERROR") {
                    let errors = response.getError();
                    let message = "Unknown error"; // Default error message
                    // Retrieve the error message sent by the server
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message = "The following error has occurred: " + errors[0].message;
                        console.log(message);

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
                }

                //helper.fireToastHelper("Error!", message, "error");

                component.set("v.disableNext", false);
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        } catch (e) {
            console.log("Error line number: " + e.lineNumber);
            console.log("Error line number: " + e.message);
        }
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