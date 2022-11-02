<!---
==========================================================
Application: CentLogic ColdFusion for Mura CMS
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: eventHandler.cfc
File Date: 2022-03-19
Description: handles required functions for CentLogic/Mura integration
NOTE:CWMURA [edit]: new file 
==========================================================
--->

<cfcomponent extends="mura.plugin.pluginGenericEventHandler" output="false">
	
	<cfinclude template="../cwadmin/cwadminapp/func/cw-func-admin.cfm">
	<cfinclude template="../cwadmin/cwadminapp/func/cw-func-adminqueries.cfm">

	<!--- register this event handler --->
	<cffunction name="onApplicationLoad" access="public" output="false" returntype="void">
		<cfargument name="$">
		<cfset variables.pluginConfig.addEventHandler(this)>
	</cffunction>

	<!--- include CentLogic's request start include --->
	<cffunction name="onSiteRequestStart" output="false" returntype="void">
		<cfargument name="$">
		<cfinclude template="../displayObjects/cwapp/appcfc/cw-app-onrequeststart.cfm">
	</cffunction>

	<!--- add settings and inject custom functions to global content renderer --->
	<cffunction name="onRenderStart" output="false" returntype="void">
		<cfargument name="$">
		<cfparam name="request.cw.sslpages" default="checkout.cfm,account.cfm">
		<cfparam name="request.cw.thispage" default="">
		<!--- set up request vars for each CW content page --->
		<cfloop list="Results,Details,ShowCart,Checkout,ConfirmOrder,Account,Search" index="pp">
			<cfset cwPageName = evaluate('request.cwpage.url#pp#')>
			<cfset "request.cwpage.url#pp#" = "#cwPageName#">
		</cfloop>
		<!--- if showing https checkout, force it with mura setting --->
		<cfif isDefined('application.cw.appSiteUrlHttps')
			and isValid('url',application.cw.appSiteUrlHttps)
			and left(application.cw.appSiteUrlHttps,6) eq 'https:'
			and listFindNoCase(request.cw.sslpages,request.cw.thispage)
			and isDefined('application.cw.appCWStoreRoot')
			and request.cw.thisURL contains application.cw.appCWStoreRoot>
			<cfset request.forceSSL = true>
		</cfif>
		<!--- INJECT METHODS --->
		<!--- display pages --->
		<cfset $.getContentRenderer().injectMethod('cwDisplayProductList', cwDisplayProductList)>
		<cfset $.getContentRenderer().injectMethod('cwDisplayProductDetails', cwDisplayProductDetails)>
		<cfset $.getContentRenderer().injectMethod('cwDisplayCheckout', cwDisplayCheckout)>
		<cfset $.getContentRenderer().injectMethod('cwDisplayAccount', cwDisplayAccount)>
		<cfset $.getContentRenderer().injectMethod('cwDisplayCart', cwDisplayCart)>
        <cfset $.getContentRenderer().injectMethod('cwDisplayConfirmOrder', cwDisplayConfirmOrder)>
		<!--- display modules --->
		<cfset $.getContentRenderer().injectMethod('cwDisplaySearchNav', cwDisplaySearchNav)>
		<cfset $.getContentRenderer().injectMethod('cwDisplayProductPreview', cwDisplayProductPreview)>
		<cfset $.getContentRenderer().injectMethod('cwDisplayCartPreview', cwDisplayCartPreview)>
		<!--- featured content --->
		<cfset $.getContentRenderer().injectMethod('cwLookupProductsTop', cwLookupProductsTop)>
		<cfset $.getContentRenderer().injectMethod('cwDisplayProductsTop', cwDisplayProductsTop)>
		<cfset $.getContentRenderer().injectMethod('cwLookupProductsNew', cwLookupProductsNew)>
		<cfset $.getContentRenderer().injectMethod('cwDisplayProductsNew', cwDisplayProductsNew)>
	</cffunction>

	<!--- HTTPS redirection - overwrite mura's standard validator --->
	<cffunction name="standardForceSSLValidator" output="false" returnType="any">
		<cfargument name="event" required="true">
		<!--- ORIGINAL MURA FUNCTION, bypassed by commenting out here --->
		<!--- 	<cfif event.getValue("contentBean").getFilename() neq "404" 
			and 
			(
			(event.getValue('forceSSL') or (event.getValue('r').restrict and application.settingsManager.getSite(event.getValue('siteID')).getExtranetSSL() eq 1)) and not application.utility.isHTTPS()
			)
			or	(
			not (event.getValue('r').restrict or event.getValue('forceSSL')) and application.utility.isHTTPS()	
			)>
			<cfset event.getHandler("standardForceSSL").handle(event)>
			</cfif> --->
	</cffunction>

	<!--- // CentLogic CUSTOM FUNCTIONS // --->
	<!--- NOTE: FOR EACH NEW FUNCTION, ADD A LINE TO onRenderStart() ABOVE --->
	
	<!--- ----------------------------- --->
	<!--- CentLogic BASE PAGE INCLUDES --->
	<!--- ----------------------------- --->
	
	<!--- PAGE: PRODUCT LIST (search results) --->
	<cffunction name="cwDisplayProductList" output="false" returntype="string">
		<cfargument required="false" name="category" type="numeric" default="0"
			hint="The ID of the category to look up">
		<cfargument required="false" name="secondary" type="numeric" default="0"
			hint="The ID of the secondary category to look up">
		<cfargument required="false" name="keywords" type="string" default=""
			hint="Text string to match">
		<cfargument required="false" name="max_rows" type="numeric" default="#application.cw.appDisplayPerPage#"
			hint="Maximum results to return">
		<cfargument required="false" name="sort_by" type="string" default="p.product_sort, p.product_name"
			hint="Column name to sort results by">
		<cfargument required="false" name="sort_dir" type="string" default="ASC"
			hint="Ascending or descending sort order (asc|desc)">
		<cfargument required="false" name="show_all" type="boolean" default="0"
			hint="If true, shows all matching products on a single page">
		<cfargument required="false" name="keywords_delimiters" type="string" default=",-|:"
			hint="The delimiter(s) to use for keyword separation, can accept multiple characters">
		<cfargument required="false" name="start_page" type="numeric" default="1"
			hint="Page number to start on">
		<cfset var returncontent = ''>
		<cfset var cwPageName = ''>
		<!--- vars set in function call can be overridden in url for any product listing page --->
		<cfparam name="url.category" default="#arguments.category#">
		<cfparam name="url.secondary" default="#arguments.secondary#">
		<cfparam name="url.keywords" default="#arguments.keywords#">
		<cfparam name="url.page" default="#arguments.start_page#">
		<cfparam name="url.maxrows" default="#arguments.max_rows#">
		<cfparam name="url.sortby" default="#arguments.sort_by#">
		<cfparam name="url.sortdir" default="#arguments.sort_dir#">
		<cfparam name="url.showall" default="#arguments.show_all#">
		<cfset request.cwpage.categoryid = val(url.category)>
		<cfset request.cwpage.secondaryid = val(url.secondary)>
		<cfset request.cwpage.keywords = url.keywords>
		<cfset request.cwpage.resultspage = url.page>
		<cfset request.cwpage.resultsmaxrows = url.maxrows>
		<cfset request.cwpage.sortby = url.sortby>
		<cfset request.cwpage.sortdir = url.sortdir>
		<cfset request.cwpage.showall = url.showall>
		<cfset request.cwpage.hrefUrl = "#request.cwpage.urlDetails#">
		<cfset request.cwpage.baseurl = "?category=#request.cwpage.categoryid#&secondary=#request.cwpage.secondaryid#">
		<cfset request.cwpage.formWindowBaseUrl="#application.cw.appCWContentDir#cwapp/inc/cw-inc-optionselect.cfm">
		<cfset request.cwpage.logoutURL = "#application.cw.appCWStoreRoot#?#cgi.QUERY_STRING#">
		<cfsavecontent variable="returnContent">
		<cfinclude template="#request.cwpage.cwIncludePath#cw-productlist.cfm">
	</cfsavecontent>
		<cfreturn returncontent>
	</cffunction>

	<!--- PAGE: PRODUCT DETAILS --->
	<cffunction name="cwDisplayProductDetails" output="false" returntype="string">
		<cfargument required="true" name="product_id" type="numeric" default="0"
			hint="The ID of the product to display">
		<cfargument required="false" name="category" type="numeric" default="0"
			hint="The ID of the category to mark as current for this product">
		<cfargument required="false" name="secondary" type="numeric" default="0"
			hint="The ID of the secondary category to mark as current for this product">
		<cfset var returncontent = ''>
		<cfparam name="url.category" default="#arguments.category#">
		<cfparam name="url.secondary" default="#arguments.secondary#">
		<cfparam name="url.product" default="#arguments.product_id#">
		<!--- vars set in request scope override url for any product details page --->
		<cfset request.cwpage.productid = url.product>
		<cfset request.cwpage.categoryid = val(url.category)>
		<cfset request.cwpage.secondaryid = val(url.secondary)>
		<cfset request.cwpage.hrefUrl = "#request.cwpage.urlDetails#">
		<cfset request.cwpage.baseurl = "">
		<cfset request.cwpage.logoutURL = "#application.cw.appCWStoreRoot#?#cgi.QUERY_STRING#">
		<cfsavecontent variable="returnContent">
	<cfinclude template="#request.cwpage.cwIncludePath#cw-product.cfm">
	</cfsavecontent>
		<cfreturn returnContent>
	</cffunction>

	<!--- PAGE: CentLogic CHECKOUT --->
	<cffunction name="cwDisplayCheckout" output="false" returntype="string">
		<cfset var returncontent = ''>
		<cfset request.cwpage.hrefUrl = "#request.cwpage.urlCheckout#">
		<cfsavecontent variable="returncontent">
		<cfmodule template="#request.cwpage.cwIncludePath#cw-checkout.cfm">
	</cfsavecontent>
		<cfreturn returnContent>
	</cffunction>
    <!--- PAGE: CentLogic Confirm --->
    <cffunction name="cwDisplayConfirmOrder" output="false" returntype="string">
		<cfset var returncontent = ''>
		<cfset request.cwpage.hrefUrl = "#request.cwpage.urlConfirmOrder#">
		<cfsavecontent variable="returncontent">
		<cfmodule template="#request.cwpage.cwIncludePath#cw-confirm.cfm">
	</cfsavecontent>
		<cfreturn returnContent>
	</cffunction>

	<!--- PAGE: CentLogic ACCOUNT --->
	<cffunction name="cwDisplayAccount" output="false" returntype="string">
		<cfargument required="false" name="view_mode" type="string" default="account"
			hint="content to show (account|orders|details|products|views)">
		<cfset var returncontent = ''>
		<!--- set base page for links --->
		<cfset request.cwpage.hrefUrl = "#request.cwpage.urlAccount#">
		<cfset request.cwpage.viewMode = "#arguments.view_mode#">
		<cfsavecontent variable="returncontent">
		<cfmodule template="#request.cwpage.cwIncludePath#cw-account.cfm">
	</cfsavecontent>
		<cfreturn returnContent>
	</cffunction>

	<!--- PAGE: CentLogic CART --->
	<cffunction name="cwDisplayCart" output="false" returntype="string">
		<cfargument required="false" name="cart_heading" type="string" default=""
			hint="heading shown with cart contents">
		<cfargument required="false" name="cart_text" type="string" default=""
			hint="text shown with cart contents">
		<cfset var returncontent = ''>
		<!--- set base page for form --->
		<cfset request.cwpage.hrefUrl = "#request.cwpage.urlShowCart#">		
		<cfset request.cwpage.cartHeading = arguments.cart_heading>
		<cfset request.cwpage.cartText = arguments.cart_text>
		<cfsavecontent variable="returncontent">
		<cfmodule template="#request.cwpage.cwIncludePath#cw-cart.cfm">
	</cfsavecontent>
		<cfreturn returnContent>
	</cffunction>

	<!--- -------------------------- --->
	<!--- CentLogic DISPLAY MODULES --->
	<!--- -------------------------- --->

	<!--- NAVIGATION: CentLogic SEARCH/NAV --->
	<cffunction name="cwDisplaySearchNav" output="false" returntype="string">
		<cfargument name="search_type" required="false" default="Links" 
		type="string" hint="(List|Links|Form|Breadcrumb)">
		<cfargument name="action_page" required="false" default="#request.cwpage.urlResults#" type="string">
		<cfargument name="show_empty" required="false" default="#application.cw.appDisplayEmptyCategories#" type="boolean">
		<cfargument name="show_secondary" required="false" default="true" type="boolean">
		<cfargument name="relate_cats" required="false" default="#application.cw.appEnableCatsRelated#" type="boolean">
		<cfargument name="separator" required="false" default="|" type="string">
		<cfargument name="all_categories_label" required="false" default="All Products" type="string">
		<cfargument name="all_secondaries_label" required="false" default="All" type="string">
		<cfargument name="all_products_label" required="false" default="All Items" type="string">
		<cfargument name="show_product_count" required="false" default="true" type="boolean">
		<cfargument name="menu_id" required="false" default="" type="string">
		<cfargument name="menu_class" required="false" default="" type="string">
		<cfargument name="form_id" required="false" default="CWproductSearch" type="string">
		<cfargument name="form_keywords" required="false" default="false" type="boolean">
		<cfargument name="form_keywords_text" required="false" default="Search Products" type="string">
		<cfargument name="form_category" required="false" default="false" type="boolean">
		<cfargument name="form_category_label" required="false" default="All #application.cw.adminLabelCategories#" type="string">
		<cfargument name="form_secondary" required="false" default="false" type="boolean">
		<cfargument name="form_secondary_label" required="false" default="All #application.cw.adminLabelSecondaries#" type="string">
		<cfargument name="form_button_label" required="false" default="Search" type="string">

		<cfset var returncontent = ''>
		<cfset request.cwpage.hrefUrl = "#request.cwpage.urlShowCart#">
		<cfsavecontent variable="returncontent">			
			<cfmodule template="#request.cwpage.cwIncludePath#cwapp/mod/cw-mod-searchnav.cfm"
			search_type="#arguments.search_type#"
			action_page="#arguments.action_page#"
			show_empty="#arguments.show_empty#"
			show_secondary="#arguments.show_secondary#"
			relate_cats="#arguments.relate_cats#"
			separator="#arguments.separator#"
			all_categories_label="#arguments.all_categories_label#"
			all_secondaries_label="#arguments.all_secondaries_label#"
			all_products_label="#arguments.all_products_label#"
			show_product_count="#arguments.show_product_count#"
			menu_id="#arguments.menu_id#"
			menu_class="#arguments.menu_class#"
			form_id="#arguments.form_id#"
			form_keywords="#arguments.form_keywords#"
			form_keywords_text="#arguments.form_keywords_text#"
			form_category="#arguments.form_category#"
			form_category_label="#arguments.form_category_label#"
			form_secondary="#arguments.form_secondary#"
			form_secondary_label="#arguments.form_secondary_label#"
			form_button_label="#arguments.form_button_label#"
			>
		</cfsavecontent>
		<cfreturn returnContent>
	</cffunction>	
	
	<!--- PREVIEW: CentLogic CART --->
 	<cffunction name="cwDisplayCartPreview" output="false" returntype="string">
		<cfargument name="display_mode" required="false" default="showcart" type="string"
			hint="(showcart|summary|totals)">
		<cfargument name="show_images" required="false" default="false" type="boolean">
		<cfargument name="show_options" required="false" default="false" type="boolean">
		<cfargument name="show_sku" required="false" default="false" type="boolean">
		<cfargument name="show_continue" required="false" default="false" type="boolean">
		<cfargument name="show_total_row" required="false" default="true" type="boolean">
		<cfargument name="link_products" required="false" default="false" type="boolean">
		<cfargument name="show_promocode_input" required="false" default="#application.cw.discountsenabled#" type="boolean">
		<cfargument name="product_order" required="false" default="false" type="boolean">
		<cfset var returncontent = ''>
		<cfset request.cwpage.hrefUrl = "#request.cwpage.urlShowCart#">
		<cfsavecontent variable="returncontent">			
			<cfmodule template="#request.cwpage.cwIncludePath#cwapp/mod/cw-mod-cartdisplay.cfm"
			display_mode="#arguments.display_mode#"
			show_images="#arguments.show_images#"
			show_options="#arguments.show_options#"
			show_sku="#arguments.show_sku#"
			show_continue="#arguments.show_continue#"
			show_total_row="#arguments.show_total_row#"
			link_products="#arguments.link_products#"
			form_action=""
			>
		</cfsavecontent>
		<cfreturn returnContent>
	</cffunction>

	<!--- PREVIEW: CentLogic PRODUCT (single product, by id) --->
	<cffunction name="cwDisplayProductPreview" output="false" returntype="string">
		<cfargument name="product_id" required="false" default="0">
		<cfargument name="add_to_cart" required="false" default="false">
		<cfargument name="show_qty" required="false" default="true">
		<cfargument name="sku_id" required="false" default="0">
		<cfargument name="show_price" required="false" default="true">
		<cfargument name="show_discount" required="false" default="true">
		<cfargument name="show_alt" required="false" default="#application.cw.adminProductAltPriceEnabled#">
		<cfargument name="show_description" required="false" default="false">
		<cfargument name="show_image" required="false" default="true">
		<cfargument name="image_type" required="false" default="1">
		<cfargument name="image_class" required="false" default="CWimage">
		<cfargument name="image_position" required="false" default="above">
		<cfargument name="title_position" required="false" default="above">
		<cfargument name="details_page" required="false" default="#application.cw.appPageDetails#">
		<cfargument name="option_display_type" required="false" default="#application.cw.appDisplayOptionView#" type="string">
		<cfargument name="details_link_text" required="false" default="&raquo; Details" type="string">
		<cfset var returncontent = ''>
		<cfset arguments.details_page = '#application.cw.appCWStoreRoot#' & arguments.details_page>
		<cfset request.cwpage.hrefUrl = "#request.cwpage.urlDetails#">
		<cfset request.cwpage.baseurl = "">
		<cfset request.cwpage.logoutURL = "#application.cw.appCWStoreRoot#?#cgi.QUERY_STRING#">
		<cfsavecontent variable="returncontent">
		
		<cfmodule template="#request.cwpage.cwIncludePath#cwapp/mod/cw-mod-productpreview.cfm"
		product_id="#arguments.product_id#"
		add_to_cart="#arguments.add_to_cart#"
		show_qty="#arguments.show_qty#"
		sku_id="#arguments.sku_id#"
		show_price="#arguments.show_price#"
		show_discount="#arguments.show_discount#"
		show_alt="#arguments.show_alt#"
		show_description="#arguments.show_description#"
		show_image="#arguments.show_image#"
		image_type="#arguments.image_type#"
		image_class="#arguments.image_class#"
		image_position="#arguments.image_position#"
		title_position="#arguments.title_position#"
		details_page="#arguments.details_page#"
		details_link_text="#arguments.details_link_text#"
		option_display_type="#arguments.option_display_type#"
		>
		
	</cfsavecontent>
		<cfreturn returnContent>
	</cffunction>

	<!--- ----------------------------------- --->
	<!--- SPECIFIC PRODUCT GROUPINGS/FEATURES --->
	<!--- ----------------------------------- --->

	<!--- FEATURE: lookup top selling products --->
	<cffunction name="cwLookupProductsTop"
		access="public"
		output="false"
		returntype="query"
		hint="Returns a query of top selling products, with option to insert placeholder for new stores"
		>
		<cfargument name="max_products" required="false" default="5" type="numeric" 
			hint="number of products to return">
		<cfargument name="sub_ids" required="false" default="0" type="string" 
			hint="IDs of products to be shown until order data is available">
		<cfset var productQuery = ''>
		<cfset var sortQuery = ''>
		<cfset var idList = '#arguments.sub_ids#'>
		<cfset var keyIds = ''>
		<cfset var itemsToAdd = ''>
		<cfif not IsNumeric(listFirst(idList))>
			<cfset idList = '0'>
		</cfif>
		<cfquery name="productQuery" datasource="#application.cw.dsn#" username="#application.cw.dsnusername#" password="#application.cw.dsnpassword#" maxrows="#arguments.max_products#">
			SELECT count(*) as prod_counter, p.product_id, p.product_name, p.product_preview_description, p.product_date_modified FROM cw_products p INNER JOIN cw_order_skus o INNER JOIN cw_skus s WHERE o.ordersku_sku = s.sku_id AND s.sku_product_id = p.product_id AND NOT p.product_on_web = 0 AND NOT p.product_archive = 1 AND NOT s.sku_on_web = 0 GROUP BY product_id ORDER BY prod_counter DESC 
		</cfquery>
		<cfset idList = listPrepend(idList,valueList(productQuery.product_id))>
		<!--- if not enough results, fill in from sub_ids --->
		<cfif productQuery.recordCount lt arguments.max_products>
			<!--- number needed --->
			<cfset itemsToAdd = arguments.max_products - productQuery.recordCount>
			<cfloop from="1" to="#itemsToAdd#" index="ii">
				<cfif listLen(idList) gte ii>
					<cfset keyIDs = listAppend(keyIds,listGetAt(idList,ii))>
				</cfif>
			</cfloop>
			<cfquery name="resultsQuery" datasource="#application.cw.dsn#" username="#application.cw.dsnusername#" password="#application.cw.dsnpassword#" maxrows="#arguments.max_products#">
				SELECT 0 as prod_counter, p.product_id, p.product_name, p.product_preview_description, p.product_date_modified FROM cw_products p WHERE p.product_id in(#keyIds#) AND NOT p.product_on_web = 0 AND NOT p.product_archive = 1 ORDER BY product_date_modified DESC 
			</cfquery>
		<cfelse>
			<cfset resultsQuery = productQuery>
		</cfif>
		<!--- sort the results --->
		<cfquery name="sortQuery" dbtype="query" maxrows="#arguments.max_products#">
			SELECT * FROM resultsQuery ORDER BY prod_counter DESC, product_date_modified 
		</cfquery>
		<cfreturn sortQuery>
	</cffunction>

	<!--- FEATURE: TOP SELLING PRODUCTS --->
	<cffunction name="cwDisplayProductsTop" output="false" returntype="string">
		<cfargument name="max_products"
			required="false"
			default="5"
			type="numeric">
		<cfargument name="default_id_list"
			required="false"
			default=""
			type="string">
		<cfargument name="add_to_cart"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="show_qty"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="show_description"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="show_image"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="show_price"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="image_class"
			required="false"
			default="CWimgResults"
			type="string">
		<cfargument name="image_position"
			required="false"
			default="above"
			type="string">
		<cfargument name="title_position"
			required="false"
			default="below"
			type="string">
		<cfargument name="details_link_text"
			required="false"
			default="&raquo; details"
			type="string">
		<cfset var bsDisplay = ''>
		<!--- QUERY: return top selling products --->
		<cfset topProductsQuery = cwLookupProductsTop(max_products=arguments.max_products,sub_ids=arguments.default_id_list)>
		<!--- list of products by ID --->
		<cfset productIDs = valueList(topProductsQuery.product_id)>
		<cfsavecontent variable="bsDisplay">
	<!--- loop list of IDs from function above --->
			<cfloop list="#productIDs#" index="pp">
			<div class="CWlistingBox">
				<!--- show the product include --->
				<cfmodule
				template="#request.cwpage.cwIncludePath#cwapp/mod/cw-mod-productpreview.cfm"
				product_id="#pp#"
				add_to_cart="#arguments.add_to_cart#"
				show_qty="#arguments.show_qty#"
				show_description="#arguments.show_description#"
				show_image="#arguments.show_image#"
				show_price="#arguments.show_price#"
				image_class="#arguments.image_class#"
				image_position="#arguments.image_position#"
				title_position="#arguments.title_position#"
				details_link_text="#arguments.details_link_text#"
				>
			</div>
			</cfloop>
	</cfsavecontent>
		<cfreturn bsDisplay>
	</cffunction>

	<!--- FEATURE: lookup newest products --->
	<cffunction name="cwLookupProductsNew"
		access="public"
		output="false"
		returntype="query"
		hint="Returns a query of new products"
		>
		<cfargument name="max_products"
			required="false"
			default="5"
			type="numeric"
			hint="number of products to return">
		<cfset var productQuery = ''>
		<cfquery name="productQuery" datasource="#application.cw.dsn#" username="#application.cw.dsnusername#" password="#application.cw.dsnpassword#" maxrows="#arguments.max_products#">
			SELECT p.product_id, p.product_name, p.product_preview_description, p.product_date_modified FROM cw_products p WHERE NOT p.product_on_web = 0 AND NOT p.product_archive = 1 ORDER by p.product_date_modified DESC 
		</cfquery>
		<cfreturn productQuery>
	</cffunction>

	<!--- FEATURE: CentLogic NEWLY ADDED PRODUCTS --->
	<cffunction name="cwDisplayProductsNew" output="false" returntype="string">
		<cfargument name="max_products"
			required="false"
			default="5"
			type="numeric">
		<cfargument name="add_to_cart"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="show_qty"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="show_description"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="show_image"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="show_price"
			required="false"
			default="true"
			type="boolean">
		<cfargument name="image_class"
			required="false"
			default="CWimgResults"
			type="string">
		<cfargument name="image_position"
			required="false"
			default="above"
			type="string">
		<cfargument name="title_position"
			required="false"
			default="below"
			type="string">
		<cfargument name="details_link_text"
			required="false"
			default="&raquo; details"
			type="string">
		<cfset var npDisplay = ''>
		<!--- QUERY: return newest products --->
		<cfset newProductsQuery = cwLookupProductsNew(max_products=arguments.max_products)>
		<!--- list of products by ID --->
		<cfset productIDs = valueList(newProductsQuery.product_id)>
		<cfsavecontent variable="npDisplay">
	<!--- loop list of IDs from function above --->
	<cfloop list="#productIDs#" index="pp">
		<div class="CWlistingBox">
			<!--- show the product include --->
			<cfmodule
			template="#request.cwpage.cwIncludePath#cwapp/mod/cw-mod-productpreview.cfm"
			product_id="#pp#"
			add_to_cart="#arguments.add_to_cart#"
			show_qty="#arguments.show_qty#"
			show_description="#arguments.show_description#"
			show_image="#arguments.show_image#"
			show_price="#arguments.show_price#"
			image_class="#arguments.image_class#"
			image_position="#arguments.image_position#"
			title_position="#arguments.title_position#"
			details_link_text="#arguments.details_link_text#"
			>
		</div>
	</cfloop>
	</cfsavecontent>
		<cfreturn npDisplay>
	</cffunction>

	<!--- --------------------------- --->
	<!--- MURA/CentLogic USER BRIDGE --->
	<!--- --------------------------- --->
	
	<!--- CUSTOMER LOGIN: log into CentLogic if logging into Mura --->
	<cffunction name="onSiteLoginSuccess" output="false" returnType="any">
		<cfargument name="$">
		<cfset var CWremoteID = ''>
		<cfset var rsCust = ''>
		<cfset request.cwpage.cwLoginError = ''>
		<cfparam name="session.mura.username" default="">
		<cftry>
			<!--- load mura user content --->
			<cfset userBean = $.getBean('user').loadBy(username=$.currentUser('username'),siteID=$.event('siteID'))>

			<!--- NEW CW CUSTOMER: if remote ID does not exist --->
			<cfif not len(trim($.currentUser('remoteID')))>
				<!--- check for existing CW customer by username and email --->
				<cfquery name="rsCust" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
					SELECT customer_id, customer_username, customer_password, customer_email FROM cw_customers 
					WHERE customer_email = <cfqueryparam value="#$.currentUser('email')#" cfsqltype="cf_sql_varchar"> 
					AND customer_username = <cfqueryparam value="#$.currentUser('username')#" cfsqltype="cf_sql_varchar"> 
					AND NOT customer_guest = 1 
				</cfquery>
				<!--- if customer found --->
				<cfif rsCust.recordCount eq 1>
					<!--- write remote ID to mura user record --->
					<cfset CWremoteID = rsCust.customer_id>
					<cfset userBean.setRemoteID(CWremoteID)>
					<cfset userBean.save()>
				<!--- if no customer found --->
				<cfelse>
					<!--- run new customer function, returns new ID --->
					<cfset CWremoteID = CWnewCustomer($=$)>
					<cfset userBean = $.getBean('user').loadBy(username=$.currentUser('username'),siteID=$.event('siteID'))>
					<!--- if no errors, save remote ID --->
					<cfif not left(CWremoteID,2) is '0-'>
						<cfset userBean.setRemoteID(CWremoteID)>
						<!--- write remote ID to mura user record --->
						<cfset userBean.save()>
					</cfif>
				</cfif>
				<!--- if remote ID does exist --->
			<cfelse>
				<cfset CWremoteID = $.currentUser('remoteID')>
			</cfif>
			<!--- /END NEW CUSTOMER --->
			<!--- look Up CW customer details --->
			<!--- Note: at this point, a remote ID should exist one way or the other --->
			<cfset rsLookup = CWquerySelectCustomerDetails(CWremoteID)>
			<!--- if no match for ID (i.e. CW customer deleted, but remote ID exists in Mura) --->
			<cfif not rsLookup.recordCount eq 1>
				<!--- run new customer function, returns new ID --->
				<cfset CWremoteID = CWnewCustomer($=$)>
				<cfset userBean = $.getBean('user').loadBy(username=$.currentUser('username'),siteID=$.event('siteID'))>
					<!--- if no errors, save remote ID --->
					<cfif not left(CWremoteID,2) is '0-'>
						<cfset userBean.setRemoteID(CWremoteID)>
						<!--- write remote ID to mura user record --->
						<cfset userBean.save()>
					</cfif>
					<cfset rsLookup = CWquerySelectCustomerDetails(CWremoteID)>
			</cfif>
			<!--- if matched, login successful --->
			<cfif rsLookup.recordCount eq 1>
				<cfset session.cwclient.cwCustomerID = rsLookup.customer_id>
				<cfset session.cwclient.cwCustomerName = rsLookup.customer_username>
				<cfset session.cwclient.cwCustomerCheckout = 'account'>
				<!--- set customer type into session --->
				<cfif isNumeric(rsLookup.customer_type_id)>
					<cfset session.cwclient.cwcustomertype = rsLookup.customer_type_id>
				<cfelse>
					<cfset session.cwclient.cwcustomertype = '1'>
				</cfif>
				<!--- QUERY: get customer shipping region and country --->
				<cfset shippingQuery = CWquerySelectCustomerShipping(session.cwclient.cwCustomerID)>
				<!--- set customer tax region, ship region --->
				<cfset customerTaxRegionQuery = CWquerySelectStateProvDetails(rsLookup.stateprov_id)>
				<cfset customerShipRegionQuery = CWquerySelectStateProvDetails(shippingQuery.stateprov_id)>
				<cfif application.cw.taxChargeBasedOn eq 'billing'>
					<cfif customerTaxRegionQuery.recordCount gt 0>
						<cfset session.cwclient.cwTaxRegionID = customerTaxRegionQuery.stateprov_id>
						<cfset session.cwclient.cwTaxCountryID = customerTaxRegionQuery.stateprov_country_id>
					</cfif>
				</cfif>
				<cfif customerShipRegionQuery.recordCount gt 0>
					<cfset session.cwclient.cwShipRegionID = customerShipRegionQuery.stateprov_id>
					<cfset session.cwclient.cwShipCountryID = customerShipRegionQuery.stateprov_country_id>
					<cfif application.cw.taxChargeBasedOn eq 'shipping'>
						<cfset session.cwclient.cwTaxRegionID = customerShipRegionQuery.stateprov_id>
						<cfset session.cwclient.cwTaxCountryID = customerShipRegionQuery.stateprov_country_id>
					</cfif>
				</cfif>
				<!--- no match --->
			<cfelse>
				<!--- if no match --->
				<cfset session.cwclient.cwCustomerID = 0>
				<cfset structDelete(session.cwclient,'customerName')>
				<cfset request.cwpage.cwLoginError = "Error: store login not recognized">
				<cfset CWpageMessage("alert",request.cwpage.cwLoginError)>
			</cfif>
			<!--- / end login match y/n --->
			<!--- catch processing errors --->
			<cfcatch type="any">
				<cfif isDefined('application.cw.testModeEnabled') and application.cw.testModeEnabled is true>
					<cfdump var="#cfcatch#">
					<cfabort>
				</cfif>
				<cfset request.cwpage.cwLoginError = "Error: store login #cfcatch.detail# #cfcatch.message#">
				<cfset CWpageMessage("alert",request.cwpage.cwLoginError)>
			</cfcatch>
		</cftry>
	</cffunction>
	<!--- /end onSiteLoginSuccess --->

	<!--- SAVE USER: update / create CentLogic customer when saving Mura user record --->
	<cffunction name="onBeforeUserSave" output="false" returnType="void">
		<cfargument name="$" required="true">
		<cfset var rsLookup = ''>
				
		<!--- check for user with current remote ID in CentLogic --->
		<cfset rsLookup = CWquerySelectCustomerDetails($.event('userbean').getRemoteId())>
		<!--- if user does not exist in CW, create the user --->
		<cfif not rsLookup.recordCount>
			<cfset CWremoteID = CWnewCustomer($=$)>
			<!--- set customer ID as remote ID for user --->
			<cfset $.event("userBean").setRemoteID(CWremoteID)>
		<!--- if user does exist in CW, update CW record with user bean values (address, etc)--->
		<cfelse>
			<cfset rsUpdate = CWqueryUpdateMuraCustomer(
								customer_id=$.event('userbean').getRemoteId(),
								customer_type_id=1,
								customer_email=$.event('userbean').getEmail(),
								customer_first_name=$.event('userbean').getFname(),
								customer_last_name=$.event('userbean').getLname(),
								customer_username=$.event('userbean').getUsername(),
								customer_password=$.event('userbean').getPassword()
								)>
			<cfset CWremoteID = $.event('userbean').getRemoteId()>
			<!--- set any errors, prevents saving --->
			<cfif left(rsUpdate,2) is '0-'>
				<cfset $.event("userBean").getErrors().cwError = right(rsUpdate,len(rsUpdate)-2)>
			</cfif>
		</cfif>
		<!--- note: whatever values exist in the user bean at this point 
			is what will be saved into mura automatically as this userSave action completes--->
	</cffunction>
	<!--- /end onBeforeUserSave --->
	
	<!--- NEW CUSTOMER: create new CentLogic customer and set remote ID for Mura current user --->
	<cffunction name="CWnewCustomer" output="false" returntype="string">
		<cfargument name="$" required="true">
		<cfset var returnStr = ''>
		<cfset var customer_fname = ''>
		<cfset var customer_lname = ''>
		<cfset var customer_email = ''>
		
		<!--- load mura user content --->
		<cfset userBean=$.event('userbean')>
		
		<!--- fish out first/last name from session if logging in (not part of default login user bean) --->
		<cfif $.event('doaction') is 'login'>
			<cfif isDefined('session.mura.fname') and not len(trim($.event('fname')))>
				<cfset customer_fname = session.mura.fname>
			<cfelse>
				<cfset customer_fname = trim($.event('fname'))>
			</cfif>
			<cfif isDefined('session.mura.lname') and not len(trim($.event('lname')))>
				<cfset customer_lname = session.mura.lname>
			<cfelse>
				<cfset customer_lname = trim($.event('lname'))>
			</cfif>
			<cfif isDefined('session.mura.email') and not len(trim($.event('email')))>
				<cfset customer_email = session.mura.email>
			<cfelse>
				<cfset customer_email = trim($.event('email'))>
			</cfif>
		<!--- default, get values from event --->
		<cfelse>
			<cfif len(trim($.event('fname')))>
				<cfset customer_fname = trim($.event('fname'))>
			</cfif>
			<cfif len(trim($.event('lname')))>
				<cfset customer_lname = trim($.event('lname'))>
			</cfif>
			<cfif len(trim($.event('email')))>
				<cfset customer_email = trim($.event('email'))>
			</cfif>
		</cfif>
		<!--- create the CentLogic user (function returns customer ID on success) --->
		<cfset CWremoteID = CWqueryInsertCustomer(
			customer_type_id = 1,
			customer_firstname = customer_fname,
			customer_lastname = customer_lname,
			customer_username = $.event('username'),
			customer_password = $.event('password'),
			customer_email = customer_email,
			customer_ship_state = CWnullStateProv(),
			customer_state = CWnullStateProv(),
			prevent_duplicates = false
			)>
		<!--- if we have any errors (function returns 0- if error occurs)--->
		<cfif left(CWremoteID,2) is '0-'>
			<cfset request.cwpage.cwLoginError = right(CWremoteID,len(CWremoteID)-2)>
			<cfset userBean.getErrors().cwError=request.cwpage.cwLoginError>
			<cfset returnStr = request.cwpage.cwLoginError>
		<cfelse>
			<cfset returnStr = CWremoteID>	
		</cfif>
		<cfreturn returnStr>
	</cffunction>
	<!--- /end CWnewCustomer --->

	<!--- NULL STATEPROV: returns id of 'undefined' country and stateprov, and creates them if needed --->
	<cffunction name="CWnullStateProv" output="false" returntype="string">
		<cfset var returnStr = ''>
		<cfset var rsState = ''>
		<cfset var rsCountry = ''>
		<cfset var countryID = ''>
		<!--- look for country called 'undefined' --->
		<cfset rsCountry = CWquerySelectCountryDetails(0,'undefined','')>
		<cfif rsCountry.recordCount>
			<cfset countryID = rsCountry.country_id>
			<!--- if no match --->
		<cfelse>
			<cfset countryID = CWqueryInsertCountry('undefined','undefined',9999,1)>
		</cfif>
		<!--- look for stateprov called 'undefined' --->
		<cfset rsState = CWquerySelectStateProvDetails(0,'undefined','',countryID)>
		<cfif rsState.recordCount>
			<cfset returnStr = rsState.stateprov_id>
			<!--- if no match --->
		<cfelse>
			<cfset returnStr = CWqueryInsertStateProv(
				stateprov_name='undefined',
				stateprov_code='undefined',
				country_id=countryID,
				stateprov_archive=1
				)>
		</cfif>
		<cfreturn returnStr>
	</cffunction>
	<!--- /end CWnullStateProv --->

	<!--- UPDATE CUSTOMER from mura onBeforeUserSave --->
	<cffunction name="CWqueryUpdateMuraCustomer" access="public" output="false" returntype="string"
				hint="Updates a customer record - returns ID of the customer, or 0-message if unsuccessful">
	
		<!--- ID is required --->
		<cfargument name="customer_id" default="0" required="true" type="string"
					hint="ID of the customer to update">
	
		<!--- others optional, default NULL (not updated in CW record)--->
		<cfargument name="customer_type_id" default="0" required="false" type="numeric"
					hint="ID of the customer type">
	
		<cfargument name="customer_first_name" default="" required="false" type="string"
					hint="First Name of the customer to update">
	
		<cfargument name="customer_last_name" default="" required="false" type="string"
					hint="Last Name of the customer to update">
	
		<cfargument name="customer_email" default="" required="false" type="string"
					hint="Email Address">
	
		<cfargument name="customer_username" default="" required="false" type="string"
					hint="username">
	
		<cfargument name="customer_password" default="" required="false" type="string"
					hint="Password">
	
		<!--- validate unique email/username --->
		<cfargument name="prevent_duplicates" default="true" required="false" type="boolean"
					hint="If true, function throws error for duplicate email/username">
	
		<cfset var checkDupEmail = ''>
		<cfset var checkDupusername = ''>
		<cfset var updateCustID = ''>
		<cfset var randomStr = randRange(100000,999999)>
	
		<!--- verify email and username are unique --->
		<!--- check email --->
		<cfif len(trim(arguments.customer_email))>
		<cfquery name="checkDupEmail" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
		SELECT customer_email
		FROM cw_customers
		<!--- if checking for duplicates, check against existing email --->
			<cfif arguments.prevent_duplicates>
				WHERE customer_email = '#trim(arguments.customer_email)#'
				AND NOT customer_guest = 1
			<!--- if ignoring duplicates, pass dummy string to match --->
			<cfelse>
				WHERE customer_email = '#randomStr#'
			</cfif>
		AND NOT customer_id='#arguments.customer_id#'
		</cfquery>
		<!--- if we have a dup, return a message --->
		<cfif checkDupEmail.recordCount>
		<cfset updateCustID = '0-Email #arguments.customer_email# is in use with a different account'>
		</cfif>
		</cfif>
		<!--- check username --->
		<cfif len(trim(arguments.customer_username))>
		<cfquery name="checkDupusername" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
		SELECT customer_username
		FROM cw_customers
			<!--- if checking for duplicates, check against existing username --->
			<cfif arguments.prevent_duplicates>
				WHERE customer_username = '#trim(arguments.customer_username)#'
				AND NOT customer_guest = 1
			<!--- if ignoring duplicates, pass dummy string to match --->
			<cfelse>
				WHERE customer_username = '#randomStr#'
			</cfif>
		AND NOT customer_id='#arguments.customer_id#'
		</cfquery>
			<!--- if we have a dup, return a message --->
			<cfif checkDupusername.recordCount>
				<cfset updateCustID = '0-Username #arguments.customer_username# is in use with a different account'>
			</cfif>
		</cfif>
		<!--- if no duplicates --->
		<cfif not left(updateCustID,2) eq '0-'>
			<!--- update main customer record --->
			<cfquery datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
			UPDATE cw_customers 
			SET
			customer_date_modified = #createODBCDateTime(now())#
			<cfif arguments.customer_type_id gt 0>
			,customer_type_id = #arguments.customer_type_id#
			</cfif>
			<cfif len(trim(arguments.customer_first_name))>
			,customer_first_name = '#arguments.customer_first_name#'
			</cfif>
			<cfif len(trim(arguments.customer_last_name))>
			, customer_last_name = '#arguments.customer_last_name#'
			</cfif>
			<cfif len(trim(arguments.customer_email))>
			, customer_email='#arguments.customer_email#'
			</cfif>
			<cfif len(trim(arguments.customer_username))>
			, customer_username='#arguments.customer_username#'
			</cfif>
			<cfif len(trim(arguments.customer_password))>
			, customer_password='#arguments.customer_password#'
			</cfif>
			WHERE customer_id='#arguments.customer_id#'
			</cfquery>
			
			<cfset updateCustID = arguments.customer_id>
		</cfif>
		<!--- /END check dups --->
	<cfreturn updateCustId>
	</cffunction>
	<!--- /END cwQueryUpdateMuraCustomer --->

</cfcomponent>