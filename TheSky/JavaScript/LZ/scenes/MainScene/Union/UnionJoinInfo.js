var UnionJoinInfo = cc.Layer.extend({
	ctor:function(data, exit){
		this._super();
		this.data = data;
		this.exit = exit;
		cc.BuilderReader.registerController("UnionJoinInfoLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionJoinInfo_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeTipFun.bind(this));
	},
	closeTipFun:function(){
		if (this.exit) {
			this.exit.apply();
		}
		this.removeFromParent(true);
	},
	/**
	 * 会长信息查看
	 */
	unionCreatorFormFun:function(){
		
	},
	/**
	 * 查看详情
	 */
	unionInfoFun:function(){
		UnionModule.doGetUnionInfo(this.data.id, function(dic){
			var info = dic.info.queryLeagueInfo;
			cc.director.getRunningScene().addChild(new UnionRankInfo(info));
		}.bind(this));
	},
	/**
	 * 加入公会
	 */
	unionApplyFun:function(){
		UnionModule.doJoin(this.data.id, function(dic){
			common.showTipText(common.LocalizedString("union_joinAccess"));
			this.closeTipFun();
		}.bind(this));
	},
});