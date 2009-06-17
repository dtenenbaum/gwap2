
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

var available_tags;


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
     
var enterDetect = function(elem, func) {
    jQuery(elem).keypress(function(e){
        var code = (e.keyCode ? e.keyCode : e.which);
         if(code == 13) { //Enter keycode 
             var search = this.value.trim();
             if (search == "") {
                 alert("You must enter some text to search on.");
                 jQuery(elem).focus();
                 return;
             }
             log("id = " + this.id);
             func();
        }
    });
}     

var addSearchBoxValueToCart = function(item) {
    addToCart(document.getElementById("tag_search_box").value);
}

var addToCart = function(item) {
    jQuery("#my_search").append("<li>" + item  + "</li>");
}
                  
var onSearchResultsLoaded = function() {
    jQuery("#check_all").click(function(){    
        jQuery(".experiment_checkbox").each(function(){
            this.checked = true;
        });
    });

    jQuery("#uncheck_all").click(function(){
        jQuery(".experiment_checkbox").each(function(){
            this.checked = false;
        });
    });
    
    jQuery("#tag_selected").click(function(){
            jQuery("#dialog").dialog({modal: true});//, 
//                buttons: {"Tag": function(){}, "Cancel", function(){}}
//            });
    });
}

jQuery(document).ready(function(){       
    jQuery('span.sf-menu').superfish();
                                              
    
    jQuery("#dialog").hide();

    

    log("setting up ajax event handlers");
    jQuery().ajaxError(function(event, request, settings){
      logAjaxEvent("#search_results", event, request, settings, "error");
    });
    
	
	// this is for the condition chooser box not the tag search box
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
             jQuery(".vis").empty();
             jQuery("#load_status").html("Loading...");     
             jQuery.get("search", {search : search, exps: exps}, function(data){    
                 jQuery("#load_status").empty();
                 jQuery("#search_results").html(data);
                 FG_fireDataEvent();
             });
         }
    });
    
    //autocomplete handler for tag search box
    jQuery("#tag_search_box").autocomplete(available_tags, {matchContains: true});
    
    jQuery("#tag_search_button").click(function(){
        addSearchBoxValueToCart();
    });
          
    jQuery("#clear_selections").click(function(){
        jQuery("#my_search").children().remove();
        jQuery("#top").focus();
    });
    
    jQuery().ajaxError(function(event, request, settings){
        log("AJAX ERROR!");
    });
               
    
    jQuery("#search_button").click(function(){ 
        var tags = "";
        var i = 0;
        jQuery("#my_search").children().each(function(item){
            tags += jQuery(this).html();
            tags += "##"
            log("added " + jQuery(this).html() + " at position " + i);
            i++;
        });      
        if (i == 0) {
            alert("Nothing to search for.");
            return;
        }                              
        jQuery("#inclusive_search_results").html("Loading...")
        
        
        jQuery.get("inclusive_search", {tags: tags}, function(data){
            jQuery("#inclusive_search_results").html(data);
        });
    });
    
    
    jQuery(".selected_menu_item").click(function(){  
        //log("before hide");
        //jQuery('#nav li.sfHover').hideSuperfishUl(jQuery('#nav')[o].o);
        //jQuery('#nav li.sfHover').hideSuperfishUl(jQuery(this));
        //jQuery(this).parent().parent().hideSuperfishUl();
        //jQuery(this).parents('li.sfHover').hideSuperfishUl(); 
        //jQuery('ul.sf-menu').hideSuperfishUl();
        //jQuery(this).find("ul").hide(); 
        //jQuery(this).hideSuperfishUl(); 
        //log("after hide");
        addToCart(jQuery(this).html());
        return false;
    });                        
    
    enterDetect("#tag_search_box", function(){ 
        addSearchBoxValueToCart();
    }); 
    
    jQuery("#clear_tag_search_box_button").click(function(){
        document.getElementById("tag_search_box").value = "";
        jQuery("#tag_search_box").focus();
     });    
     
     


});
