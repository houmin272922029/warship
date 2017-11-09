var ssoGlobal = {
	ssoLoginCallback:function(){
		ssoFactory.getInstance().loginCallBack(arguments);
	},
	ssoLogoutCallback:function(){
		ssoFactory.getInstance().logoutCallBack();
	},
	ssoPaySucc:function(){
		ssoFactory.getInstance().paySucc(arguments);
	},
	ssoPayUnsucc:function() {
		ssoFactory.getInstance().payUnsucc(arguments);
	},
	ssoPayCancle:function() {
		ssoFactory.getInstance().payCancle(arguments);
	},
	sdkClose:function() {
		ssoFactory.getInstance().sdkClose(arguments);
	},
	FbshareSucc:function() {
		ssoFactory.getInstance().FbshareSucc(arguments);
	},
	FbshareUnSucc:function() {
		ssoFactory.getInstance().FbshareUnSucc(arguments);
	},
	FbshareCancle:function() {
		ssoFactory.getInstance().FbshareCancle(arguments);
	},
	getgiftSucc:function() {
		ssoFactory.getInstance().getgiftSucc(arguments);
	},
	InviteSucc:function() {
		ssoFactory.getInstance().InviteSucc(arguments);
	},
	InviteUnSucc:function() {
		ssoFactory.getInstance().InviteUnSucc(arguments);
	},	
 }

