var LoginScene = cc.Scene.extend({
	onEnter:function(){
		this._super();
		var layer = new LoginLayer();
		this.addChild(layer);
	}
});

var LoginLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		this.initLayer();
	},
	onEnter:function(){
		this._super();
		SoundUtil.playMusic("audio/login" + ".mp3", true);
		ssoFactory.getInstance().login(this.pfLoginSucc.bind(this));
		addObserver(NOTI.STARTGAME_NOTI, "startGame", this);
		addObserver(NOTI.GOTO_GUIDE, "startGuide", this);
		addObserver(NOTI.GET_SETTING, "getSetting", this);
		addObserver(NOTI.SHOW_UPDATE_LAYER, "showUpdate", this);
		addObserver(NOTI.GET_SERVERLIST, "getServerList", this);
		addObserver(NOTI.REGISTER, "register", this);
		addObserver(NOTI.SHOW_MAIN, "showMain", this);
		addObserver(NOTI.LOGOUTACTION, "logoutAction", this);
		addObserver(NOTI.SHOW_UPADTE, "showUpdate", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.STARTGAME_NOTI, "startGame", this);
		removeObserver(NOTI.GET_SETTING, "getSetting", this);
		removeObserver(NOTI.SHOW_UPDATE_LAYER, "showUpdate", this);
		removeObserver(NOTI.GET_SERVERLIST, "getServerList", this);
		removeObserver(NOTI.REGISTER, "register", this);
		removeObserver(NOTI.SHOW_MAIN, "showMain", this);
		removeObserver(NOTI.GOTO_GUIDE, "startGuide", this);
		removeObserver(NOTI.LOGOUTACTION, "logoutAction", this);
		removeObserver(NOTI.SHOW_UPADTE, "showUpdate", this);
	},
	initLayer:function(){
		this.node = cc.BuilderReader.load(ccbi_res.LoginView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		var durs = [120, 60, 25, 20, 17, 19, 18];
		for ( var i in durs) {
			this.cloudAni(Number(i) + 1, durs[i]);
		}
		this.showMain();
	},
	/**
	 * 模拟平台登陆
	 */
	pfLoginSucc:function(){
		cc.log("pfLoginSucc");
		postNotifcation(NOTI.PLATFORM_LOGIN_SUCC);
	},
	/**
	 * 模拟游戏登陆
	 */
	loginSucc:function(){
		cc.log("login game succ");
	},
	cloudAni:function(index, duration){
		var cloud = this["cloud_" + index];
		var width = cloud.getContentSize().width;
		var offset = width + cc.winSize.width / retina;
		offset = cloud.x > 0 ? -offset : offset;
		function resetCloud(){
			var width = cloud.getContentSize().width;
			var ori = width + cc.winSize.width / retina;
			ori = cloud.x > 0 ? -ori : ori;
			cloud.x += ori;
		}
		cloud.runAction(cc.repeatForever(cc.sequence(cc.moveBy(duration, cc.p(offset, 0)), cc.callFunc(resetCloud))));
	},
	showMain:function(dic){
		this.clearContentLayer();
		var contentLayer = this["contentLayer"];
		var sid = dic ? dic.sid : null;
		var layer = new LoginMain(sid);
		contentLayer.addChild(layer);
	},
	getServerList:function(){
		this.clearContentLayer();
		var serverLayer = this["contentLayer"];
		var layer = new LoginServerView();
		serverLayer.addChild(layer);
	},
	showUpdate:function(){
		this.clearContentLayer();
		var contentLayer = this["contentLayer"];
		var layer = new LoginUpdate();
		contentLayer.addChild(layer);
	},
	clearContentLayer:function(){
		this["contentLayer"].removeAllChildren(true);
	},
	startGame:function(data){
		cc.director.runScene(new MainScene());
	},
	startGuide:function(){
		cc.director.runScene(new GuideScene());
	},
	getSetting:function(){
		LoginModule.getSetting(function(dic){
			config.fromDic(dic.info);
//			postNotifcation(NOTI.GOTO_GUIDE);
			this.runAction(cc.sequence(
				cc.delayTime(0.5),
				cc.callFunc(function(){
					LoginModule.login(NOTI.STARTGAME_NOTI, function(dic){
						if (dic.code === 1207){
							LoginModule.register([logindata.uid, logindata.token], "lll", "hero_000419", "01", function(dic){
								postNotifcation(NOTI.GET_SETTING);
							}.bind(this),function(dic){
								if (dic.code === 1209) {
									postNotifcation(NOTI.GET_SETTING);
								}
							})
						}
					});
				})
			));
		}.bind(this));
	},
	showUpdate:function(){
		this.clearContentLayer();
		var contentLayer = this["contentLayer"];
		var layer = new LoginUpdate();
		contentLayer.addChild(layer);
	},
//	logoutAction:function() {
//		if (common.getSSOType()){
//			this.showMain();
//		} else{
//			cc.director.runScene(new LoginScene());
//		}
//	},
	
});

cc.BuilderReader.registerController("LoginLayerOwner", {

});