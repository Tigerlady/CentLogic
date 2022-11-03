<cfsilent>
<!---
==========================================================
Application: CentLogic ColdFusion
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: cw-incpagestart.cfm
File Date: 2012-02-01
Description: manages global content on CentLogic store pages
==========================================================
--->
</cfsilent>
<div class="CWcontent">
	<!--- page alerts --->
	<cfinclude template="cw-inc-alerts.cfm">
	<!--- cart links --->
	<cfinclude template="cw-inc-cartlinks.cfm">
	<!--- STORE NAVIGATION --->
	<cfif request.cw.thisPage is application.cw.appPageDetails
	OR request.cw.thisPage is application.cw.appPageResults>
		<!--- category navigation --->
		<cfmodule template="../mod/cw-mod-searchnav.cfm"
		search_type="links"
		show_empty="false"
		show_secondary="true"
		show_product_count="false"
		relate_cats="#application.cw.appEnableCatsRelated#"
		all_categories_label=""
		all_secondaries_label="All"
		>
	</cfif>
</div>