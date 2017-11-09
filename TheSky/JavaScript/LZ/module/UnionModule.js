var UnionModule = {
	/**
	 * 是否加入公会
	 * 
	 * @returns {Boolean}
	 */
	bJoinUnion:function(){
		return uniondata.union.isJoinLeague;
	},
	/**
	 * 创建公会提示
	 * 
	 */
	getCreateTip:function(){
		return config.league_Description.createLeague.desp;
	},
	/**
	 * 创建公会需要金币
	 * 
	 * @returns
	 */
	getCreateCost:function(){
		return config.league_buildcost.building.amount;
	},
	getUnionData:function(){
		return uniondata.union;
	},
	/**
	 * 联盟最大人数
	 * 
	 * @param level 联盟等级
	 * @returns {Number}
	 */
	getUnionPlayerMax:function(level){
		return config.league_level[level + ""].memberMax;
	},
	/**
	 * 联盟最大经验值
	 * 
	 * @param level 联盟等级
	 * @returns {Number}
	 */
	getUnionExpMax:function(level){
		return config.league_level[level + ""].exp;
	},
	/**
	 * 联盟职务
	 * 
	 * @param duty
	 */
	getUnionDuty:function(duty){
		return config.league_Duty[duty + ""];
	},
	/**
	 * 有权限进行操作吗
	 * 
	 * @param ids
	 */
	haveAuthority:function(ids){
		var player = uniondata.union.leaguePlayer;
		var duty = player.duty;
		var authorities = config.league_Duty[duty + ""].permission;
		for (var i in ids) {
			var authority = ids[i];
			if (!common.bContainObject(authorities, authority)) {
				return false;
			}
		}
		return true;
	},
	/**
	 * 职位是否已满
	 * 
	 * @param duty
	 */
	bFull:function(duty){
		var cfg = this.getUnionDuty(duty);
		var max = cfg.numMax;
		var count = this.getDutyNum(duty);
		if (max === -1) {
			return false;
		} else {
			return count >= max;
		}
	},
	/**
	 * 获取当前职位人数
	 * 
	 * @param duty
	 */
	getDutyNum:function(duty){
		var count = 0;
		var data = this.getUnionData();
		var members = data.leagueInfo.members;
		for (var k in members) {
			var m = members[k];
			if (m.duty === duty) {
				count++;
			}
		}
		return count;
	},
	/**
	 * 获取联盟建设信息
	 */
	getBuildingInfo:function(){
		var data = this.getUnionData();
		var info = data.leagueInfo;
		var leagueWar_Lvup = config.leagueWar_Lvup;
		var ret = [];
		for (var k in leagueWar_Lvup) {
			var cfg = leagueWar_Lvup[k];
			var dic = {};
			dic.id = k;
			dic.cfg = cfg;
			var attr = cfg.attr;
			if (k === "leagueshop") {
				dic.level = info.shop.level;
				dic.cost = config[attr][dic.level + ""].lvcost;
			} else if (k === "leaguedepot") {
				dic.level = info.depot.level;
				dic.cost = config[attr][dic.level + ""].lvcost;
			} else if (k.indexOf("fort_") === 0) {
				dic.level = info.forts[k].level;
				dic.cost = config[attr][dic.level + ""][k].lvcost;
			} else if (k.indexOf("siege_") === 0) {
				dic.level = info.sieges[k].level;
				dic.cost = config[attr][dic.level + ""][k].lvcost;
			}
			ret.push(dic);
		}
		ret.sort(function(a, b){
			return a.cfg.position < b.cfg.position ? -1 : 1;
		});
		return ret;
	},
	/**
	 * 糖果屋属性加成
	 * 
	 * @param level
	 * @returns {Array}
	 */
	getDepotAttrAddByLevel:function(level){
		var ret = [];
		var cfg = config.leagueWar_Depot;
		ret.push(cfg[level + ""].max);
		ret.push(cfg[(level + 1) + ""].max);
		ret.push(cfg[(level + 1) + ""].min);
		return ret;
	},
	/**
	 * 建筑属性加成
	 * 
	 * @param level
	 * @param key
	 * @returns {Array}
	 */
	getAttrAddByLevel:function(level, key) {
		var ret = [];
		var cfg;
		if (key.indexOf("fort_") === 0) {
			cfg = config.leagueWar_Fort;
		} else if (key.indexOf("siege_") === 0) {
			cfg = config.leagueWar_Siege;
		}
		ret.push(cfg[level + ""][key].value);
		ret.push(cfg[(level + 1) + ""][key].value);
		return ret;
	},
	/**
	 * 商店是否可以升级
	 * 
	 * @param level 商店等级
	 */
	bShopCanUpgrade:function(){
		var data = this.getUnionData();
		var level = data.leagueInfo.level;
		var sLevel = data.leagueInfo.shop.level;
		var cfg = config.leagueWar_ShopLevel[sLevel + ''];
		return level >= cfg.lvrequire;
	},
	/**
	 * 获取捐献描述
	 * 
	 * @param idx
	 */
	getContributionInfo:function(idx){
		return config.leagueWar_Donate[idx + ""];
	},
	/**
	 * 下次发放糖果倒计时
	 */
	getUnionCandyTime:function(){
		var data = this.getUnionData();
		var depot = data.leagueInfo.depot;
		if (depot && depot.lastAllotTime) {
		}
	},
	/**
	 * 功能是否开放
	 * 
	 * @param func
	 */
	bOpen:function(func){
		var data = this.getUnionData();
		var level = data.leagueInfo.level;
		return level >= this.openLevel(func);
	},
	/**
	 * 功能开放等级
	 * 
	 * @param func
	 */
	openLevel:function(func){
		var cfg = config.league_FuncOpen[func] || {level : 1};
		return cfg.level;
	},
	/**
	 * 商店道具是否可以购买
	 * 
	 * @param key
	 * @param count
	 */
	bShopItemBought:function(key, count){
		var cfg = config.leagueWar_CandyShopItem[key];
		var max = cfg.max;
		return count < max;
	},
	getShopItem:function(key){
		var dic = {};
		var cfg = config.leagueWar_CandyShopItem[key];
		dic.id = cfg.ID;
		dic.type = cfg.type;
		dic.level = cfg.level;
		dic.cost = cfg.cost;
		dic.count = cfg.daily;
		dic.max = cfg.max
		if (cfg.type === "book") {
			dic.cfg = SkillModule.getSkillConfig(dic.id);
		} else if (cfg.type === "soul") {
			dic.cfg = HeroModule.getHeroConfig(dic.id);
		} else if (cfg.type === "shard") {
			dic.cfg = ShardModule.getShardConfig(dic.id);
		} else if (cfg.type === "shadow") {
			dic.cfg = ShadowModule.getShadowConfig(dic.id);
		} else {
			dic.cfg = ItemModule.getItemConfig(dic.id);
		}
		return dic;
	},
	/**
	 * 商店购买道具需要商店的等级
	 * 
	 * @param level
	 */
	getBuyStuffNeedShopLevel:function(level){
		return config.leagueWar_Shoplv[level + ""].shoplv;
	},
	/*
	 **********************************
	 *
	 *				网络
	 *
	 **********************************
	 * 
	 */
	/**
	 * 获取公会信息
	 */
	doGetMainInfo:function(succ, fail){
		dispatcher.doAction(ACTION.UNION_MAININFO, [], succ, fail);
	},
	/**
	 * 创建公会
	 * @param name
	 * @param succ
	 * @param fail
	 */
	doCreate:function(name, succ, fail){
		dispatcher.doAction(ACTION.UNION_CREATE, [name], succ, fail);
	},
	/**
	 * 搜索可加入的公会
	 * 
	 * @param succ
	 * @param fail
	 */
	doQuery:function(name, succ, fail){
		dispatcher.doAction(ACTION.UNION_QUERY, [name], succ, fail);
	},
	/**
	 * 获取联盟详细信息
	 * 
	 * @param id
	 * @param succ
	 * @param fail
	 */
	doGetUnionInfo:function(id, succ, fail){
		dispatcher.doAction(ACTION.UNION_QUERY_ID, [id], succ, fail);
	},
	/**
	 * 加入公会
	 * 
	 * @param id
	 * @param succ
	 * @param fail
	 */
	doJoin:function(id, succ, fail){
		dispatcher.doAction(ACTION.UNION_JOIN, [id], succ, fail);
	},
	/**
	 * 获取申请人
	 * 
	 * @param succ
	 * @param fail
	 */
	doGetApplicant:function(succ, fail){
		dispatcher.doAction(ACTION.UNION_APPLICANT, [], succ, fail);
	},
	/**
	 * 邀请加入公会
	 * 
	 * @param ids {Array}
	 * @param agree {Bool}
	 * @param succ
	 * @param fail
	 */
	doProcessApplicants:function(ids, agree, succ, fail){
		dispatcher.doAction(ACTION.UNION_APPLICANT_PROCESS, [ids, agree], succ, fail);
	},
	/**
	 * 退出公会
	 * 
	 * @param succ
	 * @param fail
	 */
	doQuit:function(succ, fail){
		if (this.haveAuthority([3])) {
			dispatcher.doAction(ACTION.UNION_DELETE, [], succ, fail);
		} else {
			dispatcher.doAction(ACTION.UNION_QUIT, [], succ, fail);
		}
	},
	/**
	 * 变更职位
	 * 
	 * @param id
	 * @param type -1 升 1 降
	 * @param succ
	 * @param fail
	 */
	doChangeDuty:function(id, type, succ, fail){
		dispatcher.doAction(ACTION.UNION_CHANGEDUTY, [id, type], succ, fail);
	},
	/**
	 * 开除成员
	 * 
	 * @param id
	 * @param succ
	 * @param fail
	 */
	doFire:function(id, succ, fail){
		dispatcher.doAction(ACTION.UNION_FIRE, [id], succ, fail);
	},
	/**
	 * 转让会长
	 * 
	 * @param id
	 * @param succ
	 * @param fail
	 */
	doAbdicate:function(id, succ, fail){
		dispatcher.doAction(ACTION.UNION_ABDICATE, [id], succ, fail);
	},
	/**
	 * 获取联盟动态
	 * 
	 * @param time
	 * @param succ
	 * @param fail
	 */
	doGetMessage:function(time, succ, fail){
		var param = [];
		if (time) {
			param.push(time);
		}
		dispatcher.doAction(ACTION.UNION_MESSAGE, param, succ, fail);
	},
	/**
	 * 升级建筑
	 * 
	 * @param id
	 * @param succ
	 * @param fail
	 */
	doUpgradeBuilding:function(id, succ, fail){
		dispatcher.doAction(ACTION.UNION_BUILDING_UPGRADE, [id], succ, fail);
	},
	/**
	 * 获取联盟捐献信息
	 * 
	 * @param succ
	 * @param fail
	 */
	doGetContributionInfo:function(succ, fail){
		dispatcher.doAction(ACTION.UNION_CONTRIBUTIONINFO, [], succ, fail);
	},
	/**
	 * 捐献公会经验
	 * 
	 * @param id 1 免费 2收费
	 * @param succ
	 * @param fail
	 */
	doContribute:function(id, succ, fail){
		dispatcher.doAction(ACTION.UNION_CONTRIBUTE, [id], succ, fail);
	},
	/**
	 * 糖果捐献
	 * 
	 * @param id
	 * @param succ
	 * @param fail
	 */
	doSweetContribute:function(id, succ, fail){
		dispatcher.doAction(ACTION.UNION_SWEET_CONTRIBUTE, [id], succ, fail);
	},
	/**
	 * 分发糖果
	 * 
	 * @param ids
	 * @param amount
	 * @param succ
	 * @param fail
	 */
	doSweetDistribute:function(ids, amount, succ, fail){
		dispatcher.doAction(ACTION.UNION_DISTRIBUTE_SWEET, [ids, amount], succ, fail);
	},
	/**
	 * 糖果商店购买
	 * 
	 * @param level
	 * @param succ
	 * @param fail
	 */
	doCandyShopBuy:function(level, succ, fail){
		dispatcher.doAction(ACTION.UNION_SHOP_BUY, [level], succ, fail);
	},
}