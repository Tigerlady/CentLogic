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
	// default for product ID		
	if(not structKeyExists(params,"product_id")){
		params.product_id="0";
	}
	// listProducts array is stored in CW application scope, convert to list sorted by name
	prodList = arrayToList(structSort(application.cwdata.listProducts,'textNoCase'));
</cfscript>

<!--- default for product id value --->
<cfparam name="form.product_id" default="#params.product_id#">	

<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="CentLogic Product Details Page" 
		data-objectid="#$.event('objectID')#">
		<dl class="singleColumn">
			<dt>Select Product</dt>
			<dd>
				<!--- product selector, sets product ID --->
				<select name="product_id" class="objectParam">
					<option value="0">Select a Product</option>
					<cfloop list="#prodList#" index="pp">
						<option value="#pp#"<cfif pp eq form.product_id> selected="selected"</cfif>>#application.cwdata.listProducts[pp]#</option>
					</cfloop>
				</select>
			</dd>
		</dl>			
	</div>			
</cfoutput>