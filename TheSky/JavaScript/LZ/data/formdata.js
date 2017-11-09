var formdata = {
	form:null,
	sevenForm:null,
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (data.form) {
			this.form = data.form;
		}
		if (data.form_seven) {
			this.sevenForm = data.form_seven;
		}
		if (data.seven_upgrade) {
			this.sevenUpgrade = data.seven_upgrade;
		}
		
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
}

formdata.addDataObserver();