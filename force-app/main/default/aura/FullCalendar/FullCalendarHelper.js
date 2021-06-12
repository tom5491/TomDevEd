({
    getResponse: function(component) {
        var action = component.get("c.getTasks");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("Data: \n" + result);
                var eventArr = [];
                result.forEach(function(key) {
                    eventArr.push({
                        'id':key.Id,
                        'start':key.Completed_Date__c,
                        'end':key.Completed_Date__c,
                        'title':key.Name
                    });
                });
                console.log(eventArr);
                this.loadCalendar(component, eventArr);
                
            } else if (state === "INCOMPLETE") {
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
        $A.enqueueAction(action);
    },
    
    loadCalendar :function(component, data){   
        //var m = moment();
        //document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = component.find('calendar').getElement();
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            events: data,
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay,listWeek'
            },
        
            //defaultDate: m.format(),
            editable: true,
            navLinks: true, // can click day/week names to navigate views
            weekNumbers: true,
            weekNumbersWithinDays: true,
            weekNumberCalculation: 'ISO',
            editable: true,
            eventLimit: true,
        });
        calendar.render();
    } 
})