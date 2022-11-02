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
	if(not structKeyExists(params,"display_mode")){
		params.display_mode="showcart";
		params.show_images="false";
		params.show_options="false";
		params.show_sku="false";
		params.show_continue="false";
		params.show_total_row="true";
		params.link_products="true";
		// these can be added but aren't currently used
		params.show_promocode_input=application.cw.discountsEnabled;
		params.product_order='timeadded';
		}

</cfscript>

<!--- list of available content views --->
<cfset modeList = "Show Cart, Summary, Totals">

<!--- default for form values --->
<cfparam name="form.display_mode" default="#params.display_mode#">	
<cfparam name="form.show_images" default="#params.show_images#">	
<cfparam name="form.show_options" default="#params.show_options#">	
<cfparam name="form.show_sku" default="#params.show_sku#">	
<cfparam name="form.show_continue" default="#params.show_continue#">	
<cfparam name="form.show_total_row" default="#params.show_total_row#">	
<cfparam name="form.link_products" default="#params.link_products#">	

<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="CentLogic Cart Preview" 
		data-objectid="#$.event('objectID')#">
			
		<dl class="singleColumn">
			
			<!--- heading text shown with cart --->
			<dt>Display Mode</dt>
			<dd>
				<select name="display_mode" class="objectParam">
					<cfloop list="#modeList#" index="i">
						<cfset optVal = lcase(replace(i,' ','','all'))>
						<option value="#optVal#"<cfif lcase(form.display_mode) is optVal> selected="selected"</cfif>>#i#</option>
					</cfloop>
				</select>				
			</dd>

			<!--- show images y/n--->
			<dt>Show Images</dt>
			<dd>
				<select name="show_images" class="objectParam">
					<option value="false"<cfif form.show_images is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_images is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show options y/n--->
			<dt>Show Options</dt>
			<dd>
				<select name="show_options" class="objectParam">
					<option value="false"<cfif form.show_options is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_options is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show sku y/n--->
			<dt>Show Sku Name</dt>
			<dd>
				<select name="show_sku" class="objectParam">
					<option value="false"<cfif form.show_sku is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_sku is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show continue y/n--->
			<dt>Show Continue Shopping Link</dt>
			<dd>
				<select name="show_continue" class="objectParam">
					<option value="false"<cfif form.show_continue is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_continue is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show cart totals y/n--->
			<dt>Show Cart Totals Row</dt>
			<dd>
				<select name="show_total_row" class="objectParam">
					<option value="false"<cfif form.show_total_row is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_total_row is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show cart totals y/n--->
			<dt>Link Products to Details Page</dt>
			<dd>
				<select name="link_products" class="objectParam">
					<option value="false"<cfif form.link_products is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.link_products is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>

		</dl>			
	</div>			
</cfoutput>