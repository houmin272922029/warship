var FunctionModule = {
	/**
	 * 功能是否开启
	 * 
	 * @param key
	 * @returns {Boolean}
	 */
	bOpen:function(key){
		var level = PlayerModule.getLevel();
		return level >= this.openLevel(key);
	},
	/**
	 * 功能开启等级
	 * 
	 * @param key
	 * @returns
	 */
	openLevel:function(key){
		return config.function_levelopen[key].openlevel
	}
}