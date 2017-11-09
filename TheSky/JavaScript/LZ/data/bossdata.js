var bossdata = {
	boss:{},
	lastBoss:{},
	rank:{},
	bossBattleLog:{},
	damage:null,
	hasCheckedFirst : false,
	hasCheckedSecond : false,
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		var bossInfo = data.bossInfo;
		if (data.bossInfo) {
			for (var k in bossInfo) {
				if (k == "boss") {
					var amount = bossInfo[k];
					this.boss = amount;
				} else if (k == "lastBoss") {
					var amount = bossInfo[k];
					this.lastBoss = amount;
				} else if (k == "rank") {
					var amount = bossInfo[k];
					this.rank = amount;
				}
			}
		}
		if (bossInfo) {
			for (var k in bossInfo) {
				if (k == "boss") {
					var amount = bossInfo[k];
					this.boss[k] = amount;
				} else if (k == "lastBoss") {
					var amount = bossInfo[k];
					this.lastBoss[k] = amount;
				} else if (k == "rank") {
					var amount = bossInfo[k];
					this.lastBoss[k] = amount;
				}
			}
		}
		var battleLog = data.battleLog;
		if (data.battleLog) {
			if (battleLog) {
				for (var k in battleLog) {
					var logs = battleLog[k];
					this.bossBattleLog[k] = logs;
				}
			}
			if (data.damage) {
				this.damage = data.damage;
			}
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
}

bossdata.addDataObserver();