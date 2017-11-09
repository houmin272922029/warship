var BossModule = {
	/**
	 * 恶魔谷boss是否开战
	 * 返回值：0 : 等级不够开启 1 : 12:30的boss已开启 2 : 20:30的boss已开启
	 */
	isBossFight:function(){
		if (PlayerModule.getLevel() < FunctionModule.openLevel("boss")) {
			return 0;
		}
		var begin = Global.serverBegin;
		if (Global.serverTime >= begin + 3600 * 12.5 && Global.serverTime < begin + 3600 * 13) {
			return 1;
		} else if (Global.serverTime >= begin + 3600 * 20.5 && Global.serverTime < begin + 3600 * 21){
			return 2;
		} else {
			return 0;
		}
	},
	/**
	 * 获取boss配置
	 * @param bossKey
	 */
	getBossAttrConfig:function(bossKey){
		return config.blackbeard_bossattr[bossKey] || null;
	},
	/**
	 * 获得boss的rank数组
	 */
	getLastRank:function(){
		var retArray = [];
		var bossCfg = BossModule.getBossAttrConfig(bossdata.lastBoss.key);
		if (bossCfg.npc) {
			for (var k in bossCfg.npc) {
				retArray.push(bossCfg.npc[k]);
			}
		}
		retArray.sort(function(a, b){
			return a.rank > b.rank ? -1 : 1;
		});
		return retArray;
	},
	/**
	 * 获取上次排行信息
	 */
	getRank:function(){
		var retArray = [];
		for (var k in bossdata.lastBoss.rank) {
			var dic = deepcopy(bossdata.lastBoss.rank[k]);
			dic["type"] = 1;
			if (k == "finalKiller") {
				dic["type"] = 0;
			}
			retArray.push(dic)
		}
		retArray.sort(function(a, b){
			return a.rank < b.rank ? -1 : 1;
		})
		return retArray;
	},
	/**
	 * 获取boss挑战配置
	 */
	getBossChallengeConfig:function(key){
		return cfg = config.blackbeard_revives[key] || null;
	},
	/**
	 * 对战斗返回的Log做处理
	 */
	popLog:function(){
		if (bossdata.damage == null) {
			return null;
		}
		var heroUid;
		for (var k in formdata.form) {
			if (k == 0) {
				heroUid = formdata.form[k];
			}
		}
		var heroId = HeroModule.getHeroByUid(heroUid).heroId;
		var logInfo = {damage : bossdata.damage, name : PlayerModule.getName(), heroId : heroId}; 
		bossdata.damage = null;
		return logInfo;
	},
	/**
	 * 网络接口
	 */
	/**
	 * 获取boss战信息
	 * 1、boss战是否开启
	 * 2、开放时间戳
	 * 3、上次战况
	 * 4、上次或正在开放的boss的主要信息
	 */
	doOnBossGetBossInfo:function(succ, fail){
		dispatcher.doAction(ACTION.BOSS_GETBOSSINFO, [], succ, fail);
	},
	/**
	 * boss战斗 
	 * @param type 1-普通打 2-立即复活 3-浴血奋战
	 */
	doOnBossBattle:function(type , succ, fail){
		dispatcher.doAction(ACTION.BOSS_BOSSBATTLE,[type], succ, fail);
	},
}