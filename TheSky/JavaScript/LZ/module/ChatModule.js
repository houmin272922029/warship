var ChatModule = {
	getPublicMessage:function() {
		var pbMessage = chatdata.publicMessage;
		traceTable("----chat-----", chatdata.publicMessage)
		return pbMessage;
	},
	getLeagueMessage:function() {
		var LeMessage = chatdata.leagueMessage;
		return LeMessage;
	},
	getTrumepeMessage:function() {
		var TrumepeMessage = chatdata.trumepeMessage;
		return TrumepeMessage;
	},
	
	
	/*
	 * 	 * ************************** 网络 **************************
	 */
	//全服聊天
	doSendAllserver:function(message, succ, fail) {
		dispatcher.doAction(ACTION.SEND_MESSAGE, [message], succ, fail);
	},
	
	//联盟聊天
	doSendLeaguemessage:function(message, succ, fail) {
		dispatcher.doAction(ACTION.SEND_LEAGUE_MESSAGE, [message], succ, fail);
	},
	
	//喇叭
	doSendHornmessage:function(message, succ, fail) {
		dispatcher.doAction(ACTION.SEND_HORN_MESSAGE, [message], succ, fail);
	},
	
	doGetPublicMessage:function(time, succ, fail) {
		dispatcher.doAction(ACTION.GET_PUBLIC_MESSAGE, [time], succ, fail);
	},
	
	doGetLeagueMessage:function(time, succ, fail) {
		dispatcher.doAction(ACTION.GET_LEAGUE_MESSAGE, [time], succ, fail);
	},
	
	doGetHornMessage:function(time, succ, fail) {
		dispatcher.doAction(ACTION.GET_HORN_MESSAGE, [time], succ, fail);
	},
}