
netViewGlobals={
	showLoadingScreen : function(){
		$("nodatadiv").hide();
		$("datadiv").hide();
		$("loadingscreen").show();
	
	},
	
	showVis : function(){
		$("nodatadiv").hide();
		$("datadiv").show();
		$("loadingscreen").hide();
	},
	
	showNoData : function(){
		$("nodatadiv").show();
		$("datadiv").hide();
		$("loadingscreen").hide();
	},
	};