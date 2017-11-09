var UnionContribution = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("UnionContributionPopUpOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionContribution_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		for (var i = 1; i <= 3; i++) {
			this["despLabel" + i].setString(UnionModule.getContributionInfo(i).state);
		}
		
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	onContributeTaped:function(sender){
		var tag = sender.getTag();
		if (tag > 1) {
			var info = UnionModule.getContributionInfo(tag);
			if (info.cost > PlayerModule.getGold()) {
				var text = common.LocalizedString("qingjiao_goldEnough")
				var cb = new ConfirmBox({info:text, confirm:function(){
					// TODO 充值
				}.bind(this)});
				cc.director.getRunningScene().addChild(cb);
				return;
			}
		}
		UnionModule.doSweetContribute(tag, function(dic){
			common.showTipText(common.LocalizedString("捐献成功"));
		});
	}
});