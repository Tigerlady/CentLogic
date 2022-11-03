<!--- CWMURA [edit]: NEW FILE : 2012-08-03 --->
<cfsilent>
<!---
==========================================================
Application: CentLogic ColdFusion
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: cw-func-mura.cfm
File Date: 2012-07-31
Description: contains functions specific to CentLogic / Mura CMS integration
==========================================================
--->


<!--- // ---------- MURA CMS Functions ---------- // --->
<!--- // ---------- MURA CMS Functions ---------- // --->
<!--- // ---------- MURA CMS Functions ---------- // --->

<!--- // ---------- // log user in to Mura // ---------- // --->
<cffunction name="CWqueryCustomerMuraLogin"
			access="public"
			output="false"
			returntype="any"
			hint="logs customer into Mura CMS user base"
			>

	<cfargument name="customer_id"
			required="false" 
			default="0"
			type="string"
			hint="the CentLogic customer ID for the user"
			>

	<cfargument name="customer_username"
			required="false" 
			default=""
			type="string"
			hint="the CentLogic customer username"
			>
	<cfset var customerQuery = ''>
	<cfset var returnStr = ''>
	<cftry>
		<!--- get mura user bean --->
		<cfset $=application.serviceFactory.getBean("muraScope").init(session.siteID)>
		<cfset user=$.getBean("user").loadBy(remoteID=arguments.customer_id)>
		<!--- if no user found, try by username --->
		<cfif len(trim(arguments.customer_username)) and not len(trim(user.getRemoteID())) >
			<cfset user=$.getBean("user").loadBy(username=cwUserName)>
			<cfif arguments.customer_id is 0>
				<cfset arguments.customer_id = user.getRemoteID()>
			</cfif>
		</cfif>
		<!--- if user exists, log in --->
		<cfif len(trim(user.getRemoteID()))>
			<cfset arguments.customer_id = user.getRemoteID()>
			<!--- get user utility --->
			<cfset $.getBean("userUtility").loginByUserID(user.getUserID(),user.getSiteID())>			
			<!--- set siteArray --->
			<cfif session.mura.isLoggedIn and not structKeyExists(session,"siteArray") or ArrayLen(session.siteArray) eq 0>
				<cfset session.siteArray=arrayNew(1) />
				<cfset settingsManager = $.getBean("settingsManager") />
				<cfloop collection="#settingsManager.getSites()#" item="site">
					<cfif application.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")>
						<cfset arrayAppend(session.siteArray,site) />
					</cfif>
				</cfloop>
			</cfif>			
			<!--- return ID as confirmation --->
			<cfset returnStr = user.getRemoteID()>
		<!--- if no ID, create mura user --->
		<cfelse>
			<cfset customerQuery = CWquerySelectCustomerDetails(arguments.customer_id)>
			<!--- set CW values into mura user attributes --->
			<cfset user.setValue('fname',customerQuery.customer_first_name)>
			<cfset user.setValue('lname',customerQuery.customer_last_name)>
			<cfset user.setValue('username',customerQuery.customer_username)>
			<cfset user.setValue('password',customerQuery.customer_password)>
			<cfset user.setValue('email',customerQuery.customer_email)>
			<cfset user.setValue('remoteID',arguments.customer_id)>
			<cfset user.save()>
		</cfif>
		<!--- /end if user already exists --->
	<!--- handle any errors, pass back as 0- message --->	
	<cfcatch>
		<cfset returnStr = '0-No matching Mura account found'>
		<cfset user.getErrors().cwError=returnStr>
	</cfcatch>
	</cftry>
	<cfreturn returnStr>	
</cffunction>

<!--- // ---------- // update/create mura user account // ---------- // --->
<cffunction name="CWupdateMuraCustomer"
			access="public"
			output="false"
			returntype="any"
			hint="updates or adds mura CMS member record when customer is saved in CW"
			>

	<cfargument name="customer_id"
			required="true" 
			type="string"
			hint="the CentLogic customer ID for the user"
			>

	<cfargument name="customer_username"
			required="false" 
			default=""
			type="string"
			hint="the username"
			>

	<cfargument name="customer_password"
			required="false" 
			default=""
			type="string"
			hint="the password"
			>

	<cfargument name="customer_email"
			required="false" 
			default=""
			type="string"
			hint="the email address"
			>

	<cfargument name="customer_first_name"
			required="false" 
			default=""
			type="string"
			hint="the first name"
			>

	<cfargument name="customer_last_name"
			required="false" 
			default=""
			type="string"
			hint="the last name"
			>
	<cftry>
		<!--- get mura user bean --->
		<cfset $=application.serviceFactory.getBean("muraScope").init(session.siteID)>
		<cfset user=$.getBean("user").loadBy(remoteID=arguments.customer_id,siteID=session.siteID)>
			<!--- save user values --->			
			<cfset user.setValue('remoteID',arguments.customer_id)>
			<cfset user.setValue('username',arguments.customer_username)>
			<cfset user.setValue('password',arguments.customer_password)>
			<cfset user.setValue('email',arguments.customer_email)>
			<cfset user.setValue('fname',arguments.customer_first_name)>
			<cfset user.setValue('lname',arguments.customer_last_name)>
			<cfset user.save()>
		<cfset returnStr = arguments.customer_id>
	<cfcatch>
		<cfset returnStr = '0-No matching Mura account found'>
		<cfset user.getErrors().cwError=returnStr>
	</cfcatch>
	</cftry>
	<cfreturn returnStr>	
</cffunction>

</cfsilent>