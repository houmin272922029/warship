var chatdata = {
		publicMessage:{},
		leagueMessage:{},
		trumepeMessage:{},
		fromDic:function(dic) {
			if (!dic || !dic.info) {
				return;
			}
			
			this.publicMessage = dic.info.publicMessage;
			this.leagueMessage = dic.info.leagueMessage;
			this.trumepeMessage = dic.info.trumepeMessage;
		},
		addDataObserver:function(){
			addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
		},
}
chatdata.addDataObserver();