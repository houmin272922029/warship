var DailyName = {
		Treasure : "treasure",
		DayEnergy : "dayEnergyInfo",
		KissMermaid : "kissMermaid",
		Drink : "drinkInfo",
		SingleIns : "singleIns",
		GroupIns : "groupIns",
		SignIn : "signIn",
		Invitation : "invitation",
		LevelUp : "levelUpGift",
		CraftsMan : "craftsman",
		MonthCard : "monthCard",
}

var activitydata = {
		groupInstructIndex : 0,
		
		getGroupInstructDataAboutIndex : function() {
			var data = null;
			var index = 0;
			for ( var key in this.groupIns_) {

				if (index == this.groupInstructIndex) {
					data = {};
					data["uid"] = key;
					data["data"] = this.groupIns_[key];
					break;
				}

				index++;
			}
			this.groupInstructIndex = this.groupInstructIndex + 1;

			return data;
		},
		
		getSingleInstructData : function() {
			return this.singleIns_;
		},
		
		getGroupInstructDataById : function(uid) {
			var data = {};
			data["uid"] = uid;
			data["data"] = this.groupIns_[uid];
			
			return data;
		},
		
		fromDic:function(dic){
			if (!dic || !dic.info) {
				return;
			}
			if (dic.info.dailyList) {
				this.dailyList_ = dic.info.dailyList;
				postNotifcation(NOTI.ACTIVITY_DAILY_LIST_CHANGE);	
			}
			var changeList = new Array();
			
			var data = dic.info;
			if (data.dayEnergyInfo) {
				this.dayEnergy_ = data.dayEnergyInfo;
				changeList.push("dayEnergyInfo");
			}
			
			if (data.kissMermaid) {
				this.killMermaid_ = data.kissMermaid;
				changeList.push("kissMermaid");
			}
			
			if (data.drinkInfo) {
				this.drinkInfo_ = data.drinkInfo
				changeList.push("drinkInfo");
			}
			
			if (data.singleIns) {
				this.singleIns_ = data.singleIns
				this.singleInstructIndex = 0;
				changeList.push("singleIns");
			}
			
			if (data.groupIns) {
				this.groupIns_ = data.groupIns
				this.groupInstructIndex = 0;
				changeList.push("groupIns");
			}
			
			if (data.signIn) {
				this.signIn_ = data.signIn;
				changeList.push("signIn");
			}
			
			if (data.invitation) {
				this.invitation_ = data.invitation;
				changeList.push("invitation");
			}
			
			if (data.levelUpGift) {
				this.levelUpGift_ = data.levelUpGift;
				changeList.push("levelUpGift");
			}		
			
			if (data.craftsman) {
				this.craftsman_ = data.craftsman;
				changeList.push("craftsman");
			}
			
			if (data.monthCard) {
				this.monthCard_ = data.monthCard;
				changeList.push("monthCard");
			}
			
			/**
			 * 发送已经发生数据改变的活动信息通知
			 */
			if (changeList.length > 0) {
				postNotifcation(NOTI.ACTIVITY_DATA_CHANGE, changeList);			
			}
			
			changeList = null;	
		},
		addDataObserver:function(){
			addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
		},
};

activitydata.addDataObserver();