
jQuery(document).ready(function(){
    
    jQuery("#tag").focus();

    jQuery("#select_all").click(function(){
        jQuery(":checkbox").each(function(){
            this.checked = true;
        });
        jQuery("#tag").focus();
    });                                    
    
    jQuery("#clear_selections").click(function(){
        jQuery(":checkbox").each(function(){
            this.checked = false;
        });
        jQuery("#tag").focus();
    });                                    
    
    
    jQuery("#tag").keypress(function(e){
        var code = (e.keyCode ? e.keyCode : e.which);
         if(code == 13) { //Enter keycode 
             var anythingChecked = false;
             jQuery(":checkbox").each(function(){
                 if (this.checked) {
                     anythingChecked = true;
                 }
             });
             if (anythingChecked == false) {
                 alert("You must check some experiments to tag.");
                 return;
             }
             var tag = this.value.trim();
             if (tag == "") {
                 alert("You must enter some text in the tag box.");
                 return;
             }
             this.value = "";
             var exps = "";
             jQuery(":checkbox").each(function(){
                 if (this.checked) {
                     exps += this.value;
                     exps += ",";
                 }
             });        
             var data = {ids: exps, tag: tag, url: location.href}
             // BAD HARDCODING TODO FIX
             var options = {type: "GET", url: "/main/tag_exps", data: data, dataType: "script",
                success: function(data, textStatus){
                    log("in success function");
                    //log("data = " + data + "\nstatus =" + textStatus);
                }, error: function (XMLHttpRequest, textStatus, errorThrown){
                    log("in error function");      
                    log("textStatus = " + textStatus);
                    log("errorThrown = " + errorThrown);
                }};
             jQuery.ajax(options);
             /*
             jQuery.get("../tag_exps", {ids: exps, tag: tag, oldtags: location.search}, function(data){
                log("data = " + data);
                jQuery("#remaining_tags").html(data);
             });
             */
         }
    });
});