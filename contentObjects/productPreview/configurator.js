function initProductPreview(data){
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/productPreview/configurator.cfm',
			pars:'',
			title: 'CentLogic Product Preview',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}