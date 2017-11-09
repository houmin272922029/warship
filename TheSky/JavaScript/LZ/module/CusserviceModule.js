var CusserviceModule = {
	//获得客服信息
	getServiceInfo:function() {
		var ret = [];
		var cfg = config.Help_customerservice;
		for (var k in cfg){
			ret.push(cfg[k]);
		}
		return ret;
	},
}