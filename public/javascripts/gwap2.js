
// common functions


// this loads google vis for everyone, but it does set up the no-conflict state
google.load("visualization", "1", {packages:["imagesparkline","table","linechart"]});
google.load("prototype", "1.6");

google.setOnLoadCallback(googleVisInit);



jQuery.noConflict();  

var heatmap_options;  
var plot_options;
var heatmap;      
var heatmap_data;
var table;   
var plot; 
var network;    
var net_options;



function googleVisInit() {
    //heatmap_options = {cellWidth: 30, cellHeight: 30}; 
    /*
    startColor: {r:0, g:0, b:0, a:1},
                                      endColor: {r:255, g:0, b:0, a:1},
    */
    heatmap_options = {               cellHeight: 30, 
                                      cellWidth: 30,
                                      passThroughBlack:false, 
                                      hideHeaders: true, 
                                      drawBorder: false, 
                                      useCellLabels: false, 
                                      //useRowLabels: false,
                                      cellToolTips: "headers"};
                                      

    plot_options = {height:500,width:900};

    net_options = {layout:'ForceDirected',legend:'false',edgeRenderer:'multiedge'};    

	heatmap = new org.systemsbiology.visualization.BioHeatMap(document.getElementById("heatmap"));
	table = new google.visualization.Table(document.getElementById("table"));   
	plot = new google.visualization.LineChart(document.getElementById("plot"));
	network = new org.systemsbiology.visualization.BioNetwork(document.getElementById("network"));  
	
	google.visualization.events.addListener(heatmap, 'select', function() {
	    //heatmap.getSelection()
		var obj = heatmap.getSelection();
		var me = obj[0];
		/*
		log("rows x cols = " + me['row'] + " x " + me['col']);
		log("heatmap value is " + heatmap_data.getValue(me['row'],me['col'])); 
		log("column label = " + heatmap_data.getColumnLabel(me['col']));
		log("row label = " + heatmap_data.getValue(me['row'],0));
		*/
		jQuery("#heatmap_info").html("Gene: " + heatmap_data.getValue(me['row'],0) + "<br/>"  +
		    "Condition: " + heatmap_data.getColumnLabel(me['col']) + "<br/>" + 
		    "Value: " + heatmap_data.getValue(me['row'],me['col']) + "<br/>");
	    
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

function FG_fireDataEvent() {
  // events are documented in the Flanagan Javascript book
  var ev = document.createEvent("Events");
  // initEvent(eventType, canBubble, cancelable)
  ev.initEvent("gaggleDataEvent", true, false); 
  document.dispatchEvent(ev);
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
 
String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g,"");
}
String.prototype.ltrim = function() {
	return this.replace(/^\s+/,"");
}
String.prototype.rtrim = function() {
	return this.replace(/\s+$/,"");
}                                                       

function logAjaxEvent(element, event, request, settings, status) {
    if (status == "error") {
        jQuery(element).html("<font color='red'>Error receiving data from remote server.</font>");
    }
    log("ajax event information:");
    log("event: " + event);
    log("request: " + request);
    log("settings: " + settings);
    log("status: " + status);
}

jQuery(document).ready(function(){       
    
    jQuery('span.sf-menu').superfish();

    log("setting up ajax event handlers");
    jQuery().ajaxError(function(event, request, settings){
      logAjaxEvent("#search_results", event, request, settings, "error");
    });
    
/*
    jQuery().ajaxComplete(function(event, request, settings){
      logAjaxEvent("#search_results", event, request, settings, "complete");
    });
    log("done setting up ajax event handlers");
*/
	
    jQuery(".search_box").keypress(function(e){
        var code = (e.keyCode ? e.keyCode : e.which);
         if(code == 13) { //Enter keycode 
             var search = this.value.trim();
             if (search == "") {
                 alert("You must enter some text to search on.");
                 jQuery(this).focus();
                 return;
             }
             log("id = " + this.id);
             var segs = this.id.split("_");
             var exps = segs[segs.length -1];   
             jQuery("#search_results").empty();
             jQuery("#search_results").html("Loading...");     
             jQuery.get("search", {search : search, exps: exps}, function(data){
                 jQuery("#search_results").html(data);
                 FG_fireDataEvent();
             });
         }
    });
    
    jQuery(".clear_search").click(function(){
        log("clear search pressed");
        jQuery("#search_results").html("");
    });
    
});
