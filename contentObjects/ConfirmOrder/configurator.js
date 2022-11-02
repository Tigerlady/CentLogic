function initConfirmOrder(data){
	initConfigurator(
		data,
		{
			url:'../plugins/CentLogic/contentObjects/ConfirmOrder/configurator.cfm',
			pars:'',
			title: 'CentLogic Confirmation Page',
			init: function(){},
			destroy: function(){},
			validate: function(){
				return true;	
				}
		}
	);
	return true;
}