var announcedata = {
		notice:{},
		fromDic:function(dic) {
			if (!dic || !dic.info) {
				return;
			}
			if(!dic.info.notice){
				return;
			}
			this.notice = dic.info.notice;

		},
		addDataObserver:function(){
			addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
		},
}
announcedata.addDataObserver();