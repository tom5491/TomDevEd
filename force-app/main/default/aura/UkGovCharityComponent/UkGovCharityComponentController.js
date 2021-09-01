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
    init: function (component, event, helper) {
        helper.getAccountDetails(component, event);
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
        pageNumber++;
        if (pageNumber == 0) {
            var modalContainer = component.find("modalContainer");
            $A.util.removeClass(modalContainer, "largeModal");
        }

        component.set("v.pageNumber", pageNumber - 1);
    },

    nextPage: function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        if (pageNumber == 0) {
            var modalContainer = component.find('modalContainer');
            $A.util.addClass(modalContainer, "largeModal");

            helper.doCallout(component, event).then(function (result) {
                console.log("Call 1 : ", result);

                component.set("v.pageNumber", pageNumber + 1);
            });
        } else {
            component.set("v.pageNumber", pageNumber + 1);
        }
    },

    submit: function (component, event, helper) {
        component.set("v.charityInfo", "[]");
    }
});
