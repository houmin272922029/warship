var UnionLayer = cc.Layer.extend({
	TYPE:{
		home:0, 	// 公会首页
		manage:1, 	// 公会管理
		member:2, 	// 公会成员
		rank:3, 	// 公会排行
		msg:4,		// 公会动态
		build:5,	// 公会建设
		candy:6,	// 分发糖果
		donate:7,	// 公会捐献
		shop:8,		// 公会商店
	},
	/**
	 * 公会主界面，用于控制公会子页面
	 * 
	 * @param type {Number|Null} 进入某功能
	 */
	ctor:function(type){
		this._super();
		this.type = type || 0;
		cc.BuilderReader.registerController("UnionMainViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.UnionMain_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.UNION_CHANGESTATE, "changeStateNoti", this);
		addObserver(NOTI.UNION_ML_VISIBLE, "mainLayerVisible", this);
		addObserver(NOTI.UNION_MAIN_REFRESH, "refresh", this);
		this.checkUnionState();
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.UNION_CHANGESTATE, "changeStateNoti", this);
		removeObserver(NOTI.UNION_ML_VISIBLE, "mainLayerVisible", this);
		removeObserver(NOTI.UNION_MAIN_REFRESH, "refresh", this);
	},
	refresh:function(){
		var data = UnionModule.getUnionData();
		var info = data.leagueInfo;
		var player = data.leaguePlayer;
		this.UnionBulletinTTF.setString(info.notice);
		this.RoleNameTTF.setString(PlayerModule.getName());
		this.RoleLevelTTF.setString("LV:" + PlayerModule.getLevel());
		this.RoleGandyTTF.setString(player.sweetCount);
		this.UnionLevelTTF.setString(info.level);
		this.UnionNameTTF.setString(info.name);
		this.UnionMemberCountTTF.setString(info.memberCount + "/" + UnionModule.getUnionPlayerMax(info.level));
		this.UnionExpDetailTTF.setString(info.expNow + "/" + UnionModule.getUnionExpMax(info.level));
		this.UnionCandyTTF.setString(info.depot.sweetCount);
	},
	/**
	 * 检查公会状态
	 */
	checkUnionState:function(){
		if (!UnionModule.bJoinUnion()) {
			this.mainLayer.visible = false;
			this.changeLayer(new UnionGuide());
			return;
		}
		this.mainLayer.visible = true;
		this.titleLayer.visible = true;
		this.refresh();
		switch (this.type) {
		case this.TYPE.home:
			this.changeLayer(new UnionHome());
			break;
		case this.TYPE.manage:
			this.changeLayer(new UnionManage());
			this.titleLayer.visible = false;
			break;
		case this.TYPE.member:
			this.changeLayer(new UnionMember());
			this.titleLayer.visible = false;
			break;
		case this.TYPE.rank:
			this.changeLayer(new UnionRank());
			this.titleLayer.visible = false;
			break;
		case this.TYPE.msg:
			UnionModule.doGetMessage(null, function(dic){
				var messages = dic.info.leagueMessage;
				cc.director.getRunningScene().addChild(new UnionMessage(messages));
			})
			break;
		case this.TYPE.build:
			this.changeLayer(new UnionBuild());
			this.titleLayer.visible = false;
			break;
		case this.TYPE.candy:
			this.changeLayer(new UnionCandy());
			this.titleLayer.visible = false;
			break;
		case this.TYPE.donate:
			UnionModule.doGetContributionInfo(function(dic){
				cc.director.getRunningScene().addChild(new UnionDonate(dic.info.contributionMessages));
			});
			break;
		case this.TYPE.shop:
			this.changeLayer(new UnionShop());
			this.titleLayer.visible = false;
			break;
		default:
			break;
		}
	},
	changeLayer:function(layer){
		this.UnionCententLayer.removeAllChildren(true);
		this.UnionCententLayer.visible = true;
		this.UnionCententLayer.addChild(layer);
	},
	changeStateNoti:function(dic){
		this.type = dic.state;
		this.checkUnionState();
	},
	mainLayerVisible:function(dic){
		this.UnionCententLayer.visible = dic.visible;
	}
});