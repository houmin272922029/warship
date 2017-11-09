var StageModule = {
	/**
	 * 当前关卡
	 * 
	 * @returns
	 */
	getCurrentStage:function(){
		return stagedata.current;
	},
	/**
	 * 章节
	 * 
	 * @returns {Array}
	 */
	getChapters:function(){
		var cfg = config.stageConfig_page;
		var chapters = [];
		var openIdx = this.getChapterOpenIdx();
		for (var i = 1; i <= getJsonLength(cfg); i++) {
			var id = "stage_" + common.fix(i, 2);
			var c = cfg[id];
			var dic = {};
			dic.id = id;
			dic.name = c.pageName;
			dic.bg = c.pageBg;
			dic.open = openIdx >= i;
			chapters.push(dic);
		}
		return chapters;
	},
	/**
	 * 章节开放
	 */
	getChapterOpenIdx:function(){
		var stageId = this.getCurrentStage();
		return parseInt(stageId.split("_")[1]);
	},
	/**
	 * 获得关卡信息
	 */
	getStages:function(chapter){
		var c_cfg = this.getChapterInfo(chapter);
		var ids = c_cfg.pageStage;
		var stages = [];
		for (var i in ids) {
			var id = ids[i];
			var cfg = config.stageConfig_data[id];
			var stage = {};
			stage.id = id;
			stage.cfg = cfg;
			stage.record = stagedata.record[id];
			stage.open = this.bStageOpen(id);
			stages.push(stage);
		}
		return stages;
	},
	/**
	 * 获取章节信息
	 * 
	 * @param chapter
	 */
	getChapterInfo:function(chapter){
		return config.stageConfig_page[chapter];
	},
	/**
	 * 关卡是否开放
	 * 
	 * @param stageId
	 * @returns {Boolean}
	 */
	bStageOpen:function(stageId){
		return stagedata.current >= stageId;
	},
	/**
	 * 关卡奖励
	 * 
	 * @param stageId
	 */
	getStageReward:function(stageId){
		var ret = [];
		var cfg = config.stageConfig_data[stageId];
		var reward = cfg.award;
		if (!reward) {
			return ret;
		}
		for (var k in reward) {
			ret.push(k);
		}
		return ret;
	},
	/**
	 * 敌方阵容
	 * 
	 * @param stageId
	 */
	getStageEnemy:function(stageId){
		var npcs = config.stageNpc_data[stageId].npc;
		var heroes = [];
		for (var i in npcs) {
			var npc = npcs[i];
			var id = npc.npc_id;
			var rank = npc.npc_rank;
			var n = config.stnpc_list[id];
			var hero = {
				id:n.animation,
				rank:rank
			};
			heroes.push(hero);
		}
		return heroes;
	},
	/**
	 * 关卡挑战次数
	 * 
	 * @param type
	 * @returns
	 */
	getStageChallengeMax:function(type){
		return config.stageConfig_Type[type];
	},
	/*
	 ************************************* 
	 *
	 *			 	网络
	 *
	 *************************************
	 */
	/**
	 * 战斗
	 */
	doFight:function(stageId, succ, fail){
		dispatcher.doAction(ACTION.STAGE_FIGHT, [stageId], succ, fail);
	},
	/**
	 * 扫荡
	 * 
	 * @param stageId
	 * @param count
	 * @param succ
	 * @param fail
	 */
	doMultiFight:function(stageId, count, succ, fail){
		dispatcher.doAction(ACTION.STAGE_MULTI_FIGHT, [stageId, count], succ, fail);
	},
	/**
	 * 重置
	 * 
	 * @param stageId
	 */
	doReset:function(stageId){
		dispatcher.doAction(ACTION.STAGE_RESET, [stageId], succ, fail);
	},
	/**
	 * 章节奖励
	 * 
	 * @param chapterId
	 * @param star
	 */
	doGetChapterReward:function(chapterId, star){
		dispatcher.doAction(ACTION.STAGE_CHAPTER_REWARD, [chapterId, star], succ, fail);
	},
}