Please note this file will need to be updated to accomidate an Open Source License.

==========================================================
Application: CentLogic ColdFusion for MASA CMS

Developer: Centric Web, Inc. | Centricweb.com
Licensing: http://www.Centricweb.com/eula
Support: http://www.Centricweb.com/support
==========================================================
File: README.TXT
File Date: 2022-11-01
CW Version: 4.03.01
Plugin Version: 1.03
Description: CentLogic plugin setup instructions
NOTE: The CentLogic plugin is designed to be installed into a single site within any MASA installation. 
While multi-site instances are possible, the default is a single, universal pool of products.

NOTICE/TERMS: CentLogic offers this plug in free of charge.
// -------------------//
// INSTALLATION NOTES //
// -------------------//

Need Notes here

---------------------
TO INSTALL THE PLUGIN
---------------------

- In your MASA admin, go to Site Settings > Global Settings, and click on the "Plugins" tab

- Under the "Upload New Plugin" heading, click the button to upload a new file, browse to your CentLogic MASA CMS Plugin download, select the "CentLogic.zip" file, and click "Deploy". This should upload and unpack the CentLogic plugin automatically.
 
- When MASA has finished uploading the plugin, you should see a landing page with the End User License Agreement and some basic notes about the plugin. 

- Select "I Accept" to agree to the license statement, then review the CentLogic plugin options. 
  The default values are fine in most cases, and can be changed later. Click "Update" to finish the installation.
  Important: be sure the checkbox is selected for the MASA Site to which you are adding the store. 
  (This can be checked later if you haven't added your site to MASA yet.)

- After completing the installation, you should be returned to the Global Settings > Plugins tab.
  If for some reason you are not seeing the Plugins list, you can click "Plugins", then "CentLogic" in the left side navigation menu.

- From the CentLogic Plugin main page, click the link to "Configure CentLogic Database".
  Follow the simple steps to add your CW tables to the MASA database. 
  Note: it is recommended to check the box to Delete Setup Files, unless installing on a temporary or staging environment where you may need to repeat the db setup. In general, this is a one-time process, and you won't want those files to be on the server after setup. 

- When completed, the Database Setup will redirect to the CentLogic Store Admin

- In the CentLogic admin area, review and complete all of the settings under 
  "Site Setup > Global Settings". If in doubt, leave the default settings in place.
  *Pay special attention to the "CW Store Root" setting. This should match the page to which you add the core plugin functionality.

- At this stage, you may freely explore the options available in the CentLogic Store Administration area.

Refer to the default CentLogic setup instructions and support documentation 
for instructions on configuring your site's Global Settings and other admin settings not specific to MASA CMS, at {need a place for docs} . 
	
-------------------------------------------
TO ADD CentLogic CONTENT TO YOUR MASA SITE
-------------------------------------------

- Create a page in MASA Site Manager which will serve as the root of the eCommerce section of your site (e.g. '/store').
  The entire CentLogic plugin will run from this page, with additional content added to additional custom pages as desired.
  *The name of the page can be anything you like, but the CentLogic Store Root must be set to match this page's URL
  (in the Store Admin under Site Setup > Global Settings)

- In the �Content Objects� tab for this page, select Plugins > CentLogic > "CentLogic Store (master content)"
  and place it into the primary display area on the page. This single step will add the entire CentLogic store to your site, all in one page. It also handles crucial base functionality such as Checkout and Order Confirmation when using CentLogic components on other pages.


- For simple installations, this may be all that is needed. 
  The entire CentLogic cart system will operate within this single MASA page if you so desire, with no further action required.

   To create more store pages using specific CentLogic content, there are two distinct options available, as outlined below:

   --------------------------------------	
   1. PLACE CONTENT USING DISPLAY OBJECTS
   --------------------------------------	

	- Select the Content Objects tab on any MASA Page
	
	- In the Available Content Objects, select "Plugins > CentLogic"
	
	- Select from any of the listed CentLogic Content Objects, and click to place it in any region of the page
	
	- View the page to confirm changes

	NOTE: for Content Objects with selectable options such as product, category, etc, a configurable interface will automatically appear. You can double-click on the configured object or use the front-end editor to change these configured options at any time after placement.

   --------------------------------------	
   2. PLACE CONTENT USING THE [MASA] TAG
   --------------------------------------	
	
	- When editing any MASA page, CentLogic functions can be invoked directly from the WYSIWYG editor.
	
	- These functions are listed in plugins/CentLogic/eventHandlers/eventHandler.cfc

	- All attributes can be passed to the functions within the special [MASA] tag (be sure the MASA tag is enabled in settings.ini.cfm)
	
	- EXAMPLES
	[MASA]cwDisplayProductList(category='55')[/MASA]
	[MASA]cwDisplayProductList(keywords='camera')[/MASA]
	[MASA]cwDisplayProductDetails(product_id='108')[/MASA]
	[MASA]cwDisplayCart(link_products=true,show_images=true)[/MASA]
	[MASA]cwDisplayAccount()[/MASA]

	- By invoking the CW display functions directly, single products can be placed inline with text, 
	and specific category selections or search terms can be used to show specific groupings of items within the layout of any page.
	There are a number of available configurations, see the methods in eventHandler.cfc as well as the CW native functions and display modules they control.
	Additional functions and/or display objects can be added by following the basic steps in the DEVNOTES.txt file provided as part of this plugin.

------------------------------
CentLogic PRODUCT PAGE TITLES
------------------------------

- To add CentLogic's product and category info to your MASA page titles, invoke the title like this in your MASA template: 
  <title>#request.cwpage.title# [other title content here if desired]</title>

---------------------------------
SSL REDIRECTION / SECURE CHECKOUT
---------------------------------

- In the CentLogic admin, under Global Settings, enter the secure URL for your site beginning with https:// to the Site Secure URL setting.

- Also in Global Settings, uncheck the box for non-https redirection (MASA handles this, CW does not need it enabled here)

- In MASA, you can optionally check a box in the advanced tab of any page, which will force the HTTPS prefix on that page
  This is not required, but can be applied to your cart page if you want the entire CW store to be https. 
  Also if you show the 'checkout' on any other page of your site outside the main store page, you will want to check the box to force HTTPS there.
  Normally, just leave that unchecked. There is a function in the plugin eventhandler.cfc which will force it for the checkout mode only.

NOTE: It is recommended that you leave 'index.cfm' in the MASA urls, and remove the 'siteid', at least when getting started
(These settings can be altered in the file located at MASA > config > settings.ini.cfm)

---------------------------
MASA/CentLogic USER BRIDGE
---------------------------

The connection between MASA Users (site members) and CentLogic Customers is managed by 
a series of methods in the eventHandler.cfc and a few specific edits to the CentLogic core files.
Logging in to either CentLogic or MASA will log the front-end user into the other, 
and adding or editing an account in either, will change the corresponding details in the other.
Further extension is possible, and likely in future releases.

------------------------------
CODE EDITS / CORE FILE CHANGES
------------------------------

All changes from the default CentLogic core files are marked with comments like
<!--- CWMASA ... --->

If making further changes it is recommended that you mark your own edits with a similar, 
unique comment string which can be found with a file search for future reference. 
It is also recommended that you save original, unaltered copies of any CentLogic files for future comparison.

To add further configurable CentLogic content, 
SEE DEVNOTES.TXT for basic outline of steps for adding new CW Display Objects

Extensions to existing Display Methods, Content Objects, and other CentLogic-integrated functionality are encouraged, and your feedback is always appreciated. 
Email michael@Centricweb.com or visit the CW forums http://forums.Centricweb.com to share your enhancements, questions and contributions.

-------------------------
CentLogic SUPPORT FORUMS
-------------------------

need a place