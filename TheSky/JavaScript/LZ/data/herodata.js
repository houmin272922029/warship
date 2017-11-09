var herodata = {
		heroes:{},
		fromDic:function(dic){
			if (!dic || !dic.info) {
				return;
			}
			var data = dic.info;
			if (!data.heros) {
				return;
			}
			var heroes = data.heros;
			for (var k in heroes) {
				var hero = heroes[k];
				this.heroes[k] = hero;
			}
		},
		gainHero:function(hid, hero){
			this.heroes[hid] = hero;
		},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
}

herodata.addDataObserver();