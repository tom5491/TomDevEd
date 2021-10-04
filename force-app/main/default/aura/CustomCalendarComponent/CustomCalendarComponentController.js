({
	doInit : function(component, event, helper) {
		helper.initMethod(component, event);
	},
    buttonPress: function(component, event, helper) {
        helper.buttonPress(component, event);
        //component.set('v.isModalOpen', true);
    },
    contentButton: function(component, event, helper) {
        helper.contentButton(component, event);
    }
})