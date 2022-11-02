<!---
==========================================================
Application: CentLogic ColdFusion for Mura CMS
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: config.cfm
File Date: 2012-05-22
Description: CentLogic plugin configuration
NOTE:CWMURA [edit]: new file 
==========================================================
--->
<cfsilent>
<cfif not structKeyExists(request,"pluginConfig")>
	<cfset pluginID=listLast(listGetat(getDirectoryFromPath(getCurrentTemplatePath()),listLen(getDirectoryFromPath(getCurrentTemplatePath()),application.configBean.getFileDelim())-1,application.configBean.getFileDelim()),"_")>
	<cfset request.pluginConfig=application.pluginManager.getConfig(pluginID)>
	<cfset request.pluginConfig.setSetting("pluginMode","Admin")/>
</cfif>

<cfif request.pluginConfig.getSetting("pluginMode") eq "Admin" and not isUserInRole('S2')>
	<cfif not structKeyExists(session,"siteID") or not application.permUtility.getModulePerm(request.pluginConfig.getValue('moduleID'),session.siteid)>
		<cflocation url="#application.configBean.getContext()#/admin/" addtoken="false">
	</cfif>
</cfif>

<!--- CWMURA [edit]: add redirection if session is unavailable : 2011-12-22 --->

<cfif not structKeyExists(session,'dashboardspan')>
	<cflocation url="#application.configBean.getContext()#/admin/" addtoken="false">
</cfif>

</cfsilent>