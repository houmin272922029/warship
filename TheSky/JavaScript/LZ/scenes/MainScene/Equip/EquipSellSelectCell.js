var EquipSellSelectCell = cc.Node.extend({
	ctor:function(equip){
		this._super();
		this.equip = equip;
		cc.BuilderReader.registerController("EquipSellSelectCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.EquipSellSelectCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.setContentSize(this.node.getContentSize());
		
		var cfg = equip.cfg;
		this.nameLabel.setString(cfg.name || "");
		this.nameLabel.enableShadow(cc.color.GRAY, cc.size(1, -1));
		var owner = equip.owner;
		if (!owner) {
			this.ownerLabel.visible = false;
		} else {
			this.ownerLabel.setString(owner.name);
			this.ownerName = owner.name;
		}
//		this.stageSprite.visible = equip.stage > 0;
//		this.stageLabel.setString(equip.stage + common.LocalizedString(" 阶"));
		
		if (cfg.nature && cfg.nature > 0) {
			this.runeSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("nature_" + cfg.nature + ".png"));
			this.runeSprite.visible = true;
		} else {
			this.runeSprite.visible = false;
		}
		if (equip.composeLevel) {
			this.composeLevel.visible = equip.composeLevel != 0;
		}
		if (equip.composeLevel === -1) {
			this.composeLevel.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("m_level_max.png"));
		} else if (equip.composeLevel > 0) {
			this.composeLevel.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("m_level_" + equip.composeLevel + ".png"))
		}
		this.levelLabel.setString(equip.level);
		this.rankFrame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + equip.rank + ".png"));
		this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + equip.rank + ".png"));
		this.avatarSprite.visible = true;
		this.avatarSprite.setTexture(common.getIconById(equip.cfg.icon));
		if (equip.rank === 4) {
			olAni.addPartical({
				plist:"images/purpleEquip.plist", 
				node:this.avatarSprite,
				pos:cc.p(this.avatarSprite.getContentSize().width / 2, this.avatarSprite.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		} else if (equip.rank === 5) {
			olAni.addPartical({
				plist:"images/goldEquip.plist", 
				node:this.avatarSprite,
				pos:cc.p(this.avatarSprite.getContentSize().width / 2, this.avatarSprite.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		}
		
		this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + equip.rank + "_icon.png"));
		for (var k in equip.attr) {
			this.attrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this.attrLabel.setString(equip.attr[k]);
		}
		this.valueLabel.setString(equip.price);
	},
	selectItem:function(){
		if (this.ownerName) {
			common.ShowText("该装备已经被" + this.ownerName + "穿戴");
		}
		this.stampSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("duihao_1_btn.png"));
	},
	unSelectItem:function(){
		this.stampSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("duihao_0_btn.png"));
	}
});