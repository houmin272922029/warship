var logindata = {
	uid : null,
	sid : null,
	token : null,
	serverList : null,
	selectedServer : null,
	serverTime : null,
	serverCode : null,
	
	setUid:function(uid){
		this.uid = uid;
	},
	setSid:function(sid){
		this.sid = sid;
	},
	setToken:function(token){
		this.token = token;
	},
	setServerList:function(serverList){
		this.serverList = serverList;
	},
	setSelectedServer:function(selected){
		this.selectedServer = selected;
	},
	setServerTime:function(serverTime){
		this.serverTime = serverTime;
	},
	setServerCode:function(serverCode) {
		this.serverCode = serverCode;
	},
	
}