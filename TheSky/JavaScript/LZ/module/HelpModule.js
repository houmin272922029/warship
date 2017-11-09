var HelpModule = {
		//获得设置里面帮助的信息
		getHelpInfo:function() {
			var ret = [];
			var cfg = config.Help_document;
			for (var k in cfg){
				ret.push(cfg[k]);
			}
			return ret;
		},
}