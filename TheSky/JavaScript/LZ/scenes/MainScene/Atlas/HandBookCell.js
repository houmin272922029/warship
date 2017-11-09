var HandBookCell = cc.Node.extend({
	ctor:function(dic, type){
		this._super();
		this.type = type;
		this.dic = dic;
		if (this.type == "hero") {
			cc.BuilderReader.registerController("HandBookCellOwner", {
			});
			this.node = cc.BuilderReader.load(ccbi_res.HandBookCell_ccbi, this);
		} else if (this.type == "equip" || this.type == "skill") {
			cc.BuilderReader.registerController("HandBookCellOwner", {
			});
			this.node = cc.BuilderReader.load(ccbi_res.HandBookEquipCell_ccbi, this);
		}
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.menu.setSwallowTouches(false);

		for (i = 0; i < 5; i++) {
			if (this.type == "hero") {
				var hero;
				hero = dic[i + ""];
				if (hero) {
					this["nameLabel" + (i + 1)].setString(hero.name);
					this["rankSprite" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(hero.id)));
					if (hero.rank) {
						this["avatarBtn" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ hero.rank +".png"));
						this["avatarBtn" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ hero.rank +".png"));
						this["rank_bg_" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + hero.rank +".png"));
					}
					if (HeroModule.isHaveHero(hero.id)) {
					} else {
						this["rankSprite" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_lock.png"));
						this["rankSprite" + (i + 1)].setScale(0.91);
						this["avatarBtn" + (i + 1)].setEnabled(false);
					}
				} else {
					this["nameLabel" + (i + 1)].visible = false;
					this["rankSprite" + (i + 1)].visible = false;
					this["avatarBtn" + (i + 1)].visible = false;
					this["rank_bg_" + (i + 1)].visible = false;
				}
			} else if (this.type == "equip") {
				var equip;
				equip = dic[i + ""];
				if (equip) {
					this["nameLabel" + (i + 1)].setString(equip.name);
					this["rankSprite" + (i + 1)].setTexture(common.getIconById(equip.id));
					if (equip.rank) {
						this["avatarBtn" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ equip.rank +".png"));
						this["avatarBtn" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ equip.rank +".png"));
						this["rank_bg_" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + equip.rank +".png"));
					}
					if (EquipModule.isHaveEquip(equip.id)) {
					}else {
						this["rankSprite" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_lock.png"));
						this["rankSprite" + (i + 1)].setScale(0.91);
						this["avatarBtn" + (i + 1)].setEnabled(false);
					}
				} else {
					this["nameLabel" + (i + 1)].visible = false;
					this["rankSprite" + (i + 1)].visible = false;
					this["avatarBtn" + (i + 1)].visible = false;
					this["rank_bg_" + (i + 1)].visible = false;
				}
			} else if (this.type == "skill") {
				var skill;
				skill = dic[i + ""];
				if (skill) {
					this["nameLabel" + (i + 1)].setString(skill.name);
					this["rankSprite" + (i + 1)].setTexture(common.getIconById(skill.id));
					if (skill.rank) {
						this["avatarBtn" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ skill.rank +".png"));
						this["avatarBtn" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ skill.rank +".png"));
						this["rank_bg_" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + skill.rank +".png"));
					}
					
					if (SkillModule.getSkillCount(skill.id) == 0) {
						this["rankSprite" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_lock.png"));
						this["rankSprite" + (i + 1)].setScale(0.91);
						this["avatarBtn" + (i + 1)].setEnabled(false);
					}
				} else {
					this["nameLabel" + (i + 1)].visible = false;
					this["rankSprite" + (i + 1)].visible = false;
					this["avatarBtn" + (i + 1)].visible = false;
					this["rank_bg_" + (i + 1)].visible = false;
				}
			}
		}
	},
	heroBookBtnAction:function(sender){
		if (this.type == "hero") {
			var hero = this.dic[sender.getTag()];
			cc.director.getRunningScene().addChild(new HeroDetail(hero.id, 4));
		} else if (this.type == "equip"){
			var equip = this.dic[sender.getTag()];
			cc.director.getRunningScene().addChild(new EquipDetail(equip.id, 3));
		} else if (this.type == "skill") {
			var skill = this.dic[sender.getTag()];
			cc.director.getRunningScene().addChild(new SkillDetail(skill.id, 2));
			
		}
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});