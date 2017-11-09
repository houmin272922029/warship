var souldata = {
	souls:{},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (!data.heroSouls) {
			return;
		}
		var souls = data.heroSouls;
		for (var soulId in souls) {
			var amount = souls[soulId];
			this.souls[soulId] = amount;
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
	gainSoul:function(soulId, soul){
		this.souls[soulId] = soul;
	},
}

souldata.addDataObserver();