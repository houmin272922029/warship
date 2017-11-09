var adventuredata = {
		adventures:{},
		fromDic:function(dic){
			if (!dic || !dic.info) {
				return;
			}
			var data = dic.info;
			if (!data.adventure) {
				return;
			}
			this.adventures = data.adventure;
		},
		addDataObserver:function(){
			addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
		},
}

adventuredata.addDataObserver();