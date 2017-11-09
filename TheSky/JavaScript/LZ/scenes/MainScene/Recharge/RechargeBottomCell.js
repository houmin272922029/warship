var RechargeBottomCell = cc.Layer.extend({
	ctor:function(idx){
		this._super();
		this.index = idx;
		cc.BuilderReader.registerController("ShopRechageBottomCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShopRechargeBottomCell_ccbi, this);
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
		var shopData =  ShopModule.getCashShopdata();
		var cellData = shopData["" + (this.index ) ];
		if (cellData) {
			var price = cellData.priceShow + "=" + cellData.name;
			this.label1.setString(price);
			this.label2.setString(cellData.desp);
		}
	},
	onRechargeBtnTap:function() {
		var shopData =  ShopModule.getCashShopdata();
		var cellData = shopData["" + (this.index ) ];
		jsb.reflection.callStaticMethod("TGAME", "TGAMEPayment:buyNum:realPrice:productName:extInfo:", 
				cellData.itemId, "1", cellData.price + "", cellData.name, LoginModule.getSelectedServer().id + "|" + PlayerModule.getPlayerId() + "|" + PCLId);
	},
});