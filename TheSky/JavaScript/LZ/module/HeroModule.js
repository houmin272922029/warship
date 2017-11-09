var HeroModule = {
	getHeroes:function(){
		return herodata.heroes;
	},
	/**
	 * 获得图鉴hero tableview的数据
	 */
	getHandBookViewData:function(){
		var heross = config.figure_hero;
		var heros = [];
		for (var k in heross) {
			heros.push(heross[k]);
		}
		var count = Math.floor(heros.length / 5);
		if (count == 0) {
			return [heros];
		} else {
			var hero = [];
			count = heros.length % 5 === 0 ? count : count + 1;
			for (var j = 0; j < count; j++) {
				var row = [];
				for (var i = 0; i < 5; i++) {
					var s = heros[5 * j + i];
					if (s) {
						row.push(s);
					}
				}
				hero.push(row);
			}
			return hero;
		}
	},
	/**
	 * 判断是否存在某个英雄
	 * @param heroId
	 * @returns
	 */
	isHaveHero:function(heroId){
		for (var uid in herodata.heroes) {
			if (herodata.heroes[uid].heroId == heroId) {
				return true;
			}
		}
	},
	
	getHeroByUid:function(uid){
		if (!uid) {
			return null;
		}
		var hero = deepcopy(uid);
		if (typeof uid === "string") {
			hero = deepcopy(herodata.heroes[uid]);
		}
		var cfg = this.getHeroConfigById(hero.heroId);
		hero.exp = cfg.exp;
		hero.name = cfg.name;
		hero.skill_default.skill_default = cfg.skill;
		hero.desp = cfg.desp;
		var base = hero.exp;
		hero.level = this.getHeroLevel(base, hero.expAll);
		hero.expMax = this.getExpMax(base, hero.level);
		hero.expNow = this.getExpNow(base, hero.expAll, hero.level);
		hero.rank = cfg.rank;
		if (herodata.heroes[uid].aggress) {
			hero.aggress = herodata.heroes[uid].aggress;
		}
		if (hero.aggress) {
		} else {
			hero.aggress = {}
			hero.aggress.kind = 1;
			hero.aggress.layer = 1;
			hero.aggress.base = 0;
			hero.aggress.pre = 1;
		}
		// TODO price
		hero.price = this.getHeroPrice(hero);
		return hero;

	},
		
	/**
	 * 身价计算
	 * @param hero
	 */
	getHeroPrice:function(hero){
		var price = this.getHeroAttrPrice(hero);
		if (typeof hero === "string") {
			hero = herodata.heroes[hero];
		}
		for (var k in hero.equip) {
			var eid = hero.equip[k];
			price += EquipModule.getEquipPriceById(eid);
		}
		var skills = this.getHeroSkills(hero)
		for (var k in skills) {
			var skill = skills[k];
			price += SkillModule.getSkillPrice(skill.skillId, skill.level);
		}
		return price;
	},
	/**
	 * 净身价计算 不计算装备奥义
	 * 
	 * @param hero
	 */
	getHeroAttrPrice:function(hero){
		if (typeof hero === "string") {
			hero = herodata.heroes[hero];
		}
		var price = this.getHeroPriceConfig(hero.heroId);
		var cfg = this.getHeroConfig(hero.heroId);
		var attr = 0;
		for (var k in cfg.grow) {
			attr += Math.floor(cfg.grow[k] * (hero.level - 1));
		}
		for (var k in hero.attrFix) {
			attr += parseInt(hero.attrFix[k]);
		}
		return price + Math.floor(attr * 0.75);
	},
	
	getHeroPriceConfig:function(heroId){
		var cfg = this.getHeroConfig(heroId);
		return cfg.worth;
	},
	/**
	 * 根据heroId获得英雄
	 * @param 英雄heroId
	 * @returns 英雄/null
	 */
	getHeroByHeroId:function(heroId){
		if (!heroId) {
			return null;
		}
		for (var k in herodata.heroes) {
			var hero = herodata.heroes[k]; 
			if (heroId == hero.heroId) {
				return hero;
			}
		}
		return null;
	},
	/**
	 * 
	 * @param level
	 * @returns {Number}
	 */
	getExpMax:function(base, level){
		var cfg = config.leader_exp[level + ""];
		return Math.floor(base * cfg.value2);
	},
	
	getExpNow:function(base, exp, level){
		level = level || this.getHeroLevel(base, exp);
		var total = 0;
		var cfg = config.leader_exp;
		for (var i = 1; i < level; i++) {
			var dic = cfg[i + ""];
			var m = dic.value2;
			total += Math.floor(base * m);
		}
		return exp - total;
	},
	/**
	 * 英雄等级
	 * 
	 * @param exp
	 * @returns {Number}
	 */
	getHeroLevel:function(base, exp){
		var p_level_limit = config.leader_openlevelup["1"].levelup;
		var h_level_limit = p_level_limit * 3;
		var cfg = config.leader_exp;
		var total = 0;
		for (var i = 1; i <= h_level_limit; i++) {
			var dic = cfg[i + ""];
			var m = dic.value2;
			total += Math.floor(base * m);
			if (total >= exp) {
				return i;
			}
		}
		return h_level_limit;
	},
	getHeroConfigById:function(id){
		return config.hero_data[id];
	},
	getHeroBust2ById:function(id){
		if (!id) {
			return null;
		}
		return common.formatLResPath("hero_bust_2/" + id + "_bust_2.png");
	},
	getHeroBust1ById:function(id){
		if (!id) {
			return null;
		}
		return common.formatLResPath("hero_bust_1/" + id + "_bust_1.png");
	},
	getHeroHeadById:function(id){
		cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("olRes/hero_head.plist"));
		cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("olRes/hero_head2.plist"));
		return id + "_head.png";
	},
	getAllHeroes:function(){
		var heroes = [];
		for (var k in herodata.heroes) {
			var hero = this.getHeroByUid(k);
			hero.form = common.bContainObject(formdata.form, hero.id) ? 1 : 0;
			heroes.push(hero);
		}
		heroes.sort(function(a, b){
			if (a.form === b.form) {
				if (a.rank === b.rank) {
					if (a.level === b.level) {
						if (a.price === b.price) {
							return a.name > b.name ? 1 : -1;
						}
						return a.price > b.price ? -1 : 1
					}
					return a.level > b.level ? -1 : 1;
				}
				return a.rank > b.rank ? -1 : 1;
			}
			return a.form > b.form ? -1 : 1;
		});
		return heroes;
	},
	getNotFullLevelHeroes:function(){
		var heroes = [];
		
		for (var k in herodata.heroes) {
			var hero = this.getHeroByUid(k);
			
			if (hero.level <= 3 * PlayerModule.getLevel()) {
				heroes.push(hero);
			}
		}
		
		heroes.sort(function(a, b){
			if (a.form === b.form) {
				if (a.rank === b.rank) {
					if (a.level === b.level) {
						if (a.price === b.price) {
							return a.name > b.name ? 1 : -1;
						}
						return a.price > b.price ? -1 : 1
					}
					return a.level > b.level ? -1 : 1;
				}
				return a.rank > b.rank ? -1 : 1;
			}
			return a.form > b.form ? -1 : 1;
		});
		return heroes;
	},
	/**
	 * 英雄基础属性，不包含装备
	 * 
	 * @param uid
	 */
	getHeroBasicAttrsByUid:function(uid){
		var hero;
		if (typeof uid === "string") {
			hero = this.getHeroByUid(uid);
		} else {
			hero = uid;
		}
		return this.getHeroBasicAttrs(hero);
	},
	getHeroBasicAttrs:function(hero){
		var heroId = hero.heroId;
		var cfg = this.getHeroConfig(heroId);
		var attr = deepcopy(cfg.attr);
		for (var k in cfg.grow) {
			attr[k] = attr[k] || 0;
			attr[k] += Math.floor(cfg.grow[k] * (hero.level - 1));
		}
		for (var k in hero.attrFix) {
			attr[k] = attr[k] || 0;
			attr[k] += Number(hero.attrFix[k]);
		}
		return attr;
	},
		
	/**
	 * 获取英雄修炼等级
	 * 
	 * @param uid
	 */
	getTrainLevel:function(uid){
		if (!uid) {
			return 0;
		}
		var hero = uid;
		if (typeof uid === "string") {
			hero = herodata.heroes[uid];
		}
		if (hero.discipline && hero.discipline.level) {
			return hero.discipline.level;
		}
		return 0;
	},
	/**
	 * 
	 * @param uid
	 */
	getHeroAttrsByHeroUId:function(uid){
		var array = this.getHeroAttrsAndAddByHeroUId(uid);
		var attr = array[0];
		var addAttr = array[1];
		for (var k in addAttr) {
			if (attr[k]) {
				attr[k] = Math.floor(attr[k] * (1 + addAttr[k]));
			}
		}
		return attr;
	},
		getHeroAttrsByHero:function(hero){
			var array = this.getHeroAttrsAndAddByHero(hero);
			var attr = array[0];
			var addAttr = array[1];
			for (var k in addAttr) {
				if (attr[k]) {
					attr[k] = Math.floor(attr[k] * (1 + addAttr[k]));
				}
			}
			return attr;
		},
		getHeroAttrsAndAddByHero:function(hero){
			var heroId = hero.heroId;
			var cfg = this.getHeroConfig(heroId);
			var attr = this.getHeroBasicAttrs(hero);
			var addAttr = {};
			// 闭关
			if (hero.discipline && hero.discipline.level && hero.discipline.level > 0) {
				var sa = cfg.specialadd; 
				var v = Math.floor(sa.value + (hero.discipline.level - 1) * sa.lv);
				attr[sa.attr] = attr[sa.attr] || 0;
				attr[sa.attr] += v;
			}
			// 装备
			for (var k in hero.equip) {
				var equip = EquipModule.getEquipByUid(hero.equip[k]);
				var equipId = equip.equipId;
				var level = equip.level;
				var stage = equip.stage;
				var cfg = EquipModule.getEquipConfig(equipId);
				var value = 0;
				var advanced = equip.advanced
				if (advanced && advanced > 0) {
					// TODO 装备合成
				}
				if (cfg.initial) {
					for (var k in cfg.initial) {
						var v = cfg.initial[k];
						if (cfg.refine) {
							v += Math.floor((cfg.updateEffect + cfg.refine * stage) * (level - 1));
						} else {
							v += Math.floor(cfg.updateEffect * (level - 1));
						}
						attr[k] = attr[k] || 0;
						attr[k] += v;
					}
				}
			}
			// 啦啦队
			var sevenAttr = FormModule.getSevenFormAttr()
			for (var k in sevenAttr) {
				var v = sevenAttr[k];
				attr[k] = attr[k] || 0;
				attr[k] += v;
			}
			// 影子
			var sattr = ShadowModule.getAttrsByHero(hero);
			for (var k in sattr) {
				attr[key] = attr[key] || 0;
				attr[key] += sattr[key];
			}
			// 缘分
			var combos = this.getComboByUid(hero);
			for (var i in combos) {
				var combo = combos[i];
				if (combo.flag) {
					for (var k in combo.param) {
						addAttr[k] = addAttr[k] || 0;
						addAttr[k] += combo.param[k];
					}
				}
			}

			//突破
			var breakGrow = cfg.breakgrow
			for (var k in breakGrow) {
				addAttr[k] = addAttr[k] || 0;
				addAttr[k] += breakGrow[k] * hero["break"];
			}

			// 技能
			var skills = this.getHeroSkills(hero);
			for (var k in skills) {
				var dic = skills[k];
				if (dic) {
					var skillId = dic.skillId;
					var level = dic.level;
					var skill = SkillModule.getSkill(skillId, level, hero.heroId);
					if (skill.type === 1) {
						// buff
						for (var k in skill.attr) {
							addAttr[k] = addAttr[k] || 0;
							addAttr[k] += skill.attr[k]
						}
					} else if(skill.type === 5) {
						for (var k in skill.attr) {
							attr[k] = attr[k] || 0;
							attr[k] += skill.attr[k];
						}
					}
				}
			}
			//  霸气
			var haki = this.getHeroByUid(hero.id).aggress;
			var hakiAttr = this.getHakiAttr(haki);
			for(var k in hakiAttr) {
				if (attr[k]) {
					attr[k] = hakiAttr[k] + attr[k];
				} else {
					attr[k] = hakiAttr[k];
				}

			}
			// TODO 觉醒
			return [attr, addAttr];
		},
		/**
		 * 
		 * @param uid
		 */
		getHeroAttrsAndAddByHeroUId:function(uid){
			if (!uid) {
				return null;
			}
			var hero = herodata.heroes[uid];
			return this.getHeroAttrsAndAddByHero(hero);
		},
		getHeroConfig:function(heroId){
			return config.hero_data[heroId];
		},
		/**
		 * 英雄缘分
		 * @param uid
		 */
		getComboByUid:function(uid){
			var hero = uid;
			if (typeof uid === "string") {
				hero = this.getHeroByUid(uid);
			}
			var heroId = hero.heroId;
			var array = [];
			var combos = config.assist[heroId];
			if (!combos) {
				return array;
			}
			var cfg = this.getHeroConfig(heroId);
			var max = cfg.assist[hero.rank + ""];
			for (var i = 0; i < max; i++) {
				var flag = false;
				var combo = combos[i];
				if (!combo) {
					common.showTipText(common.LocalizedString("找不到该英雄的连协配置"));
				}
				if (combo.type === 1) {
					// 英雄
					for (var k in combo.heroes) {
						var heroId = combo.heroes[k];
						if (!FormModule.bHeroOnFormByHeroId(heroId)) {
							flag = false;
							break;
						} else {
							flag = true;
						}
					}
				} else if (combo.type === 2) {
					// 装备
					for (var k in combo.equips) {
						var equipId = combo.equips[k];
						if (!EquipModule.bEquipOnHero(equipId, hero)) {
							flag = false;
							break;
						} else {
							flag = true;
						}
					}
				} else if (combo.type === 3) {
					// 技能
					for (var k in combo.books) {
						var skillId = combo.books[k];
						if (!SkillModule.bSkillOnHero(skillId, uid)) {
							flag = false;
							break;
						} else {
							flag = true;
						}
					}
				}
				var dic = {name:combo.name, flag:flag, param:combo.param};
				array.push(dic);
			}
			return array;
		},

		/**
		 * 获取缘分信息
		 * 
		 * @param heroId
		 */
		getComboInfoByHeroId:function(heroId, rank){
			var ret = "";
			var combos = config.assist[heroId];
			if (!combos) {
				return ret;
			}
			var cfg = this.getHeroConfig(heroId);
			var max = cfg.assist[rank + ""];
			for (var i = 0; i < max; i++) {
				var combo = combos[i];
				if (combo.type === 1) {
					var name = "";
					var len = getJsonLength(combo.heroes)
					for (var k in combo.heroes) {
						var heroId = combo.heroes[k];
						var cfg = this.getHeroConfig(heroId);
						name += cfg.name;
						if (k < len) {
							name += ",";
						}
					}
					var key;
					var value;
					for (var k in combo.param) {
						key = k;
						value = combo.param[k] * 100 + "";
					}
					var value = Math.round(value)
					ret = common.LocalizedString("combo_text", [ret, combo.name, 
					                                            common.LocalizedString("combo_heroes", name), common.LocalizedString(key), value]);
				} else if (combo.type === 2) {
					var name = "";
					var len = getJsonLength(combo.equips);
					for (var k in combo.equips) {
						var id = combo.equips[k];
						var cfg = EquipModule.getEquipConfig(id);
						name += cfg.name;
						if (k < len) {
							name += ",";
						}
					}
					var key;
					var value;
					for (var k in combo.param) {
						key = k;
						value = combo.param[k] * 100 + "";
					}
					var value = Math.round(value) //var value = value.substring(0,value.indexOf(".") + 3);
					ret = common.LocalizedString("combo_text", [ret, combo.name, 
					                                            common.LocalizedString("combo_equips", name), common.LocalizedString(key), value]);
				} else if (combo.type === 3) {
					var name = "";
					var len = getJsonLength(combo.books);
					for (var k in combo.books) {
						var id = combo.books[k];
						var cfg = SkillModule.getSkillConfig(id);
						name += cfg.name;
						if (k < len) {
							name += ",";
						}
					}
					var key;
					var value;
					for (var k in combo.param) {
						key = k;
						value = combo.param[k] * 100 + "";
					}
					var value = Math.round(value)
					ret = common.LocalizedString("combo_text", [ret, combo.name, 
					                                            common.LocalizedString("combo_equips", name), common.LocalizedString(key), value]);
				}
				ret += "\r\n";
			}
			return ret;
		},
		/*
		 * ************************** 装备 **************************
		 */
		/**
		 * 获取英雄身上的装备
		 */
		getHeroEquip:function(uid){
			if (!uid) {
				return null;
			}
			return herodata.heroes[uid].equip;
		},
		/*
		 * ************************** 技能 **************************
		 */
		getHeroSkills:function(uid){
			var dic = {};
			var hero = uid;
			if (typeof uid === "string") {
				hero = herodata.heroes[uid];
			}
			dic["0"] = hero.skill_default;

			if (hero.skills_ex) {
				for (var i = 1; i <= 3; i++) {
					var sid = hero.skills_ex[i + ""];
					if (sid) {
						dic[i + ""] = SkillModule.getSkillByUid(sid);
					}
				}
			}
			return dic;
		},
		/*
		 * ************************** 送别 **************************
		 */
		/**
		 * 选择送别狗粮
		 */
		getFarewellHeroes:function(desUid){
			var heroes = herodata.heroes;
			var array = [];
			for (var k in heroes) {
				if (k == desUid) {
					continue;
				}
				var hero = this.getHeroByUid(k);
				if (hero.level > 1 && !common.bContainObject(formdata.form, k)) {
					array.push(hero);
					var key;
					var value;
					var combo = this.getComboByUid(hero)
					for (var k in combo.param) {
						key = k;
						value = (combo.param[k] * 100).toPrecision(2);
					}
				}
				array.sort(function(a, b){
					if (a.level === b.level) {
						if (a.rank === b.rank) {
							return a.price > b.price ? 1 : -1;
						}
						return a.rank > b.rank ? -1 : 1;
					}
					return a.level > b.level ? -1 : 1;
				});
			}
			return array;
	},
		/*
		 * ************************** 培养 **************************
		 */
		/**
		 * 送别 返还蓝波球数量
		 */
		getFarewellItemForHeroUId:function(uid){
			var hero = this.getHeroByUid(uid);
			if (!hero) {
				return 0;
			}
			var point = 0;
			for (var k in hero.attrFix) {
				point += hero.attrFix[k];
			}
			return Math.floor(point * 0.8);
		},
		/**
		 * 送别 返还热血值
		 * 
		 * @param blood
		 */
		getFarewellBlood:function(blood, type){
			// TODO
			// _bloodCount =
			// math.floor(herodata:getHakiTrainTotalCost(srcHeroInfo.aggress or
			// {kind = 1, layer = 1, base = 0, pre = 0}) *
			// ConfigureStorage.aggress_inheritance[tostring(2 -
			// _SMPType)].getpercent)
			return 0;
		},
		/*
		 * ************************** 霸气 **************************
		 */
		//霸气开启等级
		hakiOpenLv:function() {
			return config.aggress_startlv["startlv_" + ""];
		},
		//处理后端传来的霸气值
		getAggressByUid:function(uid){
			var aggress = this.getHeroByUid(uid).aggress;
			if (aggress.base >= 30) {
				aggress.base = 30;
			} else {
				aggress.base = aggress.base + 1;
			}
			return aggress;
		},
		//获取已获得的霸气属性值
		getHakiAttr:function(haki) {
			var attr = {hp:0, atk:0, def:0, mp:0, cri:0, dod:0, parry:0, resi:0, hit:0, cnt:0};
			var base = haki.base;
			var layer = haki.layer;
			var kind = haki.kind;
			var k = 1;
			var l =	1;
			var b = 1;
			while(true) {
				if (b > base && k >= kind && l >= layer) {
					break;
				}
				var cfg = config.aggress_data["data_" + k + "_" + l + "_" + b];
				for (var key in attr) {
					attr[key] = attr[key] + cfg[key];
				}

				b = b + 1;
				if (b > 30) {
					b = 1;
					l = l + 1;
				}
				if (l > 8) {
					l = 1;
					k = k + 1;
				}
			}
			layer = layer - 1;
			kind = layer === 0 ? (kind - 1) : kind;
			layer = layer === 0 ? 8 : layer;
			var add ={hp:0, atk:0, def:0, mp:0, cri:0, dod:0, parry:0, resi:0, hit:0, cnt:0};
			for (i = 1; i <= kind; i++) {
				var max = i === kind ? layer : 8;
				for (j = 1; j < max; j++) {
					var cfg = config.aggress_roundattr["roundattr_" + i + "_" + j];
					for(var k in add) {
						add[k] = add[k] + (cfg[k] || 0);
					}
				}
			}
			for (var k in attr) {
				attr[k] = Math.floor(attr[k] * (1 + add[k]));
			}
			return attr
		},

	addExp:function(hid, exp){
		var hero = herodata.heroes[hid];
		hero.expAll += exp;
	},
	getNextBall:function(t) {
		var k = t.kind;
		var l = t.layer;
		var b = t.base;
		var p = t. pre;
		l = b > 30 && l + 1 || l;
		k = l > 8 && k + 1 || k;
		l = l > 8 && l - 8 || l;
		b = b > 30 && b - 30|| b;
		p = b == 0 && 0 || p;
		return [kind = k, layer = l, base = b, pre = p];
	},
	//获取霸气球信息
	getHakiBallInfo:function(haki) {
		var array = {};
		var pre = deepcopy(haki);
		array[1] = pre;
		array[2] = this.getNextBall(array[1]);
		array[3] = this.getNextBall[2];
		return array;

	},
	//霸气开启战斗前英雄对话
	getHakiTalk:function(kind, layer){
		return config.aggress_roundtalk;
	},
	/**
	 * 霸气训练总消耗
	 * 
	 * @param haki
	 */
	getHakiTrainTotalCost:function(haki){

		return 0;
	},
	/*
	 * ************************** 影子 **************************
	 */
	/**
	 * 获取英雄身上的影子
	 */
	getHeroShadow:function(uid){
		if (!uid) {
			return null;
		}
		return herodata.heroes[uid].shadow;
	},
	/**
	 * 获取英雄骨骼动画配置
	 * 
	 * @param id
	 */
	getHeroBoneRes:function(id){
		var cfg = config.Export_data[id];
		var ret = {};
		if (!cfg) {
			return {name:"Axe", amount:1};
		}
		return {name:cfg.name, amount:cfg.amount};
	},
//	/*
//	 * ************************** 送别 **************************
//	 */
//	/**
//	 * 选择送别狗粮
//	 */
//	getFarewellHeroes:function(desUid){
//		var heroes = herodata.heroes;
//		var array = [];
//		for (var k in heroes) {
//			if (k == desUid) {
//				continue;
//			}
//			return attr;
//			}
//		}
//	},
//		
	
		/*
		 ********************************
		 * 			  网络
		 ********************************
		 */
		/**
		 * 传承
		 */
		doFarewell:function(uid1, uid2, type, succ, fail) {
			dispatcher.doAction(ACTION.HEROFARME, [uid1, uid2, type], succ, fail);
		},

		/**
		 * 培养
		 */
		doCulture:function(uid, type, succ, fail){
			dispatcher.doAction(ACTION.HEROCULTURE, [uid, type], succ, fail);
		},
		doCulCofirm:function(uid,isSave, succ, fail){
			dispatcher.doAction(ACTION.CULTURECONFIRM, [uid, isSave], succ,fail);
		},
		/**
		 * 霸气训练
		 */
		doTrain:function(heroId, succ, fail){
			dispatcher.doAction(ACTION.HEROTRAIN, [heroId], succ, fail);
		},
		doFight:function(heroId, succ, fail) {
			dispatcher.doAction(ACTION.HEROFIGHTING, [heroId], succ, fail);
		},
		/**
		 * **************************
		 * 			突破
		 * **************************
		 */
		/**
		 * 获得英雄突破下一次增加的属性值
		 * @param uid
		 */
		getBreakAttr:function(hero){
			var cfg = this.getHeroConfig(hero.heroId);
			var array = {};
			var attr = this.getHeroBasicAttrsByUid(hero)
			for (var k in cfg.breakgrow) {
				array[k] = Math.floor(hero.level - 1) * cfg.breakgrow[k];
			}
			return array
		},
		/**
		 * 获取英雄突破提升属性
		 * 
		 * @param heroId
		 */
		getBreakKey:function(heroId){
			var cfg = this.getHeroConfig(heroId);
			for (var k in cfg.breakgrow) {
				if (cfg.breakgrow[k] > 0) {
					return k;
				}
			}
		},

	/*
	 ********************************
	 * 			  网络
	 ********************************
	 */

	/**
	 * 英雄更换技能
	 * @param hid 英雄id
	 * @param pos 更换位置
	 * @param sid 技能id
	 * @param succ 成功回调
	 * @param fail 失败回调
	 */
	doChangeSkill:function(hid, pos, sid, succ, fail){
		dispatcher.doAction(ACTION.HERO_CHANGESKILL, [hid, pos, sid], succ, fail);
	},
	/**
	 * 英雄更换装备
	 * @param hid 英雄id
	 * @param pos 更换位置
	 * @param eid 装备id
	 * @param succ 成功回调
	 * @param fail 失败回调
	 */
	doChangeEquip:function(hid, pos, eid, succ, fail){
		dispatcher.doAction(ACTION.HERO_CHANGEEQUIP, [hid, pos, eid], succ, fail);
	},


	/**
	 * 英雄更换影子
	 * @param hid 英雄id
	 * @param pos 更换位置
	 * @param eid 影子id
	 * @param succ 成功回调
	 * @param fail 失败回调
	 */
	doChangeShadow:function(hid, pos, eid, succ, fail){
		dispatcher.doAction(ACTION.HERO_CHANGESHADOW, [hid, pos, eid], succ, fail);
	},
}
	