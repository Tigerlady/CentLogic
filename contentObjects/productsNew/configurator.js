function initProductsNew(data){
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/productsNew/configurator.cfm',
			pars:'',
			title: 'CentLogic Newest Products',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}