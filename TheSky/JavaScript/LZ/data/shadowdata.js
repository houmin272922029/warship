var shadowdata = {
	shadows:{},
	shadowData:{},
	shadowExercise:{},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (data.shadows) {
			var shadows = data.shadows;
			for (var k in shadows) {
				var shadow = shadows[k];
				this.shadows[k] = shadow;
			}
		}
		if (data.shadowData) {
			var shadowData = data.shadowData;
			for (var k in shadowData) {
				var shadow = shadowData[k];
				this.shadowData[k] = shadowData[k];
			}
		}
		if (data.shadowExercise) {
			var shadowExercise = data.shadowExercise;
			for (var k in shadowExercise) {
				var shadow = shadowExercise[k];
				this.shadowExercise[k] = shadowExercise;
			}
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
}

shadowdata.addDataObserver();