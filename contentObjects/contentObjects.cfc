// CentLogic DISPLAY EVENTS FOR CONFIGURATOR DISPLAY OBJECTS 
// ==========================================================
// Application: CentLogic ColdFusion
// Copyright 2002 - 2022, All Rights Reserved
// Developer: Centric Web, Inc. | Centricweb.com
// Licensing: http://www.Centricweb.com/eula
// Support: http://www.Centricweb.com/support
// ==========================================================
// File: contentObjects.cfc
// File Date: 2012-09-12


component extends="mura.plugin.pluginGenericEventHandler" {

	public any function init(){
		return this;
	}

	// 	Page: PRODUCT LIST
	public any function dspCWproductList($){
		// collect values from configurator form
		var category = $.event('objectParams').category;
		var secondary = $.event('objectParams').secondary;
		var keywords = $.event('objectParams').keywords;
		var max_rows = $.event('objectParams').max_rows;
		var sort_by = $.event('objectParams').sort_by;
		var sort_dir = $.event('objectParams').sort_dir;
		var show_all = $.event('objectParams').show_all;
		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayProductList(
			category=category,
			secondary=secondary,
			keywords=keywords,
			max_rows=max_rows,
			sort_by=sort_by,
			sort_dir=sort_dir,
			show_all=show_all
		);
	}
	
	// 	Page: PRODUCT DETAILS
	public any function dspCWproductDetails($){
		// collect values from configurator form
		var product_id = $.event('objectParams').product_id;
		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayProductDetails(
			product_id=product_id
			);
	}
	
	// 	Page: CHECKOUT 
	public any function dspCWcheckout($){
		// collect values from configurator form
		// (no params for checkout)
		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayCheckout();
	}
    	// 	Page: Confirm Order 
	public any function dspCWConfirmOrder($){
		// collect values from configurator form
		// (no params for confirm)
		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayConfirmOrder();
	}
	
	// 	Page: ACCOUNT 
	public any function dspCWaccount($){
		// collect values from configurator form
		var view_mode = $.event('objectParams').view_mode;
		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayAccount(
			view_mode=view_mode
			);
	}
	
	// 	Page: CART 
	public any function dspCWcart($){
		// collect values from configurator form
		var cart_heading = $.event('objectParams').cart_heading;
		var cart_text = $.event('objectParams').cart_text;
		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayCart(
			cart_heading=cart_heading,
			cart_text=cart_text
			);
	}
	
	//  Navigation: SEARCH/NAV
	public any function dspCWsearchNav($){
		// collect values from configurator form
		var search_type = $.event('objectParams').search_type;
		var show_empty = $.event('objectParams').show_empty;
		var show_secondary = $.event('objectParams').show_secondary;
		var separator = $.event('objectParams').separator;
		var all_categories_label = $.event('objectParams').all_categories_label;
		var all_secondaries_label = $.event('objectParams').all_secondaries_label;
		var all_products_label = $.event('objectParams').all_products_label;
		var show_product_count = $.event('objectParams').show_product_count;
		var menu_id = $.event('objectParams').menu_id;
		var menu_class = $.event('objectParams').menu_class;
		var form_id = $.event('objectParams').form_id;
		var form_keywords = $.event('objectParams').form_keywords;
		var form_keywords_text = $.event('objectParams').form_keywords_text;
		var form_category = $.event('objectParams').form_category;
		var form_category_label = $.event('objectParams').form_category_label;
		var form_secondary = $.event('objectParams').form_secondary;
		var form_secondary_label = $.event('objectParams').form_secondary_label;
		var form_button_label = $.event('objectParams').form_button_label;

		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplaySearchNav(
			search_type=search_type,
			show_empty=show_empty,
			show_secondary=show_secondary,
			separator=separator,
			all_categories_label=all_categories_label,
			all_secondaries_label=all_secondaries_label,
			all_products_label=all_products_label,
			show_product_count=show_product_count,
			menu_id=menu_id,
			menu_class=menu_class,
			form_id=form_id,
			form_keywords=form_keywords,
			form_keywords_text=form_keywords_text,
			form_category=form_category,
			form_category_label=form_category_label,
			form_secondary=form_secondary,
			form_secondary_label=form_secondary_label,
			form_button_label=form_button_label
		);
	}	
	
	// 	Preview: CART PREVIEW 
	public any function dspCWcartPreview($){
		// collect values from configurator form
		var display_mode = $.event('objectParams').display_mode;
		var show_images = $.event('objectParams').show_images;
		var show_options = $.event('objectParams').show_options;
		var show_sku = $.event('objectParams').show_sku;
		var show_continue = $.event('objectParams').show_continue;
		var show_total_row = $.event('objectParams').show_total_row;
		var link_products = $.event('objectParams').link_products;
		
		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayCartPreview(
			display_mode=display_mode,
			show_images=show_images,
			show_options=show_options,
			show_sku=show_sku,
			show_continue=show_continue,
			show_total_row=show_total_row,
			link_products=link_products
			);
	}
	
	// 	Preview: PRODUCT PREVIEW 
	public any function dspCWproductPreview($){
		// collect values from configurator form
		var product_id = $.event('objectParams').product_id;
		var add_to_cart = $.event('objectParams').add_to_cart;
		var show_qty = $.event('objectParams').show_qty;
		var show_price = $.event('objectParams').show_price;
		var show_discount = $.event('objectParams').show_discount;
		var show_alt = $.event('objectParams').show_alt;
		var show_description = $.event('objectParams').show_description;
		var show_image = $.event('objectParams').show_image;
		var details_link_text = $.event('objectParams').details_link_text;

		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayProductPreview(
			product_id=product_id,
			add_to_cart=add_to_cart,
			show_qty=show_qty,
			show_price=show_price,
			show_discount=show_discount,
			show_alt=show_alt,
			show_description=show_description,
			show_image=show_image,
			details_link_text=details_link_text
			);
	}
	
	
	// 	Featured: TOP SELLING PRODUCTS
	public any function dspCWproductsTop($){
		// collect values from configurator form
		var max_products = $.event('objectParams').max_products;
		var add_to_cart = $.event('objectParams').add_to_cart;
		var show_qty = $.event('objectParams').show_qty;
		var show_description = $.event('objectParams').show_description;
		var show_image = $.event('objectParams').show_image;
		var show_price = $.event('objectParams').show_price;
		var details_link_text = $.event('objectParams').details_link_text;

		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayProductsTop(
			max_products=max_products,
			add_to_cart=add_to_cart,
			show_qty=show_qty,
			show_description=show_description,
			show_image=show_image,
			show_price=show_price,
			details_link_text=details_link_text
			);
	}
	
	// 	Featured: NEW PRODUCTS
	public any function dspCWproductsNew($){
		// collect values from configurator form
		var max_products = $.event('objectParams').max_products;
		var add_to_cart = $.event('objectParams').add_to_cart;
		var show_qty = $.event('objectParams').show_qty;
		var show_description = $.event('objectParams').show_description;
		var show_image = $.event('objectParams').show_image;
		var show_price = $.event('objectParams').show_price;
		var details_link_text = $.event('objectParams').details_link_text;

		// return function stored in plugins/CentLogic/eventHandlers/eventHandler.cfc
		return $.cwDisplayProductsNew(
			max_products=max_products,
			add_to_cart=add_to_cart,
			show_qty=show_qty,
			show_description=show_description,
			show_image=show_image,
			show_price=show_price,
			details_link_text=details_link_text
			);
	}
	
	
}
// end component
