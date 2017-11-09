var TrainShadowCell = cc.Node.extend({
	ctor:function(shadows){
		this._super();
		this.shadows = shadows;
		cc.BuilderReader.registerController("TrainShadowCellOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.TrainShadowCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		for (var i = 0; i < this.shadows.length; i++) {
			var item = this.shadows[i];
			if (item) {
				this["nameLabel" + (i + 1)].setString(item.cfg.name);
				var sprite = this["rankSprite" + (i + 1)];
				if (item.cfg.icon) {
					olAni.playFrameAnimation("yingzi_" + item.cfg.icon + "_", sprite,
							cc.p(sprite.getContentSize().width / 2, sprite.getContentSize().height / 2), 1, 4,
							common.getColorByRank(this.shadows[i].rank));
				}
				this["avatarBtn" + (i + 1)].setTag(i + 1);
				this["levelTTF" + (i + 1)].setString(item.level);
			}
		}
		for (var i = this.shadows.length ; i < 5; i++) {
			this["nameLabel" + (i+1) ].visible = false;
			this["rankSprite" + (i+1) ].visible = false;
			this["avatarBtn" + (i+1) ].visible = false;
			this["avatar" + (i+1) ].visible = false;
		}
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	}
});