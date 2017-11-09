var SkillDetail = cc.Layer.extend({
	TYPE:{
		team:0,  	// 阵容 左 突破 右 更换 属性：当前属性
		skills:1,	// 列表 左 突破 右 关闭 属性：当前属性
		show:1,		// 展示 左 无 右 关闭 属性：当前属性
		handbook:2, // 图鉴 左 无 右 关闭 属性：配置
	},
	ctor:function(skill, type, param){
		this._super();
		this.skill = skill;
		this.type = type;
		this.param = param
		if (this.type === this.TYPE.handbook) {
			if (typeof skill === "string") {
				this.skill = SkillModule.getSkillConfigInfo(skill);
			}
		} else {
			if (typeof skill === "string") {
				this.skill = SkillModule.getSkillInfo(skill);
			}
		}
		this.initLayer();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("SkillDetailOwner", {
		});
		cc.BuilderReader.registerController("SkillDetailCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.SkillDetail_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.refresh();
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	refresh:function(){
		this.skillInfoName.enableStroke(cc.color(32, 18, 9), 2);
		var self = this;
		var updateLabel = function(key, string){
			self[key].setString(string);
			self[key].visible = true;
		};
		var cfg = this.skill.cfg;
		updateLabel("nameLabel", cfg.name);
		if (this.type === this.TYPE.handbook) {
			this.levelBg.visible = false;
		}
		updateLabel("levelLabel", this.skill.level);
		updateLabel("despLabel", cfg.intro1);
		this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + cfg.rank + "_icon.png"));
		//this.itemBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("itemInfoBg_2_" + cfg.rank + ".png"));
		this.icon.setTexture(common.getIconById(cfg.icon));
		this.icon.visible = true;
		for (var k in this.skill.attr) {
			var v = this.skill.attr[k];
			this.attrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
		}
		this.attrLabel.setString(SkillModule.getSkillAttrStringWithValue(SkillModule.getSkillAttr(this.skill)));
		this.addLabel.setString(SkillModule.getSkillAttrDiscribe(this.skill, 0));
		switch (this.type) {
		case this.TYPE.show:
		case this.TYPE.handbook:
			this.leftItem.visible = false;
			this.leftText.visible = false;
			this.rightText.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("guanbi_text.png"));
			break;
		case this.TYPE.skills:
			this.rightText.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("guanbi_text.png"));
			break;
		case this.TYPE.team:
			var pos = this.param.pos;
			if (pos === 0) {
				this.rightText.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("guanbi_text.png"));
			}
			break;
		default:
			break;
		}
	},
	leftItemClick:function(){
		if (this.type === this.TYPE.team || this.type === this.TYPE.skills) {
			var exit = NOTI.GOTO_SKILLS;
			if (this.param && this.param.exit) {
				exit = this.param.exit;
			}
			postNotifcation(NOTI.GOTO_SKILL_BREAK, {skill:this.skill, exit:exit});
			this.closeItemClick();
		}
	},
	rightItemClick:function(){
		if (this.type === this.TYPE.team) {
			var hid = this.param.hid;
			var pos = this.param.pos;
			var idx = FormModule.getIndexWithUid(hid);
			if (pos === 0) {
				this.closeItemClick();
			} else {
				postNotifcation(NOTI.GOTO_SKILL_CHANGE, {hid:hid, pos:pos, sid:this.skill.id, exit:function(){
					postNotifcation(NOTI.GOTO_TEAM, {page : idx});
				}});
				this.closeItemClick();
			}
		} else {
			this.closeItemClick();
		}
	}
});