<cfsilent>
<!---
==========================================================
Application: CentLogic ColdFusion
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: cw-func-query.cfm
File Date: 2014-05-27
Description: misc. CentLogic query functions
==========================================================
--->

<!--- /////////////// --->
<!--- COUNTRY / REGION QUERIES --->
<!--- /////////////// --->

<!--- // ---------- Get ALL State/Provs ---------- // --->
<cfif not isDefined('variables.CWquerySelectStates')>
<cffunction name="CWquerySelectStates" access="public" output="false" returntype="query"
			hint="Returns a query with all available states including country details">

			<cfargument name="country_id" required="false" default="0" type="numeric"
						hint="The Country ID to lookup. Default is 0 (all)">

<cfset var rsGetStateList = "">
<cfquery name="rsGetStateList" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
SELECT
	cw_countries.*,
	cw_stateprov.*
FROM cw_countries
INNER JOIN cw_stateprov
	ON cw_countries.country_id = cw_stateprov.stateprov_country_id
WHERE
	cw_stateprov.stateprov_archive = 0
	AND cw_countries.country_archive = 0
	<cfif arguments.country_id gt 0>
	AND cw_countries.country_id = #arguments.country_id#
	</cfif>
ORDER BY
	cw_countries.country_sort,
	cw_countries.country_name,
	cw_stateprov.stateprov_name
</cfquery>

<cfreturn rsGetStateList>
</cffunction>
</cfif>

<!--- // ---------- Get ALL Countries ---------- // --->
<cfif not isDefined('variables.CWquerySelectCountries')>
<cffunction name="CWquerySelectCountries" access="public" output="false" returntype="query"
			hint="Returns a query with all available countries">

		<cfargument name="show_archived" required="false" default="1" type="boolean"
					hint="Include archived countries (y/n)">

<cfset var rsGetCountryList = "">
<cfquery name="rsGetCountryList" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
SELECT country_id, country_name
FROM cw_countries
<cfif arguments.show_archived eq 0>
WHERE NOT country_archive = 1
</cfif>
ORDER BY country_name
</cfquery>

<cfreturn rsGetCountryList>
</cffunction>
</cfif>

<!--- // ---------- Get ALL State/Provs by country ---------- // --->
<cfif not isDefined('variables.CWquerySelectCountryStates')>
<cffunction name="CWquerySelectCountryStates" access="public" output="false" returntype="query"
			hint="Returns a query with all available countries">

		<cfargument name="states_archived" required="false" default="0" type="numeric"
					hint="Show archived or active countries (1=archived,0=active,)">

<cfset var rsCountryStatesList = "">
<cfquery name="rsCountryStatesList" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
SELECT
cw_countries.*,
cw_stateprov.*
FROM cw_countries
LEFT JOIN cw_stateprov
ON cw_countries.country_id = cw_stateprov.stateprov_country_id
<cfif arguments.states_archived neq 2>
WHERE cw_countries.country_archive = #arguments.states_archived#
</cfif>
ORDER BY country_sort, country_name, stateprov_name
</cfquery>

<cfreturn rsCountryStatesList>
</cffunction>
</cfif>

<!--- // ---------- Get Country IDs for user defined states ---------- // --->
<cfif not isDefined('variables.CWquerySelectStateCountryIDs')>
<cffunction name="CWquerySelectStateCountryIDs" access="public" output="false" returntype="query"
			hint="Select country IDs with user defined states">

<cfset var rsGetStateCountryIDs = ''>

<cfquery name="rsGetStateCountryIDs" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
SELECT DISTINCT stateprov_country_id
FROM cw_stateprov
WHERE NOT #application.cw.sqlLower#(stateprov_name) in('none','all')
</cfquery>

<cfreturn rsGetStateCountryIDs>

</cffunction>
</cfif>

<!--- // ---------- Get State/Prov Details ---------- // --->
<cfif not isDefined('variables.CWquerySelectStateProvDetails')>
<cffunction name="CWquerySelectStateProvDetails" access="public" output="false" returntype="query"
			hint="Look up stateprov details by ID, name or code - at least one argument must match">

	<cfargument name="stateprov_id" required="true" type="numeric"
				hint="ID of the stateprov to look up - pass in 0 to select all IDs">
	<cfargument name="stateprov_name" required="false" default='' type="string"
				hint="Name of the stateprov - pass in blank '' or omit to select all names">
	<cfargument name="stateprov_code" required="false" default='' type="string"
				hint="Stateprov processing code - pass in blank '' or omit to select all codes">
	<cfargument name="country_id" required="false" default="0" type="boolean"
				hint="Stateprov related country ID - pass in 0 or blank to select all countries">
	<cfargument name="omit_list" required="false" default="0" type="string"
		hint="A list of IDs to omit">

	<cfset var rsSelectStateProv = ''>

		<!--- look up stateprov --->
		<cfquery name="rsSelectStateProv" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
		SELECT *
		FROM cw_stateprov
		WHERE 1 = 1
		<cfif arguments.stateprov_id gt 0>AND stateprov_id = #arguments.stateprov_id#</cfif>
		<cfif arguments.stateprov_name gt 0>AND stateprov_name = '#arguments.stateprov_name#'</cfif>
		<cfif arguments.stateprov_code gt 0>AND stateprov_code = '#arguments.stateprov_code#'</cfif>
		<cfif arguments.country_id gt 0>AND stateprov_country_id = #arguments.country_id#</cfif>
		<cfif arguments.omit_list neq 0>AND NOT stateprov_id in(#arguments.omit_list#)</cfif>
		</cfquery>

	<cfreturn rsSelectStateProv>

</cffunction>
</cfif>


<!--- CWMURA [edit]: add these functions to front end from adminqueries file : 2012-05-22 --->
<!--- // ---------- Insert State/Prov ---------- // --->
<cfif not isDefined('variables.CWqueryInsertStateProv')>
<cffunction name="CWqueryInsertStateProv" access="public" output="false" returntype="string"
			hint="Inserts a stateprov record - returns new ID or 0- error">

	<!--- Name, code and country are required --->
	<cfargument name="stateprov_name" required="true" type="string"
				hint="Name of the stateprov">
	<cfargument name="stateprov_code" required="true" type="string"
				hint="StateProv processing code">
	<cfargument name="country_id" required="true" type="string"
				hint="Country ID for related country">
	<!--- others are optional --->
	<cfargument name="stateprov_archive" required="false" default="0" type="string"
				hint="Archive Y/N">
	<cfargument name="stateprov_tax" required="false" default="0" type="string"
				hint="Tax Rate">
	<cfargument name="stateprov_ship_ext" required="false" default="0" type="string"
				hint="Shipping Extension">

	<cfset var newRecordID = ''>
	<cfset var getNewID = ''>
	<cfset var errorMsg = ''>

<!--- check for duplicates by name, in given country --->
<cfset dupNameCheck = CWquerySelectStateProvDetails(0,arguments.stateprov_name,'',arguments.country_id)>
<!--- if we have a duplicate, return an error message --->
<cfif dupNameCheck.recordCount>
<cfset errorMsg = errorMsg & "<br>Region Name '#arguments.stateprov_name#' already exists">
</cfif>

<!--- check for duplicates by code, in given country --->
<cfset dupCodeCheck = CWquerySelectStateProvDetails(0,'',arguments.stateprov_code,arguments.country_id)>
<!--- if we have a duplicate, return an error message --->
<cfif dupCodeCheck.recordCount>
<cfset errorMsg = errorMsg & "<br>Code '#arguments.stateprov_code#' already exists">
</cfif>

<!--- if no duplicate, insert --->
<cfif not len(trim(errorMsg))>
		<!--- insert record --->
		<cfquery datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
		INSERT INTO cw_stateprov
		(
		stateprov_name,
		stateprov_code,
		stateprov_country_id,
		stateprov_archive,
		stateprov_tax,
		stateprov_ship_ext
		)
		VALUES
		(
		'#arguments.stateprov_name#',
		'#arguments.stateprov_code#',
		#arguments.country_id#,
		#arguments.stateprov_archive#,
		#arguments.stateprov_tax#,
		#arguments.stateprov_ship_ext#
		)
		</cfquery>

		<!--- Get the new ID --->
		<cfquery name="getNewID" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
		SELECT stateprov_id FROM cw_stateprov
		WHERE stateprov_name = '#arguments.stateprov_name#'
		AND stateprov_code = '#arguments.stateprov_code#'
		AND stateprov_country_id = #arguments.country_id#
		</cfquery>

	<cfset newRecordID = getnewID.stateprov_id>

<!--- if we did have a duplicate, return error code --->
<cfelse>
<cfset newRecordID = '0-Error: #errorMsg#'>
</cfif>

<cfreturn newRecordID>

</cffunction>
</cfif>

<!--- // ---------- Update State/Prov ---------- // --->
<cfif not isDefined('variables.CWqueryUpdateStateProv')>
<cffunction name="CWqueryUpdateStateProv" access="public" output="false" returntype="string"
			hint="Update a stateprov record - returns updated ID or 0- error message">

<!--- id is required --->
		<cfargument name="stateprov_id" type="numeric" required="true"
					hint="ID of the record to update">

<!--- others are optional --->
		<cfargument name="stateprov_name" type="string" required="false" default=""
					hint="Name of the stateprov">
		<cfargument name="stateprov_code" type="string" required="false" default=""
					hint="Stateprov processing code">
		<cfargument name="stateprov_archive" required="false" default="2" type="string"
					hint="Archive Y/N">

<cfset var updatedID = ''>
<cfset var errorMsg = ''>
<cfset var checkCountry = ''>
<cfset var countryID = ''>

<!--- get country of this stateprov --->
<cfset checkCountry = CWquerySelectStateProvDetails(arguments.stateprov_id,'','',0)>
<cfset countryID = checkCountry.stateprov_country_id>

<!--- check for duplicates by name, in given country --->
<cfset dupNameCheck = CWquerySelectStateProvDetails(0,arguments.stateprov_name,'',countryID,arguments.stateprov_id)>
<!--- if we have a duplicate, return an error message --->
<cfif dupNameCheck.recordCount>
<cfset errorMsg = errorMsg & "<br>Region Name '#arguments.stateprov_name#' already exists">
</cfif>

<!--- check for duplicates by code, in given country --->
<cfset dupCodeCheck = CWquerySelectStateProvDetails(0,'',arguments.stateprov_code,countryID,arguments.stateprov_id)>
<!--- if we have a duplicate, return an error message --->
<cfif dupCodeCheck.recordCount>
<cfset errorMsg = errorMsg & "<br>Code '#arguments.stateprov_code#' already exists">
</cfif>

<!--- if no duplicate, update --->
<cfif not len(trim(errorMsg))>

			<cfquery datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
			UPDATE cw_stateprov
				SET stateprov_id = stateprov_id
					<cfif len(trim(arguments.stateprov_name))>
						,stateprov_name = '#arguments.stateprov_name#'
					</cfif>
					<cfif len(trim(arguments.stateprov_code))>
						,stateprov_code = '#arguments.stateprov_code#'
					</cfif>
					<cfif arguments.stateprov_archive neq 2>
						,stateprov_archive = #arguments.stateprov_archive#
					</cfif>
				WHERE stateprov_id=#arguments.stateprov_id#
			</cfquery>
			<cfset updatedID = arguments.stateprov_id>

<!--- if error message, return string --->
<cfelse>
<cfset updatedID  = '0-Error: #errorMsg#'>

</cfif>

<cfreturn updatedID>

</cffunction>
</cfif>

<!--- // ---------- Get Country Details ---------- // --->
<cfif not isDefined('variables.CWquerySelectCountryDetails')>
<cffunction name="CWquerySelectCountryDetails" access="public" output="false" returntype="query"
			hint="Look up country details by ID, name or code - at least one argument must match">

	<cfargument name="country_id" required="true" type="numeric"
				hint="ID of the country to look up - pass in 0 to select all IDs">
	<cfargument name="country_name" required="true" type="string"
				hint="Name of the country - pass in blank to select all names">
	<cfargument name="country_code" required="true" type="string"
				hint="Country processing code - pass in blank to select all codes">
	<cfargument name="omit_list" required="false" default="0" type="string"
		hint="A list of IDs to omit">

	<cfset var rsSelectCountry = ''>

		<!--- look up country --->
		<cfquery name="rsSelectCountry" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
		SELECT *
		FROM cw_countries
		WHERE 1 = 1
		<cfif arguments.country_id gt 0>AND country_id = #arguments.country_id#</cfif>
		<cfif arguments.country_name gt 0>AND country_name = '#arguments.country_name#'</cfif>
		<cfif arguments.country_code gt 0>AND country_code = '#arguments.country_code#'</cfif>
		<cfif arguments.omit_list neq 0>AND NOT country_id in(#arguments.omit_list#)</cfif>
		</cfquery>

	<cfreturn rsSelectCountry>

</cffunction>
</cfif>
<!--- CWMURA [end]: end new functions for mura : 2012-05-22 --->


<!--- /////////////// --->
<!--- CREDIT CARD QUERIES --->
<!--- /////////////// --->

<!--- // ---------- Get All Credit Cards ---------- // --->
<cfif not isDefined('variables.CWquerySelectCreditCards')>
<cffunction name="CWquerySelectCreditCards" access="public" output="false" returntype="query"
			hint="Returns a query with all credit card names and codes">

	<cfargument name="card_code"
			required="false"
			default=""
			type="string"
			hint="a card code to match">

<cfset var rsCCardList = ''>
<cfquery name="rsCCardList" datasource="#application.cw.dsn#" username="#application.cw.dsnUsername#" password="#application.cw.dsnPassword#">
SELECT *
FROM cw_credit_cards
<cfif len(trim(arguments.card_code))>
WHERE creditcard_code = <cfqueryparam value="#trim(arguments.card_code)#" cfsqltype="cf_sql_varchar">
</cfif>
ORDER BY creditcard_name
</cfquery>

<cfreturn rsCCardList>
</cffunction>
</cfif>

</cfsilent>