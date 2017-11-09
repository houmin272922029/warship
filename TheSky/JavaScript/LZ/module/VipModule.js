var VipModule = {
	getVipDesp:function(vipLevel) {
		var desp = config.vip_desp;
		var despIndex = desp[vipLevel + ""];
		var despStr = "";
		for ( var k in despIndex) {
			despStr =despStr +  despIndex[k];
		}
		return despStr;
	},
	getVipAwardConfig:function() {
		return config.vip_award;
	},
	getVipDayGiftAwardConfig:function() {
		return config.vip_perday;
	},
//	getDailyAward:function(){
//		var awardShow = {};
//		var dailyAward = vipdata.DailyVipGain;
//		for(var k in dailyAward) {
//			var cfg = ItemModule.getItemConfig(k);
//			var award = {};
//			award.itemName = cfg.name;
//			award.sprite = cfg.icon;
//			award.countLabel = dailyAward[k];
//			awardShow[getJsonLength(awardShow ) + 1] = award;
//		}
//		return dailyAward;
//	},
	getRewardRcord:function(idx){
		return vipdata.vip.rewardRcord["" + idx];
	},
	getdailyRecord:function(idx) {
		return vipdata.vip.dailyRcord["" + idx];
	},
	getvipRecord:function(idx) {
		return vipdata.vip.shopVipBag["" + idx];
	},
	/**
	 * 获得好友上限数
	 * @param vipLevel
	 */
	getFriendLimitByVipLevel:function(vipLevel){
		var cfg = config.vip_config;
		for (var k in cfg) {
			if (k == vipLevel) {
				return cfg[k].friend;
			}
		}
		return 0;
	},
	doVipReward:function(succ, fail) {
		dispatcher.doAction(ACTION.GETVIPDAILYREWARD, [], succ, fail);
	},
	doVipLevelReward:function(vipLevel, succ, fail) {
		dispatcher.doAction(ACTION.GETVIPLEVELREWARD, [vipLevel], succ, fail);
	}
}