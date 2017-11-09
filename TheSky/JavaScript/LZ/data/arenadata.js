var arenadata = {
	arenaRank:{},
	arenaTimes:null,
	records:{},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (data.rankInfo) {
			for (var k in data.rankInfo) {
				var arena = data.rankInfo[k];
				this.arenaRank[k] = arena;
			}
		}
		if (data.arenaTimes) {
			this.arenaTimes = data.arenaTimes;
		}
		if (data.records) {
			for (var k in data.records) {
				var record = data.records[k];
				this.records[k] = record;
			}
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
}

arenadata.addDataObserver();