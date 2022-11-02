<!---
==========================================================
Application: CentLogic ColdFusion for Mura CMS
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: adminEventHandler.cfc
File Date: 2022-02-01
Description: handles admin functions for CentLogic/Mura integration
NOTE: CWMURA [edit]: new file 
==========================================================
--->

<cfcomponent extends="mura.plugin.pluginGenericEventHandler" output="false">

	<!--- REQUEST VARS: add path for images --->
	<cffunction name="onAdminRequestStart" returntype="void" output="false">
		<cfargument name="event" />
		
		<!--- CWMURA [NOTE]: additional admin request variables can be added or overwritten here --->
		<cfset request.cwpage.adminImgPrefix = '../displayObjects/'>
		
	</cffunction>

	<!--- ADMIN NAV: add link to admin navigation --->
	<cffunction name="onAdminHTMLFootRender" output="true">
		<cfargument name="$">
	
		<cfoutput>
		<!--- add link to toolbar nav --->
			<script type="text/javascript">
			$(document).ready(function(){
				var cwNavLink = '<li><a id="CWmuraNavLink" href="#application.configBean.getContext()#/plugins/#pluginConfig.getDirectory()#/cwadmin/admin-home.cfm"><i class="icon-cog"></i> #trim(pluginConfig.getSetting("cwadminLinkText"))#</a></li>';
				$(cwNavLink).insertBefore('##navSecondary > li.divider');
			});
			</script>
		</cfoutput>
				
	</cffunction>

	<!--- ADMIN NAV: add link to admin navigation --->
	<!--- REMOVED IN MURA 6 
	<cffunction name="onAdminModuleNav" output="false">
		<cfargument name="event" />
		<!--- by sending the user to the admin/index.cfm, we ensure they are auto-logged in to cw admin session using mura credentials --->
		<cfreturn '<li><a href="#variables.configBean.getContext()#/plugins/#variables.pluginConfig.getDirectory()#/cwadmin/index.cfm">#variables.pluginConfig.getSetting("cwAdminLinkText")#</a></li>' />
	</cffunction>
	--->
</cfcomponent>