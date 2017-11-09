var frienddata = {
		friends : {},
		fromDic:function(dic){
			if (!dic || !dic.info) {
				return;
			}
			var data = dic.info;
			if (data.friends) {
				for (var k in data.friends) {
					var friend = data.friends[k];
					this.friends[k] = friend;
				}
			}
		},
		addDataObserver:function(){
			addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
		},
};

frienddata.addDataObserver();
