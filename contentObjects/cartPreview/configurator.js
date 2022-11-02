function initCartPreview(data){
		
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/cartPreview/configurator.cfm',
			pars:'',
			title: 'CentLogic Cart Preview',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}