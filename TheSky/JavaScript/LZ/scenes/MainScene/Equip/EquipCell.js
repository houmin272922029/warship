var EquipCell = cc.Node.extend({
	ctor:function(equip, type){
		this._super();
		this.equip = equip;
		this.type = type;
		cc.BuilderReader.registerController("EquipmentsTableCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.EquipCell_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		if (equip.owner) {
			this.ownerLabel.setString(equip.owner.name);
		} else {
			this.ownerLabel.visible = false;
		}
		//this.stageSprite.visible = Number(equip.stage) > 0;
		//this.stageLabel.setString((equip.stage || 0) + common.LocalizedString(" 阶"));
		if (equip.cfg.nature && equip.cfg.nature > 0) {
			this.runeSprite.visible = true;
			this.runeSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("nature_" + equip.cfg.nature + ".png"));
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
		this.avatarSprite.visible = true;
		this.avatarSprite.setTexture(common.getIconById(equip.cfg.icon));
		this.updateTitle.enableStroke(cc.color(32, 18, 9), 2);
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
		this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + equip.rank + ".png"));
		this.avatarBtn.setNormalImage(new cc.Sprite("#frame_" + equip.rank + ".png"));
		this.avatarBtn.setSelectedImage(new cc.Sprite("#frame_" + equip.rank + ".png"));
		this.nameLabel.setString(equip.cfg.name || "");
		this.nameLabel.enableShadow(cc.color.GRAY, cc.size(1, -1));
		this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + equip.rank + "_icon.png"));
		this.levelLabel.setString(equip.level);
		for (var k in equip.attr) {
			this.attrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this.attrLabel.setString(equip.attr[k]);
		}
		this.valueLabel.setString(equip.price);
	},
	onAvatarBtnTap:function(){
		cc.director.getRunningScene().addChild(new EquipDetail(this.equip, 1));
	},
	updateBtnTaped:function(){
		postNotifcation(NOTI.GOTO_EQUIPUPDATE, {eid:this.equip.id, type:1, exit:function(){
			postNotifcation(NOTI.GOTO_EQUIPS, {type:this.type});
		}.bind(this)});
	},
});