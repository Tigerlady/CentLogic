<cfsilent>
<!---
==========================================================
Application: CentLogic ColdFusion
Copyright 2002 - 2022, All Rights Reserved
Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: cw-inc-configdefaults.cfm
File Date: 2014-07-01
Description: creates placeholder values for custom application variables
when application is reset or initialized (called by cw-func-init.cfm)
Add lines below for any custom application configuration items created in admin
==========================================================
--->
<cfsavecontent variable="configlist">
adminCustomerPaging
adminDiscountThumbsEnabled
adminEditorCSS
adminEditorCategoryDescrip
adminEditorEnabled
adminEditorOptionDescrip
adminEditorProductDescrip
adminErrorHandling
adminHttpsRedirectEnabled
adminImagesMerchantDeleteOrig
adminLabelCategories
adminLabelCategory
adminLabelProductAltPrice
adminLabelProductKeywords
adminLabelProductSpecs
adminLabelSecondaries
adminLabelSecondary
adminOrderPaging
adminProductAltPriceEnabled
adminProductCustomInfoEnabled
adminProductDefaultBackOrderText
adminProductDefaultCustomInfo
adminProductDefaultPrice
adminProductImageMaxKB
adminProductImageSelectorThumbsEnabled
adminProductKeywordsEnabled
adminProductLinksEnabled
adminProductPaging
adminProductSpecsEnabled
adminProductUpsellByCatEnabled
adminProductUpsellThumbsEnabled
adminRecordsPerPage
adminSkuEditMode
adminSkuEditModeLink
adminThemeDirectory
adminWidgetCustomers
adminWidgetCustomersDays
adminWidgetOrders
adminWidgetProductsBestselling
adminWidgetProductsRecent
adminWidgetSearchCustomers
adminWidgetSearchOrders
adminWidgetSearchProducts
appActionAddToCart
appActionContinueShopping
appCWAdminDir
appCWAssetsDir
appCWContentDir
appCWStoreRoot
appCookieTerm
appDataDeleteEnabled
appDbType
appDisplayCartCustom
appDisplayCartCustomEdit
appDisplayCartImage
appDisplayCartOrder
appDisplayCartSku
appDisplayColumns
appDisplayCountryType
appDisplayEmptyCategories
appDisplayFreeShipMessage
appDisplayListingAddToCart
appDisplayOptionView
appDisplayPageLinksMax
appDisplayPerPage
appDisplayProductCategories
appDisplayProductQtyType
appDisplayProductSort
appDisplayProductSortType
appDisplayProductViews
appDisplayUpsell
appDisplayUpsellColumns
appEnableBackOrders
appEnableCatsRelated
appEnableImageZoom
appFreeShipMessage
appHttpRedirectEnabled
appImageDefault
appImagesDir
appInstallationDate
appOrderForceConfirm
appPageAccount
appPageCheckout
appPageConfirmOrder
appPageDetails
appPageResults
appPageSearch
appPageShowCart
appSearchMatchType
appSiteUrlHttp
appSiteUrlHttps
appTestModeEnabled
appVersionNumber
avalaraCompanyCode
avalaraDefaultCode
avalaraDefaultShipCode
avalaraID
avalaraKey
avalaraUrl
companyAddress1
companyAddress2
companyCity
companyCountry
companyEmail
companyFax
companyName
companyPhone
companyShipCountry
companyShipState
companyState
companyURL
companyZip
configSelectType
customerAccountEnabled
customerAccountRequired
customerRememberMe
debugApplication
debugCGI
debugCookies
debugDisplayExpanded
debugDisplayLink
debugEnabled
debugForm
debugHandleErrors
debugLocal
debugPassword
debugRequest
debugServer
debugSession
debugUrl
developerEmail
discountDisplayLineItem
discountDisplayNotes
discountsEnabled
fedexAccessKey
fedexAccountNumber
fedexMeterNumber
fedexPassword
fedexUrl
globalDateMask
globalLocale
globalTimeOffset
mailDefaultOrderPaidEnd
mailDefaultOrderPaidIntro
mailDefaultOrderReceivedEnd
mailDefaultOrderReceivedIntro
mailDefaultOrderShippedEnd
mailDefaultOrderShippedIntro
mailDefaultPasswordSendEnd
mailDefaultPasswordSentIntro
mailFootHtml
mailFootText
mailHeadHtml
mailHeadText
mailMultipart
mailSendOrderCustomer
mailSendOrderMerchant
mailSendPaymentCustomer
mailSendPaymentMerchant
mailSendShipCustomer
mailSmtpPassword
mailSmtpServer
mailSmtpUsername
paymentMethods
productPerPageOptions
shipChargeBase
shipChargeBasedOn
shipChargeExtension
shipDisplayInfo
shipDisplaySingleMethod
shipEnabled
shipWeightUOM
taxCalctype
taxChargeBasedOn
taxChargeOnShipping
taxDisplayID
taxDisplayLineItem
taxDisplayOnProduct
taxErrorEmail
taxIDNumber
taxSendLookupErrors
taxSystem
taxSystemLabel
taxUseDefaultCountry
upsAccessLicense
upsPassword
upsUrl
upsUserID
uspsUserID
uspsPassword
uspsUrl
</cfsavecontent>
<!--- loop the list with line-br delimiter --->
<cfloop list="#configList#" index="i" delimiters="#chr(10)#">
	<cfset varName = trim(i)>
	<cfif len(trim(varName))>
	<cfparam name="application.cw.#varname#" default="">
	</cfif>
</cfloop>
</cfsilent>