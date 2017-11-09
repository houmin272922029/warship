var ArenaModule = {
		/**
		 * 处理rankInfo数据(决斗页面的cell数据)
		 */
		getRankInfoArray:function(){
			var retArray = [];
			var rankInfo = arenadata.arenaRank;
			for (var i = 0; i < getJsonLength(rankInfo) + 1; i++) {
				if (rankInfo[i]) {
					retArray.push(rankInfo[i]);
				}
			}
			return retArray;
		},
		/**
		 * 返回剩余挑战次数
		 */
		getFightCount:function(){
			return arenadata.arenaTimes;
		},
		/**
		 * 获得兑换道具配置
		 */
		getExchangeAwardConfig:function(){
			return config.duel_exchange;
		},
		/**
		 * 获得积分配置
		 */
		getRecordConfig:function(key){
			return config.duel_records[key] || null;
		},
		/**
		 * 获得进入排名奖励(奖励页面的cell数据)
		 */
		getRecordAward:function(){
			var retArray = [];
			for (var k in arenadata.records) {
				var key = arenadata.records[k].key;
				var dic = deepcopy(this.getRecordConfig(key));
				dic.state = arenadata.records[k].state;
				retArray.push(dic);
			}
			retArray.sort(function(a, b){
				return a.params[0] > b.params[0] ? -1 : 1;
			});
			return retArray;
		},
		/**
		 * 网络接口
		 */
		/**
		 * 刷新决斗(竞技场)主信息(决斗)
		 */
		doOnArenaMainInfo:function(succ, fail){
			dispatcher.doAction(ACTION.ARENA_ARENAMAIN, [], succ, fail);
		},
		/**
		 * 竞技场战斗(决斗)
		 * @param  enemyPos 被打玩家排名
		 */
		doOnArenaBattle:function(enemyPos, succ, fail){
			dispatcher.doAction(ACTION.ARENA_ARENABATTLE, [enemyPos], succ, fail);
		},
		/**
		 * 获取玩家的领奖情况(领奖)
		 * @return array $resultArray
		 */
		doOnArenaRecord:function(succ, fail){
			dispatcher.doAction(ACTION.ARENA_GETARENA_RECORDS, [], succ, fail);
		},
		/**
		 * 领取首次进入排名的奖励(领奖)
		 * @param string $awardId 奖励
		 */
		doOnArenaReward:function(awardId, succ, fail){
			dispatcher.doAction(ACTION.ARENA_RECORD_AWARD, [awardId], succ, fail);
		},
		/**
		 * 刷新玩家的论剑积分(决斗、领奖)
		 */
		doOnArenaScore:function(succ, fail){
			dispatcher.doAction(ACTION.ARENA_GET_SCORE, [], succ, fail);
		},
		/**
		 * 竞技场兑换物品(领奖)
		 * @param int $type
		 */
		doOnExchangeItem:function(type, succ, fail){
			dispatcher.doAction(ACTION.ARENA_EXCHANGE_ITEM, [type], succ, fail);
		},
}