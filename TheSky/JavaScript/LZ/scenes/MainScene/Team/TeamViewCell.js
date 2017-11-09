var TeamViewCell = cc.Layer.extend({
	ctor:function(uid, page){
		this._super();
		this.page = page;
		this.uid = uid;
		if (uid) {
			this.hero = HeroModule.getHeroByUid(uid);
		}
		this.initLayer(this.uid);
	},
	initLayer:function(uid){
		var bAwake = false
		if (this.hero && this.hero.awake == 1) {
			bAwake = true;
			cc.BuilderReader.registerController("AwakeTeamViewCellOwner", {
			});
			this.node = cc.BuilderReader.load(ccbi_res.AwakeTeamViewCell_ccbi, this);
			if(this.node != null) {
				this.addChild(this.node);
			}
		} else {
			cc.BuilderReader.registerController("TeamViewCellOwner", {
			});
			this.node = cc.BuilderReader.load(ccbi_res.TeamViewCell_ccbi, this);
			if(this.node != null) {
				this.addChild(this.node);
			}
		}
		var size = this.node.getContentSize();
		this.setContentSize(size);
		this.menu.setSwallowTouches(false);
		if (this.hero) {
			var hero = this.hero;
			var attr = HeroModule.getHeroAttrsByHeroUId(uid);
			//this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("ol_hero_bg_" + hero.rank + ".png"));
			this.rankIcon.visible = true;
			this.rankIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + hero.rank + "_icon.png"));
			if (hero["break"]) {
				this.breakLevel.visible = true;
				this.breakLevelFnt.setString(hero["break"]);
			}
			if (hero.rank === 5) {
				// TODO 觉醒标识
				this.runeSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("nature_1.png"));
			}
			this.nameLabel.enableStroke(cc.color(0, 0, 0), 2);
			this.levelLabel.enableStroke(cc.color(140, 48, 30), 2);
			this.updateLabel("nameLabel", hero.name);
			this.updateLabel("levelLabel", hero.level);
			this.updateLabel("priceLabel", hero.price);
			this.updateLabel("hpLabel", attr.hp);
			this.updateLabel("atkLabel", attr.atk);
			this.updateLabel("defLabel", attr.def);
			this.updateLabel("mpLabel", attr.mp);

			var trainLevel = HeroModule.getTrainLevel(uid);
			if (trainLevel > 0) {
				this.heroTrainBg.visible = true;
				this.updateLabel("heroTrainLevel", trainLevel);
			} else {
				this.heroTrainBg.visible = false;
			}
			this.avatarSpritebg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("ol_rank_bg_"+ hero.rank + ".png"));
			this.avatarSpritebg.visible = true;
			this.avatarSprite.setTexture(HeroModule.getHeroBust1ById(hero.heroId));
			this.avatarSprite.visible = true;
			// combo
			var combos = HeroModule.getComboByUid(uid);
			for (var i = 0; i < combos.length; i++) {
				if (i === 6) {
					break;
				}
				var combo = combos[i];
				var comboLabel = this["combo" + (i + 1)];
				var cname = (i === 5 && combos.length > 6) ? "..." : combo.name;
				comboLabel.visible = true;
				comboLabel.setString(cname);
				if (cname === "..."){
					comboLabel.setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER);
				} else if (!combo.flag) {
					comboLabel.setColor(cc.color(73, 54, 40));
				}
			}

			this.progressBg.visible = true;
			this.progress = new cc.ProgressTimer(new cc.Sprite("#team_exp_pro_red.png"));
			this.progress.type = cc.ProgressTimer.TYPE_BAR;
			this.progress.midPoint = cc.p(0, 0);
			this.progress.barChangeRate = cc.p(1, 0);
			this.progressBg.getParent().addChild(this.progress);
			this.progress.setPosition(cc.p(this.progressBg.x, this.progressBg.y));
			this.progress.scale = retina;
			this.progress.percentage = hero.expNow / hero.expMax * 100;
			
			var red_head = new cc.Sprite("#pro_red_head.png");
			this.progressBg.getParent().addChild(red_head, 2);
			red_head.scaleX = hero.expNow / hero.expNow;
			red_head.attr({
				x:this.progressBg.x - this.progressBg.getContentSize().width/2 + (this.progressBg.getContentSize().width  * hero.expNow / hero.expMax),
				y:this.progressBg.y,
				anchorX:1,
				anchorY:0.5
			});
			if (hero.expNow / hero.expMax >= 1) {
				red_head.visible = false;
			}
			
			// 技能
			var skills = HeroModule.getHeroSkills(uid);
			this.skills = skills;
			var m = bAwake ? 4 : 3;
			for (var i = 0; i < m; i++) {
				var dic = skills[i + ""];
				if (dic) {
					var skillId = dic.skillId;
					var level = dic.level;
					var skill = SkillModule.getSkill(skillId, level, hero.heroId);
					var rank = dic.rank || skill.rank;
					//this["skillText" + (i + 1)].visible = false;
					this["skill_name_bg" + (i + 1)].visible = true;
					var skillName = this["skillName" + (i + 1)]
					skillName.visible = true;
					skillName.setString(skill.name);
					var skillBg = this["skill" + (i + 1)];
					skillBg.setNormalImage(new cc.Sprite("#frame_" + rank + ".png"));
					skillBg.setSelectedImage(new cc.Sprite("#frame_" + rank + ".png"));
					var skillSp = this["skillBg" + (i + 1)];
					skillSp.setTexture(common.getIconById(skill.skillId));
					skillSp.visible = true;
					if (rank === 4) {
						olAni.addPartical({
							plist:"images/purpleEquip.plist", 
							node:skillSp,
							pos:cc.p(skillSp.getContentSize().width / 2, skillSp.getContentSize().height / 2),
							z:100,
							tag:777,
							scale:2 / 0.35 / retina,
							isFollow:true
						});
					} else if (rank === 5) {
						olAni.addPartical({
							plist:"images/goldEquip.plist", 
							node:skillSp,
							pos:cc.p(skillSp.getContentSize().width / 2, skillSp.getContentSize().height / 2),
							z:100,
							tag:777,
							scale:2 / 0.35 / retina,
							isFollow:true
						});
					}
					var skillLevelBg = this["skillLevelBg" + (i + 1)];
					skillLevelBg.visible = true;
					skillLevelBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + rank + ".png"));
					var skillLevel = this["skillLevel" + (i + 1)];
					skillLevel.visible = true;
					skillLevel.setString(String(level));
				} 
			}
			// 装备
			var equips = HeroModule.getHeroEquip(uid);
			this.equips = equips;
			if (equips) {
				var m = bAwake ? 4 : 3;
				for (var i = 0; i < m; i++) {
					var eid = equips[i + ""];
					if (eid) {
						var equip = EquipModule.getEquip(eid);
						var cfg = equip.cfg;
						this["equip_name_bg" + (i + 1)].visible = true;
						var equipName = this["equipName" + (i + 1)];
						equipName.visible = true;
						equipName.setString(cfg.name);
						var equipBtn = this["equip" + (i + 1)];
						equipBtn.setNormalImage(new cc.Sprite("#frame_" + equip.rank + ".png"));
						equipBtn.setSelectedImage(new cc.Sprite("#frame_" + equip.rank + ".png"));
						var equipSprite = this["equipSprite" + i];
						equipSprite.setTexture(common.getIconById(equip.equipId));
						equipSprite.visible = true;
						var equipLevelBg = this["equipLevelBg" + (i + 1)];
						equipLevelBg.visible = true;
						equipLevelBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + equip.rank + ".png"));
						equipLevelBg.attr({
							anchorX:0.5,
							anchorY:0.5
						});
						if (equip.rank === 4) {
							olAni.addPartical({
								plist:"images/purpleEquip.plist", 
								node:equipSprite,
								pos:cc.p(equipSprite.getContentSize().width / 2, equipSprite.getContentSize().height / 2),
								z:100,
								tag:777,
								scale:2 / 0.35 / retina,
								isFollow:true
							});
						} else if (equip.rank === 5) {
							olAni.addPartical({
								plist:"images/goldEquip.plist", 
								node:equipSprite,
								pos:cc.p(equipSprite.getContentSize().width / 2, equipSprite.getContentSize().height / 2),
								z:100,
								tag:777,
								scale:2 / 0.35 / retina,
								isFollow:true
							});
						}
						var equipLevel = this["equipLevel" + (i + 1)];
						equipLevel.visible = true;
						equipLevel.setString(equip.level);
					}
				}
			}
//			this.shadowItem.visible = FunctionModule.bOpen("shadow");
//			this.shadowSpr.visible = FunctionModule.bOpen("shadow");  
			this.shadowItem.visible = false;
			this.shadowSpr.visible = false;  
		} else {
			for (var i = 0; i < 3; i++) {
				this["skill" + (i + 1)].setEnabled(false);
				this["equip" + (i + 1)].setEnabled(false);
			}
			this["bodyItem"].visible = false;
			this["shadowItem"].visible = false;
		}
	},
	onEnter:function(){
		this._super();
	},
	updateLabel:function(key, value){
		this[key].visible = true;
		this[key].setString(value);
	},
	heroItemClick:function(){
		if (this.uid) {
			cc.director.getRunningScene().addChild(new HeroDetail(this.uid, 5, this.hero.rank, {exit:function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : this.page});
			}.bind(this)}));
		} else {
			postNotifcation(NOTI.GOTO_ONFORM, {page:this.page, type:0});
		}
	},
	skillItemClick:function(sender){
		var pos = sender.getTag() - 1;
		var skill = this.skills[pos + ""];
		if (skill) {
			cc.director.getRunningScene().addChild(new SkillDetail(SkillModule.getSkillInfo(skill), 0, {exit : function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : this.page});
			}.bind(this), hid:this.uid, pos:pos}));
		} else {
			postNotifcation(NOTI.GOTO_SKILL_CHANGE, {hid:this.uid, pos:pos, exit:function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : this.page});
			}.bind(this)});
		}
	},
	equipItemClick:function(sender){
		var pos = sender.getTag() - 1;
		var equip = this.equips[pos + ""];
		if (equip) {
			cc.director.getRunningScene().addChild(new EquipDetail(EquipModule.getEquip(equip), 0, {exit : function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : this.page});
			}.bind(this), hid:this.uid, pos:pos}));
		} else {
			postNotifcation(NOTI.GOTO_EQUIP_CHANGE, {hid:this.uid, pos:pos, exit:function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : this.page});
			}.bind(this)});
		}
	},
	bodyItemClick:function(){
		trace("bodyItemClick");
	},
	shadowItemClick:function(){
		postNotifcation(NOTI.TEAM_CHANGE_TYPE, {type : 1});
	}
	
	
});