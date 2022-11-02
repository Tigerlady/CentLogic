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
	if(not structKeyExists(params,"product_id")){
		params.product_id="0";
		params.add_to_cart="false";
		params.show_qty="true";
		params.show_price="true";
		params.show_discount="true";
		params.show_alt=application.cw.adminProductAltPriceEnabled;
		params.show_description="false";
		params.show_image="true";
		params.details_link_text="&raquo; Details";
		// these can be added but aren't currently used
		params.sku_id="0";
		params.image_type="1";
		params.image_class="CWimage";
		params.image_position="above";
		params.title_position="above";
		params.details_page=application.cw.appPageDetails;
		params.option_display_type=application.cw.appDisplayOptionView;
	}
	// listProducts array is stored in CW application scope, convert to list sorted by name
	prodList = arrayToList(structSort(application.cwdata.listProducts,'textNoCase'));
</cfscript>

<!--- default for form values --->
<cfparam name="form.product_id" default="#params.product_id#">	
<cfparam name="form.add_to_cart" default="#params.add_to_cart#">	
<cfparam name="form.show_qty" default="#params.show_qty#">	
<cfparam name="form.show_price" default="#params.show_price#">	
<cfparam name="form.show_discount" default="#params.show_discount#">	
<cfparam name="form.show_alt" default="#params.show_alt#">	
<cfparam name="form.show_description" default="#params.show_description#">	
<cfparam name="form.show_image" default="#params.show_image#">	
<cfparam name="form.details_link_text" default="#params.details_link_text#">	

<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="CentLogic Product Preview" 
		data-objectid="#$.event('objectID')#">
		<dl class="singleColumn">
			
			<!--- product selector, sets product ID --->
			<dt>Select Product</dt>
			<dd>
				<select name="product_id" class="objectParam">
					<option value="0">Select a Product</option>
					<cfloop list="#prodList#" index="pp">
						<option value="#pp#"<cfif pp eq form.product_id> selected="selected"</cfif>>#application.cwdata.listProducts[pp]#</option>
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
			
			<!--- show price y/n--->
			<dt>Show Price</dt>
			<dd>
				<select name="show_price" class="objectParam">
					<option value="false"<cfif form.show_price is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_price is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show discount y/n--->
			<dt>Show Discount</dt>
			<dd>
				<select name="show_discount" class="objectParam">
					<option value="false"<cfif form.show_discount is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_discount is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
			
			<!--- show alt price y/n--->
			<dt>Show Alt Price</dt>
			<dd>
				<select name="show_alt" class="objectParam">
					<option value="false"<cfif form.show_alt is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_alt is 'true'> selected="selected"</cfif>>Yes</option>
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
			
			<!--- details link --->
			<dt>Details Link Text (leave blank for no text link)</dt>
			<dd>
				<input name="details_link_text" value="#form.details_link_text#" class="objectParam" size="23">
			</dd>
			
			
		</dl>			
	</div>			
</cfoutput>