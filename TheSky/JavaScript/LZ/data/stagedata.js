var stagedata = {
	current:"stage_01_01",
	record:{},
	resetCount:0,
	chapterAward:{},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (!data.stage) {
			return;
		}
		var stage = data.stage;
		if (stage.currStage) {
			this.current = stage.currStage;
		}
		if (stage.stageRecord) {
			this.record = stage.stageRecord;
		}
		if (stage.resetCount) {
			this.resetCount = stage.resetCount;
		}
		if (stage.pageAward) {
			this.chapterAward = stage.pageAward;
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
}

stagedata.addDataObserver();