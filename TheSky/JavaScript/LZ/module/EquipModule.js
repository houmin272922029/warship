var EquipModule = {
	getEquipByUid:function(uid){
		if (!uid) {
			return null;
		}
		return equipdata.equips[uid];
	},
	getEquipConfig:function(id){
		return config.equip_data[id];
	},
	getEquip:function(uid){
		var equip;
		if (typeof uid === "string") {
			equip = deepcopy(this.getEquipByUid(uid));
		} else {
			equip = deepcopy(uid);
		}
		var cfg = this.getEquipConfig(equip.equipId);
		equip.cfg = cfg;
		// TODO 合成
		var attr = this.getEquipAttr(equip.equipId, equip.level, equip.stage);
		equip.attr = attr;
		equip.price = this.getEquipPriceById(equip);
		return equip;
	},
	/**
	 * 获得英雄头像名称
	 */
	getEquipIconByEquipId:function(equipId){
		if (equipId) {
			if (common.havePrefix(equipId, "vip_")) {
				return common.formatLResPath("icons/vip_001.png");
			}
			return common.formatLResPath("icons/" + equipId + ".png");
		}else {
			return;
		}
	},
	//图鉴道具数据
	getHandBookViewData:function(){
		var equips = config.figure_equip;
		var equip = [];
		for ( var k in equips) {
			equip.push(equips[k]);
		}
		var count = Math.floor(equip.length / 5);
		if (count == 0) {
			return [equip];
		} else {
			var eq = [];
			count = equip.length % 5 === 0 ? count : count + 1;
			for (var j = 0; j < count; j++) {
				var row = [];
				for (var i = 0; i < 5; i++) {
					var s = equip[5 * j + i];
					if (s) {
						row.push(s);
					}
				}
				eq.push(row);
			}
			return eq;
		}
	},
	/**
	 * 判断是否存在某个装备
	 * @param equipId
	 * @returns
	 */
	isHaveEquip:function(equipId){
		for (var uid in equipdata.equips) {
			if (equipdata.equips[uid].equipId == equipId) {
				return true;
			}
		}
	},
	getOwner:function(uid){
		var form = FormModule.getForm();
		for (var k in form) {
			var hid = form[k];
			var hero = HeroModule.getHeroByUid(hid);
			if (hero.equip) {
				for (var k in hero.equip) {
					var eid = hero.equip[k];
					if (eid && eid === uid) {
						return hero;
					}
				}
			}
		}
		return null;
	},
	getEquipPriceById:function(id) {
		var equip = id;
		if (typeof id === "string") {
			equip = equipdata.equips[id];
		}
		return this.getEquipPrice(equip.equipId, equip.level)
	},
	getEquipPriceConfig:function(equipId) {
		var cfg = this.getEquipConfig(equipId);
		return cfg.worth;
	},
	getEquipPrice:function(equipId, level) {
		var cfg = this.getEquipConfig(equipId);
		var price = cfg.worth;
		if (!cfg.worthgrow) {
			return price;
		}
		return price + Math.floor(cfg.worthgrow * (level - 1));
	},
	/**
	 * 英雄是否穿了指定装备
	 * 
	 * @param equipId
	 * @param hero
	 */
	bEquipOnHero:function(equipId, hero){
		var equips = hero.equip;
		for (var k in equips) {
			var eid = equips[k];
			if (equipdata.equips[eid].equipId === equipId) {
				return true;
			}
		}
		return true;
	},
	/**
	 * 武器属性
	 * 
	 * @param equipId
	 * @param level
	 * @param stage
	 */
	getEquipAttr:function(equipId, level, stage){
		var attr = {};
		var cfg = this.getEquipConfig(equipId);
		for (var k in cfg.initial) {
			var value;
			if (cfg.refine) {
				value = cfg.initial[k] + Math.floor((cfg.updateEffect + cfg.refine * stage) * (level - 1));
			} else {
				value = cfg.initial[k] + Math.floor(cfg.updateEffect * (level - 1));
			}
			attr[k] = attr[k] || 0;
			attr[k] += value;
		}
		return attr;
	},
	/**
	 * 获取装备
	 * 
	 * @param type 
	 */
	getEquips:function(type){
		var ret = [];
		var owners = this.getOwners();
		var equips = equipdata.equips;
		for (var k in equips) {
			var equip = equips[k];
			var cfg = this.getEquipConfig(equip.equipId);
			if (type === -1 || (cfg.type === type)) {
				var dic = this.getEquip(k);
				dic.owner = owners[k];
				ret.push(dic);
			}
		}
		return ret;
	},
	/**
	 * 获取装备并排序
	 * 
	 * @param {Number} type
	 * @param {Function} sort
	 */
	getEquipsWithSort:function(type, sort){
		sort = sort || function(a, b){
			function temp(){
				if (a.rank === b.rank) {
					if (a.stage === b.stage) {
						return a.level > b.level ? -1 : 1;
					}
					return a.stage > b.stage ? -1 : 1;
				}
				return a.rank > b.rank ? -1 : 1;
			}
			if (a.owner && b.owner) {
				if (a.owner.pos === b.owner.pos) {
					return temp();
				}
				return a.owner.pos < b.owner.pos ? -1 : 1;
			} else if (!a.owner && !b.owner) {
				return temp();
			} else {
				return a.owner != null ? -1 : 1;
			}
		};
		var ret = this.getEquips(type);
		ret.sort(sort);
		return ret;
	},
	/**
	 * 获得装备持有人
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
			if (hero.equip) {
				for (var k in hero.equip) {
					var eid = hero.equip[k];
					if (eid && eid !== "") {
						owners[eid] = {name:cfg.name, pos:k};
					}
				}
			}
		}
		return owners;
	},
	/**
	 * 可以出售的装备
	 * 
	 * @param type
	 * @returns {Array}
	 */
	getEquipsCanSell:function(type){
		var ret = [];
		var owners = this.getOwners();
		var equips = equipdata.equips;
		for (var k in equips) {
			var equip = equips[k];
			var cfg = this.getEquipConfig(equip.equipId);
			var owner = owners[k];
			if (!owner && (type === -1 || (cfg.type === type))) {
				var dic = this.getEquip(k);
				ret.push(dic);
			}
		}
		return ret;
	},
	/**
	 * 可以出售的装备，并排序
	 * @param type
	 * @param sort
	 */
	getEquipsCallSellWithSort:function(type, sort){
		sort = sort || function(a, b){
			if (a.rank === b.rank) {
				if (a.stage === b.stage) {
					return a.level < b.level ? -1 : 1;
				}
				return a.stage < b.stage ? -1 : 1;
			}
			return a.rank < b.rank ? -1 : 1;
		};
		var ret = this.getEquipsCanSell(type);
		ret.sort(sort);
		return ret;
	},
	/**
	 * 获取装备更更换的列表
	 * 
	 * @param type
	 * @param eid
	 */
	getChangeList:function(type, eid){
		var selected = "";
		if (eid) {
			var equip = equipdata.equips[eid];
			selected = equip.equipId;
		}
		var owners = this.getOwners();
		var equips = equipdata.equips;
		var ret = [];
		for (var k in equips) {
			if (k === eid) {
				continue;
			}
			var equip = equips[k];
			var cfg = this.getEquipConfig(equip.equipId);
			if (cfg.type !== type) {
				continue;
			}
			var dic = this.getEquip(equip);
			dic.owner = owners[k];
			ret.push(dic);
		}
		ret.sort(function(a, b){
			if (a.rank === b.rank) {
				if (a.stage === b.stage) {
					return a.level > b.level ? -1 : 1;
				}
				return a.stage > b.stage ? -1 : 1;
			}
			return a.rank > b.rank ? -1 : 1;
		});
		return ret;
	},	
	/**
	 * 获取所有未穿上的装备
	 * 
	 * @param type
	 * @param eid
	 */
	getNotOnEquips:function(){
		var ret = [];
		var owners = this.getOwners();
		var equips = equipdata.equips;
		for (var k in equips) {
			var equip = equips[k];
			var cfg = this.getEquipConfig(equip.equipId);
			var owner = owners[k];
			if (!owner) {
				var dic = this.getEquip(k);
				ret.push(dic);
			}
		}
		ret.sort(function(a, b){
			if (a.rank === b.rank) {
				if (a.stage === b.stage) {
					return a.level > b.level ? -1 : 1;
				}
				return a.stage > b.stage ? -1 : 1;
			}
			return a.rank > b.rank ? -1 : 1;
		});
		return ret;
	},
	getEquipConfigInfo:function(equipId){
		var equip = {};
		equip.equipId = equipId;
		equip.level = 1;
		equip.stage = 0;
		var cfg = this.getEquipConfig(equipId);
		equip.rank = cfg.rank;
		equip.cfg = cfg;
		var attr = this.getEquipAttr(equip.equipId, equip.level, equip.stage);
		equip.attr = attr;
		equip.price = cfg.worth;
		return equip;
	},
	/**
	 * 获得强化装备消耗系数
	 * 
	 * @param level
	 */
	getUpdateEquipCostCoe:function(level){
		return config.equip_effect[level + ""].effect || config.equip_effect[getJsonLength(config.equip_effect) + ""].effect;
	},
	/*
	 ********************************
	 * 			  网络
	 ********************************
	 */
	/**
	 * 出售装备
	 */
	doSellEquips:function(selected, succ, fail){
		dispatcher.doAction(ACTION.EQUIP_SELLEQUIP, [selected], succ, fail);
	},
	/**
	 * 强化装备
	 * @param id
	 * @param succ
	 * @param fail
	 */
	doUpdate:function(id, succ, fail){
		dispatcher.doAction(ACTION.EQUIP_UPDATE, [id], succ, fail);
	},
	/**
	 * 精炼装备
	 * @param id
	 * @param items
	 * @param succ
	 * @param fail
	 */
	doRefine:function(id, items, succ, fail){
		dispatcher.doAction(ACTION.EQUIP_REFINE, [id, items], succ, fail);
	},
}