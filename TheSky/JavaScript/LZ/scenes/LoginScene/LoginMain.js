var LoginMain = cc.Layer.extend({
	ctor:function(sid){
		this._super();
		this.initLayer();
		this.sid = sid;
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.PLATFORM_LOGIN_SUCC, "pfLoginSucc", this);
		this.refreshServerList();
		this.refreshUid();
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.PLATFORM_LOGIN_SUCC, "pfLoginSucc", this);
	},
	initLayer:function(){
		this.node = cc.BuilderReader.load(ccbi_res.LoginMain_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.version.enableShadow(cc.color.BLACK, cc.size(2, -2));
		this.version.setString(common.getVersion() + "(" + smallVersion + ")");
		this.menu.enabled = true;
	},
	playClick:function(sender){
		cc.log("playClick");
//		cc.director.runScene(new fsmScene());
		var server = LoginModule.getSelectedServer();
		if (!server) {
			// TODO 选择服务器
			common.showTipText(common.LocalizedString("login_select_server"));
			return;
		}
		if (ssoType === "testSSO") {
			postNotifcation(NOTI.GET_SETTING);
			//TODO 是否走新手引导
		} else {
			postNotifcation(NOTI.SHOW_UPADTE);
		}
	},
	loginItemClick:function(sender){
		cc.log("loginItemClick");
	},
	serverItemClick:function(sender){
		cc.log("serverItemClick");
		postNotifcation(NOTI.GET_SERVERLIST);
	},
	registerLogin:function(){
		
	},
	refreshServerList:function(){
		var s = LoginModule.getSelectedServer();
		if (s) {
			this.serverLabel.setString(s.serverName);
			this.serverLabel.visible = true;
		} else {
			this.serverLabel.visible = false;
		}
	},
	refreshUid:function(){
		if (logindata.uid) {
			this.accountIcon.visible = false;
			this.accountLabel.setString(logindata.uid);
			this.accountLabel.visible = true;
		}
	},
	pfLoginSucc:function(){
		this.refreshUid();
		LoginModule.getServerList(common.getVersion(), logindata.uid, function(dic){
			logindata.setServerList(dic.info.serverList);
			logindata.setServerCode(dic.info.serverCode);
			if (dic.info.serverCode === null){
				logindata.setSelectedServer(dic.info.serverCode);
			} else{
				logindata.setSelectedServer(LoginModule.getSelectedServer());
			}
			this.refreshServerList();
			this.menu.enabled = true;
		}.bind(this), function(dic) {
			traceTable("server list fail", dic);
			this.menu.enabled = true;
		}.bind(this));
	},
	

});

cc.BuilderReader.registerController("LoginMainOwner", {
	
});