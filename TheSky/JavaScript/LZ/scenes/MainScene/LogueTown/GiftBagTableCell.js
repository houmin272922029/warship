var GiftBagTableCell = cc.Node.extend({
	ctor:function(item, idx){
		this._super();
		this.item = item;
		this.id = item.id;
		cc.BuilderReader.registerController("GiftBagTableCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.GiftBagTableCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.nameLabel.setString(item.name);
		this.despLabel.setString(item.desp);
		traceTable("herodata--", item);
		this["rankBg"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + item.rank + ".png"));
		this.rankFrame.setNormalImage(cc.Sprite("#frame_" + item.rank + ".png"));
		this.rankFrame.setSelectedImage(cc.Sprite("#frame_" + item.rank + ".png"));
		this.avatarSprite.visible = true;
		this.avatarSprite.setTexture(common.getIconById(item.icon));
		this.tipLabel.visible = false;
		this.buyVipCard.setTag(idx);
//		// TODO没配置
		var idx = this.buyVipCard.getTag() + 1;
		var index = (idx >= 10) ? idx : ("0" + idx);
		var price = config.shop_vip["vip_0" + index].price.diamond;
		this.priceLabel.setString(price);
		var showPrice = config.shop_vip["vip_0" + index].show.diamond
		this.showPrice.setString(showPrice);
	},
	buyBtnTaped:function(id, succ, fail) {
		var vipLv = PlayerModule.getVipLevel();
		var idx = this.buyVipCard.getTag() + 1;
		var index = (idx >= 10) ? idx : ("0" + idx);
		var vipLevel = config.shop_vip["vip_0" + (index)].vipLevel;
		var amount = config.shop_vip["vip_0" + index].amount;
		if (vipLv >= vipLevel) {
			ShopModule.doBuyBags(this.id, amount, this.BuySucc.bind(this));
		} else {
			var text = common.LocalizedString("船长，只有达到VIP" + vipLevel + "才能购买此礼包，充值可享受贵族待遇，快去充值吧");
			var cb = new ConfirmBox({info:text, type:0, close:function(){}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		}
	},
	BuySucc:function(item) {
		var item = this.id;
		var cb = new ItemDetailInfoView({info:item, type:0, close:function(){
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	onAvatarBtnTaped:function (item) {
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});