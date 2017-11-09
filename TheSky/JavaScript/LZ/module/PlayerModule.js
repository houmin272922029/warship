var PlayerModule = {
	getName:function(){
		return playerdata.name;
	},
	getVipLevel:function(score){
		score = score || playerdata.vipScore;
		var cfg = config.vip_config;
		var len = getJsonLength(cfg);
		for (var i in cfg) {
			if ((score) < cfg[i]["score"]) {
				return i - 1;
			}
		}
		return len - 1;
	},
	/**
	 * 获取当前积分比例
	 */
	getVipPro:function(score){
		score = score || playerdata.vipScore;
		var cfg = config.vip_config;
		var len = getJsonLength(cfg);
		for (var i in cfg) {
			if ((score) < cfg[i]["score"]) {
				return score / cfg[i]["score"];
			}
		}
		return 1;
	},
	/**
	 * 获取下一级积分
	 */
	getNextVipScore:function(score){
		score = score || playerdata.vipScore;
		var cfg = config.vip_config;
		var len = getJsonLength(cfg);
		for (var i in cfg) {
			if ((score) < cfg[i]["score"]) {
				return cfg[i]["score"];
			}
		}
		return score;
	},
	/**
	 * 获得到下一级vip所需的人民币数量，这个方法只用于中文地区
	 */
	getVipRMB:function(){
		var rate = config.vip_config[5].score / config.vip_config[5].cash;
		var cfg = config.vip_config;
		for (var k in cfg) {
			if (playerdata.vipScore / rate < cfg[k].cash) {
				return cfg[k].cash - playerdata.vipScore / rate;
			}
		}
		return -1;
	},
	/**
	 * 获得下一级vip所需的充值金币数量
	 */
	getNextVipNeedGold:function(){
		var cfg = config.vip_config;
		for (var k in cfg) {
			if (playerdata.vipScore < cfg[k].score) {
				return cfg[k].score - playerdata.vipScore;
			}
		}
		return -1;
	},
	getLevel:function(exp){
		exp = exp || playerdata.expAll;
		var p_level_limit = config.leader_openlevelup["1"].levelup;
		var cfg = config.leader_exp;
		var total = 0;
		for (var i = 1; i <= p_level_limit; i++) {
			var dic = cfg[i + ""];
			var base = dic.value1;
			total += Math.floor(base);
			if (total >= exp) {
				return i;
			}
		}
		return p_level_limit;
	},
	getExp:function(){
		var expAll = playerdata.expAll;
		var p_level_limit = config.leader_openlevelup["1"].levelup;
		var cfg = config.leader_exp;
		for (var i = 1; i <= p_level_limit; i++) {
			var dic = cfg[i + ""];
			var base = dic.value1;
			if (expAll > base) {
				expAll-=base;
			} else {
				break;
			}
		}
		return expAll;
	},
	getPlayerExpMax:function(level){
		level = level || this.getLevel();
		var cfg = config.leader_exp;
		return cfg[level + ""].value1
	},
	getExpMax:function(level){
		level = level || this.getLevel();
		var cfg = config.leader_exp;
		return cfg[level + ""].value2
	},
	getStrength:function(){
		return playerdata.strength;
	},
	getStrengthMax:function(level, vip){
		level = level || this.getLevel();
		vip = vip || this.getVipLevel();
		return config.energy_Uplimite[level + ""].strength;
	},
	getNextStrengthTime:function() {
		if (playerdata.strength >= this.getStrengthMax) {
			return 0;
		}
		return config.energy_Recovtime["1"].str_time - (Global.serverTime - playerdata.strength_time) % config.energy_Recovtime["1"].str_time;
	},
	getAllStrengthTime:function() {
		if (playerdata.strength >= PlayerModule.getStrengthMax()) {
			return 0;
		}
		return (PlayerModule.getStrengthMax() - playerdata.strength - 1) * config.energy_Recovtime["1"].str_time + PlayerModule.getNextStrengthTime();
	},
	getEnergy:function(){
		return playerdata.energy;
	},
	getEnergyMax:function(level, vip){
		level = level || this.getLevel();
		vip = vip || this.getVipLevel();
		return config.energy_Uplimite[level + ""].energy;
	},
	getNextEnergyTime:function() {
		if (playerdata.energy >= PlayerModule.getEnergyMax()) {
			return 0;
		}
		return config.energy_Recovtime["1"].ene_time - (Global.serverTime - playerdata.energy_time) % config.energy_Recovtime["1"].ene_time;
	},
	getAllEnergyTime:function() {
		if (playerdata.energy >= PlayerModule.getEnergyMax()) {
			return 0;
		}
		return (PlayerModule.getEnergyMax() - playerdata.energy - 1) * config.energy_Recovtime["1"].ene_time + PlayerModule.getNextEnergyTime();
	},
	getFlag:function(){
		return playerdata.flag;
	},
	getGold:function(){
		return playerdata.gold;
	},
	getBerry:function(){
		return playerdata.berry;
	},
	getPlayerId:function(){
		return playerdata.id
	},
	getPlayerArenaScore:function(){
		return playerdata.arenaScore;
	},
	reducePlayerArenaScore:function(cost){
		return playerdata.arenaScore - cost;
	},
	/**
	 * 是否还有首次充值活动
	 */
	isFirstRecharge:function(){
		return true;
	},
	//热血值
	getHotBlood:function() {
		return playerdata.hotBlood;
	},
	//登录时间
	getLoginTime:function() {
		return playerdata.LastLoingTime;
	},
	addExp:function(exp){
		var level = this.getLevel();
		playerdata.expAll += exp;
		var nextLevel = this.getLevel();
		if (nextLevel > level) {
			// TODO 升级
		}
	},
	/*
	 * 	 * ************************** 网络 **************************
	 */
	//用户反馈
	dofeedBack:function(errorInfo, succ, fail) {
		dispatcher.doAction(ACTION.FEED_BACK, [errorInfo], succ, fail);
	},
}