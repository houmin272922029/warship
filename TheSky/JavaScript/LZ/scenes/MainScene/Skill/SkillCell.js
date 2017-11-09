var SkillCell = cc.Node.extend({
	ctor:function(skill){
		this._super();
		this.skill = skill;
		cc.BuilderReader.registerController("SkillViewCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.SkillTableViewCell_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		
		this.nameLabel.setString(skill.cfg.name);
		this.nameLabel.enableStroke(cc.color(32, 18, 9), 2);
		
		this.levelLabel.setString(skill.level);
		
//		this.lvLabel.setString("LV");
//		this.lvLabel.enableShadow(cc.color.BLACK, cc.size(2, -2));
		
		if (skill.owner) {
			this.ownerLabel.setString(skill.owner.name);
		} else {
			this.ownerLabel.visible = false;
		}
		
		this.valueLabel.setString(SkillModule.getSkillPrice(skill.skillId, skill.level));
		
		this.itemBtn.setNormalImage(new cc.Sprite("#frame_" + skill.rank + ".png"));
		this.itemBtn.setSelectedImage(new cc.Sprite("#frame_" + skill.rank + ".png"));
		
		var res = common.getResource(skill.skillId);
		if (res.icon) {
			this.icon.setTexture(res.icon);
			this.icon.visible = true;
			if (skill.rank === 4) {
				olAni.addPartical({
					plist:"images/purpleEquip.plist", 
					node:this.icon,
					pos:cc.p(this.icon.getContentSize().width / 2, this.icon.getContentSize().height / 2),
					scale:2 / 0.35 / retina,
					isFollow:true
				});
			} else if (skill.rank === 5) {
				olAni.addPartical({
					plist:"images/goldEquip.plist", 
					node:this.icon,
					pos:cc.p(this.icon.getContentSize().width / 2, this.icon.getContentSize().height / 2),
					scale:2 / 0.35 / retina,
					isFollow:true
				});
			}
		}
		this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + skill.rank + "_icon.png"));
		for (var k in skill.attr) {
			this.attrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
		}
		this.attrLabel.setString(SkillModule.getSkillAttrDiscribe(skill.id, 1));
		if (skill.level >= SkillModule.getSkillBreakMax()) {
			this.refineBtn.visible = false;
			this.refineText.visible = false;
		}
	},
	onSkillTaped:function(){
		cc.director.getRunningScene().addChild(new SkillDetail(this.skill, 1, {exit : NOTI.GOTO_SKILLS}));
	},
	breakBtnTaped:function(){
		postNotifcation(NOTI.GOTO_SKILL_BREAK, {skill:this.skill, exit:NOTI.GOTO_SKILLS});
	}
	
});