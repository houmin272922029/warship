var ShadowBoxTableCell = cc.Node.extend({
	ctor:function(shadow){
		this._super();
		this.shadow = shadow;
		cc.BuilderReader.registerController("ShadowBoxTableCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShadowBoxTableCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.updateBtn.visible = true;
		var cfg = this.shadow.cfg;
		this.nameLabel.setString(cfg.name);
		this.levelTTF.setString(this.shadow.level);
		var rankLayer = this.rankLayer;
//		olAni.playFrameAnimation("yingzi_" + cfg.icon + "_", rankLayer,
//				cc.p(rankLayer.getContentSize().width / 2, rankLayer.getContentSize().height / 2), 1, 4,
//				common.getColorByRank(this.shadow.rank));
		if (cfg.level) {
			var frame = common.getDisplayFrame(cfg.property[0]);
			this.attrIcon1.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(frame));
			this.attrLable1.setString(cfg.level[0]);
			this.attrIcon1.visible = true;
			this.attrLable1.visible = true;
			if (cfg.level[1]) {
				var frame = common.getDisplayFrame(cfg.property[1]);
				this.attrIcon2.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(frame));
				this.attrLable2.setString(cfg.level[1]);
				this.attrIcon2.visible = true;
				this.attrLable2.visible = true;
			} 
		} 
		var shadowId = this.shadow.id;
		if (this.shadow.owner) {
			var name = this.shadow.owner[shadowId].name;
			this.ownerLabel.setString("装备于" + name);
		} else {
			this.ownerLabel.visible = false;
		}
		this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + this.shadow.rank + "_icon.png"));
		this.levelLabel.setString(this.shadow.level);
	},
	updateBtnAction:function(){
		postNotifcation(NOTI.GOTO_SHADOW_UPDATE, {shadow:this.shadow});
	},
	onAvatarTaped:function(){
		cc.director.getRunningScene().addChild(new ShadowDetail(this.shadow, 1));
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	}
});