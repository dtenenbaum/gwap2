function removeGene(GeneID) {
	document.tool_view.remove_gene_id.value=GeneID;
	document.tool_view.submit();
}

function submitCorrections() {
	//local variables
	var unambiguouslist = document.tool_view.non_ambiguous.value;
	var termscount = document.tool_view.ambiguous_count.value;
	
	//local functions
	var apend = function(string1, string2)
	{
		if(string1!=""){ string1 += ",";}
		return string1 + string2;
	}
	
	//currently only works for Gene_ids?
	var checkedlist = document.tool_view["Gene_id"];
	
	if(checkedlist.length)
	{
		for(var j = 0; j < checkedlist.length; j++)
		{
			
			if(checkedlist[j].checked)
			{
				unambiguouslist = apend(unambiguouslist,checkedlist[j].value);
				
				//break;
			}
		}
	}
	else
	{
		if(checkedlist.checked)
		{
			unambiguouslist = apend(unambiguouslist,checkedlist.value);
		}
	}	
		

	$("temp_folder_id").remove();
	var currentElement = document.createElement("input");
	currentElement.setAttribute("type", "hidden");
	currentElement.setAttribute("name", "gene_id");
	currentElement.setAttribute("id", "gene_id");
	currentElement.setAttribute("value", unambiguouslist);
	document.tool_view.appendChild(currentElement);
	document.tool_view.submit();
}

function show_ambigeous(){
		$('ambiguous_terms').show();
		$('ambiguous_warning').hide();
	}
