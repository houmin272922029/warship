var ShopRechargeCell = cc.Node.extend({
	ctor:function(idx){
		this._super();
		cc.BuilderReader.registerController("ShopRechargeTopCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShopRechargeTopCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function() {
//		var itemId = item.itemId;
//		var res = common.getResource(itemId);
//		var name = config.cashShop_items.name;
//		for (i = 1;i <= 3; i++){
////			this["nameLabel1"].setString(name);
//		}
//		if (res.iconType === 0) {
//			this["avatarSprite0" + i].setTexture(res.icon);
//		} else {
////			this["littleSprite" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(itemId)));
//		}
	}
});