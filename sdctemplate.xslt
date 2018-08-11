<?xml version="1.0" encoding="us-ascii"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:sr="http://www.cap.org/pert/2009/01/"
	xmlns:x="urn:ihe:qrph:sdc:2016">
	
  <xsl:output encoding="us-ascii" method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  
  
	<xsl:variable name="show-toc" select="'false'"/>
	<xsl:variable name="debug" select="'false'"/>

	<xsl:template match="/">
		
		<xsl:variable name ="required" select="string(//Header/Property[@type='web_posting_date meta']/@val)"/>
        <html>
            <head>
			<title><xsl:value-of select="//x:Header/@title"/></title>
			
			<link rel="stylesheet" href="sdctemplate.css" type="text/css" />
			
			
            <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
			<!--<script type="text/javascript" src="sdc.js"></script>-->
			
				<script type="text/javascript">
				
					<xsl:text disable-output-escaping="yes" >
						<![CDATA[
							var xmlDoc;
							var repeatIndex = 0;   //used to generate unique ids, names in repeated elements
							$(document).ready(function () {

								jQuery.support.cors = true;  //not sure if needed because cors setting is on the server
								
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
								
								//alert(xmlstring);

								//remove declaration part if exists
								//xmlstring = xmlstring.substring(xmlstring.indexOf("<FormDesign"));
								//$("#rawxml").val(xmlstring);
								
								//load into xml dom
								try{
									xmlDoc = $.parseXML(xmlstring);
									$xml = $(xmlDoc);

									//allow submit
									if($("#allowsubmit").val()=='no')
									{
										$("#send").css("display","none");
										//$("#btnAdd").css("display","none");
										
										//$(".btnAdd").css("display","none");
									}
									
									//if(!$('#scriptsubmit').is(':checked'))
									//{
									//	$("#send").css("display","none");
									//}
									

								}
								catch(err){
									alert(err.message);
								}

							});

							function loadXml()
							{
								//alert(window.location.href);
								readTextFile(window.location.href);
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
											//alert($('#rawxml').val());
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
								   
							function resetAnswer(questionId) {
									
								   var answers = document.getElementsByName(questionId);
								   for (var i = 0; i < answers.length; i++) {
										answers[i].checked = false;
									}
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
								
								if(countRepeats(parentTable,currentSectionId.split("..")[0])==max)
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
									
									repeat = countRepeats(parentTable, currentSectionId.split("..")[0])																	
									
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
							function countRepeats(parentT, sectionid) {
								
								
								var tables = parentT.getElementsByTagName('TABLE');
								var count = 0;
								for(i=0; i<tables.length; i++)
								{
								   checkid = tables[i].id.split("..")[0];
								   if(checkid == sectionid) count++;
								}
							   
								return count;

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
								var repeat = countRepeats(parentTable, table.id.split("..")[0]);
								
								
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

							function xmlToString(xmlData) {

								var xmlString;
								
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
								var elem = document.getElementById("checklist").elements;
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
								//alert(sb);

								document.getElementById('MessageDataResult').innerHTML = sb;
								document.getElementById('MessageData').style.display = 'block';
								document.getElementById('FormData').style.display = 'none';
								
								//populate hiddenresponse to access from the server code
								//$('#hiddenresponse').innerHTML = sb;

								//update Xml with answers
								updateXml();
								
								

								//var test = xmlToString(xmlDoc);
								//document.getElementById('rawxml').innerText = test;

								
								if($('#scriptsubmit').is(':checked'))
								{
									//Ajax call to web service
									CallSoapSubmit2(xmlToString(xmlDoc));
								}
								else
								{
									//call formreceiver from server side code
									ServerSubmit();

								}
						
								
							}

							/* start of functions to call .NET serverside methods*/

							function ServerSubmit()
					        {
					            var xml = document.getElementById("rawxml").value;
					            var submiturls = document.getElementById("submiturl").value
					            
					            var responsetext = PageMethods.submitform(xml, submiturls, OnServerSucceed, OnServerError);
					            
					            return false;
					        }

					        function OnServerSucceed(result)
					        {
					           //server response includes SoapResponse and SoapRequest strings delimited by #!#2#3
					            var response = result.split('#!#2#3')[0];
					            var request = result.split('#!#2#3')[1];

					            
					            //request = formatXml(request);
					            $("#submitsoap").val(request);

					            response = formatXml(response);
					            xml_escaped = response.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/ /g, '&nbsp;').replace(/\n/g, '<br />');
					            
					            $('#FormData').css('display', 'block');
					            $('#response').html("<PRE>" + xml_escaped + "</PRE>");
					            $('#response').css('backgroundColor','yellow');
					            $('#response').css('display','block');
					          	$('#MessageData').css('display','block');
					          	$('#FormData').css('display','none');			          

					           
					        }

					        function OnServerError(result)
					        {
					            alert(result);
					            document.getElementById("response").innerText = result;
					            document.getElementById("response").style.backgroundColor = "yellow";
					            document.getElementById("response").style.color = "red";
					        }

					        /* end of functions to call .NET serverside methods */


							function closeMessageData() {
								document.getElementById('MessageData').style.display = 'none';
								document.getElementById('response').style.display = 'none';
								document.getElementById('FormData').style.display = 'block';
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
													//str += "&lt;answer value=\"" + value + "\"/&gt;<br>";
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




							//soap 1.2
							function CallSoapSubmit2(data) {

							
								//server submit?
								if($('#scriptsubmit').length == 0 | (!$('#scriptsubmit').is(':checked')))
								{
									alert("Script Submit is not supported.");
									//serverSubmit(data);
									return;
								}

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
									alert("destination not found.");
									return;
								}
								
								//if(webServiceURL!="" & $("#submiturl").val()=="")
								//	$("#submiturl").val(webServiceURL);
								

								//webServiceURL = $("#submiturl").val();  
								
																
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

							/*
							function CallSoapSubmit(data) {
								var webServiceURL = "%receiver%";
								webServiceURL = prompt("Enter endpoint:", webServiceURL);
								var ns = $('#submitnamespace').val();

								$.support.cors = true;
								var xmldata = encodeURIComponent(data);
								
								var soapRequest =
												'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" + xmlns:tem="http://tempuri.org/">' + 
												 '  <soapenv:Header/>' +
												  ' <soapenv:Body>' + 
													 ' <tem:SubmitFormRequest>' + data + '</tem:SubmitFormRequest>' +
												  ' </soapenv:Body>' + 
												' </soapenv:Envelope>'

								
								soapAction = ns + "//SubmitFormRequest";    //"http://tempuri.org/SubmitFormRequest";
								
								
								$.ajax({
									type: "POST",
									url: webServiceURL,
									contentType: "text/xml",
									dataType: "xml",
									processData: false,
									headers: {
										"SOAPAction": soapAction
									},
									data: soapRequest,
									success: OnSuccess,
									error: OnError
								});

								return false;
							}
							*/


							function OnSuccess(data, url) {
								
								var xmlstring = xmlToString(data);

								xmlstring = formatXml(xmlstring);
								xml_escaped = xmlstring.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/ /g, '&nbsp;').replace(/\n/g,'<br />');

							    //add breaks
								
							    //xmlstring = xmlstring.replace(/</g,'&lt;');
							    //xmlstring = xmlstring.replace(/>/g,'&gt;');
							    //xmlstring = xmlstring.replace(/\n/g,'<br/>');
							    

								if (document.getElementById("response") != null) {       
									
									$("#response").append("Received Response from " + url  + " - <PRE>" + xml_escaped + '</PRE>');
									$("#response").css("background-color", "yellow");
									$("#response").css("display", "block");
									
									
								}
								
								
							}

							function OnError(xhr, textStatus, errThrown, url) {
								//CORS error can only be see in Chrome 
								var xmlstring = xhr.responseText;
								//alert(xhr.responseText);
								//alert(textStatus);
								//alert(errThrown);
							    //add breaks

							    
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


						]]>
					</xsl:text>
					
				</script>
				
			
			 
            </head>
            <body align="left">
			
			<nav style="position: fixed; font-size:smaller;">
				<!--<a id="linkxml" href="#" onclick="toggleviewxml()">Show Xml</a>
				<br />-->
			<!--
               <a href="##" onclick="toggle_metadata();">
                  Toggle Metadata
               </a>
               <br/>-->
               <a href="##" onclick="toggle_id();">
                  Toggle IDs
               </a>
              <br/>
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
					
					<input type="hidden" id="rawxml" />
					
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

							<!--show properties under form-design-->
							<div>
							<xsl:for-each select="//x:FormDesign/x:Property">
								<xsl:variable name="textstyle" select="@styleClass"/>
								<p class='{$textstyle}'>
									<b><xsl:value-of select="@propName"/></b>
									<xsl:if test="@propName">
										:
									</xsl:if>
									<xsl:value-of select="@val"/>
								</p>
																
							</xsl:for-each>
								
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
									<xsl:variable name="textstyle" select="@styleClass"/>
									<p class='{$textstyle}'>
										<b><xsl:value-of select="@propName"/></b>
										<xsl:if test="@propName">
											:
										</xsl:if>
										<xsl:value-of select="@val"/>
									</p>
																	
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
							<xsl:apply-templates select="//x:FormDesign/x:Body/x:ChildItems/x:Question" mode="level2" >
								<xsl:with-param name="required" select="$required" />
								<xsl:with-param name="parentId" select="'*'"/>  <!--parentId = * for outermost --> 
							</xsl:apply-templates>
							
							<!--<xsl:if test="contains($form-action, 'http') or contains($form-action, 'javascript')">-->
								<!--remove submit button for the desktop verion-->
								
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
													<div style="display:inline" class="idDisplay">
														<xsl:value-of select="substring-before(@ID, '.')"/> -
													</div>
													<xsl:value-of select="@title"/>	
													<div style="display:inline" class="MetadataDisplay">
														<!---metadata-->
													</div>													
												</div>
												<div style='clear:both'/>
											</xsl:when>
											<xsl:when test="count(ancestor::x:Section)= 1">
												<div class="{$defaultStyle}2 collapsable">
													<div style="display:inline" class="idDisplay">
														<xsl:value-of select="substring-before(@ID, '.')"/> -
													</div>
													<xsl:value-of select="@title"/>	
													<div style="display:inline" class="MetadataDisplay">
														<!---metadata-->
													</div>													
												</div>
												<div style='clear:both'/>
											</xsl:when>
											<xsl:when test="count(ancestor::x:Section)= 2">
												<div class="{$defaultStyle}2 collapsable">
													<div style="display:inline" class="idDisplay">
														<xsl:value-of select="substring-before(@ID, '.')"/> -
													</div>
													<xsl:value-of select="@title"/>	
													<div style="display:inline" class="MetadataDisplay">
														<!---metadata-->
													</div>
												</div>
											</xsl:when>
											<xsl:otherwise>
												<div class="{$defaultStyle}2 collapsable">
													<div style="display:inline" class="idDisplay">
														<xsl:value-of select="substring-before(@ID, '.')"/> -
													</div>
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
										<div style="display:inline" class="idDisplay">
											
											<xsl:value-of select="substring-before(@ID, '.')"/> -
										</div>
										<xsl:value-of select="@title"/>
										<div style="display:inline" class="MetadataDisplay">
											<!---metadata-->
										</div>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="{$defaultStyle} collapsable">
										<div style="display:inline" class="idDisplay">
											<xsl:value-of select="substring-before(@ID, '.')"/> -
										</div>
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
	</xsl:template>
	
	<!--question in section-->
	<xsl:template match="x:Question" mode="level1">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>		            
    		<input type="hidden" class="TextBox">
				<xsl:attribute name="name">
					<xsl:value-of select="$questionId"/>
				</xsl:attribute>				
				<xsl:attribute name="value">
					<xsl:value-of select="@title"/>
				</xsl:attribute>
    		</input>
    
		<div class="QuestionInSection">   <!--two columns-->
			<div class="QuestionTitle">
				<div style="display:inline" class="idDisplay">
					<xsl:value-of select="substring-before(@ID, '.')"/> -
				</div>
				<xsl:value-of select="@title"/> 
				<div style="display:inline" class="metadata">
					<!---metadata-->
				</div>
				<xsl:if test="not(x:ResponseField)">
					 <a class="QuestionReset">
					  <xsl:attribute name="href">
						 javascript:resetAnswer('<xsl:value-of select="substring($questionId,2)"/>')
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
			
			<!--11/13/2016: question within question-->
			<div style="clear:both;"/>
			<xsl:if test="x:ChildItems/x:Question">				
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level3">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
			
			</div>
		
	</xsl:template>

	
	<!--question in list item-->
<xsl:template match="x:Question" mode="level2">
	<xsl:param name="parentSectionId"/>
	<xsl:variable name="questionId" select="concat('q',@ID)"/>

    <input type="hidden" class="TextBox">
      <xsl:attribute name="name">
        <xsl:value-of select="$questionId"/>
      </xsl:attribute>
      <xsl:attribute name="value">
      <xsl:value-of select="@title"/>
      </xsl:attribute>
    </input>
    
	<div class="QuestionInListItem"> 	  
		<xsl:choose>
			<!--not showing the hidden question-->
			<xsl:when test="string-length(@title)&gt;0">
				<div class="QuestionTitle">
					<div style="display:inline" class="idDisplay">
						<xsl:value-of select="substring-before(@ID, '.')"/> -
					</div>
					<xsl:value-of select="@title"/> 
					<div style="display:inline" class="MetadataDisplay">
						<!---metadata-->
					</div>
					<xsl:if test="not(x:ResponseField)">
					 <a class="QuestionReset">
					  <xsl:attribute name="href">
						 javascript:resetAnswer('<xsl:value-of select="substring($questionId,2)"/>')
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
				<!--reset for hidden field-->
				<xsl:if test="not(x:ResponseField)">
						<a class="QuestionReset">
						  <xsl:attribute name="href">
							 javascript:resetAnswer('<xsl:value-of select="substring($questionId,2)"/>')
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

</xsl:template>

	<!--question in question-->
	<xsl:template match="x:Question" mode="level3">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>		            
		<input type="hidden" class="TextBox">
			<xsl:attribute name="name">
				<xsl:value-of select="$questionId"/>
			</xsl:attribute>				
			<xsl:attribute name="value">
				<xsl:value-of select="@title"/>
			</xsl:attribute>
		</input>
		
		<div class="QuestionInQuestion">   
			<div class="QuestionTitle">
				<div style="display:inline" class="idDisplay">
					<xsl:value-of select="substring-before(@ID, '.')"/> -
				</div>
				<xsl:value-of select="@title"/>
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
				<xsl:if test="not(x:ResponseField)">
					 <a class="QuestionReset">
					  <xsl:attribute name="href">
						 javascript:resetAnswer('<xsl:value-of select="substring($questionId,2)"/>')
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
			
			<!--11/13/2016: question within question-->
			<div style="clear:both;"/>
			<xsl:if test="x:ChildItems/x:Question">				
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level3">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
			
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
				</input> 
				<div style="display:inline" class="idDisplay">
					<xsl:value-of select="substring-before(@ID, '.')"/> -
				</div>
				<xsl:value-of select="@title"/>
				<!--show link here?-->
				
				<xsl:for-each select="x:Link">					
					<xsl:call-template name="handle_link"/>
				</xsl:for-each>
		
				
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
				<!--answer fillin-->
				<xsl:if test="x:ListItemResponseField">
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
					</input>
				</xsl:if>
			</div>
			
			<!--property-->
			<xsl:if test="x:Property">
				<div class="property">
					<xsl:value-of select="@name"/>
					<xsl:value-of select="@type"/>
					<xsl:value-of select="@val"/>
				</div>
			</xsl:if>			
			
			<!--SRB: 12/18/2016 - handle section within listitem -->
			<xsl:apply-templates select="x:ChildItems/x:Section" mode="level2">
				<xsl:with-param name="parentSectionId" select="$parentSectionId" />
			</xsl:apply-templates>
			<!--question within list-->
			<xsl:apply-templates select="x:ChildItems/x:Question" mode="level2">
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
				</input>
				<div style="display:inline" class="idDisplay">
					<xsl:value-of select="substring-before(@ID, '.')"/> -
				</div>
				<xsl:value-of select="@title"/>
				<!--show link here?-->
				
				<xsl:for-each select="x:Link">					
					<xsl:call-template name="handle_link"/>
				</xsl:for-each>
				
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
				<xsl:if test="x:ListItemResponseField">
					<input type="text" class="AnswerTextBox">
						<xsl:attribute name="name">
							<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="x:ListItemResponseField/x:Response//@val"/>
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
		
	</xsl:template>
	
	<xsl:template match="*|/" mode="DisplayedItem">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>
		<xsl:if test="x:DisplayedItem">
			<div> 
				-------------------------------
				<div class="DisplayedItem">
					<xsl:value-of select="x:DisplayedItem/@title"/> 				
				</div>		
				-------------------------
				<div style="clear:both;"/>			
			</div>	
		</xsl:if>			
	</xsl:template>
	
	<xsl:template match="x:DisplayedItem" mode="level1">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>
			<div>   
				<div class="NoteText">
					<div style="display:inline" class="idDisplay">
						<xsl:value-of select="substring-before(@ID, '.')"/> -
					</div>
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
			<div class="ListNote">
				<div style="display:inline" class="idDisplay">
					<xsl:value-of select="substring-before(@ID, '.')"/> -
				</div>
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
			<div class="ListNote">
				<div style="display:inline" class="idDisplay">
					<xsl:value-of select="substring-before(@ID, '.')"/> -
				</div>
				<xsl:value-of select="@title"/> 
				<div style="display:inline" class="MetadataDisplay">
					<!---metadata-->
				</div>
			</div>			
			<div style="clear:both;"/>			
		</div>
		
	</xsl:template>

</xsl:stylesheet>