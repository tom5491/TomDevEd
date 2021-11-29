/**
 * @description       :
 * @author            : Tom Philippou
 * @last modified on  : 17-09-2021
 * @last modified by  : Tom Philippou
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   25-08-2021   Tom Philippou   Initial Version
 **/
({
    init: function (component, event, helper) {
        helper.getAccountData(component, event);
    },

    searchCommit: function (component, event, helper) {
        var charityName = component.get("v.charityName");

        if (charityName != null) {
            helper.doCallout(component, event);
        }
    },

    search: function (component, event, helper) {
        helper.doCallout(component, event);
    },

    clearSearch: function (component, event, helper) {
        component.set("v.charityInfo", "[]");
    },

    previousPage: function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.disableNext", false);

        component.set("v.pageNumber", pageNumber - 1);

        if (pageNumber == 3) {
            var tableData = component.get("v.tableData");
            if (tableData.length == 0) {
                component.set("v.pageNumber", 1);
            } else {
                component.set("v.pageNumber", 2);
            }
        } else {
            component.set("v.pageNumber", pageNumber - 1);
        }
    },

    nextPage: function (component, event, helper) {
        // component.set("v.disableNext", true);
        var pageNumber = component.get("v.pageNumber");

        if (pageNumber == 1) {
            component.set("v.disableNext", true);
            helper.searchForCharities(component, event, helper);
        }
        if (pageNumber == 2) {
            var selectedCharityList = component.find("charityDataTable").getSelectedRows();
            if (selectedCharityList != null && selectedCharityList.length != 0) {
                component.set("v.disableNext", true);
                component.set("v.selectedRow", selectedCharityList[0]);

                var account = component.get("v.currentAccount");

                account.Charity_Number__c = selectedCharityList[0].reg_charity_number.toString();
                account.Charity_Suffix__c = selectedCharityList[0].group_subsid_suffix.toString();
                component.set("v.currentAccount", account);

                console.log("account String: " + JSON.stringify(account));

                var returnedRow = component.get("v.selectedRow");
                console.log("returnedRow: " + JSON.stringify(returnedRow));

                helper.searchForAllCharityData(component, event, helper);
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    mode: "dismissible",
                    message: "Please select a Charity before pressing next.",
                    type: "error"
                });
                toastEvent.fire();
            }
        }
        if (pageNumber == 3) {
            component.set("v.disableNext", true);
            helper.getChangedFields(component, event);
        }
    },

    submit: function (component, event, helper) {
        component.set("v.charityInfo", "[]");
    },

    closeModal: function (component, event, helper) {
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
});