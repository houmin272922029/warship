var questdata = {
		once:{},
		daily:{},
		newCompleteKey : null,
		newComplete : null,
		fromDic:function(dic){
			if (!dic || !dic.info) {
				return;
			}
			var data = dic.info;
			if (data.missions) {
				if (data.missions.daily) {
					var dailys = data.missions.daily;
					for (var k in dailys) {
						var mission = dailys[k];
						this.daily[k] = mission;
						// 刷新任务数据 返回新完成的任务
						if (dailys[k].status == 1 && (questdata.daily == null || questdata.daily[k] == null || questdata.daily[k].status == null)) {
							questdata.newCompleteKey = "daily";
							questdata.newComplete = dailys;
							break;
						}
					}
				} 
				if (data.missions.once) {
					var missions = data.missions.once;
					for (var k in missions) {
						var mission = missions[k];
						this.once[k] = mission;
						// 刷新任务数据 返回新完成的任务
						if (missions[k].status == 1 && (questdata.once == null || questdata.once[k] == null || questdata.once[k].status == null)) {
							questdata.newCompleteKey = "once";
							questdata.newComplete = missions;
							break;
						}
					}
				}
			}
			return questdata.newComplete != null;
		},
		addDataObserver:function(){
			addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
		},
};

questdata.addDataObserver();
