var QuestModule = {
		/**
		 * 获取 主线任务数据
		 */
		getQuestOnce:function(){
			var retArray = [];
			for (var k in questdata.once) {
				retArray.push(questdata.once[k]);
			}
			retArray.sort(function(a, b){
				if (a.status == b.status) {
					return a.progress < b.progress;
				}
				return a.status > b.status;
			});
			return retArray;
		},
		/**
		 * 获取 日常任务数据
		 */
		getQuestDaily:function(){
			var retArray = [];
			for (var k in questdata.daily) {
				retArray.push(questdata.daily[k]);
			}
			retArray.sort(function(a, b){
				if (a.status === b.status) {
					return a.progress < b.progress ? -1 : 1;
				}
				return a.status > b.status ?  -1 : 1;
			});
			return retArray;
		},
		/**
		 * 获取 任务系统的配置
		 */
		getQuestConfig:function(missionId, key){
			var cfg = config["mission_" + key];
			return cfg[missionId];
		},
		/**
		 * 完成任务弹框,弹出后清除
		 */
		pushComplete:function(){
			var data = deepcopy(questdata.newComplete);
			var key = deepcopy(questdata.newCompleteKey);
			questdata.newComplete = null;
			questdata.newCompleteKey = null;
			return {data : data, key : key};
		},
		/**
		 * 任务data置空
		 */
		reduceQuest:function(){
			questdata.daily = {};
			questdata.once = {};
		},
		/**
		 * 网络接口
		 */
		/**
		 * 领奖
		 */
		doOnGetReward:function(type, missionId, succ, fail){
			dispatcher.doAction(ACTION.MISSION_GETREWARD, [type, missionId], succ, fail);
		},
}