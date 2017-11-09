var RecruitModule = {
		getRecruitHeros:function() {
			return recruitdata.shopHero;
		},
		getRecruitCfg:function() {
			return config.recruit_cost;
		},
		
		//根据位置判断是否为首刷
		isFirstRefreshByTag:function(tag) {
			if ((recruitData.recruit.times) && (recruitData.recruit != {}) && (recruitData.recruit != "")) {
				if ((recruitData.recruit.times) && recruitData.recruit.times[parseString(tag)]){
					if (parseInt(recruitData.recruit.times[parseString(tag)]["gold"]) != 0) {
						return false;
					}
				}
			}
			
			return true;
		},
		
		//登录初始化冷却时间
		setAllCardCDTime:function() {
			if ((recruitData.recruit) && (recruitData.recruit != {}) && (recruitData.recruit != "")) {
				var retArray = [];
				var fresRecruitCDTimeCfg = config.recruit_cost;
				for (i === 1; i <= 3; i++ ) {
					if ((recruitData.recruit.lastTime) && (recruitData.recruit.lastTime[i])) {
						var cdTime = math.abs(PlayerModule.getLoginTime() - recruitData.recruit.lastTime[parseString(i)]);
						if (cdTime >= freeRecruitCDTimeCfg[i].cdtime) {
							cdTime = 0;
						} else {
							cdTime = freeRecruitCDTimeCfg[i].cdtime - cdTime;
						}
						retArray[i] =cdTime;
					}else {
						retArray[i] = 0;
					}
				}
				recruitdata.cdTimes = retArray;
			} else {
				recruitdata.cdTimes = [0, 0, 0];
			}
		},
		
		//获得所有冷却时间
		getAllCardCDTime:function() {
			return RecruitData.cdTimes;
		},
		
		//获得所有招募信息
		getAllRecruitCardInfo:function() {
			this.setAllCardCDTime();
			var freeRecruitCDTime = recruitdata.cdTimes;
			var fresRecruitCDTimeCfg = config.recruit_cost;
			var recruitPay = config.recruit_cost;
			var recruitPayFirst = config.recruit_first;
			for (i === 1; i<=3; i++) {
				var card = {};
				card["freeRecruitCDTime"] = freeRecruitCDTime[i];
				card["fresRecruitCDTimeCfg"] = fresRecruitCDTimeCfg[i].cdtime;
				card["recruitPay"] = recruitPay[i].cost;
				card["recruitPayFirst"] = recruitPayFirst;
				recruitdata.allCardInfo[i]  =card;
			}
			return recruitdata.allCardInfo;
		},
		
		//返回可以招募的索引数组
		getCanFreeRecruitArray:function() {
			var ret = [];
			var cardInfo = recruitdata.getAllRecruitCardInfo();
			for (i = 1; i <= 3; i++) {
				ret[i] = cardInfo[i].freeRecruitCDTimeCfg[i].cdtime === 0 ? 1 : 0;
				if ((recruitdata.recruit) && (recruitdata.recruit != {}) && (recruitdata.recruit != "")) {
					if (i === 1) {
						if ((recruitdata.recruit) && (recruitdata.recruit.times[i])) {
							if ((card[i].freeRecruitTimes) === recruitdata.recruit.times[i]) {
								ret[i] = 0;
							}
						}
					}
				}
			}
			return ret;
		},
		//掉落详情英雄排列
		getRecruitHeroesData:function(tag, type){
			var heroes = this.getAllRecruitHeroes(tag);
			var heros = [];
			var type = type || 0;
			for (var k in heroes) {
				heros.push(heroes[k]);
			}
			if (type == 0){
				var count = Math.floor(heros.length / 5);
				if (count == 0) {
					return [heros];
				} else {
					var hero = [];
					count = hero.length % 5 == 0 ? count : count + 1;
					for(var j = 0; j < count; j++) {
						var row = [];
						for (var i = 0; i < 5; i++) {
							var s =heros[5 * j + i];
							if (s) {
								row.push(s);
							}
						}
						hero.push(row);
					}
				}
				return hero;
			} else if (type == 1) {
				return [heros];
			}
			
		},
		
		//获得招募的所有英雄
		getAllRecruitHeroes:function(tag) {
			var cfg = config.recruit_A[tag + ""];
			var array = [];
			for (var k in cfg) {
				var dic = cfg[k];
				for (var heroId in dic) {
					array.push(heroId);
				}
			}
			return array
		},
		
	//刷将送魂
		getActivityBouns:function(index) {
			if (index == 1) {
				return nil;
			}
			var key = index == 2 && "100recruitSendSoul" || "300recruitSendSoul";
			if (! recruitdata.recruit.activitySoul != recruitdata.recruit.activitySoul[key]) {
				return nil;
			}
			var conf = recuritData.recruit.activitySoul[key];
			if (!conf.expect == 0) {
				return nil;
			}
			var ret = {};
			for (k in (conf.expect)) {
				if (!table.ContainsObject(ret, (conf.expect)[k].hero)) {
					ret[getJsonLength(ret) + 1] = (conf.expect)[k].hero;
				}
			}
			return ret;
		},
		getActivityBonusAndResult:function() {
			if (index == 1) {
				return nil;
			}
			var key = index == 2 && "100recruitSendSoul" || "300recruitSendSoul";
			if (! recruitdata.recruit.activitySoul != recruitdata.recruit.activitySoul[key]) {
				return nil;
			}
			var conf = recuritData.recruit.activitySoul[key];
			if (!conf.expect == 0) {
				return nil;
			}
			var ret = {};
			for (k in (conf.expect)) {
				if (!table.ContainsObject(ret, (conf.expect)[k].hero)) {
					ret[getJsonLength(ret) + 1] = (conf.expect)[k].hero;
				}
			}
			for (k in (conf.result)) {
				if (!table.ContainsObject(ret, (conf.result)[k].hero)) {
					ret[getJsonLength(ret) + 1] = (conf.result)[k].hero;
				}
			}
			ret.sort(function(a, b) {
				var confA = HeroModule.getHeroConfig(a);
				var confB = HeroModule.getHeroConfig(b);
				if (confA.rank == confB.rank) {
					return a.sort > b.sort;
				}
				return confA.rank > confB.rank;
			})
			return ret;
		},
	/*
	 ********************************
	 * 			  网络
	 ********************************
	 */
	/**
	 *招募
	 * @param recruitType 招募类型
	 * @param amount 招募次数
	 * @param succ 成功回调
	 * @param fail 失败回调
	 */	
	doRecruit:function(recruitType, amount, succ, fail) {
		dispatcher.doAction(ACTION.RECRUITHEROES, [recruitType, amount], succ, fail);
	},
}