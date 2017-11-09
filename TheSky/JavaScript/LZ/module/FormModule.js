var FormModule = {
	/**
	 * 上阵人数
	 */
	getOnFormCount:function(){
		return getJsonLength(formdata.form);
	},
	getFormMax:function(){
		var level = PlayerModule.getLevel();
		var cfg = config.team_open;
		var count;
		for (var i = 1; i <= getJsonLength(cfg); i++) {
			var limit = cfg[i + ""].Lv_limit;
			if (limit > level) {
				break;
			}
			count = i;
		}
		return count;
	},
	/**
	 * 获取下一个阵容开启等级
	 */
	getNextFormMax:function(){
		var level = PlayerModule.getLevel();
		var cfg = config.team_open;
		for (var i = 1; i <= getJsonLength(cfg); i++) {
			var limit = cfg[i + ""].Lv_limit;
			if (limit > level) {
				return limit;
			}
		}
		return 0;
	},
	getHeroUidWithFormIndex:function(idx){
		return formdata.form[idx + ""];
	},
	getIndexWithUid:function(uid){
		for (var k in formdata.form) {
			var id = formdata.form[k];
			if (id === uid) {
				return parseInt(k);
			}
		}
	},
	getForm:function(){
		return formdata.form;
	},
	/**
	 * 未上阵的英雄
	 */
	getHeroOffForm:function(){
		var array = [];
		var heroes = HeroModule.getHeroes();
		for (var k in heroes) {
			if (!this.bHeroOnForm(k)) {
				var hero = HeroModule.getHeroByUid(k);
				array.push(hero);
			}
		}
		array.sort(function(a, b){
			if (a.level === b.level) {
				if (a.rank === b.rank) {
					return a.price > b.price ? -1 : 1;
				}
				return a.rank > b.rank ? -1 : 1;
			}
			return a.level > b.level ? -1 : 1;
		});
		return array;
	},
	/**
	 * 英雄是否已经上阵
	 * 
	 * @param uid 唯一id
	 * @returns {Boolean}
	 */
	bHeroOnForm:function(uid){
		if (common.bContainObject(formdata.form, uid)) {
			return true;
		}
		if (common.bContainObject(formdata.sevenForm, uid)) {
			return true;
		}
		return false;
	},
	/**
	 * 英雄是否上阵
	 * 
	 * @param heroId 配置id
	 */
	bHeroOnFormByHeroId:function(heroId){
		var heroes = HeroModule.getHeroes();
		for (var k in formdata.form) {
			var id = formdata.form[id];
			if (id && id !== "" && heroes[id].heroId === heroId) {
				return true;
			}
		}
		for (var k in formdata.sevenForm) {
			var id = formdata.sevenForm[k];
			if (id && id !== "" && heroes[id].heroId === heroId) {
				return true;
			}
		}
		return false;
	},
	/**
	 * 队伍中的英雄加经验
	 * 
	 * @param exp
	 */
	addExp:function(exp){
		for (var k in formdata.form) {
			var hid = formdata.form[k];
			HeroModule.addExp(hid, exp);
		}
	},
	/*
	 ********************************
	 * 			  啦啦队
	 ********************************
	 */
	
	/**
	 * 啦啦队状态
	 * 0 等级未到 1 未使用道具开启 2 开启未上阵 3 已上阵
	 */
	formSevenState:function(idx){
		var max = this.getFormSevenMax();
		if (idx > max) {
			return 0;
		} else {
			var hid = this.getFormSevenByIndex(idx);
			if (hid === undefined || hid === null) {
				return 1;
			} else if (hid === "") {
				return 2;
			} else {
				return 3;
			}
		}
	},
	/**
	 * 啦啦队等级
	 * @param idx
	 * @returns
	 */
	getFormSevenLv:function(idx){
		if (!formdata.sevenUpgrade || !formdata.sevenUpgrade[(idx - 1) + ""]) {
			return 0;
		} else {
			return formdata.sevenUpgrade[(idx - 1) + ""];
		}
	},
	/**
	 * 当前可以升到几级
	 * 
	 * @param idx
	 */
	getFormSevenUpgradeMax:function(idx){
		var level = PlayerModule.getLevel();
		var cfg = config.Cheerleaders_Lvlimit;
		var dic = cfg[idx + ""];
		for (var i = 0; i < getJsonLength(dic); i++) {
			var limit = dic[i];
			if (level <= limit) {
				return i - 1;
			}
		}
		return getJsonLength(dic) - 1;
	},
	/**
	 * 获取当前槽的hid
	 * 
	 * @param idx
	 */
	getFormSevenByIndex:function(idx){
		return formdata.sevenForm[(idx - 1) + ''];
	},
	getFormSevenMax:function(){
		var level = PlayerModule.getLevel();
		var cfg = config.Cheerleaders_Lvlimit;
		var len = getJsonLength(cfg);
		for (var i = 1; i <= len; i++) {
			var dic = cfg[i + ""];
			var limit = dic[0];
			if (level < limit) {
				return i - 1;
			}
		}
		return len;
	},
	getSevenFormAttr:function(){
		var attr = {};
		for (var i = 1; i <= 7; i++) {
			var state = this.formSevenState(i);
			if (state === 3) {
				var cfgUp = config.Cheerleaders_Upgrade[i + ""];
				var hid = this.getFormSevenByIndex(i);
				var key = config.Cheerleaders_name[i + ""].attr;
				var per = cfgUp[this.getFormSevenLv(i)];
				var base = HeroModule.getHeroBasicAttrsByUid(hid);
				var value = 0;
				if (base[key]) {
					value = Math.max(Math.floor(base[key] * per), 1);
				}
				attr[key] = attr[key] || 0;
				attr[key] += value;
			}
		}
		return attr;
	},
	/**
	 * 啦啦队下一开放等级
	 */
	getNextFormSevenMax:function() {
		var level = PlayerModule.getLevel();
		var cfg = config.Cheerleaders_Lvlimit;
		var len = getJsonLength(cfg);
		var ret;
		for (var i = 1; i <= len; i++) {
			var dic = cfg[i + ""];
			var limit = dic[0];
			if (level < limit) {
				ret = limit;
				break;
			}
		}
		return ret;
	},
	/**
	 * 是否可以激活啦啦队
	 * 
	 * @param idx
	 */
	formSevenCanOpen:function(idx){
		if (idx === 1) {
			return true;
		}
		var state = this.formSevenState(idx - 1);
		return state > 1;
	},
	/**
	 * 啦啦队 开启和升级的消耗
	 * 
	 * @param idx
	 * @param level
	 */
	formSevenCost:function(idx, level){
		var cfg = config.Cheerleaders_Upcost;
		return cfg[idx + ""][level];
	},
	/**
	 * 啦啦队加成属性
	 * 
	 * @param idx
	 */
	getFSNameConfig:function(idx) {
		return config.Cheerleaders_name[idx + ""];
	},
	getFSUpgradeConfig:function(idx){
		return config.Cheerleaders_Upgrade[idx + ""];
	},
	
	/*
	 ********************************
	 * 			  网络
	 ********************************
	 */
	/**
	 * 上阵
	 */
	doOnForm:function(idx, hid, succ, fail){
		dispatcher.doAction(ACTION.FORM_ONFORM, [idx, hid], succ, fail);
	},
	/**
	 * 啦啦队上阵
	 */
	doOnSevenForm:function(idx, hid, succ, fail){
		dispatcher.doAction(ACTION.FORM_ONSEVENFORM, [idx, hid], succ, fail);
	},
	/**
	 * 更换阵容
	 * 
	 * @param form
	 * @param succ
	 * @param fail
	 */
	doChangeTeam:function(form, succ, fail){
		dispatcher.doAction(ACTION.FORM_CHANGEFORM, [form], succ, fail);
	},
	/**
	 * 开启啦啦队
	 * 
	 * @param idx
	 * @param succ
	 * @param fail
	 */
	doOpenFormSeven:function(idx, succ, fail) {
		dispatcher.doAction(ACTION.FORM_OPENSEVEN, [idx], succ, fail);
	},
	/**
	 * 升级啦啦队
	 * 
	 * @param idx
	 * @param succ
	 * @param fail
	 */
	doUpgradeFormSeven:function(idx, succ, fail) {
		dispatcher.doAction(ACTION.FORM_UPGRADESEVEN, [idx], succ, fail);
	}
}