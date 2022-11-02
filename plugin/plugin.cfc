<!---
==========================================================
Application: CentLogic ColdFusion for Mura CMS
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: plugin.cfc
File Date: 2012-05-22
Description: generic Mura plugin base routines
NOTE: CWMURA [edit]: new file 
==========================================================
--->
<cfcomponent extends="mura.plugin.plugincfc">

 	<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="pluginConfig" type="any" default="" />

		<cfset variables.pluginConfig = arguments.pluginConfig />

		<cfreturn this />
	</cffunction>

	<cffunction name="install" returntype="void" access="public" output="false">
	</cffunction>

	<cffunction name="update" returntype="void" access="public" output="false">
	</cffunction>

	<cffunction name="delete" returntype="void" access="public" output="false">
	</cffunction>

</cfcomponent>