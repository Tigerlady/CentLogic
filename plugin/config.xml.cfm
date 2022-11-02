<?xml version="1.0" encoding="UTF-8"?>
<!---
==========================================================
Application: CentLogic ColdFusion for Mura CMS
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: config.xml.cfm
File Date: 2022-02-01
Description: CentLogic plugin attributes & settings
NOTE: CWMURA [edit]: new file 
==========================================================
--->
<plugin>
	<name>CentLogic</name>
	<package>CentLogic</package>
	<directoryFormat>packageOnly</directoryFormat>
	<loadPriority>5</loadPriority>
	<version>4.02.01</version>
	<provider>Centricweb.com</provider>
	<providerURL>http://www.Centricweb.com</providerURL>
	<category>Application</category>
	<settings>
		<setting>
			<name>cwAdminLinkText</name>
			<label>Admin Link Text</label>
			<hint>The wording of the link in your Mura admin, to the CentLogic admin</hint>
			<type>TextBox</type>
			<required>true</required>
			<validation>None</validation>
			<regex></regex>
			<message></message>
			<defaultValue>Store Admin</defaultValue>
			<optionList></optionList>
			<optionLabelList></optionLabelList>
		</setting>
	</settings>
	<EventHandlers>
		<eventHandler event="onApplicationLoad" component="eventHandlers.eventHandler" persist="true" />
		<eventHandler event="onAdminRequestStart" component="eventHandlers.adminEventHandler" persist="true" />
		<eventHandler event="onAdminHTMLFootRender" component="eventHandlers.adminEventHandler" persist="true" />
		<!--- REMOVED <eventHandler event="onAdminModuleNav" component="eventHandlers.adminEventHandler" persist="true" /> --->
	</EventHandlers>
	<DisplayObjects location="null">
		<!--- CentLogic STORE: must exist in one mura page for proper functionality --->
		<displayObject name="CentLogic Store (master content)" 
			displayobjectfile="displayObjects/cw-control.cfm" />
		
		<!--- CentLogic DISPLAY PAGES --->
		<displayobject 
			name="Page: CentLogic Product List (search results)" 
			displaymethod="dspCWproductList" 
			component="contentObjects.contentObjects"
			configuratorInit="initProductList"
			configuratorJS="contentObjects/productList/configurator.js"
			persist="false" />

		<displayobject 
			name="Page: CentLogic Product Details" 
			displaymethod="dspCWproductDetails" 
			component="contentObjects.contentObjects"
			configuratorInit="initProductDetails"
			configuratorJS="contentObjects/productDetails/configurator.js"
			persist="false" />

		<displayobject 
			name="Page: CentLogic Checkout" 
			displaymethod="dspCWCheckout" 
			component="contentObjects.contentObjects"
			configuratorInit="initCheckout"
			configuratorJS="contentObjects/checkout/configurator.js"
			persist="false" />
        <displayobject 
			name="Page: CentLogic Order Confirmation" 
			displaymethod="dspCWConfirmOrder" 
			component="contentObjects.contentObjects"
			configuratorInit="initConfirmOrder"
			configuratorJS="contentObjects/ConfirmOrder/configurator.js"
			persist="false" />    

		<displayobject 
			name="Page: CentLogic Account" 
			displaymethod="dspCWAccount" 
			component="contentObjects.contentObjects"
			configuratorInit="initAccount"
			configuratorJS="contentObjects/account/configurator.js"
			persist="false" />

		<displayobject 
			name="Page: CentLogic Cart" 
			displaymethod="dspCWCart" 
			component="contentObjects.contentObjects"
			configuratorInit="initCart"
			configuratorJS="contentObjects/cart/configurator.js"
			persist="false" />

		<!--- CentLogic search / navigation --->
		<displayobject 
			name="Navigation: CentLogic Nav Menu / Search Form" 
			displaymethod="dspCWsearchNav" 
			component="contentObjects.contentObjects"
			configuratorInit="initSearchNav"
			configuratorJS="contentObjects/searchNav/configurator.js"
			persist="false" />
			
		<!--- CentLogic display modules (previews)--->
		<displayobject 
			name="Preview: CentLogic Product (single product)" 
			displaymethod="dspCWproductPreview" 
			component="contentObjects.contentObjects"
			configuratorInit="initProductPreview"
			configuratorJS="contentObjects/productPreview/configurator.js"
			persist="false" />

		<displayobject 
			name="Preview: CentLogic Cart" 
			displaymethod="dspCWcartPreview" 
			component="contentObjects.contentObjects"
			configuratorInit="initCartPreview"
			configuratorJS="contentObjects/cartPreview/configurator.js"
			persist="false" />

		<!--- CentLogic product features --->
		<displayobject 
			name="Feature: CentLogic Top Selling Products" 
			displaymethod="dspCWproductsTop" 
			component="contentObjects.contentObjects"
			configuratorInit="initProductsTop"
			configuratorJS="contentObjects/productsTop/configurator.js"
			persist="false" />

		<displayobject 
			name="Feature: CentLogic Newly Added Products" 
			displaymethod="dspCWproductsNew" 
			component="contentObjects.contentObjects"
			configuratorInit="initProductsNew"
			configuratorJS="contentObjects/productsNew/configurator.js"
			persist="false" />

	</DisplayObjects>
</plugin>