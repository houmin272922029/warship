var SkillSelectCell = cc.Node.extend({
	ctor:function(skill){
		this._super();
		cc.BuilderReader.registerController("SkillSelectCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.SkillSelectCell_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		this.nameLabel.setString(skill.cfg.name);
		this.frameIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + skill.rank + ".png"));
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
		this.valueLabel.setString(SkillModule.getSkillPrice(skill.skillId, skill.level));
		if (skill.owner) {
			this.equipOnLabel.setString(skill.owner.name);
			this.equipOnLabel.visible = true;
		} else {
			this.equipOnLabel.visible = false;
		}
		this.levelLabel.setString(skill.level);
//		this.lvLabel.setString("LV");
//		this.lvLabel.enableShadow(cc.color.BLACK, cc.size(2, -2));
		
		this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + skill.rank + "_icon.png"));
		for (var k in skill.attr) {
			this.attrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
		}
		this.attrLabel.setString(SkillModule.getSkillAttrDiscribe(skill.id, 1));
	},
	selectCell:function(){
		this.stampSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("duihao_1_btn.png"));
		//this.cellBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("huobanCellBg_sel.png"));
	},
	unSelectCell:function(){
		this.stampSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("duihao_0_btn.png"));
		//this.cellBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("huobanCellBg.png"));
	}
});