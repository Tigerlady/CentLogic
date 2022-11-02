function initAccount(data){
		
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/account/configurator.cfm',
			pars:'',
			title: 'CentLogic Account Page',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}