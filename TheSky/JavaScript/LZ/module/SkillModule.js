var SkillModule = {
	getSkillByUid:function(uid){
		return skilldata.skills[uid];
	},
	getSkillInfo:function(skill){
		var skill;
		if (typeof skill === "string") {
			skill = deepcopy(this.getSkillByUid(skill));
		} else {
			skill = deepcopy(skill);
		}
		var cfg = this.getSkillConfig(skill.skillId);
		skill.cfg = cfg;
		for (var k in cfg.attr) {
			var attr = {};
			attr[k] = cfg.attr[k] + (skill.level - 1) * cfg.attrlv;
			skill.attr = attr;
		}
		return skill;
	},
	getSkillConfigInfo:function(skillId){
		var skill = {};
		skill.skillId = skillId;
		skill.level = 1;
		var cfg = this.getSkillConfig(skillId);
		skill.cfg = cfg;
		return skill;
	},
	getSkill:function(skillId, level, heroId) {
		var cfg = this.getSkillConfig(skillId);
		var skill = {};
		skill.skillId = skillId;
		skill.type = cfg.type;
		skill.name = cfg.name;
		skill.level = level;
		skill.rank = cfg.rank;
		skill.attr = {};
		for (var k in cfg.attr) {
			skill.attr[k] = cfg.attr[k] + cfg.attrlv * (level - 1);
		}
		skill.trigger = cfg.trigger;
		if (heroId && cfg.link && cfg.link[heroId]) {
			skill.trigger += cfg.link[heroId];
		}
		if (cfg.range) {
			skill.range = cfg.range;
		}
		return skill;
	},
	getSkillConfig:function(skillId){
		return config.skill_data[skillId];
	},
	/**
	 * 英雄是否装备指定技能
	 * 
	 * @param skillId
	 * @param hid
	 */
	bSkillOnHero:function(skillId, hid){
		var skills = HeroModule.getHeroSkills(hid);
		for (var k in skills) {
			var skill = skills[k];
			if (skill.skillId === skillId) {
				return true;
			}
		}
		return false;
	},
	/**
	 * 获得技能持有人
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
			if (hero.skills_ex) {
				for (var k in hero.skills_ex) {
					var sid = hero.skills_ex[k];
					if (sid && sid !== "") {
						owners[sid] = {name:cfg.name, pos:k};
					}
				}
			}
		}
		return owners;
	},
	/**
	 * 获得所有的技能
	 */
	getAllSkills:function(){
		var skills = skilldata.skills;
		var ret = [];
		var owners = this.getOwners();
		for (var k in skills) {
			var dic = this.getSkillInfo(k);
			dic.owner = owners[k];
			ret.push(dic);
		}
		ret.sort(function(a, b){
			if (a.owner && b.owner) {
				if (a.owner.pos == b.owner.pos) {
					if (a.rank === b.rank) {
						return a.level > b.level ? -1 : 1;
					}
					return a.rank > b.rank ? -1 : 1;
				}
				return a.owner.pos < b.owner.pos ? -1 : 1;
			} else if (!a.owner && !b.owner) {
				if (a.rank === b.rank) {
					if (a.skillId === b.skillId) {
						return a.level > b.level ? -1 : 1;
					}
					return a.skillId < b.skillId ? -1 : 1;
				}
				return a.rank > b.rank ? -1 : 1;
			}
			return (a.owner != null || a.owner != undefined) ? -1 : 1;
		});
		return ret;
	},
	/**
	 * 技能身价
	 */
	getSkillPrice:function(skillId, level){
		var cfg = this.getSkillConfig(skillId);
		var price = cfg.worth || 0;
		if (!cfg.worthgrow) {
			return price;
		}
		return price + Math.floor(cfg.worthgrow * (level - 1));
	},
	/**
	 * 获取技能属性描述
	 * 
	 * @param uid
	 * @param type 0 完整 1 简短模式
	 */
	getSkillAttrDiscribe:function(uid, type){
		var skill = uid;
		if (typeof uid === "string") {
			skill = this.getSkillByUid(uid);
		}
		var cfg = this.getSkillConfig(skill.skillId);
		var intro = type === 0 ? cfg.intro2: cfg.intro3;
		var value = this.getSkillAttr(uid);
		value = parseInt(value) === value ? value : Math.abs(parseInt(value * 100)) + "%";
		return String(intro).format([value]);
	},
	/**
	 * 获取技能属性
	 * @param uid
	 * @returns Number
	 */
	getSkillAttr:function(uid){
		var skill = uid;
		if (typeof uid === "string") {
			skill = this.getSkillByUid(uid);
		}
		var cfg = this.getSkillConfig(skill.skillId);
		var value;
		for (var k in cfg.attr) {
			value = cfg.attr[k] + (skill.level - 1) * cfg.attrlv;
		}
		return value;
	},
	getSkillAttrStringWithValue:function(value){
		var str = value >= 0 ? "+" : "";
		if (parseInt(value) === value) {
			str += (" " + value); 
		} else {
			str += (" " + parseInt(value * 100) + "%");
		}
		return str;
	},
	/**
	 * 技能属性描述
	 * @param uid
	 */
	getSkillAttrString:function(uid) {
		var value = this.getSkillAttr(uid);
		return this.getSkillAttrStringWithValue(value);
	},
	/**
	 * 技能升级需要的经验值
	 *  
	 * @param rank
	 * @param level
	 */
	getSkillUpdateExp:function(rank, level) {
		var cfg = config.skill_lv;
		var base = cfg[rank + ""].exp1;
		return Math.pow(2, level - 1) * base;
	},
	/**
	 * 狗粮提供经验
	 * 
	 * @param rank
	 * @param level
	 */
	getSkillFoodExp:function(rank, level) {
		var cfg = config.skill_lv;
		var base = cfg[rank + ""].exp2;
		return level * base;
	},
	/**
	 * 最大突破等级
	 * 
	 */
	getSkillBreakMax:function(){
		return 7;
	},
	/**
	 * 获取其余技能
	 * 
	 * @param sid
	 */
	getSkillWithoutSid:function(sid) {
		var skills = skilldata.skills;
		var ret = [];
		var owners = this.getOwners();
		for (var k in skills) {
			if (k === sid) {
				continue;
			}
			var dic = this.getSkillInfo(k);
			dic.owner = owners[k];
			ret.push(dic);
		}
		ret.sort(function(a, b){
			if (a.owner && b.owner) {
				if (a.owner.pos == b.owner.pos) {
					if (a.level === b.level) {
						return a.rank < b.rank ? -1 : 1;
					}
					return a.level < b.level ? -1 : 1;
				}
				return a.owner.pos > b.owner.pos ? -1 : 1;
			} else if (!a.owner && !b.owner) {
				if (a.rank === b.rank) {
					if (a.level === b.level) {
						return a.skillId > b.skillId ? -1 : 1;
					}
					return a.level < b.level ? -1 : 1;
				}
				return a.rank < b.rank ? -1 : 1;
			}
			return (a.owner != null || a.owner != undefined) ? -1 : 1;
		});
		return ret;
	},

	getHandBookViewData:function(){
		var skills = config.figure_skill;
		var skill = [];
		for ( var k in skills) {
			skill.push(skills[k]);
		}
		var count = Math.floor(skill.length / 5);
		if (count == 0) {
			return [skill];
		} else {
			var sk = [];
			count = skill.length % 5 === 0 ? count : count + 1;
			for (var j = 0; j < count; j++) {
				var row = [];
				for (var i = 0; i < 5; i++) {
					var s = skill[5 * j + i];
					if (s) {
						row.push(s);
					}
				}
				sk.push(row);
			}
			return sk;
		}
	},

	/**
	 * 获取可更换的技能列表
	 * 
	 * @param hid
	 * @param sid
	 */
	getChangeList:function(hid, sid){
		var hero = herodata.heroes[hid];
		var on = {};
		on[hero.skill_default.skillId] = true;
		for (var k in hero.skills_ex) {
			if (hero.skills_ex[k]) {
				var skill = skilldata.skills[hero.skills_ex[k]];
				on[skill.skillId] = true;
			}
		}
		var selected = "";
		if (sid) {
			var skill = skilldata.skills[sid];
			selected = skill.skillId;
		}
		var owners = this.getOwners();
		var skills = [];
		for (var k in skilldata.skills) {
			if (k === sid) {
				continue;
			}
			var skill = skilldata.skills[k];
			if (skill.skillId === selected || !on[skill.skillId]) {
				var dic = this.getSkillInfo(skill);
				dic.owner = owners[k];
				skills.push(dic);
			}
		}
		skills.sort(function(a, b){
			if (a.rank === b.rank) {
				if (a.skillId === b.skillId) {
					return a.level > b.level ? -1 : 1;
				}
				return a.skillId < b.skillId ? -1 : 1;
			}
			return a.rank > b.rank ? -1 : 1;
		});
		return skills;
	},
	/**
	 * 获取某个几能的数量
	 * @param skillId
	 */
	getSkillCount:function(skillId){
		var count = 0;
		for (var k in skilldata.skills) {
			if (skilldata.skills[k].skillId == skillId) {
				count += 1;
			}
		}
		return count;
	},
	/**
	 * 获取技能TypeGo骨骼动画配置
	 * 
	 * @param id
	 */
	getSkillBoneTypeGoRes:function(id){
		if (!config.Export_typego) {
			return {name:"gpqg01", amount:1};
		}
		var cfg = config.Export_typego[id];
		if (!cfg) {
			return {name:"gpqg01", amount:1};
		}
		return {name:cfg.name, amount:cfg.amount};
	},
	/**
	 * 获取技能TypeOn骨骼动画配置
	 * 
	 * @param id
	 */
	getSkillBoneTypeOnRes:function(id){
		if (!config.Export_typeon) {
			return {name:"blfst", amount:1};
		}
		var cfg = config.Export_typeon[id];
		if (!cfg) {
			var skillCfg = config.skill_data[id];
			if (skillCfg.typeon && skillCfg.typeon.typeon == 1) {
				return {name:"blfst", amount:1};
			} else if (skillCfg.typeon && (skillCfg.typeon.typeon == 2 || skillCfg.typeon.typeon == 3)) {
				return {name:"dysgp", amount:2};
			} else {
				return;
			}
		}
		return {name:cfg.name, amount:cfg.amount};
	},
	/*
	 ********************************
	 * 			  网络
	 ********************************
	 */
	
	/**
	 * 
	 * @param id 突破的id
	 * @param dogfood 使用的技能id
	 */
	doBreak:function(id, dogfood, succ, fail){
		dispatcher.doAction(ACTION.SKILL_BREAK, [id, dogfood], succ, fail);
	}
}