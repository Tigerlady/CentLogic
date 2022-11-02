<!--
   Copyright 2012 Blue River Interactive

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->
<cfscript>
	$=application.serviceFactory.getBean("MuraScope").init(session.siteID);
		
	params=$.event("params");
		
	if(isJSON(params)){
		params=deserializeJSON(params);
	} else {
		params=structNew();
	}
	// default for scripted elements		
	if(not structKeyExists(params,"view_mode")){
		params.view_mode="account";
		}

</cfscript>

<!--- list of available content views --->
<cfset modeList = "Account,Orders,Details,Products,Views">

<!--- default for form values --->
<cfparam name="form.view_mode" default="#params.view_mode#">	

<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="CentLogic Account Page" 
		data-objectid="#$.event('objectID')#">
			
		<dl class="singleColumn">
			
			<!--- category selector, sets product category --->
			<dt>View Mode (initial page load)</dt>
			<dd>
				<select name="view_mode" class="objectParam">
					<cfloop list="#modeList#" index="i">
						<option value="#lcase(i)#"<cfif lcase(form.view_mode) is lcase(i)> selected="selected"</cfif>>#i#</option>
					</cfloop>
				</select>
			</dd>

		</dl>			
	</div>			
</cfoutput>