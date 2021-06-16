({
    initMethod: function(component, event, helper) {
        var action = component.get('c.initialMethod');
        
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                //set response value in wrapperList attribute on component.
                component.set('v.dateList', resp.dateList);
                component.set('v.currentDate', resp.currentDate);
                component.set('v.monthName', resp.monthName);
            }
        });
        $A.enqueueAction(action);
    },
    buttonPress: function(component, event, helper) {
        var action = component.get('c.changeMonthMethod');
        var direction = event.getSource().get("v.name");
        var currentDate = component.get("v.currentDate");
        
        action.setParams({
            "direction" : direction,
            "currentDate" : currentDate
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                //set response value in wrapperList attribute on component.
                component.set('v.dateList', resp.dateList);
                component.set('v.currentDate', resp.currentDate);
                component.set('v.monthName', resp.monthName);
            }
        });
        $A.enqueueAction(action);
    },
    contentButton: function(component, event, helper) {
    	
    }
})