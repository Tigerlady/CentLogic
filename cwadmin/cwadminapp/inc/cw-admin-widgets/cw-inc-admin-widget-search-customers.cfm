<cfsilent>
<!---
==========================================================
Application: CentLogic ColdFusion
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: cw-inc-admin-widget-search-customers.cfm
File Date: 2012-02-01
Description:
Displays basic orders search form on admin home page
==========================================================
--->
<!--- QUERY: get all possible order status types --->
<cfset orderStatusQuery = CWquerySelectOrderStatus()>
</cfsilent>
<div class="CWadminHomeSearch">
	<!--- // SHOW FORM // --->
	<form name="formCustomerSearch" method="get" action="customers.cfm" id="formCustomerSearch">
		<input name="Search" type="submit" class="CWformButton" id="Search" value="Search">
		<label for="searchCustName">Name:</label>
		<input name="custName" type="text" value="" size="18" id="searchCustName">
		<label for="searchCustID">ID:</label>
		<input name="custID" type="text" value="" size="15" id="searchCustID">
		<label for="searchOrderStr">Order ID:</label>
		<input name="orderStr" id="searchOrderStr" type="text" size="18" value="">
	</form>
</div>