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
