google.load("visualization", "1", {packages:["linechart","imagesparkline"]});
google.load("prototype", "1.6");

jQuery.noConflict();  

google.setOnLoadCallback(setup);

function setup() {                          
    var clickee;
    
    jQuery(".exp").click(function(){
       clickee = this;
       log("ok");
       log("html = " + jQuery(this).html());
       jQuery.get("/main/get_cond/" + jQuery(this).html(), function(data){
          log("got data" + data);  
          jQuery(data).appendTo(clickee);
       });
    });
    
    jQuery(".add_tag_to_experiment").focus();
    
    jQuery(".add_tag_to_experiment").keypress(function(e){
        var code = (e.keyCode ? e.keyCode : e.which);
         if(code == 13) { //Enter keycode  
           var tag = this.value;
           var id = jQuery(this).attr("id");
           var segs = id.split("_");
           var exp_id = segs[segs.length -1];
           log("value = " + this.value);
           var inputbox = this;
           jQuery.get("../add_experiment_tag/" + exp_id, {tag: this.value}, function(data){
               inputbox.value = "";
               log("ok, got data: " + data);
               jQuery("#experiment_tags").html(data);
           });
         }
    });
    
}





var fb_lite = false;
try {
	if (firebug) {
		fb_lite = true;  
		firebug.d.console.cmd.log("initializing firebug logging");
	}
} catch(e) {
	// do nothing
}



function log(message) {
	//if (typeof(window['console']) != 'undefined') {
	if (fb_lite) {  
		console.log(message);
		/*
		try {
			firebug.d.console.cmd.log(message);  
		} catch (e) {
			//alert("oops");
		} 
		*/
	} else {
		if (window.console) {
			console.log(message);
		} 
	}
}                          
