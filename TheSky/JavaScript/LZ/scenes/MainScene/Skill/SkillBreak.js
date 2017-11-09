var SkillBreak = cc.Layer.extend({
	dogfood : [],
	/**
	 * 
	 * @param skill
	 * @param 退出的通知
	 */
	ctor:function(skill, dogfood, exit){
		this._super();
		this.dogfood = dogfood || [];
		this.skill = (typeof skill === "string") ? SkillModule.getSkillInfo(skill) : skill;
		this.exit = exit || NOTI.GOTO_SKILLS;
		cc.BuilderReader.registerController("BreakSkillLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.SkillBreak_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.updateFingerState();
		this.updateStageContent();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	updateFingerState:function(){
		var finger = this.breakFinger;
		finger.visible = false;
		for (var i = 1; i <= 5; i++) {
			if (i > this.dogfood.length) {
				var btn = this["selectBtn" + i];
				finger.x = btn.x;
				finger.y = btn.y + 70;
				finger.visible = true;
				break;
			}
		}
		if (this.dogfood.length > 0) {
			var allexp = 0;
			for (var k in this.dogfood) {
				var ds = this.dogfood[k];
				allexp += SkillModule.getSkillFoodExp(ds.cfg.rank, ds.level);
			}
			var need = SkillModule.getSkillUpdateExp(this.skill.cfg.rank, this.skill.level);
			this.updateTopLabel(true, allexp / need);
		} else {
			this.updateTopLabel(false);
		}
	},
	updateStageContent:function(){
		for (var i = 1; i <= 5; i++) {
			var stageIcon = this["stageIcon" + i];
			var avatarIcon = this["avatarIcon" + i];
			var avatarIconbg = this["avatarIconbg" + i];
			var skill = this.dogfood[i - 1];
			if (skill) {
				stageIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + skill.rank + ".png"));
				avatarIconbg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + skill.rank + ".png"));
				avatarIcon.setTexture(common.getIconById(skill.skillId));
				avatarIcon.visible = true;
				if (skill.rank === 4) {
					olAni.addPartical({
						plist:"images/purpleEquip.plist", 
						node:avatarIcon,
						pos:cc.p(avatarIcon.getContentSize().width / 2, avatarIcon.getContentSize().height / 2),
						scale:2 / 0.35 / retina,
						isFollow:true
					});
				} else if (skill.rank === 5) {
					olAni.addPartical({
						plist:"images/goldEquip.plist", 
						node:avatarIcon,
						pos:cc.p(avatarIcon.getContentSize().width / 2, avatarIcon.getContentSize().height / 2),
						scale:2 / 0.35 / retina,
						isFollow:true
					});
				}
			} else {
				stageIcon.visible = false;
				avatarIcon.visible = false;
				avatarIconbg.visible = false;
			}
		}
		var skill = this.skill;
		this.nameLabel.setString(skill.cfg.name);
		this.topFrame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + skill.rank + ".png"));
		this.levelSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + skill.rank + ".png"));
		this.levelLabel.setString(skill.level);
		this.topAvatarBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + skill.rank + ".png"));
		this.topAvatar.setTexture(common.getIconById(skill.skillId));
		this.topAvatar.visible = true;
		if (skill.rank === 4) {
			olAni.addPartical({
				plist:"images/purpleEquip.plist", 
				node:this.topAvatar,
				pos:cc.p(this.topAvatar.getContentSize().width / 2, this.topAvatar.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		} else if (skill.rank === 5) {
			olAni.addPartical({
				plist:"images/goldEquip.plist", 
				node:this.topAvatar,
				pos:cc.p(this.topAvatar.getContentSize().width / 2, this.topAvatar.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		}
	},
	/**
	 * 更新顶部描述
	 * @param flag [false 只显示一个提示] 
	 * @param args
	 */
	updateTopLabel:function(flag, per) {
		this.topTipInfo.visible = false;
		this.successRet.visible = false;
		if (flag) {
			this.successRet.visible = true;
			this.successRet.setString(common.LocalizedString("成功概率：%s%%", Math.min(Math.floor(per * 100), 100)));
		} else {
			this.topTipInfo.visible = true;
		}
	},
	onSelectBtnTaped:function(sender){
		var dogfood = {};
		for (var k in this.dogfood) {
			var skill = this.dogfood[k];
			dogfood[skill.id] = true;
		}
		postNotifcation(NOTI.GOTO_SKILL_BREAK_SELECT, {skill:this.skill, dogfood:dogfood});
	},
	onBackClicked:function(){
		if (typeof this.exit === "string") {
			postNotifcation(this.exit);
		} else {
			this.exit.apply();
		}
	},
	onFareWellClicked:function(){
		if (this.dogfood.length > 0) {
			var dogfood = [];
			for (var k in this.dogfood) {
				var skill = this.dogfood[k];
				dogfood.push(skill.id);
			}
			SkillModule.doBreak(this.skill.id, dogfood, function(dic){
				this.dogfood = [];
				var isUp = dic.info.isUp;
				if (isUp && isUp === 1) {
					// TODO 技能突破动画
					postNotifcation(NOTI.GOTO_SKILL_BREAK_RESULT, {oriSkill:this.skill, type:isUp, exit:this.exit});
				} else {
					postNotifcation(NOTI.GOTO_SKILL_BREAK_RESULT, {oriSkill:this.skill, type:isUp, exit:this.exit});
				}
			}.bind(this), function(dic){
				traceTable("break skill fail", dic);
			}.bind(this));
		} else {
			common.showTipText(common.LocalizedString("请选择奥义材料"));
		}
	}
	
});