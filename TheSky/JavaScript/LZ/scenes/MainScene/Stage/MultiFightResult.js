var MultiFightResult = cc.Layer.extend({
	ctor:function(result, gain, pay){
		this._super();
		
		this.result = result;
		this.gain = gain;
		this.pay = pay;

		cc.BuilderReader.registerController("SweepInfoOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.MultiFightResult_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.addResult();
	},
	closeItemClick:function(){
//		common.gain(this.gain);
//		common.pay(this.pay);
		postNotifcation(NOTI.STAGE_REFRESH);
		this.removeFromParent(true);
	},
	addResult:function(){
		var result = this.result;
		var size = this.contentLayer.getContentSize();
		this.lv = new ccui.ListView();
		this.lv.setDirection(ccui.ScrollView.DIR_VERTICAL);
		this.lv.setTouchEnabled(true);
		this.lv.setBounceEnabled(true);
		this.lv.setContentSize(size);
		this.lv.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this.contentLayer.addChild(this.lv);
		for (var i = 0; i < getJsonLength(result); i++) {
			var dic = result[i + ""];
			var node = new MultiFightResultCell(dic, i + 1);
			var size = node.getContentSize();
			var item = new ccui.Layout();
			item.setTouchEnabled(true);
			item.setContentSize(size);
			item.addChild(node);
			node.attr({
				x:size.width / 2,
				y:size.height / 2
			});
			this.lv.pushBackCustomItem(item);
		}
	}

});