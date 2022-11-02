function initCart(data){
		
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/cart/configurator.cfm',
			pars:'',
			title: 'CentLogic Cart Page',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}