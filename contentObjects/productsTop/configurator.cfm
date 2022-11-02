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
	if(not structKeyExists(params,"max_products")){
		
		params.max_products="5";
		params.add_to_cart="false";
		params.show_qty="true";
		params.show_description="false";
		params.show_image="true";
		params.show_price="true";
		params.details_link_text="&raquo; Details";
		// these can be added but aren't currently used
		params.image_class="CWimage";
		params.image_position="above";
		params.title_position="above";
	}
</cfscript>

<!--- default for form values --->
<cfparam name="form.max_products" default="#params.max_products#">	
<cfparam name="form.add_to_cart" default="#params.add_to_cart#">	
<cfparam name="form.show_qty" default="#params.show_qty#">	
<cfparam name="form.show_description" default="#params.show_description#">	
<cfparam name="form.show_image" default="#params.show_image#">	
<cfparam name="form.show_price" default="#params.show_price#">	
<cfparam name="form.details_link_text" default="#params.details_link_text#">	

<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="CentLogic Top Selling Products" 
		data-objectid="#$.event('objectID')#">
		<dl class="singleColumn">
			
			<!--- number of products to show --->
			<dt>Max. Products to Show</dt>
			<dd>
				<select name="max_products" class="objectParam">
					<cfloop from="1" to="100" index="i">
						<option value="#i#"<cfif i eq form.max_products> selected="selected"</cfif>>#i#</option>
					</cfloop>
				</select>
			</dd>
			
			<!--- add to cart y/n--->
			<dt>Show Add To Cart Button</dt>
			<dd>
				<select name="add_to_cart" class="objectParam">
					<option value="false"<cfif form.add_to_cart is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.add_to_cart is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show qty y/n--->
			<dt>Show Quantity Option</dt>
			<dd>
				<select name="show_qty" class="objectParam">
					<option value="false"<cfif form.show_qty is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_qty is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show description y/n--->
			<dt>Show Description</dt>
			<dd>
				<select name="show_description" class="objectParam">
					<option value="false"<cfif form.show_description is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_description is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show image y/n--->
			<dt>Show Image</dt>
			<dd>
				<select name="show_image" class="objectParam">
					<option value="false"<cfif form.show_image is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_image is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>

			<!--- show price y/n--->
			<dt>Show Price</dt>
			<dd>
				<select name="show_price" class="objectParam">
					<option value="false"<cfif form.show_price is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_price is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- details link --->
			<dt>Details Link Text (leave blank for no text link)</dt>
			<dd>
				<input name="details_link_text" value="#form.details_link_text#" class="objectParam" size="23">
			</dd>
			
			
		</dl>			
	</div>			
</cfoutput>