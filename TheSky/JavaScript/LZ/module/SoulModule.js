var SoulModule = {
		getAllSouls:function(){
			var souls = [];
			for (var k in souldata.souls) {
				var amount = souldata.souls[k];
				if (amount > 0) {
					var cfg = this.getSoulConfig(k);
					var soul = {};
					soul.id = k;
					soul.amount = amount;
					soul.name = cfg.name;
					soul.heroId = cfg.heroId;
					var hCfg = HeroModule.getHeroConfig(cfg.heroId);
					soul.rank = hCfg.rank;
					
					var hero = HeroModule.getHeroByHeroId(soul.heroId)
					if (hero) {
						var curRank = hero.rank;
						soul.state = "break";
						var heroId = cfg.heroId;
						var need = this.getBreakNeedSoulCount(soul.rank, curRank, hero["break"]);
						if (need === -1) {
							soul.sortFlag = 4;
						} else if (soul.amount >= need) {
							soul.sortFlag = 0;
						} else {
							soul.sortFlag = 2;
							soul.breCount = need - soul.amount;
						};
						soul["break"] = hero["break"];
					}else{
						soul.state = "recuit";
						var recuit = this.getheroRecuitConfig(soul.rank, soul.rank);
						var recuitData = this.getheroRecuitDataConfig(recuit);
						if (soul.amount >= recuitData.hero) {
							soul.sortFlag = 1;
						} else {
							soul.recCount = recuitData.hero - soul.amount;
							soul.sortFlag = 3;
						}
					}
					souls.push(soul);
				}
			};
			souls.sort(function(a,b){
				if (a.sortFlag == b.sortFlag) {
					if (a.rank == b.rank) {
						return a.amount > b.amount ? 1 : -1;
					};
					return a.rank > b.rank ? -1 : 1;
				};
				return a.sortFlag > b.sortFlag ?  1 : -1
			});
			return souls;
		},
		getSoulConfig:function(id){
			return config.hero_soul[id];
		},
		/**
		 * 通过配置rank和当前rank获得魂魄招募表的key
		 */
		getheroRecuitConfig:function(rank, curRank){
			return config.hero_recuit[rank][curRank];
		},
		/**
		 * 读取魂魄配置表
		 * 
		 * @param recuit
		 * @returns
		 */
		getheroRecuitDataConfig:function(recuit){
			return config.hero_recuit_data[recuit];
		},
		/**
		 * 获得某个英雄突破所需的魂魄
		 * @param rank 配置的rank
		 * @param curBreak 当前 rank
		 * @returns {Number}
		 */
		getBreakNeedSoulCount:function(rank, curRank, curBreak){
			var recuit = this.getheroRecuitConfig(rank, curRank);
			var cfg = this.getheroRecuitDataConfig(recuit);
			if (!cfg) {
				return 0;
			};
			if (curBreak >= getJsonLength(cfg["break"])) {
				return -1;
			};
			return cfg["break"][curBreak];
		},
		/**
		 * 获得某个英雄突破后增加的潜力
		 * @param rank 配置的rank
		 * @param curRank 当前的rank
		 * @returns {Number}
		 */
		getBreakedPoints:function(rank, curRank){
			var recuit = this.getheroRecuitConfig(rank, curRank);
			var cfg = this.getheroRecuitDataConfig(recuit);
			if (!cfg) {
				return 0;
			}else {
				return cfg.breakcapacity;
			}
		},
		/**
		 * 获得某个魂魄的数量
		 * @param soulId
		 * @returns {Number}
		 */
		getBreakSoulCount:function(soulId){
			if (souldata.souls[soulId]) {
				return souldata.souls[soulId];
			}
			return 0
		},
		/**
		 * 减少魂魄
		 * @param soulId - 魂魄id
		 * @param amount - 减少的数目
		 * @returns null
		 */
		reduceSoul:function(soulId, amount){
			souldata.souls[soulId] = Math.max(souldata.souls[soulId] - amount, 0);
			if (souldata.souls[soulId] == 0) {
				delete souldata.souls[soulId];
			}
		},
		/**
		 * 增加魂魄
		 * @param soulId - 魂魄id
		 * @returns null
		 */
		addSoulByDic:function(dic){
			for ( var k in dic) {
				souldata.souls[k] = (souldata.souls[k] || 0) + dic[k];
			}
		},
		/*
		 ********************************
		 * 			  网络
		 ********************************
		 */
		/**
		 * 突破
		 */
		doOnBreakHero:function(soulid, succ, fail){
			dispatcher.doAction(ACTION.FORM_BREAKHERO, soulid, succ, fail);
		},
		/**
		 * 招募
		 */
		doOnRecruitSoul:function(soulid, succ, fail){
			dispatcher.doAction(ACTION.FORM_RECRUITSOUL, soulid, succ, fail);
		}
}