var ShopBuySomePopUp = cc.Layer.extend({
	/**
	 * 
	 * @param param
	 * type 0 确定取消， 1只有关闭
	 */
	ctor:function(param){
		this._super();
		this.param = param;
		var info = param.info;
		var type = param.type || 0;
		this.confirm = param.confirm;
		this.close = param.close;
		this.exit = param.exit;
		this.amount = 1;
		this.price = info.price;
		this.id = info.id;
		
		cc.BuilderReader.registerController("ShopBuySomeOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShopBuySomePopUp_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true);
		this.addBtn1.visible = false;
		this.addBtn2.visible = false;
		
		var nameLabel = common.LocalizedString("您购买" + info.name + "的数量");
		this.simpleText.setString(nameLabel);

		if (type === 1) {
			this.confirmBtn.visible = false;
			this.confirmText.visible = false;
			var size = this.cardContent.getContentSize();
			this.cancelBtn.x = size.width / 2;
			this.closeText.x = size.width / 2;
		}
	},
	closeItemClick:function(){
		if (this.close) {
			this.close();
		}
		this.removeSelf();

	},
	confirmBtnAction:function(id, amount, succ, fail){
		if (this.confirm) {
			this.confirm();
		}
//		this.removeSelf();
		ShopModule.doBuyItems(this.id, this.amount, this.buySucc.bind(this), succ, fail);
		
	},
	buySucc:function() {
		this.removeSelf();
		var ItemId = this.id;
		var cb = new ItemDetailInfoView({info:ItemId, type:0, close:function(){
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	ExitBtnAction:function() {
		if (this.exit) {
			this.exit();
		}
		this.removeSelf();
	},
	addBtnAction:function(sender) {
		var tag = sender.getTag();
		if (tag == 0) {
			this.amount = this.amount < 10 ? 1 : this.amount - 10;
			if (this.amount == 1) {
				this.addBtn1.visible = false;
				this.addBtn2.visible = false;
			}
			var price = this.price * this.amount;
			this.countLabel.setString(this.amount);
			this.priceLabel.setString(price);
		}else if(tag == 1){
			this.amount = this.amount > 1 ? this.amount - 1 : 1 ;
			if(this.amount == 1){
				this.addBtn1.visible = false;
				this.addBtn2.visible = false;
			}
			var price = this.price * this.amount;
			this.countLabel.setString(this.amount);
			this.priceLabel.setString(price);
		}else if(tag == 2){
			this.amount += 1;
			this.addBtn1.visible = true;
			this.addBtn2.visible = true;
			var price = this.price * this.amount;
			this.countLabel.setString(this.amount);
			this.priceLabel.setString(price);
		}else if(tag == 3){
			this.amount += 10;
			this.addBtn1.visible = true;
			this.addBtn2.visible = true;
			var price = this.price * this.amount;
			this.countLabel.setString(this.amount);
			this.priceLabel.setString(price);
		}
		
	},
	removeSelf:function(){
		this.removeFromParent(true);
	},
	

});