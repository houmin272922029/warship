var SelectSMPLayer = cc.Layer.extend({
	selected:-1,
	ctor:function(func){
		this._super();
		this.func = func;
		cc.BuilderReader.registerController("SelectSMPOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.SelectSMP_ccbi, this);
		if(this.node != null){
			this.addChild(this.node);
		}
		var infoBg = this.infoBg;
		common.swallowLayer(this, true, infoBg, this.closeItemClick.bind(this));
		this.refreshUI();
	},
	refreshUI:function(){
		var items = ["item_009", "item_008"];
		for (var i in items) {
			var idx = Number(i) + 1;
			var item = items[i];
			var cfg = ItemModule.getItemConfig(item);
			var amount = ItemModule.getItemCount(item);
			this["useBtn" + idx].visible = amount > 0;
			this["buyBtn" + idx].visible = amount <= 0;
			this["useLabel" + idx].visible = amount > 0;
			this["buyLabel" + idx].visible = amount <= 0;
			this["priceLabel" + idx].visible = amount <= 0;
			this["price" + idx].visible = amount <= 0;
			this["amountLabel" + idx].visible = amount > 0;
			this["amount" + idx].visible = amount > 0;
			this["gold" + idx].visible = amount <= 0;
			if (amount <= 0) {
				this["price" + idx].setString(ShopModule.getItemPrice(item));
			} else {
				this["amount" + idx].setString(amount);
			}
			this["name" + idx].setString(cfg.name);
			this["desp" + idx].setString(cfg.desp);
		}
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	useClick:function(sender){
		var tag = sender.getTag();
		this.func(2 - tag);
		this.removeFromParent(true);
	},
	buyClick:function(sender){
		var tag = sender.getTag();
		
	},
});