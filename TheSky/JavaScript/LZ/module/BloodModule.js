var BloodModule = {
		/**
		 * 获取新世界各个关卡配置
		 * @returns cfg
		 */
		getBloodConfig:function(groupId){
			var cfg = config.newworld_npcgroup
			return cfg[groupId] || null;
		},
		getBloodAward:function(){
			var award = [];
			var blooddatas = blooddata.datas;
			var berry = (blooddatas.thisRecord - blooddatas.historyRecord) * blooddatas.awardConfig.perstar;
			if (blooddatas.award["5start"]) {
				berry += blooddatas.award["5start"];
			}
			award.push({"berry" : berry});
			var items = {};
			if (blooddatas.award["15start"]) {
				for ( var k in blooddatas.award["15start"]) {
					if (items[k]) {
						items[k] += blooddatas.award["15start"][k]
					} else {
						items[k] = blooddatas.award["15start"][k];
					}
				}
			}
			if (blooddatas.award["30start"]) {
				for ( var k in blooddatas.award["30start"]) {
					if (items[k]) {
						items[k] += blooddatas.award["30start"][k]
					} else {
						items[k] = blooddatas.award["30start"][k];
					}
				}
			}
			for ( var k in items) {
				award.push({k : items[k]});
			}
			if (blooddatas.award["45start"]) {
				award.push({"gold" : blooddatas.award["45start"]})
			}
			return award;
		},
		/**
		 * blood网络接口
		 */
		/**
		 * 获取当前血战信息
		 */
		doOnGetBloodInfo:function(succ, fail){
			dispatcher.doAction(ACTION.BLOOD_GETBLOODINFO, [], succ, fail);
		},
		/**
		 * 开始挑战
		 */
		doOnBeginBlood:function(succ, fail){
			dispatcher.doAction(ACTION.BLOOD_BEGINBLOOD, [], succ, fail);
		},
		/**
		 * 增加首次buff
		 * @param String $attr 增加的buff项（攻、防、血、内）
		 */
		doOnAddFirstBuff:function(attr, succ, fail){
			dispatcher.doAction(ACTION.BLOOD_ADDFIRSTBUFF, [attr], succ, fail);
		},
		/**
		 * 增加buff
		 * @param $option buff的选项（0,1,2）
		 */
		doOnAddBuff:function(buff, succ, fail){
			dispatcher.doAction(ACTION.BLOOD_ADDBUFF, [buff], succ, fail);
		},
		/**
		 * 领取奖励
		 */
		doOnAddAward:function(succ, fail){
			dispatcher.doAction(ACTION.BLOOD_ADDAWARD, [], succ, fail);
		},
		/**
		 * 血战-战斗
		 * @param Number $outpostNum 挑战的关卡
		 * @param Number $grade 难度（1,2,3）
		 */
		doOnBloodBattle:function(postNum, grade, succ, fail){
			dispatcher.doAction(ACTION.BLOOD_BLOODBATTLE, [postNum, grade], succ, fail);
		},
		/**
		 * 获得昨天的排名信息
		 */
		doOnBloodRankInfo:function(succ, fail){
			dispatcher.doAction(ACTION.BLOOD_GETBLOODRANKINFO, [], succ, fail);
		},
		/**
		 * 补发某些区服某些天的奖励
		 */
		doOnBloodRankAndAwardForOneDay:function( succ, fail){
			dispatcher.doAction(ACTION.BLOOD_RANKANDAWARDFORONEDAY, [], succ, fail)
		},
}