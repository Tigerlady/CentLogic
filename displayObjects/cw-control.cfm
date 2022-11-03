<!--- CWMURA [edit]: new file, plugin controller file : 2011-12-23 --->
<cfsilent>
<!---
==========================================================
Application: CentLogic ColdFusion
Copyright 2002 - 2009, All Rights Reserved
Developer: Application Dynamics Inc.,
		   1560 NE 10th, East Wenatchee, WA 98802
Support: http://www.Centricweb.com/support
==========================================================
File: cw-control
File Date: 2014-06-04
Description: CentLogic content controller for mura cms store
==========================================================
--->

<!--- select page content based on full url --->
<cfparam name="request.cw.thisUrl" default="#cgi.path_info#">
<!--- CWMURA [edit]: changed from url.path to request.cw.thisurl : 2014-06-05 --->
<cfset cwincname = trim(listFirst(request.cw.thisUrl,'?'))>
<cfset cwincname = listLast(cwincname,'/')>

</cfsilent>

<!--- cart links, log in links, alerts --->
<cfinclude template="cwapp/inc/cw-inc-pagestart.cfm">

<cfif cwincName eq listLast(request.cwpage.urlResults,'/')>
		<cfinclude template="cw-productlist.cfm">
<cfelseif cwincName eq listLast(request.cwpage.urlDetails,'/')>
		<cfinclude template="cw-product.cfm">
<cfelseif cwincName eq listLast(request.cwpage.urlCheckout,'/')>
		<cfinclude template="cw-checkout.cfm">
<cfelseif cwincName eq listLast(request.cwpage.urlConfirmOrder,'/')>
		<cfinclude template="cw-confirm.cfm">
<cfelseif cwincName eq listLast(request.cwpage.urlAccount,'/')>
		<cfinclude template="cw-account.cfm">
<cfelseif cwincName eq listLast(request.cwpage.urlShowcart,'/')>
		<cfinclude template="cw-cart.cfm">
<cfelseif cwincName eq listLast(request.cwpage.urlDownload,'/')>
		<cfinclude template="cw-download.cfm">
<!--- invoke 'reset.cfm' to clear values --->
<cfelseif cwincName eq 'reset.cfm'>
	<!--- clear all cw cookie vars (set to null/expired) --->
	<cfloop collection="#cookie#" item="cc">
		<cfif left(cc,2) is 'cw'>
			<cfcookie name="#cc#" value="" expires="NOW">
		</cfif>
	</cfloop>
	<!--- clear session --->
	<cfset structClear(session.cw)>
	<cfset structClear(session.cwclient)>
	<cfset session.cw.userConfirm = "Session Reset Successful">
	<cflocation url="#application.cw.appPageResultsurl#" addtoken="no">
<!--- if no page requested with store URL, default to results page --->
<cfelse>
		<cfinclude template="cw-productlist.cfm">
</cfif>


<!--- NOTE: anything added here will be output on every CW page --->
<!---
<cfdump var="#request.cw#" label="REQUEST.CW">
<cfdump var="#request.cwpage#" label="REQUEST.CWPAGE">
<cfdump var="#url#" label="url">
<cfdump var="#request#" label="request">
 --->
