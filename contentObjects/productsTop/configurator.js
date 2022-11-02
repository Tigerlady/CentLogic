function initProductsTop(data){
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/productsTop/configurator.cfm',
			pars:'',
			title: 'CentLogic Best Selling Products',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}