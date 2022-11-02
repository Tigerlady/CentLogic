function initCheckout(data){
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/checkout/configurator.cfm',
			pars:'',
			title: 'CentLogic Checkout Page',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}