function initSearchNav(data){
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/searchNav/configurator.cfm',
			pars:'',
			title: 'CentLogic Search / Navigation',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}