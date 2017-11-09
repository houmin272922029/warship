var ShadowModule = {
	/**
	 * 获取后台返回的影子数据(不包含配置)
	 * @param uid 影子唯一id
	 * @returns 影子数组
	 */
	getShadowByUid:function(uid){
		if (!uid) {
			return null;
		}
		return shadowdata.shadows[uid];
	},
	/**
	 * 获取一个影子的全部数据(后台返回及配置信息)
	 * @param uid 影子唯一id
	 * @returns 影子数组
	 */
	getOneShadowByUid:function(uid){
		var shadow = this.getShadowByUid(uid);
		var retArray = {};
		retArray["shadow"] = shadow;
		retArray["cfg"] = this.getShadowConfig(shadow.shadowId);
		var attr = this.getAttr(shadow.level, shadow.shadowId);
		retArray["attr"] = attr;
		var heros = herodata.heroes;
		for (var hid in heros) {
			var hero = heros[hid];
			var hcfg = HeroModule.getHeroConfig(hero.heroId);
			var hs = hero.shadow || {};
			for (var k in hs) {
				if (hs[k] === uid) {
					retArray["owner"] = {name:hcfg.name, id:hid};
				}
			}
		}
		return retArray;
	},
	/**
	 * 获得所有的影子并排序
	 * @param sortType  0 按获得时间排序 1 按rank和等级排序 2按伙伴的等级排序
	 */
	getAllShadowData:function(sortType){
		var sortType = sortType || 0;
		var shadow = [];
		var owners = {};
		var shadows = shadowdata.shadows;
		var heros = HeroModule.getHeroes();
		for (var hid in heros) {
			var hero = heros[hid];
			var hcfg = HeroModule.getHeroConfig(hero.heroId);
			var hs = hero.shadow || {};
			for (var sid in hs) {
				owners[hs[sid]] = {name:hcfg.name, id:hid};
			}
		}
		for (var k in shadows) {
			var s = deepcopy(shadows[k]);
			s.gainTime = s.gainTime || 0;
			s.cfg = this.getShadowConfig(s.shadowId);
			if (s.cfg.isup == 1) {
				if (owners[k]) {
					s.owner = owners;
				}
				shadow.push(s);
			}
		}
		if (sortType == 0) {
			shadow.sort(function(a, b){
				return a.gainTime < b.gainTime ? -1 : 1;
			});
		} else if (sortType == 1){
			shadow.sort(function(a, b){
				if (a.rank === b.rank) {
					return a.level > b.level ? -1 : 1;
				}
				return a.rank > b.rank ? -1 : 1;
			});
		} else if (sortType == 2) {
			shadow.sort(function(a, b){
				if ((a.owner && b.owner) || (!a.owner && !b.owner)) {
					if (a.rank === b.rank) {
						return a.level > b.level ? -1 : 1;
					}
					return a.rank > b.rank ? -1 : 1;
				} 
				return a.owner != null ? -1 : 1;
			});
		}
		return shadow;
	},
	/**
	 * 通过将要升级的影子shadowId 获取升级能够使用的材料
	 * @Param shadowId 
	 * @param type  0:重新排序 1:不排序
	 */
	getCanUserShadowMaterialByUid:function(shadowId,type){
		var retArray = [];
		var owners = {};
		var type = type || 0;
		var heros =HeroModule.getAllHeroes();
		var shadows = shadowdata.shadows;
		for (var hid in heros) {
			var hero = heros[hid];
			var hcfg = HeroModule.getHeroConfig(hero.heroId);
			var hs = hero.shadow || {};
			for (var sid in hs) {
				owners[hs[sid]] = {name:hcfg.name, id:hid};
			}
		}
		for ( var k in shadows) {
			if (k != shadowId && !owners[k]) {
				var s = deepcopy(shadows[k]);
				s.cfg = this.getShadowConfig(s.shadowId);
				retArray.push(s);
			}
		}
		retArray.sort(function(a, b){
			if (a.rank === b.rank) {
				return a.level < b.level ? -1 : 1;
			}
			return a.rank < b.rank ? -1 : 1;
		});
		if (type == 0) {
			var count = Math.floor(retArray.length / 5);
			if (count == 0) {
				return [retArray];
			} else {
				var ret = [];
				count = retArray.length % 5 === 0 ? count : count + 1;
				for (var j = 0; j < count; j++) {
					var row = [];
					for (var i = 0; i < 5; i++) {
						var s = retArray[5 * j + i];
						if (s) {
							row.push(s);
						}
					}
					ret.push(row);
				}
				return ret;
			}
		} else if (type == 1) {
			return retArray;
		}
	},
	/**
	 * 获得TrainView tableview的数据
	 */
	getTrainViewData:function(){
		var shadows = ShadowModule.getAllShadowData();
		var count = Math.floor(shadows.length / 5);
		if (count == 0) {
			return [shadows];
		} else {
			var shadow = [];
			count = shadows.length % 5 === 0 ? count : count + 1;
			for (var j = 0; j < count; j++) {
				var row = [];
				for (var i = 0; i < 5; i++) {
					var s = shadows[5 * j + i];
					if (s) {
						row.push(s);
					}
				}
				shadow.push(row);
			}
			return shadow;
		}
	},
	/**
	 * 获得由一个等级升到下一个等级需要的经验值
	 * @param level 当前等级 品阶
	 * @param rank  品阶
	 */
	getNeedEXPToNextLevel:function(level, rank){
		var shadowUpDate = ShadowModule.getShadowUpDateConfig(level, rank);
		return shadowUpDate || 0;
	},
	/**
	 * 一个影子可以提供的经验值
	 * @param shadowId 
	 * @param level 当前等级 品阶
	 * @param rank  品阶
	 */
	oneShadowCanGaveEXP:function(shadowId, level, rank){
		var exp = 0;
		var cfg = this.getOneShadowConfig(shadowId);
		for (var i = 0; i < level; i++) {
			if (i == 0) {
				exp = exp + cfg.exp;
			} else {
				exp = exp + this.getShadowUpDateConfig(i, rank);
			}
		}
		return exp;
	},
	getAttrsByHero:function(hero){
		var attr = {};
		if (hero.shadows) {
			for (var k in hero.shadows) {
				var v = hero.shadows[k];
				var shadow = ShadowModule.getShadowByUid(v);
				var sattr = ShadowModule.getAttr(shadow.level, shadow.shadowId);
				for (var key in sattr) {
					attr[key] = attr[key] || 0;
					attr[key] += sattr[key];
				}
			}
		}
		return attr;
	},
	getAttr:function(level, id){
		var cfg = this.getShadowConfig(id);
		var attr = {};
		for (var k in cfg.property) {
			var key = cfg.property[k];
			var base = cfg.level[k];
			var growth = cfg.growth[k];
			attr[key] = base + growth * (level - 1);
		}
		return attr;
	},
	/**
	 * 读取影子配置表
	 * @param id 普通id
	 */
	getShadowConfig:function(id){
		return config.shadow_Data[id];
	},
	/**
	 * 读取影子所需贝里数目配置表
	 * @param pos 
	 */
	getShadowRandConfig:function(pos){
		return config.shadow_Rand[pos].silver || 0;
	},
	/**
	 * 影槽是否开放
	 * @param level
	 * @param idx
	 * return true 开启 false 关闭
	 */
	bOpen:function(level, idx){
		var cfg = config.shadow_lvlimit;
		var limit = cfg[idx + ""].lvlimit;
		return level >= limit;
	},
	/**
	 * 读取影子升级配置表(获得由一个等级升到下一个等级需要的经验值)
	 * @param level
	 * @param rank
	 */
	getShadowUpDateConfig:function(level, rank){
		var cfg = config.shadow_Update;
		var level = cfg[level + ""] || {};
		return level[rank + ""] || 0;
	},
	/**
	 * 获取单个影子的配置信息
	 * @param id
	 */
	getOneShadowConfig:function(id){
		return config.shadow_Data[id];
	},
	/**
	 * 获得一个影子的属性数组
	 * @param level 
	 * @param id 
	 */
	getShadowAttrByLevelAndCid:function(level, id){
		var cfg = ShadowModule.getOneShadowConfig(id);
		var retArray = [];
		var attr = {};
		for ( var k in cfg.property) {
			if (k) {
				attr = level * cfg.growth[k] + cfg.level[k];
				retArray.push(attr);
			}
		}
		return retArray;
	},
	/**
	 * (影文页面)获取所有可售影子信息
	 */
	getWaveConfigData:function(){
		var retArray = [];
		var cfg = config.shadow_Data;
		for (var k in cfg) {
			if (cfg[k].isSale == 1) {
				var dic = {};
				dic.id = k;
				var attr = {};
				if (cfg[k].property) {
					for (var i in cfg[k].property) {
						var key = cfg[k].property[i];
						var value = cfg[k].level[i];
						attr[key] = value;
					}
				}
				dic.attr = attr;
				dic.cfg = cfg[k];
				retArray.push(dic);
			}
		}
		retArray.sort(function(a, b){
			if (a.rank === b.rank) {
				return a.id < b.id ? -1 : 1;
			}
			return a.rank > b.rank ? -1 : 1;
		});
		return retArray;
	},
	/**
	 * (影文页面)获取用户拥有的影币
	 */
	getShadowCoin:function(){
		if (shadowdata.shadowData) {
			return shadowdata.shadowData.shadowCoin || 0;
		} else {
			return 0;
		}
	},
	/**
	 * 获得炼影页面中间显示的影子索引
	 */
	getCenterIndex:function(){
		if (shadowdata.shadowData) {
			return shadowdata.shadowData.statusNow || 1;
		} else {
			return 1;
		}
	},
	/**
	 * 获得距离下次免费刷新时间的时间间隔
	 */
	getTimeDurationNextFreeTime:function(){
		//TODO traceTable(LoginModule.getLoginTime())//时间是空的
		if (shadowdata.shadowData && shadowdata.shadowData.nextFreeTime) {
			return shadowdata.shadowData.nextFreeTime - Global.serverTime;
		}
		return 0;
	},
	/**
	 * 获得练影所需金币配置
	 */
	getTrainShadowNeedBerry:function(pos){
		var cfg = config.shadow_Rand[pos];
		return config.shadow_Rand[pos] || 0;
	},
	getShadowLevelAndExp:function(baseLevel, exp, rank){
		var level, need;
		for (level = baseLevel; level <= getJsonLength(config.shadow_Update); level++) {
			need = this.getNeedEXPToNextLevel(level, rank);
			if (exp < need) {
				break;
			}
			exp -= need;
		}
		return [level, exp, need];
	},
	/**
	 * 获得练影-炼其他页面帮助信息配置
	 */
	getShadowNoticConfig:function(){
		return config.shadow_Notice;
	},
	/**
	 * 获得炼其他帮助信息
	 */
	trainShadowRule:function(){
		var retArray = [];
		var cfg = this.getShadowNoticConfig();
		for (var i = 0; i < getJsonLength(cfg) ; i++) {
			retArray.push(cfg["notice_00"+ (i + 1)].desp)
		}
		return retArray;
	},
	/**
	 * 获得影子持有人
	 * 
	 * @returns {Array}
	 */
	getOwners:function(){
		var owners = [];
		var form = FormModule.getForm();
		for (var k in form) {
			var hid = form[k];
			var hero = HeroModule.getHeroByUid(hid);
			var cfg = HeroModule.getHeroConfig(hero.heroId);
			if (hero.shadow) {
				for (var k in hero.shadow) {
					var sid = hero.shadow[k];
					if (sid && sid != "") {
						owners[sid] = {name:cfg.name, pos:k};
					}
				}
			}
		}
		return owners;
	},
	/**
	 * 获取可更换影子列表
	 * 
	 *  @param hid
	 *  @param sid
	 */
	getChangeList:function(hid, sid){
		var hero = herodata.heroes[hid];
		var on = {};
		for (var k in hero.shadow) {
			if (hero.shadow[k]) {
				var shadow = shadowdata.shadows[hero.shadow[k]];
				on[shadow.shadowId] = true;
			}
		}
		var selected = "";
		if (sid) {
			var shadow = shadowdata.shadows[sid];
			selected = shadow.shadowId;
		}
		var owners = this.getOwners();
		var shadows = [];
		for (var k in shadowdata.shadows) {
			if (k == sid) {
				continue;
			}
			var shadow = shadowdata.shadows[k];
			
			if (shadow.shadowId === selected || !on[shadow.shadowId]) {
				var dic = this.getOneShadowByUid(k);
				if (dic.cfg.wear == 1) {
					dic.owner = owners[k];
					shadows.push(dic);
				}
			}
		}
		shadows.sort(function(a, b){
			if (a.shadow.rank === b.shadow.rank) {
				if (a.shadow.shadowId === b.shadow.shadowId) {
					return a.shadow.level > b.shadow.level ? -1 : 1;
				}
				return a.shadow.shadowId < b.shadow.shadowId ? -1 : 1;
			}
			return a.shadow.rank > b.shadow.rank ? -1 : 1;
		});
		return shadows;
	},
	/*
	 ********************************
	 * 			  网络
	 ********************************
	 */
	/**
	 * 坚决
	 */
	doOnShadowChangeStatus:function(des, succ, fail){
		dispatcher.doAction(ACTION.SHADOW_CHANGE_STATUS, des, succ, fail);
	},
	/**
	 * 购买影子
	 * @param shadowId
	 */
	doOnShadowBuy:function(shadowId, succ, fail){
		dispatcher.doAction(ACTION.SHADOW_SHADOW_BUY, shadowId, succ, fail);
	},
	/**
	 * 炼影
	 * @param dec 次数
	 */
	doOnShadowExercise:function(des, succ, fail){
		dispatcher.doAction(ACTION.SHADOW_EXERCISE, des, succ, fail);
	},
	/**
	 * 带状态炼影
	 * @param status 状态
	 * @param dec 次数
	 */
	doOnShadowExerciseWithStatus:function(status, des, succ, fail){
		dispatcher.doAction(ACTION.SHADOW_EXERCISE_STATUS, [status, des], succ, fail);
	},
	/**
	 * 影子-升级
	 * @param shadowUid  唯一id
	 * @param shadowUids 被吃掉的影子
	 */
	doOnShadowUpdate:function(shadowUid, shadowUids, succ, fail){
		dispatcher.doAction(ACTION.SHADOW_SHADOW_UPDATE, shadowUid, shadowUids, succ, fail)
	},
}