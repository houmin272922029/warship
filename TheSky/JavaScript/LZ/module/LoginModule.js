var LoginModule = {
	getLogindataUid:function(){
		return logindata.uid;
	},
		/**
		 * 登陆
		 * 
		 * @param succ 可以是通知的key也可以是回调方法
		 * @param fail
		 * @returns {String}
		 */
	selected:null,

	setLoginData:function(uid, token){
		logindata.uid = uid;
		logindata.token = token;
	},
	/**
	 * 登陆
	 * 
	 * @param succ 可以是通知的key也可以是回调方法
	 * @param fail
	 * @returns {String}
	 */
	login:function(succ, fail){
		var params = [[logindata.uid, logindata.token]]
		dispatcher.doAction(ACTION.LOGIN, params, succ, fail);
	},
	getSelectedServerList:function(){
		var serverList = logindata.serverList;
		var serverCode = logindata.serverCode;
		var list = [];
		for (var i = 0; i < getJsonLength(serverCode); i++) {
			var id = serverCode[i + ""];
			var s = serverList[id];
			list.push(s);
		}
		return list;
	},
	getSelectedServer:function(){
		var serverList = logindata.serverList;
		if (!serverList) {
			return null;
		}
		if (this.selected) {
			return serverList[this.selected];
		}
		var serverCode = logindata.serverCode;
		if (getJsonLength(serverCode) === 0) {
			var list = this.getServersList();
			return list[0];
		}
		return serverList[serverCode["0"]];
	},
	getServersList:function(){
		var serverList = logindata.serverList;
		var list = [];
		for (var k in serverList) {
			list.push(serverList[k]);
		}
		list.sort(function(a, b){
			return a.sort < b.sort ? -1 : 1;
		});
		return list;
	},
	setSelectedServer:function(id){
		this.selected = id;
		postNotifcation(NOTI.SHOW_MAIN, {sid: this.selected});
	},
	getSetting:function(succ, fail){
		dispatcher.doAction(ACTION.GETSETTING, [], succ, fail);
	},
	getServerList:function(version, userGuid, succ, fail){
		dispatcher.doAction(ACTION.GETSERVERLIST, [version, userGuid], succ, fail);
	},
	register:function(registerParamArray, name, heroId, flag, succ, fail){
		dispatcher.doAction(ACTION.REGISTER, [registerParamArray, name, heroId, flag], succ, fail);
	},
	/**
	 * 渠道版本信息
	 * @param version 大版本号
	 * @param uid 账号系统id
	 * @param succ
	 * @param fail
	 */
	doGetVersion:function(version, uid, succ, fail){
		dispatcher.doAction(ACTION.GETVERSION, [version, uid], succ, fail);
	}
}