var ShadowSelectCell = cc.Node.extend({
	ctor:function(shadow){
		this._super();
		cc.BuilderReader.registerController("ShadowChangeCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.ShadowChangeCell_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.shadow = shadow;
		this.nameLabel.setString(shadow.cfg.name);
		this.rankSpr.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + shadow.shadow.rank + "_icon.png"));
		this.avatarSprite.visible = true;
		olAni.playFrameAnimation("yingzi_" + shadow.cfg.icon + "_", this.avatarSprite,
				cc.p(this.avatarSprite.getContentSize().width / 2, this.avatarSprite.getContentSize().height / 2), 1, 4,
				common.getColorByRank(shadow.shadow.rank));
		if (shadow.owner) {
			this.status.setString(shadow.owner.name);
			this.status.visible = true;
		} else {
			this.status.visible = false;
		}
		this.level.setString(shadow.shadow.level);
		this.level.enableShadow(cc.color.BLACK, cc.size(2, -2));
		var i = 1;
		for (var k in shadow.attr) {
			if (k) {
				this["bufSpr" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
				this["bufLabel" + i].setString(shadow.attr[k]);
				this["bufSpr" + i].visible = true;
				this["bufLabel" + i].visible = true;
			}
			i++;
		}
	},
	selectCell:function(){
		this.bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("huobanCellBg_sel.png"));
	},
	unSelectCell:function(){
		this.bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("huobanCellBg.png"));
	},
	frameBtn:function(){
		cc.director.getRunningScene().addChild(new ShadowDetail(this.shadow, 1));
	},
});