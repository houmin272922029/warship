var UnionShopPreCell = cc.Node.extend({
	ctor:function(array){
		this._super();
		cc.BuilderReader.registerController("UnionGiftPreviewCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionShopPreCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		
		for (var i = 0; i < 4; i++) {
			var idx = i + 1;
			var rankSprite = this["rankFrame" + idx];
			if (array[i]) {
				var item = UnionModule.getShopItem(array[i].itemKey);
				traceTable("item", item);
				var cfg = item.cfg;
				this["countLabel" + idx].setString(item.count);
				if (item.type === "shadow") {
					rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("s_frame.png"));
					rankSprite.x += 3;
					rankSprite.y -= 5;
					cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("shadow.plist"));
					var shadowContent = this["shadowContent" + idx];
					olAni.playFrameAnimation("yingzi_" + cfg.icon + "_", shadowContent, 
							cc.p(shadowContent.getContentSize().width / 2, shadowContent.getContentSize().height / 2),
							1, 4, ShadowModule.getColorByRank(cfg.rank));
				} else {
					rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + cfg.rank + ".png"));
					if (item.type === "soul") {
						var smallAvatarSprite = this["smallAvatarSprite" + idx];
						smallAvatarSprite.visible = true;
						smallAvatarSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(item.id)));
					} else {
						var bigAvatarSprite = this["bigAvatarSprite" + idx];
						bigAvatarSprite.visible = true;
						bigAvatarSprite.setTexture(common.getIconById(cfg.icon));
						if (item.type === "shard") {
							this["chipIcon" + idx].visible = true;
						}
					}
				}
			} else {
				rankSprite.visible = false;
			}
		}
	}
});