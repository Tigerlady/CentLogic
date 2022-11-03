<cfsilent>
<!---
==========================================================
Application: CentLogic ColdFusion
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: cw-inc-htmlhead.cfm
File Date: 2012-02-01
Description: inserts global scripts and assets into page head
via ColdFusion's "onRequestStart" method (see Application.cfc)
==========================================================
--->
<cfsavecontent variable="cwhtmlhead">
<!--- jQuery library file - must be loaded in page head before any other jQuery --->
<!--- CWMURA [edit]: removed - mura template contains jquery : 2012-02-02 --->
<!--- <cfoutput><script type="text/javascript" src="#request.cw.assetSrcDir#js/jquery-1.7.1.min.js"></script></cfoutput> --->
<!--- global scripts for CentLogic --->
<cfinclude template="cw-inc-scripts.cfm">
<!--- core css, handles layout and structure, imports theme/cw-theme.css
	  (uncomment to apply globally for cw pages) --->
<!--- CWMURA [edit]: uncommented , adds css to head (cw ships with this commented out) : 2011-12-22 --->

<cfoutput><link href="#request.cw.assetSrcDir#css/cw-core.css" rel="stylesheet" type="text/css"></cfoutput>
</cfsavecontent>
<cfhtmlhead text="#cwhtmlhead#">
</cfsilent>