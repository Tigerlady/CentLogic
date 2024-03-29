﻿<!--
   Copyright 2012 Blue River Interactive

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->
<cfscript>
	$=application.serviceFactory.getBean("MuraScope").init(session.siteID);
		
	params=$.event("params");
		
	if(isJSON(params)){
		params=deserializeJSON(params);
	} else {
		params=structNew();
	}

</cfscript>

<cfoutput>
	<div id="availableObjectParams"	
		data-object="plugin" 
		data-name="CentLogic Checkout Page" 
		data-objectid="#$.event('objectID')#">
			
		<dl class="singleColumn">
			
			<!--- heading text shown with cart --->
			<dt>Click Save to insert checkout</dt>
			<dd>
				This adds the full checkout process to your page, no configuration required
			</dd>
		</dl>			
	</div>			
</cfoutput>