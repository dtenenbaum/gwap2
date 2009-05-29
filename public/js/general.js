// This file contains Javascript that's loaded on every page.
// It was created by merging data from multiple js files, along
// with scripts that were hard-coded in TACOHeader.tt.

// Swap.js - start
var ExpandImage = 'expand.jpg';
var CollapseImage = 'collapse.jpg';

function GetTag(TagID) {
//returns a reference to the HTML element with ID = TagID
	var Ret=document.getElementById(TagID);
	if (!Ret) alert("GetTag: tag '"+TagID+"' does not exist.");
	return Ret;
}

function ToggleExpand(ExpandID, ImagePath) {
	var ExpandButton = GetTag(ExpandID + "_expand_button");
	var ShortHTML = GetTag(ExpandID + "_short_html");
	var LongHTML = GetTag(ExpandID + "_long_html");

	if (ShortHTML.style.display == "none") {
		ShortHTML.style.display = "";
		LongHTML.style.display = "none";
		ExpandButton.src = ImagePath+ExpandImage;
	} else {
		ShortHTML.style.display = "none";
		LongHTML.style.display = "";
		ExpandButton.src = ImagePath+CollapseImage;
	}
}

function ShowHide(ExpandID, SelectID, Value) {
	var ShortHTML = GetTag(ExpandID + "_short_html");
	var LongHTML = GetTag(ExpandID + "_long_html");
	var Select = document.getElementById(SelectID);
	if (!Select) alert("ShowHide: tag '"+SelectID+"' does not exist.");

	if (Select.options[Select.selectedIndex].value == Value) {
		ShortHTML.style.display = "none";
		LongHTML.style.display  = "";
		SetHiddenField(ExpandID,'true');
	} else {
		ShortHTML.style.display = "";
		LongHTML.style.display  = "none";
		SetHiddenField(ExpandID,'false');
	}
}

function SetHiddenField(FieldID, Value) {
	var HiddenField = document.getElementById(FieldID);
	HiddenField.value = Value;
}
// Swap.js - end

// popup.js - start
var newwindow = '';

function popup(URL,WindowLoc) {
//	if (!WindowLoc) { WindowLoc = 'height=200,width=400,top=500,left=700'; }
	if (!newwindow.closed && newwindow.location) {
		newwindow.location.href = URL;
	} else {
		newwindow = window.open(URL, '', WindowLoc);
		if (window.focus) {newwindow.focus()}
	}
	if (window.focus) { newwindow.focus() }
	return false;
}
// popup.js - end

// getCookie.js - start
function getCookie(name) {
	var dc = document.cookie;
	var prefix = name + "=";
	var begin = dc.indexOf("; " + prefix);
	if (begin == -1) {		 
		begin = dc.indexOf(prefix);
		if (begin != 0) {return null};
	} else {
		begin += 2;
	}
	var end = document.cookie.indexOf(";", begin);
	if (end == -1) {end = dc.length;}
	return unescape(dc.substring(begin + prefix.length, end));
}
// getCookie.js - end

// RewriteInnerHtml.js - start
function GetTag(TagID) {
	var Ret=document.getElementById(TagID);
	return Ret;
}
                                                                                                                                                             
function RewriteInnerHTML(TagID,NewInnerHTML) {
	GetTag(TagID).innerHTML=NewInnerHTML;
}
// RewriteInnerHtml.js - end

// Search code from TACOHeader.tt - start
function setFocus(FormName, ElementName) {
	document.getElementById(FormName).document.getElementById(ElementName).focus();
}
// Search code from TACOHeader.tt - end

// Login code from TACOHeader.tt - start
var keep_current=0;
var UsernameCookieValue = getCookie('username')

function pageOnClick() {
	if(keep_current!=1) {
		closeCurrent();
	}
}

function pageOnLoad(LogoutLink, LoginLink) {
	var login_text = '<img src="/images/icons/user.gif" hspace="3" align="bottom" alt="Logged In" />Logged in as ';
	var logout_text = '<a href="'+LogoutLink+'">Log Out</a>&nbsp;&nbsp;';
	var do_login_text = '<a href="'+LoginLink+'">Log In</a>&nbsp;&nbsp;';

	if (UsernameCookieValue && UsernameCookieValue!='nobody') {
		RewriteInnerHTML('login_username', login_text+' '+UsernameCookieValue+' '+logout_text);
	} else {
		RewriteInnerHTML('login_username', do_login_text);	
	}
}
// Login code from TACOHeader.tt - end

// popout_menu.js - start
var timerID;
var active_menu;

// Retrieves the div object from the id given
function getObject( obj ) {
  if ( document.getElementById ) {
	obj = document.getElementById( obj );
  } else if ( document.all ) {
	obj = document.all.item( obj );
  } else {
	obj = null;
  }
  return obj;
}

// Moves the div object to the mouse location and displays the div
function moveObject( obj, e ) {
  var tempX = 0;
  var tempY = 0;
  var yoffset = 5;
  var xoffset = 5;
  var objHolder = obj;

  // close other active menu
  if(active_menu) { 
  	clearTimeout(timerID);
  	closeCurrent();  	
  }
	
  obj = getObject( obj );
  if (obj==null) return;

  if (document.all) {
	tempX = event.clientX + document.body.scrollLeft;
	tempY = event.clientY + document.body.scrollTop;
  } else {
	tempX = e.pageX;
   tempY = e.pageY;
  }

  if (tempX < 0){tempX = 0}
  if (tempY < 0){tempY = 0}

  obj.style.top  = (tempY + yoffset) + 'px';
  obj.style.left = (tempX + xoffset) + 'px';

  displayObject( objHolder, true );
}

// Show or hide the div
function displayObject( obj, show ) {
  var objHolder = obj;

  obj = getObject( obj );
  if (obj==null) return;
  active_menu = obj;

  obj.style.display = show ? 'block' : 'none';
  obj.style.visibility = show ? 'visible' : 'hidden';
}

// Hide the div after 1 second
function delayClose() { 
  if(timerID) clearTimeout(timerID);
  timerID = setTimeout("closeCurrent()",1000);
}

// Stop the hide timer
function stopClose() {
  if(timerID) clearTimeout(timerID);
}

function closeCurrent() {
  obj = active_menu;
  if(obj) {
	obj.style.display = 'none';
	obj.style.visibility = 'hidden';
  }
}

function changeTooltip(obj, title, description) {
	obj = getObject( obj );
	if (obj===null) { return; }

	if (description.length > 55) {
		var description_array = description.split(" ");
		var desc_midpoint = parseInt(description_array.length/2, 10);
		var firstline = "";
		var secondline = "";
		for (var i = 0; i <= desc_midpoint; i++) {
			firstline += description_array[i]+' ';
		}
		for (i = desc_midpoint+1; i < description_array.length; i++) {
			secondline += description_array[i]+' ';
		}
		description = firstline+'<br >'+secondline;
	}

	obj.innerHTML = '<b>'+title+'</b><br />'+description;
}
// popout_menu.js - end

// expands a toggle section
function Expand(ExpandID, ImagePath) {
	var ExpandButton = GetTag(ExpandID + "_expand_button");
	var ShortHTML = GetTag(ExpandID + "_short_html");
	var LongHTML = GetTag(ExpandID + "_long_html");

	if (LongHTML.style.display == "none") {
		ShortHTML.style.display = "none";
		LongHTML.style.display = "";
		ExpandButton.src = ImagePath+CollapseImage;
	}

}

