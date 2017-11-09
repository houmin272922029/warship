var UnionGuide = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("UnionOuterLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionGuide_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
	},
	createUnionFun:function(){
		cc.director.getRunningScene().addChild(new UnionCreate());
	},
	joinUnionFun:function(){
		UnionModule.doQuery(null, function(dic){
			traceTable("query succ", dic);
			var list = dic.info.leagueList;
			cc.director.getRunningScene().addChild(new UnionJoin(list));
			postNotifcation(NOTI.UNION_ML_VISIBLE, {visible:false});
		}, function(dic){
			traceTable("query fail", dic);
		});
	},
});