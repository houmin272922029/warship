var maildata = {
		
	mails:{},
	
	fromDic:function(dic) {
		if (!dic || !dic.info) {
			return;
		}
		if(!dic.info.mails){
			return;
		}
		this.mails = dic.info.mails;
		
	},
	
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
		
	pay:function(mailId){
		if (this.mails && this.mails.attachment) {
			var awards = this.mails.attachment;
			for (var k in awards) {
				if (awards[k].id == mailId) {
					delete this.mails.attachment[k];
				}
			}
		}
	},
}
maildata.addDataObserver();