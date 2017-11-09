var VipBagCell = cc.Node.extend({
	ctor:function(dic, idx){
		this._super();
		this.dic = dic;
		this.ID =dic. ID;
		this.limitVIP = dic.limitVIP;
		cc.BuilderReader.registerController("GiftBagTableCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.GiftBagTableCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.nameLabel.setString(dic.Name);
		this.despLabel.setString(dic.Descript);
		this.showPrice.setString(dic.Ordin_price);
		this.priceLabel.setString(dic.Espec_price);
		this.timeLabel.visible = false;
		this.tipLabel.setString(common.LocalizedString("limitbuy",dic.canBuyNum));
		this.avatarSprite.visible = true;
		
	},
	buyBtnTaped:function(ID) {
		var vipLv = PlayerModule.getVipLevel();
		if (vipLv >= this.limitVIP) {
			ShopModule.doBuy(this.ID,this.BuySucc.bind(this));
		} else {
			var text = common.LocalizedString("船长，只有达到VIP" + this.limitVIP + "才能购买此礼包，充值可享受贵族待遇，快去充值吧");
			var cb = new ConfirmBox({info:text, type:0, 
				confirm:function(){
					postNotifcation(NOTI.GOTO_CHONGZHI);
				}.bind(this),
				close:function(){
				}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		}
	},
	BuySucc:function(dic) {
		trace("购买成功");
	},
	onAvatarBtnTaped:function (ID) {
		var cb = new ItemDetailInfoView({info:ID, type:0, close:function(){
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});