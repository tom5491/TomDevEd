({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchLookUpValues");
        // set param to method  
        console.log(getInputkeyWord);
        console.log(component.get("v.objectAPIName"));
        console.log(component.get("v.lstSelectedRecords"));
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'ExcludeitemsList' : component.get("v.lstSelectedRecords")
        });
        console.log('after setParams');
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('SUCCESS');
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                console.log('storeResponse.length ' + storeResponse.length);
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Records Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse); 
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    saveMethod : function(component, event, helper) {
        var action = component.get("c.saveMethod");
        console.log('component.get("v.recordId"): ' + component.get("v.recordId"));
        console.log('component.get("v.lstSelectedRecords"): ' + component.get("v.lstSelectedRecords"));
        action.setParams({
            'recordId': component.get("v.recordId"),
            'lstSelectedRecords' : component.get("v.lstSelectedRecords")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Failed",
                    "message": "The record has not been updated successfully."
                });
            }
            toastEvent.fire();
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    initMethod : function(component, event, helper) {
        var action = component.get("c.initMethod");
        console.log(component.get("v.recordId"));
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            //$A.util.removeClass(component.find("mySpinnerAll"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var respValue = response.getReturnValue();
                component.set("v.lstSelectedRecords", respValue);
            }
            $A.util.addClass(component.find("mySpinnerAll"), "slds-hide");
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    }
})