var EquipRefineResult = cc.Layer.extend({
	ctor:function(eid, stage){
		this._super();

		cc.BuilderReader.registerController("EquipRefineResultOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.EquipRefineResult_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
		
		var equip = EquipModule.getEquip(eid);
		var cfg = equip.cfg;
		
		this.frameSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + equip.rank + ".png"));
		this.avatarSprite.visible = true;
		this.avatarSprite.setTexture(common.getIconById(cfg.icon));
		this.nameLabel.setString(cfg.name);
		this.stageLabel.setString(common.LocalizedString("%s阶", equip.stage));
		
		for (var k in equip.attr) {
			for (var i = 1; i <= 3; i++) {
				this["attrSprite" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			}
			this.attrLabel3.setString("+" + equip.attr[k]);
		}
		this.attrLabel1.setString("+" + Math.floor(equip.stage * cfg.refine * 10));
		trace(equip.stage + " " + stage);
		var attr = EquipModule.getEquipAttr(equip.equipId, equip.level, stage);
		for (var k in attr) {
			this.attrLabel2.setString("+" + attr[k]);
		}
		
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	}
});