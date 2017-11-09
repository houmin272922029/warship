var blooddata = {
	datas:{},
	yesterdayRankInfo:{},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (data.bloodInfo) {
			for (var k in data.bloodInfo) {
				var datainfo = data.bloodInfo[k];
				this.datas[k] = datainfo;
			}
		}
		if (data.yesterdayRankInfo) {
			for (var k in data.yesterdayRankInfo) {
				var info = data.yesterdayRankInfo[k];
				this.yesterdayRankInfo[k] = info;
			}
		}
	},
	blooddataFlag : {
		home : 1,
		dayBuff : 2,
		fight : 3,
		tempBuff : 4,
		reward : 5,
		lose : 6, //1-准备挑战；2-有首次buff；3-正在挑战；4-有奖励；5-有buff加成；6-失败
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", blooddata);
	},
}

blooddata.addDataObserver();