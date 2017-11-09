var UnionDonate = cc.Layer.extend({
	ctor:function(info){
		this._super();
		this.info = info;
		
		cc.BuilderReader.registerController("unionJuanXianOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionDonate_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true);
		this.refreshMsg();
	},
	refreshMsg:function(){
		for (var i = 0; i < 3; i++) {
			var idx = i + 1;
			var dic = this.info[i + ""];
			if (!dic) {
				this["gainLabel" + idx].visible = false;
			} else {
				this["gainLabel" + idx].setString(dic.message);
			}
		}
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	donateClick:function(sender){
		var tag = sender.getTag();
		UnionModule.doContribute(tag, function(dic){
			this.info = dic.info.contributionMessages;
			this.refreshMsg();
			var text = tag === 1 ? common.LocalizedString("联盟经验增加100") : common.LocalizedString("联盟经验增加300");
			common.showTipText(text);
		}.bind(this));
	}
});