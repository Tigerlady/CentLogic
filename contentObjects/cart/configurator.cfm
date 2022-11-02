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
	if(not structKeyExists(params,"cart_heading")){
		params.cart_heading="";
		params.cart_text="";
		}

</cfscript>

<!--- default for form values --->
<cfparam name="form.cart_heading" default="#params.cart_heading#">	
<cfparam name="form.cart_text" default="#params.cart_text#">	

<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="CentLogic Cart Page" 
		data-objectid="#$.event('objectID')#">
			
		<dl class="singleColumn">
			
			<!--- heading text shown with cart --->
			<dt>Cart Heading (optional)</dt>
			<dd>
				<input name="cart_heading" class="objectParam" value="#form.cart_heading#" size="23">
			</dd>

			<!--- description text shown with cart --->
			<dt>Cart Text (optional)</dt>
			<dd>
				<input name="cart_text" class="objectParam" value="#form.cart_text#" size="23">
			</dd>

		</dl>			
	</div>			
</cfoutput>