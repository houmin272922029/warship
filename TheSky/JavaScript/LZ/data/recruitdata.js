var recruitdata = {
	shopHero:{},
	recruit:{},
	cdTimes:{},
	tempCDTime:{},
	times:{},
	heros:{},
	lastTime:{},
	fromDic:function(dic) {
		if (!dic || !dic.info) {
			return;
		}
		
		var data = dic.info;
		if(!data.shopHero) {
			return;
		}
		var shopHeroData = data.shopHero;
		if (!shopHeroData) {
			return;
		}
		for (var k in shopHeroData) {
			var shopheroes = shopHeroData[k];
			this.shopHero[k] = shopheroes;
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
}
recruitdata.addDataObserver();