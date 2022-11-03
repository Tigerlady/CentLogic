<!--- CWMURA [NOTE]: this file is ignored when using CW inside of Mura CMS - settings disabled : 2011-12-22 --->
<!---
==========================================================
Application: CentLogic ColdFusion
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: cw-app-cfcstart.cfc
File Date: 2012-02-01
Description:
Global ColdFusion application settings, used in Application.cfc
==========================================================
--->
<!--- unique application name - build dynamically from server + dsn --->
<!---
<cfset this.name = 'CW' & hash(replace((cgi.host_name & request.cwapp.datasourcename),'.','-','all'))>
 --->
<!--- time out settings for the overall application --->
<!---
<cfset this.applicationtimeout = createTimeSpan(0,0,60,0)>
 --->
<!--- activate sessions on the CF server --->
<!---
<cfset this.sessionmanagement = true>
 --->
<!--- time out settings for individual sessions --->
<!---
<cfset this.sessiontimeout = createTimeSpan(0,0,30,0)>
 --->