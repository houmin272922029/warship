var config = {
	fromDic:function(dic) {
		if (!dic) {
			trace("config is null");
			return;
		}
		for (var key in dic) {
			config[key] = dic[key];
		}
	}
}