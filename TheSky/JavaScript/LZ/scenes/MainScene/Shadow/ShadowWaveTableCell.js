var ShadowWaveTableCell = cc.Node.extend({
	ctor:function(shadow){
		this._super();
		this.shadow = shadow;
		cc.BuilderReader.registerController("ShadowWaveTableCell", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShadowWaveTableCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.nameLabel.setString(this.shadow.cfg.name);
		var rankSprite = this.rankSprite;
		traceTable(this.shadow.cfg)
//		olAni.playFrameAnimation("yingzi_" + this.shadow.cfg.icon + "_", rankSprite,
//				cc.p(rankSprite.getContentSize().width / 2, rankSprite.getContentSize().height / 2), 1, 4,
//				common.getColorByRank(this.shadow.cfg.rank));
		var attr = this.shadow.attr;
		if (attr) {
			var i = 0;
			for ( var k in attr) {
				i = i + 1;
				if (k) {
					var frame = common.getDisplayFrame(k);
					this["attrIcon" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(frame));
					this["attrLabel" + i].setString(attr[k]);
					this["attrIcon" + i].visible = true;
					this["attrLabel" + i].visible = true;
				}
			}
		}
		this.priceLabel.setString(this.shadow.cfg.coin);
		this.rankIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + this.shadow.cfg.rank + "_icon.png"));
	},
	onAvatarTaped:function(){
		//TODO 展示影子信息
	},
	chargeBtnTaped:function(){
		ShadowModule.doOnShadowBuy([this.shadow.id],this.onShadowBuySucc.bind(this));
	},
	onShadowBuySucc:function(){
		postNotifcation(NOTI.SHADOW_WAVE_REFRESH)
		trace("成功购买影子");
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	}
});