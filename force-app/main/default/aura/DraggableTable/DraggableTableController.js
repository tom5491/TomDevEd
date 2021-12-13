({
    initMethod : function(component, event, helper) {
        // alert("jQuery loaded");
    },
    drag : function(component, event) {
        event.dataTransfer.setData("text", event.target.id);
      },

      allowDrop : function(component, event) {
        event.preventDefault();
      },

      drop : function(component, event) {
            event.preventDefault();
            console.log("event.target.id: " + event.target.id);
            var divCount = $("#"+event.target.id).children("div").length;
            console.log("divCount: " + divCount);
            
            var _target = $("#" + event.target.id);
            var nodrop = $(_target).hasClass("nodrop");
            console.log("nodrop: " + nodrop);
            if (nodrop || divCount >= 1) {
                event.preventDefault();
                alert("There is already value for this cell");
            } else {
                var data = event.dataTransfer.getData("text");
                event.target.appendChild(document.getElementById(data));     
            }
            
    }
})
