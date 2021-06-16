({
    doInit: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.getFitbitData(component, helper);
        helper.getTodaySummary(component, helper);
        helper.getFriendsDetails(component, helper);
        helper.getmyBadges(component, helper);
        component.set("v.showSpinner", false);
    }
});
