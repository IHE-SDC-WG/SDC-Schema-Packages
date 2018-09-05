<?xml version="1.0" encoding="us-ascii"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2018_08_17" xmlns:sr="http://www.cap.org/pert/2009/01/"
	xmlns:x="urn:ihe:qrph:sdc:2016">
	
  <xsl:output encoding="us-ascii" method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  
  
	<xsl:variable name="show-toc" select="'false'"/>
	<xsl:variable name="debug" select="'false'"/>

	<!-- new code -->
	<xsl:variable name="metadata-display" select="'true'"/>
	<xsl:variable name="change-display" select="'true'"/>
	
	<xsl:template match="/">
		
		<xsl:variable name ="required" select="string(//Header/Property[@type='web_posting_date meta']/@val)"/>
        <html>
            <head>
			<!-- <h3>HELLO</h3> -->
			<!-- <div> HELLO </div> -->
		    
			<title><xsl:value-of select="//x:Header/@title"/></title>
			
			<!--<link rel="stylesheet" href="Transforms/working/sdctemplate.css" type="text/css" />-->
			<!--<link rel="stylesheet" href="sdctemplate.css" type="text/css" />-->
			
            <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
			<!--<script type="text/javascript" src="sdctemplate.js"></script>-->
			
			
			<script type="text/javascript">
			
			$(document).ready(function () {	
				$('.mustImplement').parent().toggle();
			
			    var toggle_all = true;
				$(".collapse_all_control").click(function(){
					$(".collapsable_q").each(function(){
					    if ($(this).siblings().is( ":visible" ) &amp;&amp; toggle_all === true) {
						   $(this).siblings().toggle(false);
						   $(this).toggleClass("Question collapsed_q");
						} else if (!$(this).siblings().is( ":visible" ) &amp;&amp; toggle_all === false) {
						   $(this).siblings().toggle(true);
						   $(this).toggleClass("Question collapsed_q");
						}
					});
					
					$(".collapsable").each(function(){
						if ($(this).siblings().is( ":visible" ) &amp;&amp; toggle_all === true) {
							$(this).siblings().toggle(false);
							$(this).toggleClass("HeaderGroup collapsed");
						} else if (!$(this).siblings().is( ":visible" ) &amp;&amp; toggle_all === false) {
							$(this).siblings().toggle(true);
							$(this).toggleClass("HeaderGroup collapsed");
						}
					});
					
					if (toggle_all) {
					    toggle_all = false;
					} else {
					    toggle_all = true;
					}
				});
				
				$(".collapsable").click(function(){
					$(this).siblings().toggle();
					$(this).toggleClass("HeaderGroup collapsed");									
				});	
				
				var toggle_section = true;
				$(".collapse_control").click(function(){
					$(".collapsable").each(function(){
						if ($(this).siblings().is( ":visible" ) &amp;&amp; toggle_section === true) {
							$(this).siblings().toggle(false);
							$(this).toggleClass("HeaderGroup collapsed");
						} else if (!$(this).siblings().is( ":visible" ) &amp;&amp; toggle_section === false) {
							$(this).siblings().toggle(true);
							$(this).toggleClass("HeaderGroup collapsed");
						}
					});
					
					if (toggle_section) {
					    toggle_section = false;
					} else {
					    toggle_section = true;
					}
				});
				
				var toggle_question  = true;
				$(".collapse_q_control").click(function(){
					$(".collapsable_q").each(function(){
					    if ($(this).siblings().is( ":visible" ) &amp;&amp; toggle_question === true) {
						   $(this).siblings().toggle(false);
						   $(this).toggleClass("Question collapsed_q");
						} else if (!$(this).siblings().is( ":visible" ) &amp;&amp; toggle_question === false) {
						   $(this).siblings().toggle(true);
						   $(this).toggleClass("Question collapsed_q");
						}
					});
					
					if (toggle_question)
					    toggle_question = false;
				    else
					    toggle_question = true;
				});
				
				//support toggle - sections
				$(".collapsable").click(function(){
					$(this).siblings().toggle();
					$(this).toggleClass("HeaderGroup collapsed");									
				});	

				// support toggle - questions
				$(".collapsable_q").click(function(){
					$(this).siblings().toggle();
					$(this).toggleClass("Question collapsed_q");									
				});	
			});
			
					<xsl:text disable-output-escaping="yes" >
						<![CDATA[
						
							$(document).ready(function () {
							
								//link CSS based on whether runing from disk or from server
								
								if (window.location.protocol=='file:')
								{
									//$('<script type="text/javascript" src="sdctemplate.js"/>').appendTo('head');
									$('<link type="text/css" rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>').appendTo('head');
									$("<link rel='stylesheet' href='sdctemplate.css' type='text/css' />").appendTo('head');
									
								}
								else{
									//$('<script type="text/javascript" src="Transforms/working/sdctemplate.js"/>').appendTo('head');
									$("<link rel='stylesheet' href='Transforms/working/sdctemplate.css' type='text/css' />").appendTo('head');
								}
								
								})
								
								
var xmlDoc;
var repeatIndex = 0;   //used to generate unique ids, names in repeated elements
var _debug = true;

 
		
$(document).ready(function () {
	
	// 2018-08-02
	// alert($('#checklist').length);
								
	//hide all notRequired
	//toggle_notRequired();
	toggle_mustImplement();
	

	jQuery.support.cors = true;  //not sure if needed because cors setting is on the server
	
	$("#btnParameters").click(function(){
		$("#options").toggle();
	});
	
	$("#btnParameters").click();
	
	//support toggle
	$(".collapsable").click(function(){
		$(this).siblings().toggle();
		$(this).toggleClass("HeaderGroup collapsed");									
	});								
	
	
	var endpoints;
	var successIndex = 0;
	
	
	
	/*
		save original xml in jquery variable  
		server or xslt puts original xml in #rawxml, issue with xslt putting in xml is copy-of function decodes special characters, thus 
		making xml invalid
	*/
	
	var xmlstring = $("#rawxml").val();   
	// 2018-08-02
	// alert($("#rawxml").length);
	
	//load into xml dom
	try{
		
		
		xmlDoc = $.parseXML(xmlstring);
		
		$xml = $(xmlDoc);

		//allow submit
		if($("#allowsubmit").val()=='no')
		{
			$("#send").css("display","none");
			
		}
		
		
	}
	catch(err){
		alert('Error loading xml: ' + err.message);
	}
	
	
	//disable all fill-in boxes
	/*
	var $fillins = $xml.find("ListItemResponseField")
	$fillins.each(function(){
		var answerid = $(this).parent().attr("ID");
		var $answerElement = getAnswerItemByID(answerid, $("html"))
		if(!$answerElement.prop('checked'))
			$answerElement.parent().find('.AnswerTextBox').prop('disabled',true);
		
	})
	*/
});

function validateDate(value)
{
	//2015-1-11 13:57:24
	var pattern = /^\d\d\d\d-(0?[1-9]|1[0-2])-(0?[1-9]|[12][0-9]|3[01]) (00|[0-9]|1[0-9]|2[0-3]):([0-9]|[0-5][0-9]):([0-9]|[0-5][0-9])$/g;
	
}
function doConfirm(msg, yesFn, noFn)
{
	
	var confirmBox = $("#confirmBox");
	confirmBox.find(".message").text(msg);
	confirmBox.find(".yes,.no").unbind().click(function()
	{
		confirmBox.hide();
	});
	confirmBox.find(".yes").click(yesFn);
	confirmBox.find(".no").click(noFn);
	confirmBox.show();
}

function isLocalMode()
{
	if (window.location.protocol=='file:')
	{
		return true;
	}
	else
	{
		return false;
	}
}

function loadXml(){
	
	if (isLocalMode())
	{
		// 2018-08-02 change: 
	    // alert('local');
		
		$('#rawxml').remove();
		$('<textarea id="rawxml" rows="20" style="-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;width: 100%;"/>').appendTo('body');
		readTextFile(window.location.href);
		if(_debug)
		{
		
			$('#rawxml').show();
		}
		else{
		    
			$('#rawxml').hide();
		}								
	}
}

function readTextFile(file)
{
		
	var rawFile = new XMLHttpRequest();
	rawFile.open("GET", file, false);
	rawFile.onreadystatechange = function ()
	{
		if(rawFile.readyState === 4)
		{
			if(rawFile.status === 200 || rawFile.status == 0)
			{
				var allText = rawFile.responseText;
				
				$('#rawxml').val(allText);
				
			}
		}
	}
	rawFile.send(null);
}

function sayHello(name) {
	alert("sayHello function in javascripts says - hello, " + name);
	return window.external.ShowMessage("If you can see this message sayHello successfully called ShowMessage function in this desktop client app.");

}

function toggle_metadata() {

   var divsMD = document.getElementsByClassName('MetadataDisplay')
   var divsMDH = document.getElementsByClassName('MetadataDisplayHeader')           
	  
	  var display = 'none'
	  if (divsMD[0].style.display)
	  {                  
		 if (divsMD[0].style.display == 'inline' )
		 { display = 'none' }
			else
		 { display = 'inline' }
	  }
	  
	  for (var i = 0; i < divsMD.length; i++)
	  { divsMD[i].style.display = display }
	  for (var i = 0; i < divsMDH.length; i++) 
	  { divsMDH[i].style.display = display } 
	  
	  
	  //Toggle ids too
	  var divs = document.getElementsByClassName('idDisplay')   
	  for (var i = 0; i < divs.length; i++)
	  { 
		 divs[i].style.display = display 
	  }
	  
	  //Toggle deprecated items                 
	  var dis = document.getElementsByClassName('TopHeader')
	  var searchText = "(Deprecated Items)"
	  
	  for (var i = 0; i < dis.length; i++) 
	  { 
	  if (dis[i].textContent.indexOf(searchText) >=0) 
		 {
			var divHeader = dis[i].parentElement.parentElement.parentElement //the tbody element
			if (display == 'inline') {display = ''}
			divHeader.style.display = display
			break;                         
		 }                     
	  }                

   }

function toggle_mustImplement()
{
	//alert('here');
	// $('.mustImplement').parent().toggle();
	if($('.mustImplement').parent().is(":visible")){
		$('#mnuRequired').text('Toggle optional items');
		$('.mustImplement').parent().toggle();
	}
	else{
		$('#mnuRequired').text('Hide optional items');
		$('.mustImplement').parent().toggle();
	}

}
function toggle_id() {
		  var divs = document.getElementsByClassName('idDisplay');
			var display = 'none';
			
		  if (divs[0].style.display)
		  {                  
			  if (divs[0].style.display == 'inline' )
				{ display = 'none'; }
			  else
				{ display = 'inline'; }
		  }
		  
		  for (var i = 0; i < divs.length; i++)
		  { divs[i].style.display = display; }
		  
	   }
	   
function resetAnswer(questionId, event) {
		/*will it work with repeated sections?*/
	  
	   var answers = document.getElementsByName(questionId);
	   for (var i = 0; i < answers.length; i++) {
			var selecttype = $(answers[i]).attr('type');
			if(selecttype=="checkbox" || selecttype=="radio")
			{
				answers[i].checked = false;
				
				// fire onchange on this answer choice	
				
				answers[i].onchange();
			}
		}
		
		return false;
		
	}
	
function ShowHideDemo() {
	$('#divdemo').toggle();
	if (($('#divdemo')).css("display")=='none')
		$('#demshowhide').text('+ Demographics');
	else
		$('#demshowhide').text('- Demographics');
	
}


//adds a new repeat of a section
function addSection(obj) {
	//obj is btnAdd
	/*
		UI: Clone the block
			Get new guid for block (section)
			Change names of each element (textbox, hiddenbox, checkbox, radio) in the block to original id + ":" + blockguid
		XML:    
			Clone the current section in xml
			Add new attribute called Guid = blockguid to the top level element
			Add new attribute called ParentGuid and set it equal to blockguid
			Change Id of each child to original id + ":" + blockguid
			
		Each question and answer choices in repeated block will have their ids changed to their original id + ": " + blockguid 
		
	*/
	
	
	
	//we need to clone table, so get table
	var td = obj.parentElement;
	var table = td.parentElement  //tr
				   .parentElement  //tbody
				   .parentElement //table
	
	/*if current section is the first occurrence, it's ID is from the xml
	if current section is a repeat it's ID = ID from the xml + Guid*/
	var currentSectionId = table.id; 
	
	var blockGuid = generateShortUid();  // generateGuid();  //to distinguish each repeat of parent element which is section for now
	repeatIndex++;
	
	
	var max = table.parentElement.firstChild.value;  //maxcardinality								
	
	try{
		var parentTable =  table.parentElement.
						   parentElement.
						   parentElement.
						   parentElement.
						   parentElement;
		
	}
	catch(err)
	{
		alert("Error when getting parent table: " + err);
		return;
	}
	
	if(countSectionRepeats(parentTable,currentSectionId.split("..")[0])==max)
	{
		alert("max repeat = " + max + " reached ");
		return;
	}
	
	var newtable = table.cloneNode(true);    							
	
	//newtable.id = currentSectionId.split(":")[0] + ":" + blockGuid;   //each repeated section id has the same ID from xml + blockGuid							
	newtable.id = currentSectionId.split("..")[0] + ".." + repeatIndex
	
								
	//set new ids to each nested table 
	var newtableitems = newtable.getElementsByTagName('*');										
	for(i=0; i< newtableitems.length; i++)			
		if(newtableitems[i].tagName=="TABLE")
			//newtableitems[i].id = newtableitems[i].id.split(":")[0] + ":" + blockGuid;
			newtableitems[i].id = newtableitems[i].id.split("..")[0] + ".." + repeatIndex;

	var trace = 0;
	var newname;
	var i;
	
	var ID;

	//add the new repeat
	try {
		
		/*find section in xml corresponding to this block (ID=currentSectionId.substring(1)) and clone it, then assign new ID*/
		//alert(currentSectionId.substring(1));
		var $sectionCurrent = $xml.find('Section[ID="' + currentSectionId.substring(1) + '"]:first');  //first is redundant since there is only one section with this ID
		if($sectionCurrent.length==0)
		{
			alert("Section ID = " + currentSectionId.substring(1) + " not found");
			return;
		}
		
		
		var $sectionNew = $sectionCurrent.clone(true);
		
		//$sectionNew.attr('ID',currentSectionId.split(":")[0].substring(1)+":" + blockGuid);
		$sectionNew.attr('ID',currentSectionId.split("..")[0].substring(1)+".." + repeatIndex);								
		
		//xml: set IDs of all children sections
		$sectionNew.find('Section').each(function(index){
			//var secid = $(this).attr("ID").split(":")[0] + ":" + blockGuid;	
			var secid = $(this).attr("ID").split("..")[0] + ".." + repeatIndex;	
			$(this).attr("ID",secid);
			
			
		});
		
		
											
		var oldtableitems = td.getElementsByTagName("input");  //get hidden input, radio buttons, checkboxes and input text boxes
		
		//iterate through oldtableitems and assign new unique ids to them
		for (i = 0; i < oldtableitems.length; i++) {
			
			if (oldtableitems[i].type == "hidden" || oldtableitems[i].type == "text" || oldtableitems[i].type=="radio") {
				oldname = oldtableitems[i].name;  //name of the first instance is ID from xml, repeats have ID + ":" + Guid

				if(oldtableitems[i].id=="maxcardinality")
					  continue;

				if(oldtableitems[i].name=="")
				{
					alert("error: a " + oldtableitems[i].type + " box without name is found at " + i);
					continue;
				}
					   
				//newname = oldtableitems[i].name.split(":")[0] + ':' + blockGuid;
				newname = oldtableitems[i].name.split("..")[0] + '..' + repeatIndex;
															
				//find the element in the new table
				
				newtableitems = newtable.getElementsByTagName('*');										
				
				
				
				for(k=0;k<newtableitems.length;k++)
				{											
					
				   if(newtableitems[k].name == oldtableitems[i].name)
				   {
						newtableitems[k].name = newname;													
						
						
						if(newtableitems[k].type=="hidden")   //question will have Q as the first letter
						{  
							
						   //find question in xml fragment and change ID
						   
						   $question = $sectionNew.find('Question[ID="' + oldtableitems[i].name.substring(1) + '"]');
						   
						   if($question.length==0)
						   {
								alert("Qusetion ID = " + oldtableitems[i].name.substring(1) + " not found.");
								$sectionNew.find('Question').each(function(index){
									alert($(this).attr("ID"));
								})
								return;
							}
							else{
								
								//$question.attr("ID", newtableitems[k].name.split(":")[0].substring(1) + ':' + blockGuid); 
								$question.attr("ID", newtableitems[k].name.split("..")[0].substring(1) + '..' + repeatIndex); 
								
							}
						   
						   
						   /* 12/18/2016
						   New constraints
						   Property name, ResponseField name and Value name have to be unique 
						   */
						   
						   if (typeof $question.find("Property").attr("name") != 'undefined')
						   {
								//new property name
								//var propname = $question.find("Property").attr("name") + "_" + blockGuid; // repeat;
								var propname = $question.find("Property").attr("name").split('..')[0] + ".." + repeatIndex;
								$question.find("Property").attr("name",propname);
						   }
						   
						   if (typeof $question.find("ResponseField").attr("name") != 'undefined')
						   {
								//new response name
								//propname = $question.find("ResponseField").attr("name") + "_" + blockGuid;  // repeat;
								propname = $question.find("ResponseField").attr("name").split('..')[0] + ".." + repeatIndex;  // repeat;
								$question.find("ResponseField").attr("name",propname);
						   }
						   if (typeof $question.find("Response").children(0).attr("name") != 'undefined')
						   {
								//new name on value field
								//propname = $question.find("Response").children(0).attr("name") + "_" + blockGuid;  // repeat;
								propname = $question.find("Response").children(0).attr("name").split('..')[0] + ".." + repeatIndex;  // repeat;
								$question.find("Response").children(0).attr("name", propname);
						   }
						   
						}
						else {                   //answers do not have Q											
								if(newtableitems[k].type=="radio" || newtableitems[k].type == "checkbox")
								{
									 newtableitems[k].checked = false;														 
									 
								}
								 else
								{
									 newtableitems[k].value = "";
								}
						}												   
					}
				}
					
			}
		}

		//better to append new table after setting properties of individual controls
		table.parentElement.appendChild(newtable);

											
		//insert newsec after last section
		
		//$xml.find('Section[ID="' + table.id.substring(1) + '"]').after($sectionNew);
		
		var $orgsecid = table.id.substring(1).split('..')[0];
		
		var $lastindex = $xml.find('Section[ID*="' + $orgsecid + '"]').length - 1;									
		
		if($lastindex>=0)
		{
			$xml.find('Section[ID*="' + $orgsecid + '"]').last().after($sectionNew);
			
		}
		else
		{
			alert("error adding section repeat");
			return;
		}
			
			
		//remove all nested repeats
		newtable = removeNestedTableRepeats(newtable);
	
		//update rawxml for view							
		$('#rawxml').val(xmlToString(xmlDoc));												
		
		repeat = countSectionRepeats(parentTable, currentSectionId.split("..")[0])																	
		
		showHideButtons(newtable);	
		
		//make sure + is visible on the first repeat of nested section
		nestedtables = getChildTables(newtable);
		
		
		for(i=0;i<nestedtables.length;i++)
		{
			elements = nestedtables[i].getElementsByTagName('*');	
			for(j=0;j<elements.length;j++)
			{
				if(elements[j].className=="btnAdd")
					elements[j].style.visibility="visible";
			}
		}
			
		
	}
	catch (err) {
		alert(err.message + "\n" + trace + "\n" + newname + "n" + i);
	}

}

//adds a new repeat of a question
function addQuestion(obj) {
	//obj is btnAdd inside command div
	/*
		UI: Clone .question div, update id of this div to original id + '..' + repeatIndex
		change names of children to name + '..' + repeatIndex 
			
			
		XML:    
			Clone the current question node in xml
			Change Id of the question and its children to original id + ":" + blockguid
			
		Each question and answer choices in repeated block will have their ids changed to their original id + ": " + blockguid 
		
	*/
	
	
	try{
	
		
		var button = $(obj);
		
		//find question div
		var questionToRepeat = button.closest('.question');  //closest parent div with class='question'
				
		
			//alert(questionToRepeat.html())
			
		var currentQuestionId = questionToRepeat.attr('id');
		
		currentQuestionId = currentQuestionId.substring(1).split('..')[0];
		
		var max = questionToRepeat.find("input[id='maxcardinality']").first().val();  //maxcardinality	
	    var repeats = countQuestionRepeats(currentQuestionId);
		if( repeats>= max)
		{
			
			alert('max value ' + max + ' reached.');
			return;
		}
		
		//
		
		
		repeatIndex++;
		
		
		
		
		var clonedBlock = questionToRepeat.clone();
		
		clonedBlock.attr("id", 'q' + currentQuestionId + '..' + repeatIndex);
		
		//alert(clonedBlock.html());
		
		//find the top level question node in xml and clone it
		var elementToClone = $xml.find("Question[ID='" + currentQuestionId + "']");
		var clonedXml = elementToClone.clone();
		
		//change name attributes 
		clonedXml.find("Property").each(function(){
				var prop = $(this);
				if(typeof prop.attr("name") != "undefined")
					prop.attr("name",prop.attr("name").split('..')[0] + ".." + repeatIndex);
		});
		
		clonedXml.find("ResponseField").each(function(){
				var temp = $(this);
				if(typeof temp.attr("name") != "undefined")
				temp.attr("name",temp.attr("name").split('..')[0] + ".." + repeatIndex);
		});
		
		clonedXml.find("Response").each(function(){
				var temp = $(this).children(0);
				if(typeof temp.attr("name") != "undefined")
				temp.attr("name",temp.attr("name").split('..')[0] + ".." + repeatIndex);
		});
		
		clonedXml.find("ListItemResponseField").each(function(){
				var temp = $(this);
				if(typeof temp.attr("name") != "undefined")
				temp.attr("name",temp.attr("name").split('..')[0] + ".." + repeatIndex);
		});
		
		
		
		//update names of cloned elements
		var clonedItems = clonedBlock.find("input");  //get hidden input, radio buttons, checkboxes and input text boxes
		
		
		//iterate through clonedItems and assign new unique ids to them
		clonedItems.each(function(){
			var item = $(this);
			var name = item.attr('name');
			
			if(typeof name != 'undefined')
			{
				
						   
				if(name.substring(0,1)=='q')
				{
					var questionId = name.substring(1).split('..')[0];
					item.attr('name','q' + questionId + '..' + repeatIndex);
					//alert(questionId + ':' + clonedXml.find("Question[ID='" + questionId + "']").length);
					if(clonedXml.attr("ID")==questionId)
					{
						//alert('here')
						clonedXml.attr("ID",questionId + '..' + repeatIndex);	
					}
					else{
						clonedXml.find("Question[ID='" + name.substring(1) + "']").attr('ID',questionId + '..' + repeatIndex);	
						//alert(questionId + '..' + repeatIndex);
					}
					
				}
				else{
					//answer choices do not have 'q'
					var questionId = name.split('..')[0];
					item.attr('name',questionId + '..' + repeatIndex);
					//alert(item.attr('type'));
					if(item.attr('type')=='text')
					{
						item.val('');
					}
					
					item.attr('checked',false);
				}
			}
				
		});
		
		//append cloned node to xml
		clonedXml.appendTo(elementToClone.parent());
		
		
		
		
		//append cloned UI block in display
		clonedBlock.find('.btnRemove').css('visibility', 'visible');  //show does not work
		//clonedBlock.appendTo(questionToRepeat.after());   
		questionToRepeat.after(	clonedBlock);	
		
		
		
		
		
		
	}
	catch (err) {
		alert(err.message );
	}

}


function removeQuestion(obj)
{

	try {
		var button = $(obj);
		
		//find question div
		var questionToRemove = button.closest('.question');  //closest parent div with class='question'
																				
		var currentQuestionId = questionToRemove.attr('id').substring(1);
		
		//remove
		questionToRemove.remove();
		//alert('now removing ' + currentQuestionId);
		//alert(countQuestionRepeats(currentQuestionId));
		if($xml.find("Question [ID='" + currentQuestionId + "']").length==0)
		{
			alert("ID = " + currentQuestionId + " not found");
		}
		$xml.find("Question [ID='" + currentQuestionId + "']").remove();
	}
	
	catch(err)
	{
		alert(err.message);
	}

}


function getRepeats(id)
{
	var id = id.split('_')[0];
	var count = 0;
	$('input').each(function(){
		var name = $(this).attr('name');
		if(name==id)
		{
			count++;
		}
	});
	
	return count;
	
}

function generateShortUid() {
		return ("0000" + (Math.random()*Math.pow(36,4) << 0).toString(36)).slice(-4)
}

function generateGuid() {
	var result, i, j;
	result = '';
	for (j = 0; j < 32; j++) {
		if (j == 8 || j == 12 || j == 16 || j == 20)
			result = result + '-';
		i = Math.floor(Math.random() * 16).toString(16).toUpperCase();
		result = result + i;
	}
	return result;
}


/*
Counts the number of repeats of a block (table)
Each repeated block (table) has id that has two parts
1. id that is the same for each repeat.
2. a guid that is different for each repeat 
*/
function countSectionRepeats(parentT, sectionid) {
	
	
	var tables = parentT.getElementsByTagName('TABLE');
	var count = 0;
	for(i=0; i<tables.length; i++)
	{
	   checkid = tables[i].id.split("..")[0];
	   if(checkid == sectionid) count++;
	}
   
	return count;

}


/*
count question repeats 
*/
function countQuestionRepeats(questionid) {
	
	questionid = questionid.split('..')[0];
	//alert(questionid + ':' + $xml.find('Question[ID^="' + questionid + '"]').length);
	return $xml.find('Question[ID^="' + questionid + '"]').length;
	

}


function getMaxCount(sectionid)
{
	alert(document.getElementById(sectionid).length);

}


function getSiblingTables(parentT) {								
	
	return tables = parentT.getElementsByTagName('TABLE');								

}



function getChildTables(table)
{
	return table = table.getElementsByTagName('TABLE');
}

function getLastRepeat(sectionid) {
	var section = document.getElementById(sectionid);
	var tables = section.parentElement.getElementsByTagName('TABLE');
	var ret = null;
	for(i=0;i<tables.length;i++)
	{
	   if(tables[i].id.split("..")[0]==sectionid)
		 ret = tables[i];
	}
	return ret;
}

function getFirstRepeat(sectionid) {
	var section = document.getElementById(sectionid);
	var tables = section.parentElement.getElementsByTagName('TABLE');
	var ret = null;
	for(i=0;i<tables.length;i++)
	{
	   if(tables[i].id.split("..")[0]==sectionid)
	   {
		 ret = tables[i];
		 break;
		}
	}
	return ret;
}

function removeNestedTableRepeats(table)
{
	
	var all = table.getElementsByTagName("*");
	for(i=0; i<all.length-1; i++)
	{
		if(all[i].id.indexOf("s")==0 & all[i].tagName=="TABLE") //nested table
		{										
			var id = all[i].id;
			//alert("delete id = " + id);
			for(j=i+1; j<all.length-1; j++)
			{
				
				if(all[j].id.split("..")[0]==id.split("..")[0])
				{
					
					v = all[j].id;
					
					//remove table
					all[j].parentElement.removeChild(all[j]);
					
					//remove xmlnode
					
					$j = $xml.find('Section[ID="' + v.substring(1) + '"]');
					
					
					if($j.length==0)
						alert("removeNestedTableRepeats - not found: " + v.substring(1));
					
					if($j.length > 1 )
					{
						try
						{
							$j.slice(1).remove();  //remove from index = 1 down
							
						}
						catch(err)
						{
							alert("Error in removeNestedTableRepeats: " + err);
						}
					}
					removeNestedTableRepeats(table);
				}
			}
		}
	}
	return table;
}

//gets the id parentSection of +, - buttons
function getParentSectionId(button)
{
	if(button.parentElement.parentElement.parentElement.parentElement.tagName=="TABLE")
		return button.parentElement.parentElement.parentElement.parentElement.id;
	else
		alert("Unexpected tagName");

}

function getParentTable(table)
{
	//get parentTable
	try{
	var parentTable =  table.parentElement.
						   parentElement.
						   parentElement.
						   parentElement.
						   parentElement;
	return parentTable;
	}
	catch(err)
	{
		alert("Error in getParentTable: " + err);
		return;
	}
}

function showHideButtons(table)
{
	//get parentTable
	
	var parentTable =  getParentTable(table)
	
	//show/hide buttons
	
	//get all siblings of this table
	var siblings = getSiblingTables(parentTable);
	
	//get max repeat for this table - get parent which is DIV and the firstChild of DIV is maxcount
	var max = table.parentElement.firstChild.value;  
	
	//how many repeats are there for this table currently
	var repeat = countSectionRepeats(parentTable, table.id.split("..")[0]);
	
	
	var inputs = "";
	if(siblings.length==0)
	{
		alert("error in getting siblings");
		return;
	}
	

	
	if(repeat<max)   //
	{
		
		for (k=0;k<siblings.length; k++)
		{										
			if(siblings[k].id.split("..")[0]==table.id.split("..")[0])
			{	
				inputs = siblings[k].getElementsByTagName('*');
		
				for(m=0;m<inputs.length;m++)
				{
					if(inputs[m].className=="btnAdd")
					{														
						//which section does it belong?
						sectionid = getParentSectionId(inputs[m]);
						
						if(table.id.split("..")[0] != sectionid.split("..")[0])
						{
							//alert(table.id);
							//alert(sectionid);
							continue;
						}													
						
						
						if(k>0)
						{
							inputs[m].nextSibling.style.visibility = "visible";
							inputs[m].style.visibility = "visible";
						}
						else
						{
							
							inputs[m].nextSibling.style.visibility = "hidden";
							inputs[m].style.visibility = "visible";
						}											
						
					}
					
				}
			}
		}
	}
	else
	{
		
		for (k=0;k<siblings.length; k++)
		{
			if(siblings[k].id.split("..")[0]==table.id.split("..")[0])
			{
				inputs = siblings[k].getElementsByTagName('*');
				for(m=0;m<inputs.length;m++)
				{
					if(inputs[m].className=="btnAdd")
					{
						
						inputs[m].style.visibility = "hidden";
						
						if(k>0)
							inputs[m].nextSibling.style.visibility = "visible";
					}
				}
			}
		}				
	}								
}
							
function removeSection(obj) {
	td = obj.parentElement;
	tr = td.parentElement;
	tbody = tr.parentElement;
	table = tbody.parentElement;
	var section = table.parentElement;
	var id = table.id;
	
	parentTable = getParentTable(table);
	
						   
	//do not let user remove the first instance
	if(table.id.indexOf("..")==-1)
	{
		alert("Cannot remove the first instance.");
		return;
	}
	section.removeChild(table);

									
	id = section.id;
									
	$todelete = $xml.find('Section[ID="' + table.id.substring(1) + '"]');
	if($todelete.length==0)
	{
		alert("Could not find section with ID = " + table.id.substring(1) + " to delete");
		return;
	}
	
	$todelete.remove();
	
	$todelete = $xml.find('Section[ID="' + table.id.substring(1) + '"]');
	if($todelete.length!=0)
	{
		alert("Could not delete Section ID = " + table.id.substring(1));									
	}
	
	//update rawxml
	$('#rawxml').val(xmlToString(xmlDoc));
								
	//current table is deleted, so get the first table by going upto the parent, then the first Table
	table = document.getElementById(parentTable.id);
	
	if(table.tagName=="DIV")   //first table is inside DIV element
	{
		table = table.childNodes[1];  //parentTable
		table = table.getElementsByTagName("TABLE")[0]  //firstChild table																		
		
	}
	else  //subsequent repeats are nested inside parent TABLE directly
	{
		
		table = table.getElementsByTagName("TABLE")[0]  //first child table
	}
								
	
	showHideButtons(table);
		
}


/*
Helper functions
*/
function trim(input) {
input = input.replace(/^\s+|\s+$/g, '');
return input;
}

function findElementById(parentId, Id) {
   //finds an element among descedants of a given node
   var parent = document.getElementById(parentId);

   var children = parent.getElementsByTagName('*');


   for (i = 0; i < children.length; i++) {

	  if (children[i].id == Id) {
		 return children[i];
	  }
   }

}

function findElementByName(parentName, Name) {
  //finds an element among descedants of a given node
  var parent = document.getElementById(parentName);
  var children = parent.getElementsByTagName('*');
  
  for (i = 0; i < children.length; i++) {
	 if (children[i].name == Name) {
		 return children[i];
	 }
  }
}

function validateSubmit()
{
	//alert('in validate');
	$('input').removeClass('error');
	document.getElementById('navBar').style.display = 'none';
	var retval = false;
	var $allinputs = $("#FormData").find(":input:not([type=hidden], [type=button], [type=submit])")
	$allinputs.each(function() {
		var $test = $(this);
		
		if($test.is(':checkbox') || $test.is(':radio'))
		{
			if($test.prop('checked')==true)
			{
					//alert($test.attr('id'));
				retval = true;
			}
		}
		else
		{
			if($test.val()!='')
			{
				retval = true;
				//alert($test.attr('id'));
			}
		}
	});
	
	//alert(retval);
	if(!retval)
	{
		alert('Error: You have not selected/entered any response on the form.');
		return false; //so 
	}
	
	retval = true;
	
	
	
	var $fillins = $(xmlDoc).find("ListItemResponseField")
	
	$fillins.each(function(){
		var answerid = $(this).parent().attr("ID");
		var $answerElement = getAnswerItemByID(answerid, $("#FormData"));
		
		if(!$answerElement.prop('checked') & $answerElement.parent().find(".AnswerTextBox").val()!=''){
				//alert('error');
				$answerElement.parent().find('.AnswerTextBox').addClass('error');
				retval = false;
		}
		
	})
	//alert(retval);
	if(!retval)
	{
		alert('Error: You have entered text in fill-in box)(es) without selecting the corresponding choice(s)');
		return false;
	}
	
	var requiredResponses = $xml.find("ListItemResponseField[responseRequired='true']");
	retval = true;
	requiredResponses.each(function(){
		var test = $(this);
		var id = test.parent().attr('ID');
		
		
		
		var response = test.find('>Response');
		
		if(response.length>0)
		{
			var box = $(document).find(':input[value^="' + id + '"]'); //check/option 
			if(box.length>0)
			{
			
				var testval = box.siblings('input').val();									
			
			
				if(testval=='')
				{												
					
					if(box.is(':checked'))
					{
						box.siblings('input').addClass('error');
						retval = false;
					}													
					
				}
			
			}
													
				
		}
	});
	
	if(!retval)
	{
		alert('Error: You have not answered all required questions.');
		return false
	}
	return true;
}

function xmlToString(xmlData) {

	var xmlString;
	//alert(xmlData);
	xmlString = (new XMLSerializer()).serializeToString(xmlData);
	
	return xmlString;
}

//helper functions end

//submit form calls this function
/*
Builds flatXml, updates the original xml with answers.
Note that new section nodes for repeat sections have already been added (upon clicking btnAdd - addSection function) 
*/
var flatXml;
function openMessageData(submit) {
	
	var sb = "";
	var answer = "";
	
	try {
	if(document.getElementById("checklist")==null)
	{
       alert('checklist not found');	
	   //return;
	}
	if(document.getElementById("FormData")==null)
	{
       alert('checklist not found');	
	   return;
	}
	var elem = document.getElementById("checklist").elements;
	//var elem = document.getElementById("FormData").elements;
	var response = "<response>";
	var html = "";
	
	
	
	for (var i = 0; i < elem.length; i++) {
		html = "";
		var name = elem[i].name;

		var value;

		
		var instanceGuid = '';
		
		var id = name;
		var guid = "";
		if (name.indexOf("q") == 0) {
			
			value = elem[i].value;
			
			//make answer xml safe
			answer = GetAnswer(name.substring(1));

			if (answer != "") {
				
				
				
				response += "<question ID=\"" + id + "\" display-name=\"" + value.replace(/</g, "&lt;").replace(/>/g, "&gt;") 
						 + "\">";
				response += answer + "</question>";               

				
				newid = id.split('..')[0].substring(1);									
				
				if(id.split('..').length==2)
					guid=id.split('..')[1]
				


				//html += "<div class=\"MessageDataQuestion\">&lt;question ID=\"" + id + "\" guid=\"" + guid + "\" display-name=\"" + value + "";
				html += "<div class=\"MessageDataQuestion\">&lt;question ID=\"" + id.substring(1) +  "\" display-name=\"" + value + "";
				html += "&gt;<br><div class=\"MessageDataAnswer\">" + answer.replace(/</g,"&lt;").replace(/>/g,"&gt;") + "</div>&lt;/question&gt;</div>";

				
				
			}
			sb += html;
			answer = "";
		}
	}

	
	response = response.replace(/<br>/g, "");
	response = response + "</response>";															
	flatXml = response;


	sb = "<div style='font-weight:bold; color:purple'>Flat Xml response</div>" 
		 + "<div class=\"MessageDataChecklist\">&lt;response&gt;" + sb + "&lt;/response&gt;</div>"
		 + "<br/><div style='font-weight:bold; color:purple'>Response xml sent to web service.</div>"
	

	//update Xml with answers
	updateXml();
	
	if(!validateSubmit())
	{
	
		if (confirm('Do you want to submit this form with errors? Click Ok to submit or Cancel to fix errors.')==false)
		{
			return;
		}
	}								
	
	document.getElementById('MessageDataResult').innerHTML = sb;
	document.getElementById('MessageData').style.display = 'block';
	document.getElementById('FormData').style.display = 'none';
	
	//if running from disk 
	if(isLocalMode()) return;
	

	var test = xmlToString(xmlDoc);
	document.getElementById('rawxml').innerText = test;
	
	
	
	if($('#scriptsubmit').is(':checked'))
	{
		//Ajax call to web service
		CallSoapSubmit2(xmlToString(xmlDoc));
		return false;
	}
	else
	{
		//call formreceiver from server side code
		//alert('calling server submit');
		ServerSubmit();

	}

	}
	catch(err)
	{
		alert(err);
	}
}

/* start of functions to call .NET serverside methods*/

function ServerSubmit()
{
	//alert('trace1');
	var xml = document.getElementById("rawxml").value;
	var submiturls = document.getElementById("submiturl").value
	//alert(submiturls);
	//alert('trace2');
	var responsetext = PageMethods.submitform(xml, submiturls, OnServerSucceed, OnServerError);
	//alert('trace3');
	return false;
}

function OnServerSucceed(result)
{
	//alert('Server submit succeded.');
   //server response includes SoapResponse and SoapRequest strings delimited by #!#2#3
	var response = result.split('#!#2#3')[0];
	var request = result.split('#!#2#3')[1];

	
	
	//request = formatXml(request);
	$("#submitsoap").val(request);

	response = formatXml(response);
	xml_escaped = response.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/ /g, '&nbsp;').replace(/\n/g, '<br />');
	
  
	$("#response").html("<PRE>" + xml_escaped + '</PRE>');
	$("#response").css("background-color", "yellow");
	$("#response").css("display", "block");								

   
}

function OnServerError(error)
{
	var result = error.get_message();
	alert("Error on server submit: " + result);
	document.getElementById("response").innerText = result;
	document.getElementById("response").style.backgroundColor = "yellow";
	document.getElementById("response").style.color = "red";
}

/* end of functions to call .NET serverside methods */


function closeMessageData() {
	document.getElementById('MessageData').style.display = 'none';
	document.getElementById('response').style.display = 'none';
	document.getElementById('FormData').style.display = 'block';
	document.getElementById('navBar').style.display = 'block';
}

function GetAnswer(qCkey) {
	
	var elem = document.getElementById("checklist").elements;
	var str = "";
	var name, value;

	for (var i = 0; i < elem.length; i++) {
		name = elem[i].name;
		value = elem[i].value;

		//if (name.indexOf(qCkey) == 0) {
		if (name==qCkey) {	
			if (elem[i].checked || (elem[i].type == "text" && value != "")) {

				{
					
					var k = value.split(',');

					if (elem[i].type == "text" && value != "") {
						value = value.replace(/&/g,"&amp;")
									 .replace(/</g,"&lt;")
									 .replace(/>/g,"&gt;")
									 .replace(/"/g,"&quot;")
									 .replace(/'/g,"&apos;");
												 
					//alert(answer);
						
						str += "<answer value=\"" + value + "\"/><br>";
					}
					else if (elem[i].type != "text") {
						//str += "&lt;answer ID=\"" + k[0] + "\" display-name=\"" + GetDisplayName(value) + "\"/&gt;<br>";
						str += "<answer ID=\"" + k[0] + "\" display-name=\"" + GetDisplayName(value) + "\"/><br>";
					}
				}
			}
		}
	}
	return str;
}

function GetDisplayName(value) {
	
	var strArray = value.split(',');
	var returnStr = "";
	if (strArray.length > 1) {
		for (var i = 1; i < strArray.length; i++) {
			if (i != strArray.length) {
				returnStr += strArray[i] + ",";
			}
			else {
				returnStr += strArray[i];
			}
		}
	}
	returnStr = returnStr.replace(/</g,"&lt;").replace(/>/g,"&gt;");
	return returnStr.substr(0, returnStr.length - 1);
}


//updates answers in full xml
function updateXml() {
	var $xml = $(xmlDoc);  //full xml
	FlatDoc = $.parseXML(flatXml);
	$xmlFlatDoc = $(FlatDoc);
	$xmlFlatDoc.find('question').each(function () {
		var $question = $(this);
		var questionid = $question.attr("ID");

		

		questionid = questionid.substring(1);

		var repeat = 0;
		


		//there may be multiple answers per question
		$question.find('answer').each(function () {
			var $test = $(this);
			var id = $test.attr("ID");
			var val = $test.attr("value");

			
			var $targetQuestion = $(xmlDoc).find("Question[ID='" + questionid + "']");
			var targetQuestionId = $targetQuestion.attr("ID");


			if (id != null) {
				 
				var $targetAnswer = $targetQuestion.find("ListItem[ID='" + id + "']");
				$targetAnswer.attr("selected", "true");
				//alert("set selected to true");
				if ($targetAnswer.find("ListItemResponseField") != null) {
					val = $question.find('answer').next().attr("value");
					$response = $targetAnswer.find("Response").children(0);
					$response.attr("val", val);
				}

			}
			else {  //free response
				
				$targetAnswer = $targetQuestion.find("ResponseField").find("Response");
				$targetAnswer.children(0).attr("val", val);
			}
		});

	});
	
   

}

function padLeft (str, max) {
  str = str.toString();
  return str.length < max ? padLeft("0" + str, max) : str;
}


//soap 1.2
function CallSoapSubmit2(data) {

	
	if($('#scriptsubmit').length == 0 | (!$('#scriptsubmit').is(':checked')))
	{
		alert("Script Submit is not supported.");
		//serverSubmit(data);
		return;
	}

	
	try{
		//get DemogFormDesign and FormDesign element only
	xmlDoc = $.parseXML(data);
	$xml = $(xmlDoc);
	
	var $formdesignelement = $xml.find('FormDesign');
			   
	if($xml.find('DemogFormDesign'))
	{
		
		$demog = $xml.find('DemogFormDesign'); 
		$demogNew = $demog.clone(true);
	}

	var $designNew = $formdesignelement.clone(true);
	newDoc = $.parseXML("<SDCSubmissionPackage xmlns='urn:ihe:qrph:sdc:2016'></SDCSubmissionPackage>")
	test = $(newDoc).find("SDCSubmissionPackage");
	
	
	
	//add 2018 - pkgInstanceURI, pkgInstanceVersionURI, pkgPreviousInstanceVersionURI, pkgDateTimeStamp
	test.attr("pkgInstanceURI","1223456");
	test.attr("pkgInstanceVersionURI","1223456");
	test.attr("pkgPreviousInstanceVersionURI","1223456");
	
	var d = new Date();

	var month = padLeft(d.getMonth()+1,2);
	var day = padLeft(d.getDate(),2);
	var year = d.getFullYear();
	var hr = padLeft(d.getHours(),2);
	var min = padLeft(d.getMinutes(),2);
	var sec = padLeft(d.getSeconds(),2);
	var fulldate = year + '-' + month + '-' + day + 'T' + hr + ':' + min + ':' + sec;
	//alert(fulldate);
	var dt = new Date("30 July 2010 15:05 UTC");
	//document.write(dt.toISOString());
	//test.attr("pkgDateTimeStamp","2017-11-18T07:53:01");
	//2017-11-18T8:7:34
	test.attr("pkgDateTimeStamp",fulldate);
	test.append($designNew);
	if($demogNew)
	{
		test.prepend($demogNew);						
		
	}

	data = xmlToString(newDoc);

	//read destination url from xml if present
	var webServiceURL = "";

	
	$destinations = $xml.find('Destination');
	
	if($destinations.length>0)								
	{
		$.each($destinations, function(){
			
			webServiceURL = webServiceURL + "|" + $(this).find('Endpoint').attr('val');
		});
	
		webServiceURL = webServiceURL.substring(1);															
		
	}
	else
	{
		alert('submiturl = ' + $("#submiturl").val());
		webServiceURL = $("#submiturl").val();
		if(webServiceURL=='')
		{
			alert("destination not found.");
			return;
			}
	}
	
	
	

	  
	
									
	var ns = 'urn:ihe:iti:rfd:2007';

	$.support.cors = true;
	var xmldata = encodeURIComponent(data);
	
	var soapRequest =
						'<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"' + 
						' xmlns:urn="' + ns + '">'  + 
						'<soap:Header/>' +
							' <soap:Body>' +
									' <urn:SubmitFormRequest>' +
									 data +
									'</urn:SubmitFormRequest>' +
							' </soap:Body>' +
						' </soap:Envelope>';
								

	$("#submitsoap").val(soapRequest);
	endpoints = webServiceURL.split('|')  //multiple endpoints are separated by |
	numEndpoints = endpoints.length;
	
	//clear before submit
	$("#response").html('');
	
	var currEndpoint='';
	for(i=0;i<numEndpoints;i++)
	{
		currEndpoint = endpoints[i].trim();
		try
		{
			$.ajax({
			type: "POST",
			context:{test:currEndpoint},  //test is the value when call was made and is available in success and error
			url: currEndpoint,
			//contentType: "application/soap+xml;charset=utf-8;",
			contentType: "application/soap+xml;",
			dataType: "xml",
			processData: false,									
			data: soapRequest,
			success: function (response) {OnSuccess(response,this.test)},
			error: function (xhr, message, exception ) {OnError(xhr, message, exception, this.test)}
			});
		}

		catch(err)
		{
			alert("Error when posting submit request to " + currEndpoint + ": " + err);
		}
	
	}
	

	return false;
	}
	
	catch (err)
	{
		alert(err.message);
		return false;
	}

	
	
}


//soap 1.1
function CallSoapSubmit1(data) {
	
	
	$("#response").val("************");
	

	//get DemogFormDesign and FormDesign element only
	xmlDoc = $.parseXML(data);
	$xml = $(xmlDoc);

	var $formdesignelement = $xml.find('FormDesign');
			   
	if($xml.find('DemogFormDesign'))
	{
		
		$demog = $xml.find('DemogFormDesign'); 
		$demogNew = $demog.clone(true);
	}

	var $designNew = $formdesignelement.clone(true);
	newDoc = $.parseXML("<SDCSubmissionPackage xmlns='urn:ihe:qrph:sdc:2016'></SDCSubmissionPackage>")
	test = $(newDoc).find("SDCSubmissionPackage");
	test.append($designNew);
	if($demogNew)
	{
		test.prepend($demogNew);						
		
	}

	data = xmlToString(newDoc);

	//read destination url from xml if present
	var webServiceURL = "";

	//webServiceURLFromPackage = $xml.find('Destination').find('Endpoint').attr('val');
	$destinations = $xml.find('Destination');
	
	if($destinations.length>0)								
	{
		for(i=0;i<$destinations.length;i++)
		{
			webServiceURL = webServiceURL + "|" + $destinations.find('Endpoint').attr('val');									
			
		}
		webServiceURL = webServiceURL.substring(1);															
		
	}
	else
	{
		alert('1.1');
		alert("destination not found.");
		return;
	}
	
	if(webServiceURL!="" & $("#submiturl").val()=="")
		$("#submiturl").val(webServiceURL);
	

	webServiceURL = $("#submiturl").val();  
	
	
	var ns = $("#submitnamespace").val();
	
	$.support.cors = true;
	var xmldata = encodeURIComponent(data);
	
	
	var soapRequest =
						'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"' + 
						' xmlns:urn="' + ns + '">'  + 
						'<soap:Header/>' +
							' <soap:Body>' +
									' <urn:SubmitFormRequest>' +
									//' <SDCSubmissionPackage xmlns="urn:ihe:qrph:sdc:2016">' +
									 data +
									// ' </SDCSubmissionPackage>' +
									'</urn:SubmitFormRequest>' +
							' </soap:Body>' +
						' </soap:Envelope>';

	
	$("#submitsoap").val(soapRequest);

	//soapAction = "SubmitForm";  
	soapAction = $("#submitaction").val();
	
	endpoints = webServiceURL.split('|')  //multiple endpoints are separated by |
	numEndpoints = endpoints.length;
	
	var currEndpoint='';
	
	//clear before submit
	$("#response")='';
	
	//soapRequest='<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ihe:iti:rfd:2007"> <soap:Header/><soap:Body><urn:SubmitFormRequest>test</urn:SubmitFormRequest> </soap:Body></soap:Envelope>'
	//alert(soapRequest);
	for(i=0;i<numEndpoints;i++)
	{
		currEndpoint = endpoints[i].trim();
		
		$.ajax({
		type: "POST",
		context:{test:currEndpoint},  //test is the value when call was made and is available in success and error
		url: currEndpoint,
		contentType: "text/xml",
		dataType: "xml",
		processData: false,
		headers: {
			"SOAPAction": soapAction  
		},
		data: soapRequest,
		success: function (response) {OnSuccess(response,this.test)},
		error: function (response) {OnError(response, this.test)}
	});
	
	}
	

	

	return false;
	
}




function OnSuccess(data, url) {
	
	
	var xmlstring = xmlToString(data);

	xmlstring = formatXml(xmlstring);
	xml_escaped = xmlstring.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/ /g, '&nbsp;').replace(/\n/g,'<br />');

	

	if (document.getElementById("response") != null) {       
		
		$("#response").append("Received Response from " + url  + " - <PRE>" + xml_escaped + '</PRE>');
		$("#response").css("background-color", "yellow");
		$("#response").css("display", "block");
		
		
	}
	
	
}

function OnError(xhr, textStatus, errThrown, url) {
	//CORS error can only be see in Chrome 
	var xmlstring = xhr.responseText;
	

	
	if (document.getElementById("response") != null) {       
		$("#response").append("Receiver Response from " + url + " - <PRE>" + xmlstring + '</PRE>');
		$("#response").css("background-color", "white");
		$("#response").css("color", "red");
		$("#response").css("display", "block");
	}
	
}

//https://gist.github.com/sente/1083506
function formatXml(xml) {
	var formatted = '';
	var reg = /(>)(<)(\/*)/g;
	xml = xml.replace(reg, '$1\r\n$2$3');
	var pad = 0;
	jQuery.each(xml.split('\r\n'), function(index, node) {
		var indent = 0;
		if (node.match( /.+<\/\w[^>]*>$/ )) {
			indent = 0;
		} else if (node.match( /^<\/\w/ )) {
			if (pad != 0) {
				pad -= 1;
			}
		} else if (node.match( /^<\w([^>]*[^\/])?>.*$/ )) {
			indent = 1;
		} else {
			indent = 0;
		}

		var padding = '';
		for (var i = 0; i < pad; i++) {
			padding += '  ';
		}

		formatted += padding + node + '\r\n';
		pad += indent;
	});

	return formatted;
}



function getAnswerItemByID(ID, container)
{
	//finds an answer item within container element
	try{
		//alert(ID + ':' + $(container).find(':input[value^="' + ID + '"]').length);
		return $(container).find(':input[value^="' + ID + '"]');
		}
	catch(e)
	{
		alert(e + ", ID = " + ID);
	}

}


function getAnswerID(answerElement)
{
	
	var id = $(answerElement).attr('value');
	if (id === undefined || id === null) {
		 // do something 
		 alert("Error in getAnswerID: value attribute not found.");
		 alert($(answerElement).length);
	}
	if(id.indexOf(',')>0)
		id = id.substring(0, id.indexOf(','));
	return id;
}
/*
function getQuestionID(answerElement)
{
	var id = answerElement.attr('name');
	return id;
}
*/

function getSectionID(answerElement)
{
	var $section = $(answerElement).parentsUntil('table').parent();
	//alert($section.get(0).nodeName);
	var sectionid = '';
	if($section.length>0)
	{
		sectionid = $section.get(0).id.substring(1);
	}
	return sectionid;
}

function getAnswerSection(answerElement)
{
   //returns DOM element
	var $section = $(answerElement).parentsUntil('table').parent();
	
	//return the first in the list
	return $($section.get(0));
}

function isSDSAnswer(answerElement)
{
	//alert('isSDS');
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	var attr = $answer.attr('selectionDeselectsSiblings');

	// For some browsers, 'attr' is undefined; for others,
	// 'attr' is false.  Check for both.
	if (typeof attr !== typeof undefined && attr !== false) {
		return true;
	}
	else{
		return false;
	}
}

function isFillinAnswerChoice(answerElement)
{
//checks if the checkbox or radio button has fillin-abswer box
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	//alert($answer.child().attr(
	if ($answer.has('> ListItemResponseField').length>0)
		return true;
	else
		return false;	
}

function isFillinInput(answerElement)
{
	//checks if the input box is a fill-in answer input box
	alert($(answerElement).prev().type());
}


function isSDCAnswer(answerElement)
{
	//alert('isSDC');
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	var attr = $answer.attr('selectionDisablesChildren');

	// For some browsers, 'attr' is undefined; for others,
	// 'attr' is false.  Check for both.
	if (typeof attr !== typeof undefined && attr !== false) {
		return true;
	}
	else{
		return false;
	}		
}

function isNestedAnswer(answerElement)
{
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	if($answer.length==0)
		alert('Error in isNestedAnswer');
	var $parent = $answer.parentsUntil('Question').parent();
	if($parent.length==0)
		alert('Error in isNestedAnswer');
	
	if($parent.parent().get(0).nodeName=='ChildItems')
	{
		if($parent.parent().parent().get(0).nodeName=='ListItem')
			return true;
		else
			return false;
	}
	else
	{
		return false;
	}
}

function getAnswerSiblings(answerElement)
{
	//returns xml nodes
	
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	return $answer.siblings('ListItem');
}

function getNestedAnswers(answerElement)
{
	//return xml nodes
	
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	return $answer.children("ChildItems").children("Question").children("ListField").children("List").children("ListItem");
}

function getParentAnswerID(answerElement)
{
	//finds answer in xml and returns parentAnswerID
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	if($answer.length==0)
	{
		alert('Error in getParentAnswerID: answerElement not found.answerid=' + answerid);
	}
	var $parent = $answer.parentsUntil('Question').parent();
	if($parent.length==0)
		alert('Error in getParentAnswerID: Question element not found.');
	if($parent.parent().get(0).nodeName=='ChildItems')
	{
		if($parent.parent().parent().get(0).nodeName=='ListItem')
		{
			return $parent.parent().parent().attr('ID');
		}
		else{
			//no parent answer
			return "";
		}
	}
	else
		alert('Error in getParentAnswerID');

}


function isAnswerSelected(answerElement)
{
	return $(answerElement).is(':checked');

}

function SelectAnswer(answerElement, section)
{
	$(answerElement).prop('checked',true);
	$(answerElement).parent().find('.AnswerTextBox').prop('disabled',false);
	
	//if there are any SDS answers they will need to be unchecked
	var $siblings = getAnswerSiblings(answerElement);
	$siblings.each(function() {
		var id = $(this).attr("ID");
		var testElement = getAnswerItemByID(id, section);
		if(isSDSAnswer($(answerElement)))  //if this answer element is SDS, unselect all siblings
		{
			UnSelectAnswer(testElement, section);
		}
		else if(isSDSAnswer(testElement))//if this sibling is SDS 
		{
		   UnSelectAnswer(testElement, section);
		}
		else if ($(answerElement).is(":radio"))  //if this is a single select make sure the siblings and their children are unselected
		{
			
			UnSelectAnswer(testElement, section);
		}
	}
	)
	
}

function UnSelectAnswer(answerElement, section)
{
	//unselects answerElement and its children recursively
	if(!$(answerElement).is(":checkbox, :radio")) return;
	
		$(answerElement).prop('checked',false);
		
	//unselect all child answers
	var $childanswers = getNestedAnswers(answerElement);
	
	$childanswers.each(function(){
		var childid = $(this).attr("ID");									
		
		var childelement = getAnswerItemByID(childid, section);
		
		UnSelectAnswer(childelement,section);
	})
		

}

function DisableAnswer(answerElement)
{
	$(answerElement).prop('disabled',true);
	//disble children
	$(answerElement).find('*').prop('disabled', true);
	
	
	
}

function EnableAnswer(answerElement)
{
	$(answerElement).prop('disabled',false);
}

function getSelectedListItems(listitems, section)
{
	var $selecteditems = [];
	
	listitems.each(function() {
		var $answeritem = getAnswerItemByID($(this).attr('ID'),section);
		if(($answeritem).is(':checked'))
			$selecteditems.push($answeritem);
	});
	
	return $selecteditems;
}



function UncheckChildAnswers(currentInput)
{
	var test;
	
	$(currentInput).find(':input:checked').prop('checked', false);
}



function UncheckSiblings(currentInput)
{

}
function getSelectedSiblings(currentInput)
{
	var count =0 ;
	var siblings = $(currentInput).parent().siblings();
	siblings.each(function() {
		if($(this).get(0).className=='Answer')
		{
			
			if ($(this).find(':input').is(':checked'))
				count++;
		}
			
	});
	if($(currentInput).is(':checked'))
		count++;
	return count;
}

function SelectUnselectDescendents(parentQuestion, event)
{

}

function SelectUnselectChoiceOnBlur(choiceID, element)
{
	var $section = getAnswerSection(element);
	
	var $answeritem = getAnswerItemByID(choiceID, $section);
	
	return;
	
	if($(element).val()!='')
		SelectAnswer($answeritem, $section);
	else
		UnSelectAnswer($answeritem, $section);
}

function OnChoiceBlur(choiceID, element)
{
	var $section = getAnswerSection(element);
	
	//alert(choiceID);
	var $answeritem = getAnswerItemByID(choiceID, $section);
    	
	
	var $input = $answeritem.parent().find('.AnswerTextBox');
	
	$input.removeClass('error');
	
	if(!$answeritem.is(':checked'))
	{
		
		if($input.val()!='')
		{
			
			//$answeritem.siblings('input').addClass('error');
			//$input.removeClass('error');
			//$input.addClass('error');
			//alert($input.val());
		}
		//$input.prop('disabled',true);
		
	}
}

//changing fill-in value calls this function
function SelectChoiceOnKeyPress(choiceID, element, event)
{
	
	//if control characters return
	var keycode = (event.keyCode ? event.keyCode : event.which);
	
	if(keycode==8) return;
		
	
	var $answeritem = $(element).parent().find('input:radio, input:checkbox');
	
	$($answeritem).prop('checked',true);
	
	var $section = getAnswerSection($answeritem.get(0));
	var parentid = getParentAnswerID($answeritem.get(0));
	if(parentid==null || parentid=='')
		return;
	
	var parent = getAnswerItemByID(parentid, $section);
	
	SelectAnswer(parent, $section);	
}


function SelectUnselectParents(parentQuestion, element)
{
	
	/* parentQuestion: questionid of the answer clicked */
	if (!$(element).is(":checkbox, :radio"))  //only if the element is a radio or a checkbox
	{
		
		return;
	}
	var issingleselect = $(element).is(":radio");
	var answerid = getAnswerID(element);  //$(event.target).attr("name");
	//alert(answerid);
	var selecttype = $(element).attr('type');
	var $section = getAnswerSection(element);
	var $answeritem = getAnswerItemByID(answerid, $section);
	var selected = $answeritem.is(':checked');  //value is true or false
	var sectionId = getSectionID(element);
	
	
	var $siblings = getAnswerSiblings(element);
	var $childanswers = getNestedAnswers(element);
	
	
	var parentid = getParentAnswerID(element);
	
	
	
	var selectedsiblings = $(getSelectedListItems($siblings,$section)).length;
	
	/*
	SELECT/UNSELECT PARENT ANSWER
	if current item or one or more of its siblings are selected
	  select the parent answer
	*/
	if( selected || (selectedsiblings > 0))
	{
		//select parent answer
		
		if(parentid=="")
		{
			//alert('no parent answer');
		}
		else{
			var parent = getAnswerItemByID(parentid, $section);	
			
			//if parent is SDC, don't select it 
			if(!isSDCAnswer(parent))
			{	
				SelectAnswer(parent, $section);											
			}
		}									
		
	}
	else  //neither this answer nor any of its siblings are selected, unselect parent
	{
		//unselect parent answer
		UnSelectAnswer(getAnswerItemByID(parentid, $section),$section);
	
	}
	
	/*
	 UNSELECT all child answers if current answer is not selected
	*/
	
	if(selected==false){
		//unckeck all children
		
		$childanswers.each(function(){
			var childid = $(this).attr("ID");
			UnSelectAnswer(getAnswerItemByID(childid, $section),$section);
		})
	}
	
	
	//selection disables children
	if (isSDCAnswer(element) & selected)
	{
	   try{
			//go to the Answer level and disable all answer choices at first
			$(element).parent().parent().find('* [type=checkbox], [type=radio], [type=text]').prop('disabled', true);
			//uncheck all answers
			$(element).parent().parent().find('* [type=checkbox],[type=radio]').prop('checked', false);
			//enable just this answer
			EnableAnswer(element);  //EnableAnswer will enable checkbox/radio and fill-in box 
			//check just this answer
			SelectAnswer(element, $section);
	   }
	   
	   catch(err)
	   {
			alert(err);
	   }
		
		
	}
	else 
	{
		//enable children
										
		try{
			$(element).parent().parent().find('* [type=checkbox], [type=radio]').prop('disabled', false);
			
	   }
	   
	   catch(err)
	   {
			alert(err);
	   }
	
	}
	
	
	//selection deselects siblings
	if(isSDSAnswer(element) & selected)
	{
		//unselect all siblings
		$siblings.each(function() {
	
			var id = $(this).attr("ID");
			UnSelectAnswer(getAnswerItemByID(id, $section), $section);  //unselect will disable fill-in also
		})
	}
	else if(!isSDSAnswer(element) & selected)
	{
		//all SDSAnswers must be unselected
		$siblings.each(function() {
			
			var id = $(this).attr("ID");
			var testElement = getAnswerItemByID(id, $section);
			
			if(isSDSAnswer(testElement))
			   UnSelectAnswer(testElement, $section);    //unselect will disable fill-in also
			
		})
	
	}
	
	
	
	//enable/disable fillin boxes
	if(selected & isFillinAnswerChoice(element))
	{
		//enable fillin box
		//var $input = $(element).parent().find('.AnswerTextBox');
		//$input.prop('disabled',false);
		
	}
	else if (!selected & isFillinAnswerChoice(element))
	{
		//disable fillin box
		//var $input = $(element).parent().find('.AnswerTextBox');
		//$input.prop('disabled',true);
		
	}
	
	if(selected & $(element).is(":radio"))
	{ 
		$siblings.each(function(){
			var sibling = $(this);
		UnSelectAnswer(sibling, $section);
				
		});
	}

	
}



								
						]]>
					</xsl:text>
					
					
					
				</script>
			<script>
			
			</script>
			 
            </head>
            <!-- <body align="left" onload='loadXml()'> -->
			<body align="left">
			
			<nav style="position: fixed; font-size:smaller;" id="navBar">
				<!--<a id="linkxml" href="#" onclick="toggleviewxml()">Show Xml</a>
				<br />-->
			 
               <a href="##" onclick="toggle_metadata();">
                  Toggle Metadata
               </a>
              <br/>
			   
               <a href="##" onclick="toggle_id();">
                  Toggle IDs
               </a>
              <br/>
			  
			  <a style='display:inline-block; max-width:100px' href="##" id='mnuRequired' onclick="toggle_mustImplement();">
                  Toggle optional items
              </a>
			 <br/>
			 
			  <a href="##" class="collapse_all_control">
				Toggle All
			  </a><br/>
				 
			 <a href="##" class="collapse_control">
				Toggle Sections
			 </a><br/>
			 
			 <a href="##"  class="collapse_q_control">
				Toggle Questions
			 </a>
			
            </nav>
            	
            	<!--hidden textbox to store rawxml at run time-->
            	<!--<input type="hidden" id = "rawxml"/>-->
            	<!--<textarea rows="10" style="width:90%;margin:40px;background-color:lightyellow" id = 'rawxml'> 
		               <xsl:copy-of select="node()"/>
		               
         		</textarea>	-->
				
				<div class="BodyGroup">
					<!--
					<xsl:if test="$show-toc='true' and count($template-links/template-link) &gt; 0">
						<xsl:attribute name="style">
							<xsl:text>float:left</xsl:text>
						</xsl:attribute>
					</xsl:if>
					-->
					<div id="confirmBox">
						<div class="message"></div>
						<span class="yes">Yes</span>
						<span class="no">No</span>
					</div>
					
					
					<!--<textarea id="rawxml" />-->
					
					<div id="MessageData" style="display:none;">
						<table class="HeaderGroup" align="center">
							<tr>
								<td>
									
									<div class="TopHeader">
										Structured Report Data
									</div>
									<div id="MessageDataResult" class="MessageDataResult"/>
									
									
									<div class="SubmitButton">
										<input type="button" value="Back" onClick="javascript:closeMessageData()" />
									</div>
								</td>
							</tr>
						</table>
					</div>
					
					<br style="clear:both"/>
						
					<div id="response" style="display:none;">
					</div>
					
					<div id="FormData">
					    
						
						<form id="checklist" name="checklist" method="post" >
							<xsl:attribute name="action">
								<!--<xsl:value-of select="$form-action"/>-->
							</xsl:attribute>
							
							<!--formInstanceURI, formInstanceVersionURI, formPreviousInstanceVersionURI-->
							<div class="form-version">								
								<xsl:if test="//x:FormDesign/@formInstanceURI">
									<p>
										Form Instance: 
										<xsl:value-of select="//x:FormDesign/@formInstanceURI"/>
									</p>
								</xsl:if>
								<xsl:if test="//x:FormDesign/@formInstanceVersionURI">
									<p>
										Version: 
										<xsl:value-of select="//x:FormDesign/@formInstanceVersionURI"/>
									</p>
								</xsl:if>
								<xsl:if test="//x:FormDesign/@formPreviousInstanceVersionURI">
									<p>
										Previous Version: 
										<xsl:value-of select="//x:FormDesign/@formPreviousInstanceVersionURI"/>
									</p>
								</xsl:if>
							</div>
							
							<div class='formTitle'>
								<xsl:value-of select="//x:FormDesign/@formTitle"/>
							</div>
			
							<!--show properties under form-design-->
							<div>
							<div id='columnarblock'>							
								<div id='left-column'>
									<xsl:for-each select="//x:FormDesign/x:Property">
										<xsl:if test="@val">
											<xsl:variable name="textstyle" select="@styleClass"/>
											<xsl:if test='not(@styleClass)'>
												<p class='{$textstyle}'>
												<b><xsl:value-of select="@propName"/></b>
												<xsl:if test="@propName">
													:
												</xsl:if>
												<xsl:value-of select="@val"/>
												</p>
											</xsl:if>
										</xsl:if>
									</xsl:for-each>
								</div>
								<div id='right-column'>
									
										<xsl:for-each select="//x:FormDesign/x:Property">
											<xsl:if test="@val">
												<xsl:variable name="textstyle" select="@styleClass"/>
												<xsl:if test='$textstyle="right" or $textstyle="float-right"'>
													<p class='{$textstyle}'>
													<b><xsl:value-of select="@propName"/></b>
													<xsl:if test="@propName">
														:
													</xsl:if>
													<xsl:value-of select="@val"/>
													</p>
												</xsl:if>
											</xsl:if>
									</xsl:for-each>
								</div>
							</div>
							</div>
			
							<!--show header-->
							<xsl:if test="//x:Header">
								<xsl:variable name="title_style" select="//x:Header/@styleClass"/>
								<xsl:variable name='title_id' select="//x:Header/@ID"/>
								<div ID = '{$title_id}' class="Header_{$title_style}">								
									<xsl:value-of select="//x:Header/@title"/>
								</div>
								<div style="clear:both"/>
								<hr/>
								
								<div>
								<xsl:for-each select="//x:Header/x:Property">
									<xsl:if test="@val">
									
										<xsl:variable name="textstyle" select="@styleClass"/>
										<p class='{$textstyle}'>
											<b><xsl:value-of select="@propName"/></b>
											<xsl:if test="@propName">
												:
											</xsl:if>
											<xsl:value-of select="@val"/>
										</p>
									</xsl:if>								
								</xsl:for-each>
									
								</div>
							</xsl:if>
							<div style="clear:both"></div>
							
							<!--Demo-->		
							<xsl:if test="//x:DemogFormDesign">
								<a style="text-decoration:none;color:black;font-weight:bold;font-size:large" id="demshowhide" href="#" onclick="ShowHideDemo()">+ Demographics</a>
								<div id="divdemo" style="display:none">								
									<xsl:apply-templates select="//x:DemogFormDesign/x:Body/x:ChildItems/x:Section" mode="level1" >
										<xsl:with-param name="required" select="$required" />
										<xsl:with-param name="parentId" select="'*'"/>  
										<xsl:with-param name="defaultStyle" select="'TopHeaderDemo'"/>
									</xsl:apply-templates>
									<xsl:apply-templates select="//x:DemogFormDesign/x:Body/x:ChildItems/x:Question" mode="level2" >
										<xsl:with-param name="required" select="$required" />
										<xsl:with-param name="parentId" select="'*'"/>   
									</xsl:apply-templates>
								</div>
							</xsl:if>
							<hr/>
							<!--show body-->
							<xsl:apply-templates select="//x:FormDesign/x:Body/x:ChildItems/x:Section|//x:FormDesign/x:Body/x:ChildItems/x:DisplayedItem" mode="level1">
								<xsl:with-param name="required" select="$required" />
								<xsl:with-param name="parentId" select="'*'"/> <!--parentId = * for outermost --> 
								<xsl:with-param name="defaultStyle" select="'TopHeader'"/>
							</xsl:apply-templates>
							
							<!--<xsl:apply-templates select="//x:FormDesign/x:Body/x:ChildItems/x:Question" mode="level2" >-->
							<xsl:apply-templates select="//x:FormDesign/x:Body/x:ChildItems/x:Question" mode="level1" >
								<xsl:with-param name="required" select="$required" />
								<xsl:with-param name="parentId" select="'*'"/>  <!--parentId = * for outermost --> 
							</xsl:apply-templates>
							
							<!--<xsl:if test="contains($form-action, 'http') or contains($form-action, 'javascript')">-->
								<!--remove submit button for the desktop verion-->
								<div style="clear:both"/>
								<div class="SubmitButton">
									<input type="submit" id="send" value="Submit" onclick="javascript:openMessageData(1);return false;"/>
								</div>
							<!--</xsl:if>-->
						</form>
					</div>
				</div>
            </body>
        </html>
    </xsl:template>
   
    <xsl:template match="//x:Header">
       
       
    </xsl:template>
	
	<!--sections within body and other sections directly inside sections-->
	<xsl:template match="x:Section" mode="level1">
		<xsl:param name="parentSectionId"/>	
		<xsl:param name="defaultStyle"/>
		<!--<xsl:if test="string-length(@title) &gt; 0">--> <!--do not show if there is no title-->
			<xsl:if test="not (@visible) or (@visible='true')">
				<xsl:variable name="required" select="true"/>
				<xsl:variable name="style" select="@styleClass"/>
				<!--<xsl:variable name="defaultStyle" select="'TopHeader'"/>-->
				<xsl:variable name="sectionId" select="concat('s',@ID)"/>
				<div> 					
					<xsl:attribute name="id">
						<xsl:value-of select="$sectionId"/>						
					</xsl:attribute>
	  				<xsl:if test="@mustImplement='false'">
						<div class='mustImplement'></div>
					</xsl:if>
					<input id = "maxcardinality" type="hidden">
						<xsl:attribute name="value">
							<xsl:value-of select="@maxCard"/>
						</xsl:attribute>						
					</input>
					
					<!-- table is repeated if cardinality is greater than 1 and id value will be incremented-->
					<table class="HeaderTable" align="center">					   
					   <xsl:attribute name="id">
						<xsl:value-of select="$sectionId"/>
					   </xsl:attribute>
						<tr>
							<td>								
								<xsl:choose>
									<xsl:when test="$style!=''">
										<div class="{$style} collapsable">										
											<xsl:value-of select="@title"/>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="count(ancestor::x:Section)= 0">
												<div class="{$defaultStyle} collapsable">
													<!-- new code -->
													<xsl:call-template name="ItemWithID">
													   <xsl:with-param name="required" select="required"/>
													</xsl:call-template>
													
													<xsl:value-of select="@title"/>	
													<div style="display:inline" class="MetadataDisplay">
														<!---metadata-->
													</div>													
												</div>
												<div style='clear:both'/>
											</xsl:when>
											<xsl:when test="count(ancestor::x:Section)= 1">
												<div class="{$defaultStyle}2 collapsable">
													<!-- new code -->
													<xsl:call-template name="ItemWithID">
													   <xsl:with-param name="required" select="required"/>
													</xsl:call-template>
													
													<xsl:value-of select="@title"/>	
													<div style="display:inline" class="MetadataDisplay">
														<!---metadata-->
													</div>													
												</div>
												<div style='clear:both'/>
											</xsl:when>
											<xsl:when test="count(ancestor::x:Section)= 2">
												<div class="{$defaultStyle}2 collapsable">
													<!-- new code -->
													<xsl:call-template name="ItemWithID">
													   <xsl:with-param name="required" select="required"/>
													</xsl:call-template>
													
													<xsl:value-of select="@title"/>	
													<div style="display:inline" class="MetadataDisplay">
														<!---metadata-->
													</div>
												</div>
											</xsl:when>
											<xsl:otherwise>
												<div class="{$defaultStyle}2 collapsable">
													<!-- new code -->
													<xsl:call-template name="ItemWithID">
													   <xsl:with-param name="required" select="required"/>
													</xsl:call-template>
													
													<xsl:value-of select="@title"/>	
													<div style="display:inline" class="MetadataDisplay">
														<!---metadata-->
													</div>
												</div>
											</xsl:otherwise>
											
										</xsl:choose>
										
									</xsl:otherwise>
								</xsl:choose>
								<!--show link here?-->
								<xsl:for-each select="x:Link">					
									<xsl:call-template name="handle_link"/>
								</xsl:for-each>

								<xsl:choose>
									<xsl:when test="$required='false'">

									</xsl:when>
									<xsl:otherwise>	
										<xsl:apply-templates select="x:ChildItems/x:Question | x:ChildItems/x:Section | x:ChildItems/x:DisplayedItem" mode="level1" >
											<xsl:with-param name="required" select="'true'"/>
											<xsl:with-param name="parentSectionId" select="$sectionId"/>
											<xsl:with-param name="defaultStyle" select="$defaultStyle"/>
										</xsl:apply-templates>

									</xsl:otherwise>
								</xsl:choose>
								<div style="clear:both"/>
								
								<xsl:if test="@maxCard&gt;1">
								
									<input type="button" class="btnAdd" onclick="addSection(this)" value="+"/>
									<input type="button" class ="btnRemove" onclick="removeSection(this)" value="-">
										<xsl:attribute name = "style">
											<xsl:value-of select="'visibility:hidden;'"/>
										</xsl:attribute>
									</input>
								</xsl:if>
							</td>
						</tr>
					</table>
				</div>
			
			</xsl:if>
		<!--</xsl:if>-->
	</xsl:template>
	
	<!--section within a list item -->
	<xsl:template match="x:Section" mode="level2">
		<xsl:param name="parentSectionId"/>	
		<xsl:param name="defaultStyle"/>		
		<xsl:if test="not (@visible) or (@visible='true')">
			<xsl:variable name="required" select="true"/>
			<xsl:variable name="style" select="@styleClass"/>
			<!--<xsl:variable name="defaultStyle" select="'TopHeader2'"/>-->
			<xsl:variable name="sectionId" select="concat('s',@ID)"/>
			
			<div class="section_wthin_list"> 				
				<xsl:attribute name="id">
					<xsl:value-of select="$sectionId"/>					
				</xsl:attribute>
				<xsl:if test="@mustImplement='false'">
					<div class='mustImplement'></div>
				</xsl:if>
				<input id = "maxcardinality" type="hidden">
					<xsl:attribute name="value">
						<xsl:value-of select="@maxCard"/>
					</xsl:attribute>					
				</input>
				
				
				<!-- table is repeated if cardinality is greater than 1 and id value will be incremented-->
				<table class="HeaderTableChild" align="center">					
					<xsl:attribute name="id">
						<xsl:value-of select="$sectionId"/>
					</xsl:attribute>
					<tr>
						<td>
							<xsl:choose>
								<xsl:when test="$style!=''">
									<div class="{$style}">	
										<!-- new code -->
										<xsl:call-template name="ItemWithID">
										   <xsl:with-param name="required" select="required"/>
										</xsl:call-template>
										
										<xsl:value-of select="@title"/>
										<div style="display:inline" class="MetadataDisplay">
											<!---metadata-->
										</div>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="{$defaultStyle} collapsable">
										<!-- new code -->
										<xsl:call-template name="ItemWithID">
										   <xsl:with-param name="required" select="required"/>
										</xsl:call-template>
										
										<xsl:value-of select="@title"/>
										<div style="display:inline" class="MetadataDisplay">
											<!---metadata-->
										</div>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							<!--show link here?-->
							<xsl:for-each select="x:Link">					
								<xsl:call-template name="handle_link"/>
							</xsl:for-each>

							<xsl:choose>
								<xsl:when test="$required='false'">
									
								</xsl:when>
								<xsl:otherwise>	
									<xsl:apply-templates select="x:ChildItems/x:Question | x:ChildItems/x:Section" mode="level2" >
										<xsl:with-param name="required" select="'true'"/>
										<xsl:with-param name="parentSectionId" select="$sectionId"/>
										<xsl:with-param name="defaultStyle" select="$defaultStyle"/>
									</xsl:apply-templates>
									
								</xsl:otherwise>
							</xsl:choose>
							<div style="clear:both"/>
							<xsl:if test="@maxCard&gt;1">
							
								<input type="button" class="btnAdd" onclick="addQuestion(this)" value="+"/>
								<input type="button" class ="btnRemove" onclick="removeQuestion(this)" value="-">
									<xsl:attribute name = "style">
										<xsl:value-of select="'visibility:hidden;'"/>
									</xsl:attribute>
								</input>
							</xsl:if>
						</td>
					</tr>
				</table>
			</div>
			
		</xsl:if>
	</xsl:template>
	
	<!--question in section-->
	<xsl:template match="x:Question" mode="level1">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>
			<div class='question'>
				<xsl:attribute name="id">
					<xsl:value-of select="$questionId"/>	
				</xsl:attribute>
				
				<input type="hidden" class="TextBox">
					<xsl:attribute name="name">
						<xsl:value-of select="$questionId"/>
					</xsl:attribute>				
					<xsl:attribute name="value">
						<xsl:value-of select="@title"/>
					</xsl:attribute>
				</input>
				<input id = "maxcardinality" type="hidden">
					<xsl:attribute name="value">
						<xsl:value-of select="@maxCard"/>
					</xsl:attribute>					
				</input>
				<div class="QuestionInSection">   <!--two columns-->
					<xsl:if test="@mustImplement='false'">
						<div class='mustImplement'></div>
					</xsl:if>
					<div class="QuestionTitle collapsable_q">
					
						<!-- new code -->
						<xsl:call-template name="ItemWithID">
						   <xsl:with-param name="required" select="required"/>
						</xsl:call-template>
						
						<xsl:value-of select="@title"/> 
						<div style="display:inline" class="metadata">
							<!---metadata-->
						</div>
						
						<!-- new code placement -->
						<xsl:call-template name="QuestionSectionAttributes"/>
						
						<xsl:if test="not(x:ResponseField) and not(@readOnly)">
							 <a class="QuestionReset">
							 <xsl:attribute name="href">
								#
							  </xsl:attribute>
							  <xsl:attribute name="onclick">
								 javascript:resetAnswer('<xsl:value-of select="substring($questionId,2)"/>',event);return false;
							  </xsl:attribute>
							  <xsl:text>(reset)</xsl:text>
							</a>
						</xsl:if>
						<xsl:if test="x:ResponseField">
							<xsl:call-template name="ResponseFieldAttributes"/>
							<input type="text" class="TextBox">
								<xsl:attribute name="name">
									<xsl:value-of select="substring($questionId,2)"/>
								</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="x:ResponseField/x:Response//@val"/>
								</xsl:attribute>
							</input>
						</xsl:if>
						
						
						
						<!--show link here?-->
						<xsl:for-each select="x:Link">					
							<xsl:call-template name="handle_link"/>
						</xsl:for-each>

					</div>
					
					<div class='command'>
						<xsl:if test="@maxCard&gt;1">				
							<input type="button" class="btnAdd" onclick="addQuestion(this)" value="+"/>
							<input type="button" class ="btnRemove" onclick="removeQuestion(this)" value="-">
								<xsl:attribute name = "style">
									<xsl:value-of select="'visibility:hidden;'"/>
								</xsl:attribute>
							</input>
						</xsl:if>
					</div>
						
					<div style="clear:both;"/>
					
					<xsl:if test="x:ListField">
					  <xsl:apply-templates select="x:ListField" mode="level1">
						  <xsl:with-param name="questionId" select="$questionId" />
						  <xsl:with-param name="parentSectionId" select="$parentSectionId" />
					  </xsl:apply-templates>
					</xsl:if>
					
					<!--11/13/2016: question within question-->
					<div style="clear:both;"/>
					<xsl:if test="x:ChildItems/x:Question">	
					 
						<xsl:apply-templates select="x:ChildItems/x:Question" mode="level3">
							<xsl:with-param name="parentSectionId" select="$parentSectionId" />
						</xsl:apply-templates>
					</xsl:if>
					
				</div>
		</div>
		
	</xsl:template>

	
	<!--question in list item-->
<xsl:template match="x:Question" mode="level2">
	<xsl:param name="parentSectionId"/>
	<xsl:variable name="questionId" select="concat('q',@ID)"/>
	<div class='question'>
		<xsl:attribute name="id">
			<xsl:value-of select="$questionId"/>						
		</xsl:attribute>
		<input type="hidden" class="TextBox">
			<xsl:attribute name="name">
				<xsl:value-of select="$questionId"/>
			</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="@title"/>
			</xsl:attribute>
		</input>
		<input id = "maxcardinality" type="hidden">
			<xsl:attribute name="value">
				<xsl:value-of select="@maxCard"/>
			</xsl:attribute>					
		</input>
		<div class="QuestionInListItem"> 	 
			<xsl:if test="@mustImplement='false'">
				<div class='mustImplement'></div>
			</xsl:if>
			<xsl:choose>
				<!--not showing the hidden question-->
				<xsl:when test="string-length(@title)&gt;0">
					<div class="QuestionTitle collapsable_q">
						<div style="display:inline" class="idDisplay">
							<xsl:value-of select="substring-before(@ID, '.')"/> -
						</div>
						<xsl:value-of select="@title"/>
						<div style="display:inline" class="MetadataDisplay">
							<!---metadata-->
						</div>
					
						<!-- new code placement -->
						<xsl:call-template name="QuestionSectionAttributes"/>
						
						<xsl:if test="not(x:ResponseField) and not(@readOnly)">
							<a class="QuestionReset">
								<xsl:attribute name="href">
									#
								</xsl:attribute>
								<xsl:attribute name="onclick">
									javascript:resetAnswer('<xsl:value-of select="substring($questionId,2)"/>',event);return false;
								</xsl:attribute>
								<xsl:text>(reset)</xsl:text>
							</a>
						</xsl:if>
						<xsl:if test="x:ResponseField">
							<input type="text" class="TextBox">
								<xsl:attribute name="name">
									<xsl:value-of select="substring($questionId,2)"/> <!--drop q-->
								</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="x:ResponseField/x:Response//@val"/>
								</xsl:attribute>
							</input>
						</xsl:if>
					
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="QuestionTitle collapsable_q">
						<!-- new code -->
						<xsl:call-template name="ItemWithID">
						   <xsl:with-param name="required" select="required"/>
						</xsl:call-template>
						
						<div style="display:inline" class="MetadataDisplay">
							<!---metadata-->
						</div>
					</div>
					<!--reset for hidden field-->
					<xsl:if test="not(x:ResponseField) and not(@readOnly)">
						<a class="QuestionReset">
						<xsl:attribute name="href">
						#
					  </xsl:attribute>
						  <xsl:attribute name="onclick">
							 javascript:resetAnswer('<xsl:value-of select="substring($questionId,2)"/>',event);return false;
						  </xsl:attribute>
						  <xsl:text>(reset)</xsl:text>
						</a>
					</xsl:if>
					
					<xsl:if test="x:ResponseField">
						<input type="text" class="TextBox">
							<xsl:attribute name="name">
								<xsl:value-of select="substring($questionId,2)"/>
							</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="x:ResponseField/x:Response//@val"/>
							</xsl:attribute>
						</input>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>		
		
			<div class='command'>
				<xsl:if test="@maxCard&gt;1">				
					<input type="button" class="btnAdd" onclick="addQuestion(this)" value="+"/>
					<input type="button" class ="btnRemove" onclick="removeQuestion(this)" value="-">
						<xsl:attribute name = "style">
							<xsl:value-of select="'visibility:hidden;'"/>
						</xsl:attribute>
					</input>
				</xsl:if>
			</div>
					
			<div style="clear:both;"/>
			<xsl:if test="x:ListField">
				<xsl:apply-templates select="x:ListField" mode="level1">
					<xsl:with-param name="questionId" select="$questionId" />
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
		
			<!--11/13/2016: question within question-->
			<!--<xsl:if test="x:ChildItems/x:Section">			-->
				<xsl:apply-templates select="x:ChildItems/x:Section | x:ChildItems/x:Question" mode="level2">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
					<xsl:with-param name="defaultStyle" select="'TopHeader2'"/>
				</xsl:apply-templates>
			<!--</xsl:if>-->
		
		</div>
	</div>
</xsl:template>

	<!--question in question-->
	<xsl:template match="x:Question" mode="level3">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>	
		<div class='question'>
		<xsl:attribute name="id">
			<xsl:value-of select="$questionId"/>						
		</xsl:attribute>
		<input type="hidden" class="TextBox">
			<xsl:attribute name="name">
				<xsl:value-of select="$questionId"/>
			</xsl:attribute>				
			<xsl:attribute name="value">
				<xsl:value-of select="@title"/>
			</xsl:attribute>
		</input>
		
		<input id = "maxcardinality" type="hidden">
			<xsl:attribute name="value">
				<xsl:value-of select="@maxCard"/>
			</xsl:attribute>					
		</input>
		
		<div class="QuestionInQuestion"> 
			<xsl:if test="@mustImplement='false'">
				<div class='mustImplement'></div>
			</xsl:if>		
			<div class="QuestionTitle collapsable_q">
				<!-- new code -->
				<xsl:call-template name="ItemWithID">
				   <xsl:with-param name="required" select="required"/>
				</xsl:call-template>
						
				<xsl:value-of select="@title"/>
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
				
				<!-- new code placement -->
				<xsl:call-template name="QuestionSectionAttributes"/>
						
				<xsl:if test="not(x:ResponseField) and not(@readOnly)">
					 <a class="QuestionReset">
					 <xsl:attribute name="href">
						#
					  </xsl:attribute>
					  <xsl:attribute name="onclick">
						 javascript:resetAnswer('<xsl:value-of select="substring($questionId,2)"/>',event);return false;
					  </xsl:attribute>
					  <xsl:text>(reset)</xsl:text>
					</a>
				</xsl:if>				
				<xsl:if test="x:ResponseField"> 
					<input type="text" class="TextBox">
						<xsl:attribute name="name">
							<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="x:ResponseField/x:Response//@val"/>
							<!--<xsl:value-of select="substring($expandedId,2)"/>-->
						</xsl:attribute>
					</input>
				</xsl:if>
				
				
				
				<!--show link here?-->
				<xsl:for-each select="x:Link">					
					<xsl:call-template name="handle_link"/>
				</xsl:for-each>

			</div>
			
			<div style="clear:both;"/>
			
			<xsl:if test="x:ListField">
				<xsl:apply-templates select="x:ListField" mode="level1">
					<xsl:with-param name="questionId" select="$questionId" />
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
			
			<div class='command'>
				<xsl:if test="@maxCard&gt;1">				
					<input type="button" class="btnAdd" onclick="addQuestion(this)" value="+"/>
					<input type="button" class ="btnRemove" onclick="removeQuestion(this)" value="-">
						<xsl:attribute name = "style">
							<xsl:value-of select="'visibility:hidden;'"/>
						</xsl:attribute>
					</input>
				</xsl:if>
			</div>
				
			<!--11/13/2016: question within question-->
			<div style="clear:both;"/>
			<xsl:if test="x:ChildItems/x:Question">				
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level3">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
			
		</div>
		</div>
	</xsl:template>
	
	
	<!--question in body-->
	<xsl:template match="x:Question" mode="level5">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>	
		<div class='question'>
		<xsl:attribute name="id">
			<xsl:value-of select="$questionId"/>						
		</xsl:attribute>
		
		<!-- new code -->
		<xsl:call-template name="ItemWithID">
		   <xsl:with-param name="required" select="required"/>
		</xsl:call-template>
		
		<input type="hidden" class="TextBox">
			<xsl:attribute name="name">
				<xsl:value-of select="$questionId"/>
			</xsl:attribute>				
			<xsl:attribute name="value">
				<xsl:value-of select="@title"/>
			</xsl:attribute>
		</input>
		
		<input id = "maxcardinality" type="hidden">
			<xsl:attribute name="value">
				<xsl:value-of select="@maxCard"/>
			</xsl:attribute>					
		</input>
		
		<div class="QuestionInQuestion">  
            <xsl:if test="@mustImplement='false'">
				<div class='mustImplement'></div>
			</xsl:if>		
			<div class="QuestionTitle collapsable_q">
				<!-- new code -->
				<xsl:call-template name="ItemWithID">
				   <xsl:with-param name="required" select="required"/>
				</xsl:call-template>
				
				<xsl:value-of select="@title"/>
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
				<xsl:if test="not(x:ResponseField) and not(@readOnly)">
					 <a class="QuestionReset">
					  <xsl:attribute name="href">
						#
					  </xsl:attribute>
					  
					  <xsl:attribute name="onclick">
						 javascript:resetAnswer('<xsl:value-of select="substring($questionId,2)"/>',event);return false;
					  </xsl:attribute>
					  <xsl:text>(reset)</xsl:text>
					</a>
				</xsl:if>				
				<xsl:if test="x:ResponseField"> 
					<input type="text" class="TextBox">
						<xsl:attribute name="name">
							<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="x:ResponseField/x:Response//@val"/>
							<!--<xsl:value-of select="substring($expandedId,2)"/>-->
						</xsl:attribute>
					</input>
				</xsl:if>
				
				
				<!--show link here?-->
				<xsl:for-each select="x:Link">					
					<xsl:call-template name="handle_link"/>
				</xsl:for-each>

			</div>
			
			<div class='command'>
				<xsl:if test="@maxCard&gt;1">				
					<input type="button" class="btnAdd" onclick="addQuestion(this)" value="+"/>
					<input type="button" class ="btnRemove" onclick="removeQuestion(this)" value="-">
						<xsl:attribute name = "style">
							<xsl:value-of select="'visibility:hidden;'"/>
						</xsl:attribute>
					</input>
				</xsl:if>
			</div>
				
			<div style="clear:both;"/>
			
			<xsl:if test="x:ListField">
				<xsl:apply-templates select="x:ListField" mode="level1">
					<xsl:with-param name="questionId" select="$questionId" />
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
			
			<!--11/13/2016: question within question-->
			<div style="clear:both;"/>
			<xsl:if test="x:ChildItems/x:Question">				
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level3">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
			
		</div>
		</div>
	</xsl:template>

<xsl:template match="x:ListField" mode="level1">
   <xsl:param name="questionId" />
   <xsl:param name="parentSectionId" />  
	<xsl:choose>
		<!--single select-->
		<xsl:when test="@maxSelections='1' or not (@maxSelections)" >
			<xsl:apply-templates select= "x:List/x:ListItem|x:List/x:DisplayedItem" mode="singleselect">
				<xsl:with-param  name="questionId" select ="$questionId"/>
				<xsl:with-param  name="parentSectionId" select ="$parentSectionId"/>	
			</xsl:apply-templates>			
		</xsl:when>	
		<!--multi select-->
		<xsl:otherwise>			
			<xsl:apply-templates select= "x:List/x:ListItem|x:List/x:DisplayedItem" mode="multiselect">
				<xsl:with-param  name="questionId" select ="$questionId"/>
				<xsl:with-param  name="parentSectionId" select ="$parentSectionId"/>	
			</xsl:apply-templates>			
		</xsl:otherwise>		
	</xsl:choose>
</xsl:template>
	
	<xsl:template match="x:ListItem" mode="singleselect">
		<xsl:param name="questionId" />
		<xsl:param name="parentSectionId" />  		
			<div class="Answer">
				<xsl:if test="@mustImplement='false'">
					<div class='mustImplement'></div>
				</xsl:if>
				<input type="radio" style="float:left">
					<xsl:attribute name="name">
						<xsl:value-of select="substring($questionId,2)"/>
					</xsl:attribute>
					<xsl:if test="@selected='true'">
						<xsl:attribute name="checked">
						</xsl:attribute>
					</xsl:if>					
					<xsl:attribute name="value">
						<xsl:value-of select="@ID"/>,<xsl:value-of select="@title"/>
					</xsl:attribute>
					<xsl:attribute name="onchange">
						javascript:SelectUnselectParents('<xsl:value-of select="$questionId" />', this);
					</xsl:attribute>
					<!--<xsl:attribute name="onclick">
						javascript:SelectUnselectParents('<xsl:value-of select="$questionId" />', this)
					</xsl:attribute>-->
					<xsl:attribute name="onblur">
						javascript:OnChoiceBlur('<xsl:value-of select="@ID" />', this)
					</xsl:attribute>
					
				</input> 
				<!-- new code -->
				<xsl:call-template name="ItemWithID">
				   <xsl:with-param name="required" select="required"/>
				</xsl:call-template>
				
				<xsl:value-of select="@title"/>
				<!--show link here?-->
				
				<xsl:for-each select="x:Link">	
				
					<xsl:call-template name="handle_link"/>
				</xsl:for-each>
		
				<!-- new code placement -->
				<xsl:call-template name="ListItemAttributes"/>
				<xsl:call-template name="CommonAttributes"/>
				
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
				<!--answer fillin-->
				<xsl:if test="x:ListItemResponseField">
					<xsl:call-template name="ResponseFieldAttributes"/>
					<input type="text" class="AnswerTextBox">
						<xsl:attribute name="width">
							<xsl:value-of select="100"/>
						</xsl:attribute>
						<xsl:attribute name="name">
							<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="x:ListItemResponseField/x:Response//@val"/>
						</xsl:attribute>
						
						<xsl:attribute name="onkeydown">
							javascript:SelectChoiceOnKeyPress('<xsl:value-of select="@ID" />', this, event)
						</xsl:attribute>
						<xsl:attribute name="onblur">
							javascript:SelectUnselectChoiceOnBlur('<xsl:value-of select="@ID" />', this)
						</xsl:attribute>
						
					</input>
					
					&#xA0;<xsl:value-of select="x:ListItemResponseField/x:TextAfterResponse/@val"/>
					<!--&#xA0;<xsl:value-of select="x:ListItemResponseField/x:ResponseUnits/@val"/>-->
				</xsl:if>
			</div>
			
			<!--property-->
		<!--<xsl:if test="x:Property">
				<div class="property">
					<xsl:value-of select="@name"/>
					<xsl:value-of select="@type"/>
					<xsl:value-of select="@val"/>
				</div>
			</xsl:if>			
			-->
			<!--SRB: 12/18/2016 - handle section within listitem -->
			<xsl:apply-templates select="x:ChildItems/x:Section" mode="level2">
				<xsl:with-param name="parentSectionId" select="$parentSectionId" />
			</xsl:apply-templates>
			<!--question within list-->
			<xsl:apply-templates select="x:ChildItems/x:Question" mode="level2">
				<xsl:with-param name="parentSectionId" select="$parentSectionId" />
			</xsl:apply-templates>	
		<xsl:apply-templates select="x:ChildItems/x:DisplayedItem" mode="singleselect">
			<xsl:with-param name="parentSectionId" select="$parentSectionId" />
		</xsl:apply-templates>	
			
	</xsl:template>
	
	<xsl:template name="handle_link">
	
		<!--show link here?-->
		
			&#160;
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of select="x:LinkURI/@val"/>
				</xsl:attribute>
				<xsl:attribute name="target">
					_blank
				</xsl:attribute>
				<xsl:attribute name="title">
					<xsl:value-of select="x:LinkText/x:Property[@propClass='tooltip']/@val"/>							
				</xsl:attribute>
				<xsl:value-of select="x:LinkText/@val"/>
			</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="x:ListItem" mode="multiselect">
		<xsl:param name="questionId" />
		<xsl:param name="parentSectionId" />  		
			<div class="Answer">
				<xsl:if test="@mustImplement='false'">
					<div class='mustImplement'></div>
				</xsl:if>
				<input type="checkbox" style="float:left;">
					<xsl:attribute name="name">
						<xsl:value-of select="substring($questionId,2)"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="@ID"/>,<xsl:value-of select="@title"/>
					</xsl:attribute>
					<xsl:if test="@selected='true'">
						<xsl:attribute name="checked">
						</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="onchange">
						javascript:SelectUnselectParents('<xsl:value-of select="$questionId" />', this)
					</xsl:attribute>
					<xsl:attribute name="onblur">
						javascript:OnChoiceBlur('<xsl:value-of select="@ID" />', this)
					</xsl:attribute>
				</input>
				<!-- new code -->
				<xsl:call-template name="ItemWithID">
				   <xsl:with-param name="required" select="required"/>
				</xsl:call-template>
				
				<xsl:value-of select="@title"/>
				<!--show link here?-->
				
				<xsl:for-each select="x:Link">					
					<xsl:call-template name="handle_link"/>
				</xsl:for-each>
				
				<!-- new code placement, want to inline this information inside Answer -->
				<xsl:call-template name="ListItemAttributes"/>
				<xsl:call-template name="CommonAttributes"/>
				
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
				<xsl:if test="x:ListItemResponseField">
					<xsl:call-template name="ResponseFieldAttributes"/>
					<input type="text" class="AnswerTextBox">
						<xsl:attribute name="name">
							<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="x:ListItemResponseField/x:Response//@val"/>
						</xsl:attribute>
						
						<xsl:attribute name="onkeydown">
							javascript:SelectChoiceOnKeyPress('<xsl:value-of select="@ID" />', this, event)
						</xsl:attribute>
						<xsl:attribute name="onblur">
							javascript:SelectUnselectChoiceOnBlur('<xsl:value-of select="@ID" />', this)
						</xsl:attribute>
						
					</input>
				</xsl:if>
			</div>
			<!--SRB: 12/18/2016 - handle section within listitem -->
			<xsl:apply-templates select="x:ChildItems/x:Section" mode="level2">
				<xsl:with-param name="parentSectionId" select="$parentSectionId" />
			</xsl:apply-templates>
			<!--question within list-->
			<xsl:apply-templates select="x:ChildItems/x:Question" mode="level2">
				<xsl:with-param name="parentSectionId" select="$parentSectionId" />
			</xsl:apply-templates>
		<xsl:apply-templates select="x:ChildItems/x:DisplayedItem" mode="multiselect">
			<xsl:with-param name="parentSectionId" select="$parentSectionId" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*|/" mode="DisplayedItem">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>
		<xsl:if test="x:DisplayedItem">
			<div> 
				<xsl:if test="@mustImplement='false'">
					<div class='mustImplement'></div>
				</xsl:if>	
				<div class="DisplayedItem">
					<xsl:value-of select="x:DisplayedItem/@title"/> 				
				</div>		
				
				<div style="clear:both;"/>			
			</div>	
		</xsl:if>			
	</xsl:template>
	
	<xsl:template match="x:DisplayedItem" mode="level1">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>
			<div>  
				<xsl:if test="@mustImplement='false'">
					<div class='mustImplement'></div>
				</xsl:if>
				<div class="NoteText">
					<!-- new code -->
					<xsl:call-template name="ItemWithID">
					   <xsl:with-param name="required" select="required"/>
					</xsl:call-template>
					
					<xsl:value-of select="@title"/> 
					<div style="display:inline" class="MetadataDisplay">
						<!---metadata-->
					</div>					
				</div>			
				<div style="clear:both;"/>			
			</div>	
					
	</xsl:template>
	
	<xsl:template match="x:DisplayedItem" mode="singleselect">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>
		<div>  
			<xsl:if test="@mustImplement='false'">
				<div class='mustImplement'></div>
			</xsl:if>
			<div class="ListNote">
				<!-- new code -->
				<xsl:call-template name="ItemWithID">
				   <xsl:with-param name="required" select="required"/>
				</xsl:call-template>
					
				<xsl:value-of select="@title"/> 
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
			</div>			
			<div style="clear:both;"/>			
		</div>		
	</xsl:template>
	
	
	<xsl:template match="x:DisplayedItem" mode='multiselect'>
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>
		
		<div>  
			<xsl:if test="@mustImplement='false'">
				<div class='mustImplement'></div>
			</xsl:if>
			<div class="ListNote">
				<!-- new code -->
				<xsl:call-template name="ItemWithID">
				   <xsl:with-param name="required" select="required"/>
				</xsl:call-template>
					
				<xsl:value-of select="@title"/> 
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
			</div>			
			<div style="clear:both;"/>			
		</div>
		
	</xsl:template>

	<!-- new code -->
	<xsl:template name="SectionAttributes">
		<xsl:param name="metadataClass" select="'MetadataDisplay'"/>
		
		 <xsl:if test="change/@change_type='newItem'">
			 <!--&#160;<span class="sdc">sdc* </span>			 -->
			 <xsl:apply-templates select="change" mode="label">
				<xsl:with-param name="changeAttribute" select="'newItem'"/>
				<xsl:with-param name="label" select="'new*'"/>
				<xsl:with-param name="tooltip" select="concat('NEW ITEM ADDED. New: ', change/@change_type)"/>
				
			</xsl:apply-templates>
		 </xsl:if>
		 
		 <xsl:if test="change/@change_type='parent'">
			 <xsl:apply-templates select="change" mode="label">
				<xsl:with-param name="changeAttribute" select="'parent'"/>
				<xsl:with-param name="label" select="'parent*'"/>
				<xsl:with-param name="tooltip" select="concat('NEW PARENT ITEM:: ', change/@change_type)"/>
			 </xsl:apply-templates>
		 </xsl:if>
				
		 <xsl:if test="change/@change_type='prevSibling'">
			 <xsl:apply-templates select="change" mode="label">
				<xsl:with-param name="changeAttribute" select="'prevSibling'"/>
				<xsl:with-param name="label" select="'prevSibling*'"/>
				<xsl:with-param name="tooltip" select="concat('NEW PREV SIBLING:: ', change/@change_type)"/>
			 </xsl:apply-templates>
		 </xsl:if>
	</xsl:template>
	
	<!-- new code -->
	<xsl:template name="HeaderSectionAttributes">
      <xsl:param name="metadataClass" select="'MetadataDisplay'"/>
	
		<xsl:if test="$change-display = 'true'">
			<xsl:if test="change/@change_type='templateTitle'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'templateTitle'"/>
					<xsl:with-param name="label" select="'templateTitle*'"/>
					<xsl:with-param name="tooltip" select="concat('new: ', change/@templateTitle-new,', old: ', change/@templateTitle-old)"/>
				</xsl:apply-templates>
			</xsl:if>
			
			<xsl:if test="change/@change_type='figo'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'figo'"/>
					<xsl:with-param name="label" select="'figo*'"/>
					<xsl:with-param name="tooltip" select="concat('new: ', change/@figo-new,', old: ', change/@figo-old)"/>
				</xsl:apply-templates>
			</xsl:if>	
			
			<xsl:if test="change/@change_type='cs'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'cs'"/>
					<xsl:with-param name="label" select="'cs*'"/>
					<xsl:with-param name="tooltip" select="concat('new: ', change/@cs-new,', old: ', change/@cs-old)"/>
				</xsl:apply-templates>
			</xsl:if>	
		</xsl:if>
	</xsl:template>
	
	<!-- new code -->
	<xsl:template name="QuestionSectionAttributes">
      <xsl:if test="$metadata-display = 'true'">
         <div class="MetadataDisplay">
            <xsl:if test="string(@locked) = 'true'">
               &#160;<div class="locked">locked</div>
            </xsl:if>
            <xsl:if test="string(@minCard) != ''">
               &#160;<div class="minCard">min: </div>
               <xsl:value-of select="@minCard"/>
            </xsl:if>
            <xsl:if test="string(@maxCard) != ''">
               &#160;<div class="maxCard">max: </div>:
               <xsl:value-of select="@maxCard"/>
            </xsl:if>
            <!--<xsl:call-template name="CommonAttributes">
               <xsl:with-param name="metadataClass" select="$metadataClass"/>
            </xsl:call-template>-->
         </div>
      </xsl:if>
	
      
	
         <xsl:call-template name="CommonAttributes"/>
				   <!-- <xsl:with-param name="metadataClass" select="$metadataClass"/> -->
		 <!-- </xsl:call-template> -->
      
   </xsl:template>
   
   <!-- new code -->
   <xsl:template name="ResponseFieldAttributes">
      <xsl:if test="$metadata-display = 'true'">
         <div class="MetadataDisplay">
            <xsl:if test="string(@datatype) != ''">
               &#160;<div class="dataType">dt: </div>
               <xsl:value-of select="@datatype"/>
            </xsl:if>
			
            <xsl:if test="string(x:ListItemResponseField/x:ResponseUnits/@val) != ''">
			<!-- GOT HERE LI-1			 -->
				<!-- <xsl:value-of select ="local-name()"/> -->
               &#160;<div class="ResponseUnits">un: </div>
               <xsl:value-of select="x:ListItemResponseField/x:ResponseUnits/@val"/>
            </xsl:if>
            <xsl:if test="string(x:ListItemResponseField/x:TextAfterResponse/@val) != ''">
			<!-- GOT HERE LI-2 -->
               &#160;<div class="TextAfterResponse">txtAft: </div>
               <xsl:value-of select="x:ListItemResponseField/x:TextAfterResponse/@val"/>
            </xsl:if>
            <xsl:if test="string(x:ListItemResponseField/@responseRequired) = 'true'">
			<!-- GOT HERE LI-3 -->
               &#160;<div class="responseRequired">respReq: </div>
			   <xsl:value-of select="x:ListItemResponseField/@responseRequired"/>
            </xsl:if>  

            <xsl:if test="string(x:ResponseField/x:ResponseUnits/@val) != ''">
			<!-- GOT HERE R-1 -->
               &#160;<div class="ResponseUnits">un: </div>
               <xsl:value-of select="x:ResponseField/x:ResponseUnits/@val"/>
            </xsl:if>
            <xsl:if test="string(x:ResponseField/x:TextAfterResponse/@val) != ''">
			<!-- GOT HERE R-2 -->
               &#160;<div class="TextAfterResponse">txtAft: </div>
               <xsl:value-of select="x:ResponseField/x:TextAfterResponse/@val"/>
            </xsl:if>
            <xsl:if test="string(x:ResponseField/@responseRequired) = 'true'">
			<!-- GOT HERE R-3 -->
               &#160;<div class="responseRequired">respReq: </div>
			   <xsl:value-of select="x:ResponseField/@responseRequired"/>
            </xsl:if>			
         </div>
      </xsl:if>
   <xsl:if test="$change-display = 'true'">
         <div class="ChangeDisplay">      
            <xsl:if test="change/@change_type='dataType'">
				<xsl:apply-templates select="change" mode="label">
				   <xsl:with-param name="changeAttribute" select="'dataType'"/>
				   <xsl:with-param name="label" select="'dt*'"/>
				   <xsl:with-param name="tooltip" select="concat('DataType Changed. New: ', change/@dataType-new,', Old: ', change/@dataType-old)"/>
				</xsl:apply-templates>
            </xsl:if>
			 <xsl:if test="change/@change_type='answerUnits'">
				 <xsl:apply-templates select="change" mode="label">
					 <xsl:with-param name="changeAttribute" select="'answerUnits'"/>
					 <xsl:with-param name="label" select="'un*'"/>
					 <xsl:with-param name="tooltip" select="concat('Answer Units Changed. New: ', change/@answerUnits-new,', Old: ', change/@answerUnits-old)"/>
				 </xsl:apply-templates>
			 </xsl:if>
           <xsl:if test="change/@change_type='length'">
				<xsl:apply-templates select="change" mode="label">
                  <xsl:with-param name="changeAttribute" select="'length'"/>
				  <xsl:with-param name="label" select="'len*'"/>
				  <xsl:with-param name="tooltip" select="concat('new: ', change/@length-new,', old: ', change/@length-old)"/>
               </xsl:apply-templates> 
			</xsl:if>   
            <!--display change if exists-->
			 
            <!--<xsl:apply-templates select="change" mode="label">
               <xsl:with-param name="changeAttribute" select="'textAfterResponse'"/>
               <xsl:with-param name="label" select="'txtAft'"/>
            </xsl:apply-templates>-->
            
            <!--display change if exists-->
			 <xsl:if test="change/@change_type='responseRequired'">
				 <xsl:apply-templates select="change" mode="label">
					 <xsl:with-param name="changeAttribute" select="'responseRequired'"/>
					 <xsl:with-param name="label" select="'respReq*'"/>
					 <xsl:with-param name="tooltip" select="concat('Fill-in Response is Required. New: ', change/@responseRequired-new,', Old: ', change/@responseRequired-old)"/>
				 </xsl:apply-templates>
			 </xsl:if>
         </div>
      </xsl:if>
   </xsl:template>
   
   <!-- new code -->
   <xsl:template name="ListItemAttributes">
      <xsl:if test="$metadata-display = 'true'">
         <div class="MetadataDisplay">
            <xsl:if test="@selectionDisablesChildren = 'true'">
               &#160;<div class="sdc">sdc </div>
            </xsl:if>
            <xsl:if test="string(@omitWhenSelected) = 'true'">
               &#160;<div class="omitWhenSel">omitWhenSel </div>
            </xsl:if>
            <xsl:if test="string(@locked) = 'true'">
               &#160;<div class="locked">locked</div>
            </xsl:if>
            <xsl:if test="@selectionDeselectsSiblings = 'true'">
               &#160;<div class="sds">sds </div>
            </xsl:if>
            <xsl:if test="string(@selected) = 'true'">
               &#160;<div class="selected">sel: </div>
            </xsl:if>

         </div>
      </xsl:if>
	   
	  <xsl:if test="$change-display = 'true'">
         <div class="ChangeDisplay">
			 <xsl:if test="change/@change_type='sdc'">
				 <!--&#160;<span class="sdc">sdc* </span>			 -->
				 <xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'sdc'"/>
					<xsl:with-param name="label" select="'sdc*'"/>
					<xsl:with-param name="tooltip" select="concat('Selection Disables All Children Changed. New: ', change/@sdc-new,', Old: ', change/@sdc-old)"/>
					
				</xsl:apply-templates>
			 </xsl:if>
			 
			<xsl:if test="change/@change_type='parent'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'parent'"/>
					<xsl:with-param name="label" select="'parent*'"/>
					<xsl:with-param name="tooltip" select="concat('NEW PARENT ITEM:: ', change/@change_type)"/>
				</xsl:apply-templates>
			</xsl:if>
		
		    <xsl:if test="change/@change_type='prevSibling'">
			    <xsl:apply-templates select="change" mode="label">
				    <xsl:with-param name="changeAttribute" select="'prevSibling'"/>
				    <xsl:with-param name="label" select="'prevSibling*'"/>
				    <xsl:with-param name="tooltip" select="concat('NEW PREV SIBLING:: ', change/@change_type)"/>
			    </xsl:apply-templates>
		    </xsl:if>
		 
			 <xsl:if test="change/@change_type='newItem'">
				 <!--&#160;<span class="sdc">sdc* </span>			 -->
				 <xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'newItem'"/>
					<xsl:with-param name="label" select="'new*'"/>
					<xsl:with-param name="tooltip" select="concat('NEW ITEM ADDED. New: ', change/@change_type)"/>
					
				</xsl:apply-templates>
			 </xsl:if> 
			 
			 <xsl:if test="change/@change_type='omitWhenSelected'">            
               <!--&#160;<span class="omitWhenSel">omitWhenSel* </span>-->
			   <xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'omitWhenSelected'"/>
					<xsl:with-param name="label" select="'omitWhenSel*'"/>
					<xsl:with-param name="tooltip" select="concat('Omit When Selected Changed. New: ', change/@omitWhenSelected-new,', Old: ', change/@omitWhenSelected-old)"/>
					
				</xsl:apply-templates>
            </xsl:if>			 
            <xsl:if test="change/@change_type='locked'">
               <!--&#160;<span class="locked">locked*</span>-->
			   <xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'locked'"/>
					<xsl:with-param name="label" select="'locked*'"/>
					<xsl:with-param name="tooltip" select="concat('Locked Changed. New: ', change/@locked-new,', Old: ', change/@locked-old)"/>
					
				</xsl:apply-templates>
            </xsl:if>
            <xsl:if test="change/@change_type = 'sds'">
               <!--&#160;<span class="sds">sds* </span>-->
			   <xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'sds'"/>
					<xsl:with-param name="label" select="'sds*'"/>
					<xsl:with-param name="tooltip" select="concat('Selection Deselects Siblings Changed. New: ', change/@sds-new,', old: ', change/@sds-old)"/>
					
				</xsl:apply-templates>
            </xsl:if>
            <xsl:if test="change/@change_type='selected'">
               <!--&#160;<span class="selected">sel* </span>-->
			   <xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'sel'"/>
					<xsl:with-param name="label" select="'sel*'"/>
					<xsl:with-param name="tooltip" select="concat('new: ', change/@selected-new,', old: ', change/@selected-old)"/>
					
				</xsl:apply-templates>
            </xsl:if>
			<xsl:if test="change/@change_type='itemType'">
               <!--&#160;<span class="itemType">itemType* </span>-->
			   <xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'itemType'"/>
					<xsl:with-param name="label" select="'itemType*'"/>
					<xsl:with-param name="tooltip" select="concat('Item Type Changed. New: ', change/@itemType-new,', Old: ', change/@itemType-old)"/>
					
				</xsl:apply-templates>
            </xsl:if>
			
         </div>
      </xsl:if>
   </xsl:template>
   
   <!-- new code -->
   <xsl:template name="CommonAttributes">
      <xsl:param name="metadataClass" select="'MetadataDisplay'"/>
      <xsl:if test="$metadata-display = 'true'">
         <div class="{string($metadataClass)}">
		    <!-- unnecessary logging -->
            <xsl:if test="string(@mustImplement) = 'false'">
               &#160;<div class="mustImplement">mI: </div>
               <xsl:value-of select="@mustImplement"/>
            </xsl:if>
			
            <xsl:if test="string(@showInReport) = 'false'">
               &#160;<div class="showInReport">inRpt: </div>
               <xsl:value-of select="@showInReport"/>
            </xsl:if>
			
            <!-- <xsl:if test="string(@reportText) != ''"> -->
               <!-- &#160;<div class="reportText">rpt: </div> -->
               <!-- <xsl:value-of select="@reportText"/> -->
            <!-- </xsl:if> -->
			         	
         	<xsl:if test="string(x:Property/@propName) != '' and string(x:Property/@propName) != '{no text}'">
         		&#160;<div class="reportText">rpt: </div>
         		<xsl:value-of select="x:Property/@val"/>
         	</xsl:if>
         	
            <xsl:if test="string(@alt-text) != ''">
               &#160;<div class="altText">alt: </div>
               <xsl:value-of select="@alt-text"/>
            </xsl:if>
            <xsl:if test="string(@name) != ''">
               &#160;<div class="name">name: </div>
               <xsl:value-of select="@name"/>
            </xsl:if>
            <xsl:if test="string(@visible) = 'false'">
               &#160;<div class="visible">vis: </div>
               <xsl:value-of select="@visible"/>
            </xsl:if>

            <xsl:if test="string(@enabled) != ''">
               &#160;<div class="enabled">enabled: </div>
               <xsl:value-of select="@enabled"/>
            </xsl:if>
            <xsl:if test="string(@styleClass) != ''">
               &#160;<div class="styleClass">class: </div>
               <xsl:value-of select="@styleClass"/>
            </xsl:if>
            <xsl:if test="string(@type) != ''">
               &#160;<div class="type">type: </div>
               <xsl:value-of select="@type"/>
            </xsl:if>

            <xsl:if test="string(@tooltip) != ''">
               &#160;<div class="tooltip">tooltip: </div>
               <xsl:value-of select="@tooltip"/>
            </xsl:if>
            <xsl:if test="string(@linkText) != ''">
               &#160;<div class="linkText">link: </div>
               <xsl:value-of select="@linkText"/>
            </xsl:if>
            <xsl:if test="string(@linkText2) != ''">
               &#160;<div class="linkText2">link2: </div>
               <xsl:value-of select="@linkText2"/>
            </xsl:if>
         </div>
      </xsl:if>
	   
	 <xsl:if test="$change-display = 'true'">
         <div class="ChangeDisplay">
			
            <xsl:if test="change/@change_type='mustImplement'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'mustImplement'"/>
					<xsl:with-param name="label" select="'mI*'"/>
					<xsl:with-param name="tooltip" select="concat('Must Implement Changed. New: ', change/@mustImplement-new,', Old: ', change/@mustImplement-old)"/>
				</xsl:apply-templates>              
            </xsl:if>
            <xsl:if test="change/@change_type='showInReport'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'showInReport'"/>
					<xsl:with-param name="label" select="'inRpt*'"/>
					<xsl:with-param name="tooltip" select="concat('new: ', change/@showInReport-new,', old: ', change/@showInReport-old)"/>
				</xsl:apply-templates> 
            </xsl:if>
            <xsl:if test="change/@change_type='reportText'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'reportText'"/>
					<xsl:with-param name="label" select="'rpt*'"/>
					<xsl:with-param name="tooltip" select="concat('Report Text Changed. New: ', change/@reportText-new,', Old: ', change/@reportText-old)"/>
				</xsl:apply-templates> 
            </xsl:if>
            <xsl:if test="change/@change_type='altText'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'altText'"/>
					<xsl:with-param name="label" select="'alt*'"/>
					<xsl:with-param name="tooltip" select="concat('Hidden Text Changed. New: ', change/@altText-new,', Old: ', change/@altText-old)"/>
					
				</xsl:apply-templates>              
            </xsl:if>
            <xsl:if test="change/@change_type='name'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'name'"/>
					<xsl:with-param name="label" select="'name*'"/>
					
				</xsl:apply-templates>  
            </xsl:if>
            <xsl:if test="change/@change_type='visible'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'visible'"/>
					<xsl:with-param name="label" select="'vis*'"/>
					
				</xsl:apply-templates>
			
            </xsl:if>

            <xsl:if test="change/@change_type='enabled'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'enabled'"/>
					<xsl:with-param name="label" select="'enabled*'"/>
					
				</xsl:apply-templates>
            </xsl:if>
            <xsl:if test="change/@change_type='class'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'styleClass'"/>
					<xsl:with-param name="label" select="'class*'"/>
					
				</xsl:apply-templates>
            </xsl:if>
            <xsl:if test="change/@change_type='type'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'type'"/>
					<xsl:with-param name="label" select="'type*'"/>
					
				</xsl:apply-templates>
             </xsl:if>

            <xsl:if test="change/@change_type='tooltip'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'tooltip'"/>
					<xsl:with-param name="label" select="'tooltip*'"/>
					
				</xsl:apply-templates>              
            </xsl:if>
            <xsl:if test="change/@change_type='linkText'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'linkText'"/>
					<xsl:with-param name="label" select="'link*'"/>
					
				</xsl:apply-templates>              
            </xsl:if>
            <xsl:if test="change/@change_type='linkText2'">
				<xsl:apply-templates select="change" mode="label">
					<xsl:with-param name="changeAttribute" select="'linkText2'"/>
					<xsl:with-param name="label" select="'link2*'"/>
					
				</xsl:apply-templates>
            </xsl:if>
         </div>
      </xsl:if>

   </xsl:template>
   
   <!-- new code -->
   <xsl:template name="ItemWithID">
      <xsl:param name="required"/>
      <xsl:if test="$required = 'false' or @mustImplement = 'false'">
         <div class="notRequired">+</div>
      </xsl:if>

      <xsl:if test="$metadata-display = 'true'">
         <div style="display:inline" class="idDisplay">
            <a onClick="javascript:syncItem(this)">
				<xsl:attribute name="name">
					<xsl:value-of select="substring-before(@ID, '.')"/>
				</xsl:attribute>				
				<xsl:value-of select="substring-before(@ID, '.')"/>
				-   
			</a>
         </div>
      </xsl:if>

      <xsl:choose>
         <xsl:when test="count(display/property) > 1">
            <xsl:apply-templates select="display"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
	<!-- new code -->
	<!--puts a label on change-->
   <xsl:template match="change" mode="label">
      <xsl:param name="changeAttribute"/>
      <xsl:param name="label"/>
	  <xsl:param name="tooltip"/>
	  
      <xsl:variable name="currentChangeAttriibute" select="@change_type"/>
	  <!--<xsl:variable name="tooltip" select="@oldText"/>-->
	  
	   <div class="ChangeDisplay">
		   <xsl:choose>
			 <xsl:when test="$currentChangeAttriibute != '' and $currentChangeAttriibute=$changeAttribute">
			 	  <!-- GOT CHANGE -->
				  <!-- <xsl:value-of select="$changeAttribute" /> -->
				  <!-- <xsl:value-of select="$currentChangeAttriibute" /> -->
				  <!-- <xsl:value-of select="$tooltip" /> -->
				  <!-- <xsl:value-of select="$label" /> -->
				<span class="{$currentChangeAttriibute}" title="{$tooltip}">
				   <xsl:choose>
					  <xsl:when test="$label=''">
						  <xsl:value-of select="$currentChangeAttriibute"/>* 
					  </xsl:when>
					  <xsl:otherwise>
						  <xsl:value-of select="$label"/> 
					  </xsl:otherwise>
				   </xsl:choose>
				</span>
			 </xsl:when>         
		  </xsl:choose>  
	   </div>
       
   </xsl:template>
</xsl:stylesheet>