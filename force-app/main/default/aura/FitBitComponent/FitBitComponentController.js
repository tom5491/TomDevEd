({
    doInit: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.getFitbitData(component, helper);
        helper.getTodaySummary(component, helper);
        helper.getFriendsDetails(component, helper);
        helper.getmyBadges(component, helper);
        helper.getStepData(component, helper);
        component.set("v.showSpinner", false);
    },
    getChartData: function (component, event, helper) {
        var timePeriod = event.currentTarget.id;
        if (timePeriod === "todaySteps") {
        }
    },
    createGraph: function (component, jsonResp, financialYear) {
        var chart = Highcharts.stockChart("container", {
            rangeSelector: {
                selected: 1
            },

            title: {
                text: "AAPL Stock Price"
            },

            series: [
                {
                    name: "AAPL",
                    data: data,
                    tooltip: {
                        valueDecimals: 2
                    }
                }
            ]
        });
    }
});