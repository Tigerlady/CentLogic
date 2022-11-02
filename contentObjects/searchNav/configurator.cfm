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
	if(not structKeyExists(params,"search_type")){
		params.search_type="Links";
		params.show_empty=application.cw.appDisplayEmptyCategories;
		params.show_secondary="true";
		params.separator="|";
		params.all_categories_label="All Products";
		params.all_secondaries_label="All";
		params.all_products_label="All Items";
		params.show_product_count="true";
		params.menu_id="";
		params.menu_class="";
		params.form_id="CWproductSearch";
		params.form_keywords="false";
		params.form_keywords_text="Search Products";
		params.form_category="false";
		params.form_category_label="All " & application.cw.adminLabelCategories;
		params.form_secondary="false";
		params.form_secondary_label="All " & application.cw.adminLabelSecondaries;
		params.form_button_label="Search";		
		// not used currently , set at application level
		params.relate_cats=application.cw.appEnableCatsRelated;
	}
</cfscript>

<!--- default for form values --->
<cfparam name="form.search_type" default="#params.search_type#">
<cfparam name="form.show_empty" default="#params.show_empty#">
<cfparam name="form.show_secondary" default="#params.show_secondary#">
<cfparam name="form.separator" default="#params.separator#">
<cfparam name="form.all_categories_label" default="#params.all_categories_label#">
<cfparam name="form.all_secondaries_label" default="#params.all_secondaries_label#">
<cfparam name="form.all_products_label" default="#params.all_products_label#">
<cfparam name="form.show_product_count" default="#params.show_product_count#">
<cfparam name="form.menu_id" default="#params.menu_id#">
<cfparam name="form.menu_class" default="#params.menu_class#">
<cfparam name="form.form_id" default="#params.form_id#">
<cfparam name="form.form_keywords" default="#params.form_keywords#">
<cfparam name="form.form_keywords_text" default="#params.form_keywords_text#">
<cfparam name="form.form_category" default="#params.form_category#">
<cfparam name="form.form_category_label" default="#params.form_category_label#">
<cfparam name="form.form_secondary" default="#params.form_secondary#">
<cfparam name="form.form_secondary_label" default="#params.form_secondary_label#">
<cfparam name="form.form_button_label" default="#params.form_button_label#">

<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="CentLogic Search/Nav" 
		data-objectid="#$.event('objectID')#">
		<dl class="singleColumn">
			
			<!--- search type--->
			<dt>Search Type</dt>
			<dd>
				<select name="search_type" class="objectParam">
					<cfloop list="List,Links,Form,Breadcrumb" index="t">
					<option value="#t#"<cfif form.search_type is t> selected="selected"</cfif>>#t#</option>
					</cfloop>
				</select>
			</dd>
			
			<!--- show empty y/n--->
			<dt>Show Empty Categories</dt>
			<dd>
				<select name="show_empty" class="objectParam">
					<option value="false"<cfif form.show_empty is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_empty is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
	
			<!--- show secondary --->
			<dt>Show Secondary Categories</dt>
			<dd>
				<select name="show_secondary" class="objectParam">
					<option value="false"<cfif form.show_secondary is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_secondary is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
	
			<!--- separator --->
			<dt>Separator</dt>
			<dd>
				<input name="separator" value="#form.separator#" class="objectParam" size="2">
			</dd>
	
			<!--- all categories --->
			<dt>All Categories Label</dt>
			<dd>
				<input name="all_categories_label" value="#form.all_categories_label#" class="objectParam" size="23">
			</dd>
	
			<!--- all secondaries --->
			<dt>All secondaries Label</dt>
			<dd>
				<input name="all_secondaries_label" value="#form.all_secondaries_label#" class="objectParam" size="23">
			</dd>
	
			<!--- all products --->
			<dt>All products Label</dt>
			<dd>
				<input name="all_products_label" value="#form.all_products_label#" class="objectParam" size="23">
			</dd>
	
			<!--- show product count in nav --->
			<dt>Show Product Count</dt>
			<dd>
				<select name="show_product_count" class="objectParam">
					<option value="false"<cfif form.show_product_count is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.show_product_count is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
	
			<!--- menu id --->
			<dt>Nav Menu ID</dt>
			<dd>
				<input name="menu_id" value="#form.menu_id#" class="objectParam" size="23">
			</dd>
	
			<!--- menu class --->
			<dt>Nav Menu Class</dt>
			<dd>
				<input name="menu_class" value="#form.menu_class#" class="objectParam" size="23">
			</dd>
	
			<!--- form id --->
			<dt>Search Form ID</dt>
			<dd>
				<input name="form_id" value="#form.form_id#" class="objectParam" size="23">
			</dd>

			<!--- show keywords field --->
			<dt>Show Keyword Search</dt>
			<dd>
				<select name="form_keywords" class="objectParam">
					<option value="false"<cfif form.form_keywords is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.form_keywords is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
	
			<!--- form keywords default text --->
			<dt>Default Search Text</dt>
			<dd>
				<input name="form_keywords_text" value="#form.form_keywords_text#" class="objectParam" size="23">
			</dd>
	
			<!--- show category list in form --->
			<dt>Show Category Search</dt>
			<dd>
				<select name="form_category" class="objectParam">
					<option value="false"<cfif form.form_category is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.form_category is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>
	
			<!--- all cats --->
			<dt>Default Category Text</dt>
			<dd>
				<input name="form_category_label" value="#form.form_category_label#" class="objectParam" size="23">
			</dd>
	
			<!--- show secondary list in form --->
			<dt>Show Secondary Search</dt>
			<dd>
				<select name="form_secondary" class="objectParam">
					<option value="false"<cfif form.form_secondary is 'false'> selected="selected"</cfif>>No</option>
					<option value="true"<cfif form.form_secondary is 'true'> selected="selected"</cfif>>Yes</option>
				</select>
			</dd>

			<!--- all cats --->
			<dt>Default Secondary Text</dt>
			<dd>
				<input name="form_secondary_label" value="#form.form_secondary_label#" class="objectParam" size="23">
			</dd>
	
			<!--- search button --->
			<dt>Search Button Text</dt>
			<dd>
				<input name="form_button_label" value="#form.form_button_label#" class="objectParam" size="23">
			</dd>
						
		</dl>			
	</div>			
</cfoutput>