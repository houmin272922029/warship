var titledata = {
		titles:{},
		fromDic:function(dic){
			if(!dic || !dic.info) {
				return;
			}
			var data = dic.info;
			if(!data.titles) {
				return;
			}
			var titleData = data.titles;
			
			for (var k in titleData){
				this.titles[k] = titleData[k];
			}
		},
		addDataObserver:function(){
			addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
		},
} 
titledata.addDataObserver();