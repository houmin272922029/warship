var vipdata = {
	vip:{},
	fromDic:function(dic){
		if(!dic || !dic.info) {
			return;
		}
		
		var data = dic.info;
		if(!data.vip) {
			return;
		}
		var vipData = data.vip;
		if (!vipData) {
			return;
		}
		for (var k in vipData){
			var vipl = vipData[k];
			this.vip[k] = vipl;
			var vip = data.vip;
			for (var k in vip){
			var v = vip[k];
			this.vip[k] = v;
			}
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
} 
vipdata.addDataObserver();