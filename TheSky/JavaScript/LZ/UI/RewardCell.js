var RewardCell = cc.Node.extend({
	ctor:function(data){
		this._super();
		this.data = data;
		cc.BuilderReader.registerController("GetSomeRewardCellOwner", {
		})
		var node = cc.BuilderReader.load(ccbi_res.GetSomeRewardCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		var id = data.id;
		var type = data.type;
		var amount = data.amount;
		this.headSprite.setLocalZOrder(-1);
		this.itemSprite.setLocalZOrder(-1);
		this.rank_bg.setLocalZOrder(-2);
		this.countLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.itemName.enableStroke(cc.color(32, 18, 9), 2);
		if (type === "shadows") {
			var cfg = ShadowModule.getShadowConfig(id);
			this.itemFrame.visible = false;
			this.shadowFrame.visible = true;
			this.rank_bg.visible = false;
			this.itemName.setString(cfg.name);
			this.countLabel.setString(amount);
			cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("shadow.plist"));
			olAni.playFrameAnimation("yingzi_" + cfg.icon + "_", this.srankLayer, 
					cc.p(this.srankLayer.getContentSize().width / 2, this.srankLayer.getContentSize().height / 2),
					1, 4, common.getColorByRank(cfg.rank));
		} else {
			trace(id);
			var res = common.getResource(id);
			traceTable("res====", res)
			this.itemFrame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + res.rank + ".png"));
			this.rank_bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + res.rank + ".png"));
			if (type === "heroSouls" || type === "heros") {
				this.headSprite.visible = true;
				this.headSprite.setSpriteFrame(HeroModule.getHeroHeadById(id));
				this.soulIcon.visible = type !== "heros";
			} else {
				this.itemSprite.visible = true;
				this.itemSprite.setTexture(res.icon);
				if (type === "equipShard") {
					this.chipIcon.visible = true;
				}
			} 
			this.itemName.setString(res.name);
			this.countLabel.setString(amount);
			if (res.rank === 4) {
				olAni.addPartical({
					plist:"images/purpleEquip.plist", 
					node:this.rank_bg1,
					pos:cc.p(this.rank_bg1.getContentSize().width / 2, this.rank_bg1.getContentSize().height / 2),
					scale:2 / 0.35 / retina,
					isFollow:true
				});
			} else if (res.rank === 5) {
				olAni.addPartical({
					plist:"images/goldEquip.plist", 
					node:this.rank_bg1,
					pos:cc.p(this.rank_bg1.getContentSize().width / 2, this.rank_bg1.getContentSize().height / 2),
					scale:2 / 0.35 / retina,
					isFollow:true
				});
			}
		}
	}
});