function tgameCnSSO(){

}

tgameCnSSO.prototype = {
		login:function(func){
			this.loginSucc = func;
			var obj = jsb.reflection.callStaticMethod("TGAME", "TGAMELogin");
		},

		loginCallBack:function(args){
			logindata.setUid(args[0]);
			logindata.setToken(args[1]);
			if (this.loginSucc) {
				this.loginSucc.apply();
				this.loginSucc = null;
			}
		},

		logOut:function(func) {
			var obj = jsb.reflection.callStaticMethod("TGAME", 
			"TGAMELogout");
		},
		logoutCallBack:function() {
			if (playerdata.id) {
				playerdata.resetAllData();
				cc.director.runScene(new LoginScene());
			} else {
				cc.director.runScene(new LoginScene());
			}
		},
		userCenter:function() {
			var obj = jsb.reflection.callStaticMethod("TGAME", 
			"TGAMEUserCenter");
		},
		getUserName:function() {
			var obj = jsb.reflection.callStaticMethod("TGAME", 
			"getAccountName")
		},
		paySucc:function(args){
			dispatcher.doAction(ACTION.FLUSH_PLAYER_DATA, [], function(){
				postNotifcation(NOTI.GOLD_REFRESH);
			}.bind(this));
		},
		payUnsucc:function() {
//			var errorCode = "";
//			ShowText(errorCode);
		},
//		initGameInfoRoleId:function(){
//			jsb.reflection.callStaticMethod("TGAME","initGameInfoRoleId:roleName:serverCode:serverName:gameName:")
//		},
		getAccountName:function() {
			jsb.reflection.callStaticMethod("TGAME","getAccountName");
		},
		

}