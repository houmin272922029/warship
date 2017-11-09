var uniondata = {
	union:null,
	fromDic:function(dic){
		if(!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if(!data.league) {
			return;
		}
		this.union = data.league;
		postNotifcation(NOTI.UNION_MAIN_REFRESH);
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", uniondata);
	}
}
uniondata.addDataObserver();
