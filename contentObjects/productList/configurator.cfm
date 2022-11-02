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
	if(not structKeyExists(params,"category")){
		params.category="0";
		params.secondary="0";
		params.keywords="";
		params.max_rows=application.cw.appDisplayPerPage;
		params.sort_by="name";
		params.sort_dir="asc";
		params.show_all="false";
		// these can be added but aren't currently used
		params.keywords_delimiters=",-|:";
		params.start_page="1";
		}
	// listProducts array is stored in CW application scope, convert to list sorted by name
	categoryList = arrayToList(structSort(application.cwdata.listCategories,'textNoCase'));
	secondaryList = arrayToList(structSort(application.cwdata.listSubcategories,'textNoCase'));
</cfscript>

<!--- default for form values --->
<cfparam name="form.category" default="#params.category#">	
<cfparam name="form.secondary" default="#params.secondary#">	
<cfparam name="form.keywords" default="#params.keywords#">	
<cfparam name="form.max_rows" default="#params.max_rows#">	
<cfparam name="form.sort_by" default="#params.sort_by#">	
<cfparam name="form.sort_dir" default="#params.sort_dir#">	
<cfparam name="form.show_all" default="#params.show_all#">	

<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="CentLogic Product List Page" 
		data-objectid="#$.event('objectID')#">
			
		<dl class="singleColumn">
			
			<!--- category selector, sets product category --->
			<dt>Select #application.cw.adminLabelCategory#</dt>
			<dd>
				<select name="category" class="objectParam">
					<option value="0">All #application.cw.adminLabelCategories#</option>
					<cfloop list="#categoryList#" index="cc">
						<option value="#cc#"<cfif cc eq form.category> selected="selected"</cfif>>#application.cwdata.listCategories[cc]#</option>
					</cfloop>
				</select>
			</dd>
			<!--- secondary selector, sets product subcategory --->
			<dt>Select #application.cw.adminLabelSecondary#</dt>
			<dd>
				<select name="secondary" class="objectParam">
					<option value="0">All #application.cw.adminLabelSecondaries#</option>
					<cfloop list="#secondaryList#" index="cc">
						<option value="#cc#"<cfif cc eq form.secondary> selected="selected"</cfif>>#application.cwdata.listSubcategories[cc]#</option>
					</cfloop>
				</select>
			</dd>

			<!--- search keywords --->
			<dt>Keywords (leave blank for no keyword search)</dt>
			<dd>
				<input name="keywords" value="#form.keywords#" class="objectParam" size="23">
			</dd>

			<!--- max rows --->
			<dt>Number per page (on initial view)</dt>
			<dd>
				<select name="max_rows" class="objectParam">
					<cfloop list="#application.cw.productPerPageOptions#" index="i">
						<cfif isNumeric(i)>
							<option value="#i#"<cfif i eq form.max_rows> selected="selected"</cfif>>#i#</option>
						</cfif>
					</cfloop>
				</select>
			</dd>

			<!--- sort by--->
			<dt>Sort By</dt>
			<dd>
				<select name="sort_by" class="objectParam">
						<option value="name"<cfif form.sort_by is 'name'> selected="selected"</cfif>>Name</option>
						<option value="id"<cfif form.sort_by is 'id'> selected="selected"</cfif>>Newly Added</option>
						<option value="price"<cfif form.sort_by is 'price'> selected="selected"</cfif>>Price</option>
						<option value="sort"<cfif form.sort_by is 'sort'> selected="selected"</cfif>>Sort Order</option>
				</select>
			</dd>
			
			<!--- sort direction--->
			<dt>Sort Direction</dt>
			<dd>
				<select name="sort_dir" class="objectParam">
					<option value="asc"<cfif form.sort_dir is 'asc'> selected="selected"</cfif>>Ascending (a-z/1-9)</option>
					<option value="desc"<cfif form.sort_dir is 'desc'> selected="selected"</cfif>>Descending (z-a/9-1)</option>
				</select>
			</dd>
	
			<!--- show all y/n--->
			<dt>Show All (overrides per page setting above)</dt>
			<dd>
				<select name="show_all" class="objectParam">
					<option value="false"<cfif form.show_all is 'false'> selected="selected"</cfif>>No (use product paging)</option>
					<option value="true"<cfif form.show_all is 'true'> selected="selected"</cfif>>Yes (show all in single page)</option>
				</select>
			</dd>
			
		</dl>			
	</div>			
</cfoutput>