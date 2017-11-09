var elitestagedata = {
	current:"elitestage_0001_01",
	record:{},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (!data.eliteStage) {
			return;
		}
		var stage = data.eliteStage;
		if (stage.currentStage) {
			this.current = stage.currentStage;
		}
		if (stage.record) {
			this.record = stage.record;
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
}

elitestagedata.addDataObserver();