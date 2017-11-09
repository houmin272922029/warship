var shopdata = {
		vipshop:{},
		fromDic:function(dic){
			if(!dic || !dic.info) {
				return;
			}
			var data = dic.info;
			if(!data.vipShopInfo) {
				return;
			}
			var vipshop = data.vipShopInfo;
			for (var k in vipshop){
				var bags = vipshop[k];
				this.vipshop[k] = bags;
			}
		},
		addDataObserver:function(){
			addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
		},
} 
shopdata.addDataObserver();