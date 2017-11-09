var UnionQuit = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("unionQuitOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionQuit_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.cardContent, this.closeItemClick.bind(this));
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	confirmBtnAction:function(){
		var data = UnionModule.getUnionData();
		var info = data.leagueInfo;
		var text;
		if (UnionModule.haveAuthority([3])) {
			text = common.LocalizedString("确定解散联盟【%s】？", info.name);
		} else {
			text = common.LocalizedString("确定退出联盟【%s】？", info.name);
		}
		var cb = new ConfirmBox({info:text, confirm:function(){
			UnionModule.doQuit(function(dic){
				postNotifcation(NOTI.UNION_CHANGESTATE, {state:0});
				this.closeItemClick();
			}.bind(this));
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	}
});