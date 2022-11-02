<cfsilent>
<!---
==========================================================
Application: CentLogic ColdFusion for Mura CMS
Copyright 2002 - 2012, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: index.cfm
File Date: 2022-02-01
Description: CentLogic Plugin installation / management page
NOTE: CWMURA [edit]: new file 
==========================================================
--->

<cfinclude template="plugin/config.cfm">
<cfset request.cw.adminLinkText = request.pluginConfig.getSetting("cwadminLinkText")>
<cfif not len(trim(request.cw.adminLinkText))>
	<cfset request.cw.adminLinkText = 'Store Admin'>
</cfif>
<cfsavecontent variable="variables.body">
	<cfoutput>
	<h2>#request.pluginConfig.getName()# for Mura CMS</h2>
	<!--- show store link if at least one product exists --->
	<cfif isDefined('application.cwdata.listProducts') 
			and structCount(application.cwdata.listProducts) gt 0>
		<p>&raquo; <a href="cwadmin/admin-home.cfm">#request.cw.adminLinkText#</a></p>
		<p>&raquo; <a href="cwadmin/orders.cfm">Manage Orders</a></p>
		<p>&raquo; <a href="cwadmin/products.cfm">Manage Products</a></p>
		<p>&raquo; <a href="cwadmin/customers.cfm">Manage Customers</a></p>
	</cfif>
	<!--- show setup link if files exist (db setup deletes itself and the sql file after running) --->
	<cfif fileExists(expandPath('cwadmin/db-setup.cfm')) and 
		(fileExists(expandPath('cwadmin/db-mysql.sql')) or fileExists(expandPath('cwadmin/db-mssql.sql')))>
		<p>&raquo; <a href="cwadmin/db-setup.cfm">Configure CentLogic Database</a></p>
	</cfif>
	<!--- general CW links --->
		<p>&raquo; <a href="README.txt" target="_blank">Installation Instructions</a></p>
		<p>&raquo; <a href="http://docs.centricweb.com" target="_blank">CentLogic Documentation</a></p>
	</cfoutput>
</cfsavecontent>
</cfsilent>

<cfoutput>#application.pluginManager.renderAdminTemplate(body=variables.body,pageTitle=request.pluginConfig.getName())#</cfoutput>