var UnionHome = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("UnionInnerLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionHome_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
	},
	/**
	 * 管理
	 */
	unionManageFun:function(){
		if (!UnionModule.haveAuthority([1, 2])) {
			common.showTipText(common.LocalizedString("ERR_2708"));
			return;
		}
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:1});
	},
	/**
	 * 成员
	 */
	unionMemberFun:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:2});
	},
	/**
	 * 排行
	 */
	unionRankFun:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:3});
	},
	/**
	 * 动态
	 */
	unionInformationFun:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:4});
	},
	/**
	 * 建设
	 */
	unionBuildFun:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:5});
	},
	/**
	 * 捐献
	 */
	unionActivityFun:function(){
		if (!UnionModule.bOpen("UNION_DONATE")) {
			common.showTipText(common.LocalizedString("union_needLevel", UnionModule.openLevel("UNION_DONATE")));
			return;
		}
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:7});
	},
	/**
	 * 商店
	 */
	unionShopFun:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:8});
	}
});