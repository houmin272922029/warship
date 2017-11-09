var SkillBreakResult = cc.Layer.extend({
	ctor:function(oriSkill, type, exit) {
		this._super();
		var skill = SkillModule.getSkillInfo(oriSkill.id);
		this.skill = skill;
		this.exit = exit;
		cc.BuilderReader.registerController("BreakSkillResultOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.SkillBreakResult_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.nameLabel.setString(skill.cfg.name);
		this.rankFrame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + skill.rank + ".png"));
		this.levelLabel.setString(skill.cfg.name);
		this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + skill.rank + "_icon.png"));
		this.head_bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + skill.rank + ".png"));
		this.avatarIcon.visible = true;
		this.avatarIcon.setTexture(common.getIconById(skill.skillId));
		if (skill.rank === 4) {
			olAni.addPartical({
				plist:"images/purpleEquip.plist", 
				node:this.avatarIcon,
				pos:cc.p(this.avatarIcon.getContentSize().width / 2, this.avatarIcon.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		} else if (skill.rank === 5) {
			olAni.addPartical({
				plist:"images/goldEquip.plist", 
				node:this.avatarIcon,
				pos:cc.p(this.avatarIcon.getContentSize().width / 2, this.avatarIcon.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		}
		for (var k in skill.attr) {
			var v = skill.attr[k];
			var oriv = oriSkill.attr[k];
			this.attrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this.nowAttrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this.nextAttrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			
			this.attrLabel.setString(SkillModule.getSkillAttrStringWithValue(v));
			this.nowAttrValueLabel.setString(SkillModule.getSkillAttrStringWithValue(oriv));
			this.nextAttrValueLabel.setString(SkillModule.getSkillAttrStringWithValue(v));
		}
		
		
		this.nowLevelLabel.setString("LV:" + oriSkill.level);
		this.nextLevelLabel.setString("LV:" + skill.level);
		
		if (type === 1) {
			this.resultSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("tupochenggong_text.png"));
		} else {
			this.resultSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("tuposhibai_text.png"));
		}
	},
	ontExitBtnTaped:function(){
		if (typeof this.exit === "string") {
			postNotifcation(this.exit);
		} else {
			this.exit.apply();
		}
	},
	onGoonBtnClicked:function(){
		postNotifcation(NOTI.GOTO_SKILL_BREAK, {skill:this.skill, dogfood:[], exit:this.exit});
	}
});