/**
 * @description       : 
 * @author            : Tom Philippou
 * @group             : 
 * @last modified on  : 27-08-2021
 * @last modified by  : Tom Philippou 
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   27-08-2021   Tom Philippou   Initial Version
**/
({
    doInit: function (component, event, helper) {
        var option1 = component.get("v.option1");
        var option2 = component.get("v.option2");

        var options = [
            { label: option1, value: false },
            { label: option2, value: true }
        ];
    },

    onchange: function (component, event, helper) {
        var eventSource = event.getSource();
        var buttonName = eventSource.getLocalId();
        if (buttonName == "option1") {
            component.set("v.option2Value", "");
        } else {
            component.set("v.option1Value", "");
        }
    }
});