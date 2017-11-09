var equipdata = {
	equips:{},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (!data.equips) {
			return;
		}
		var equips = data.equips;
		for (var k in equips) {
			var equip = equips[k];
			this.equips[k] = equip;
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
	payEquip:function(eid){
		if (this.equips[eid]) {
			delete this.equips[eid];
		}
	},
	gainEquip:function(eid, equip){
		this.equips[eid] = equip;
	}
}

equipdata.addDataObserver();