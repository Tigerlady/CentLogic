function initProductList(data){
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/productList/configurator.cfm',
			pars:'',
			title: 'CentLogic Product List Page',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}