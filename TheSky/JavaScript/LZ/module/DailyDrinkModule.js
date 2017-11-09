/**
 *   饮酒相关
 */
var DailyDrinkModule = {
		/**
		 * 饮酒
		 */
		fetchDrinkData : function(param, target, successCallBack, errorCallBack) {
			var onSuccess = function(dic) {
				if (typeof successCallBack == "function") {
					successCallBack.call(target, dic);
				}
			};

			var onError = function(dic) {
				if (typeof errorCallBack == "function") {
					errorCallBack.call(target, dic);
				}
			};
			dispatcher.doAction(ACTION.DAILY_DRING_INFO, param, onSuccess, onError);
		},
		
		/**
		 *  获取饮酒rank
		 */
		getDrinkRank : function() {
			var data_ = activitydata.drinkInfo_;
			return data_.wineRank;
		},
		
		/**
		 * 获取饮酒数据
		 * @param isFirstIn   是否第一次进入
		 * @param isJustDrink 是否刚饮完酒
		 * @returns {___anonymous528_529}
		 */
		getDrinkData : function(isFirstIn, isJustDrink) {
			var viewData = {};
			
			// 处理字符串值
			var labels = {}
			var data_ = activitydata.drinkInfo_;
			
			labels["zorosWord"] = config.drinkPage_talk["meat_" + data_.wineRank].desp;
			
			if (isFirstIn) {
				labels["zorosWord"] = common.LocalizedString("daily_drinkWine_zorosWord_in");
			} else if (isJustDrink) {
				labels["zorosWord"] = common.LocalizedString("daily_drinkWine_zorosWord_afterDrink");
			}
			
			// 已喝次数/ 总的可喝次数（免费）
			var freeDrinkTimesLast = config.drinkPage_freetimes.eat.times - data_.drinkTimes;
			if (freeDrinkTimesLast < 0) {
				freeDrinkTimesLast = 0;
			}
			labels["drinkTimes1"] = String("{0}/{1}").format(freeDrinkTimesLast, config.drinkPage_freetimes.eat.times);
			
			// vip饮酒次数
			var vipDrinkTime_num = config.vip_config[PlayerModule.getVipLevel()].drinktimes;
			if ((config.drinkPage_freetimes.eat.times - data_.drinkTimes) < 0) {
				labels["vipDrinkTimes1"] = vipDrinkTime_num + config.drinkPage_freetimes.eat.times - data_.drinkTimes;
			} else {
				labels["vipDrinkTimes1"] = vipDrinkTime_num
			}
			
			// 一键换酒的花销
			labels["goldCost"] = String("X{0}").format(config.drinkPage_othercosts.top.diamond);
			
			// 普通换酒的花销
			var changeCount = data_.changeTimes;
			if (changeCount + 1 > 10) {
				changeCount = 9;
			}

			labels["gold2Cost"] = String("X{0}").format(config.drinkPage_changeWineCost[changeCount + 1].costw)
			
			var totalFreeTimes;
			for (var int = 0; int < getJsonLength(config.drinkPage_changeWineCost); int++) {
				if (config.drinkPage_changeWineCost[int + 1].costw > 0) {
					totalFreeTimes = int;
					break;
				}
			}
			
			var freeTimes = totalFreeTimes - data_.changeTimes;
			if (freeTimes < 0) {
				freeTimes = 0;
			}
			labels["todaysFreeTimesToChange"] = common.LocalizedString("daily_drinkWine_todaysFreeTimes", freeTimes);
			
			labels["numberOfTodaysCapGet"] = data_.capToday
			viewData["labels"] = labels;
			
			return viewData;
		},
		
		getMaxDrinkPoint : function(heroData) {
			var rankInfo = config.drinkPage_rank[heroData.rank];
			return Math.ceil(rankInfo.base + rankInfo.grow * (heroData.level - 1));
		},
		
		/**
		 * 获取喝酒页面英雄的显示数据
		 * @param heroData
		 * @return heroViewData
		 */
		getDrinkHeroViewData : function(heroData) {
			var heroViewData = {};
			heroViewData["frameImg"] = String("frame_{0}.png").format(heroData.rank);
			heroViewData["headImg"] = HeroModule.getHeroHeadById(heroData.heroId);
						
			var maxPointDrink = DailyDrinkModule.getMaxDrinkPoint(heroData);
			var curPointDrink = 0;
			if (heroData.pointDrink != null) {
				curPointDrink = heroData.pointDrink;
			}
			heroViewData["playersPotentialInfo"] = String("{0}/{1}").format(curPointDrink, maxPointDrink);
						
			return heroViewData
		},
		
		showHeroListAction : function(callBack, target) {
			var closeCallBack = function(index) {
				if (this.choseHeroView_ != null) {
					this.choseHeroView_ = null;
				}
				
				if (index >= 0) {
					var heroListData = DailyDrinkModule.getDrinkHero();;
					var heroData = heroListData[index];
					callBack.call(target, heroData);
				}
			}
			
			if (this.choseHeroView_ == null) {
				var heroListData = DailyDrinkModule.getDrikHeroListData();
				var params = {
						closeCallBack : closeCallBack,
						manager : this,
						viewData : heroListData
				};
				
				this.choseHeroView_ = new DrinkChooseHero(params);
				cc.director.getRunningScene().addChild(this.choseHeroView_);
			}
		},
		
		showCapExchangeView : function(callBack, target) {
			var closeCallBack = function(index) {
				if (DailyDrinkModule.capExchangeView_ != null) {
					DailyDrinkModule.capExchangeView_ = null;
				}
			}

			if (DailyDrinkModule.capExchangeView_ == null) {
				var capListData = DailyDrinkModule.getDrikCapExchangeListData();
				var viewData = {};
				viewData["data"] = DailyDrinkModule.getDrikCapExchangeData();
				viewData["capList"] = capListData;
				var params = {
						closeCallBack : closeCallBack,
						manager : this,
						viewData : viewData
				};

				DailyDrinkModule.capExchangeView_ = new DrinkExchangeCap(params);
				cc.director.getRunningScene().addChild(DailyDrinkModule.capExchangeView_);
			}
		},
		
		/**
		 * 瓶盖兑换
		 * @param int index 0开始 
		 * @returns
		 */
		doCapExchange : function(index) {
			var drinkData = activitydata.drinkInfo_;
			if (drinkData.capAll < config.drinkPage_buycap[index + 1].capPay) {
				common.ShowText(common.LocalizedString("daily_drinkW_Cap_lackOfCap"));
				return;
			}
			
			var onSuccess = function(dic) {
				if (DailyDrinkModule.capExchangeView_ != null) {
					var exchangeData = DailyDrinkModule.getDrikCapExchangeData();
					DailyDrinkModule.capExchangeView_.refreshView(exchangeData);
				}
				
				common.ShowText(common.LocalizedString("daily_drinkW_Cap_getRumble"));
			};

			dispatcher.doAction(ACTION.DAILY_CAP_EXCHANGE, [index + 1], onSuccess);
		},
		
		/**
		 * 获取所有可选英雄
		 */
		getDrinkHero : function(){
			var heros = HeroModule.getAllHeroes();
			return heros;
		},
		
		getDrikHeroListData : function() {
			var listData = [];
			var heros = DailyDrinkModule.getDrinkHero();
			for (var int = 0; int < heros.length; int++) {
				var hero = heros[int];
				var heroShowData = {};
				
				var viewLabel = {};
				heroShowData["labels"] = viewLabel;
				viewLabel["nameLabel"] = hero.name;
				viewLabel["level"] = hero.level;
				viewLabel["ifOnForm"] = hero.form == 1 ? common.LocalizedString("daily_drinkW_ChoseHero_onform") : "";
				viewLabel["AddedPoint"] = common.LocalizedString("daily_drinkW_ChoseHero_AddedPoint");

				var maxPointDrink = DailyDrinkModule.getMaxDrinkPoint(hero);
				var curPointDrink = 0;
				if (hero.pointDrink != null) {
					curPointDrink = hero.pointDrink;
				}
				viewLabel["playersPotentialInfo"] = String("{0}/{1}").format(curPointDrink, maxPointDrink);
				
				heroShowData["rank"] = hero.rank;
				heroShowData["breakLevel"] = hero["break"];
				heroShowData["frameImg"] = String("frame_{0}.png").format(hero.rank);
				heroShowData["headImg"] = HeroModule.getHeroHeadById(hero.heroId);
			
				listData.push(heroShowData);
			}
			
			return listData;
		},
		
		/**
		 * 获取瓶盖兑换页面数据
		 */
		getDrikCapExchangeData : function() {
			var capViewData = {};
			
			var drinkData = activitydata.drinkInfo_;
			capViewData["capToday"] = drinkData.capToday;
			capViewData["capAll"] = drinkData.capAll;
			
			return capViewData;
		},
		
		/**
		 * 获取瓶盖页面配置数据列表
		 */
		getDrikCapExchangeListData : function() {
			var changeList = new Array();
			
			var capConf = config.drinkPage_buycap;
			
			var conf = ItemModule.getItemResource("item_006");
			for (var int = 0; int < 4; int++) {
				var cellData = {};
				cellData["icon"] = conf.icon;
				cellData["capNum"] = String("X{0}").format(capConf[(int + 1)].capPay);
				cellData["count"] = capConf[(int + 1)].items.item_006;
				cellData["need"] = common.LocalizedString("daily_drinkW_Cap_need");
				cellData["rank"] = conf.rank;
				changeList.push(cellData);
			}
			
			return changeList;
		},
		
		/**
		 * 喝酒界面动作
		 * 
		 * @param drinkType int 1: 喝酒  2：换酒 3：一键换酒
		 * @target 回调的target
		 * @callBack 执行完网络请求的回调
		 * @params 附带请求参数
		 */

		doDrink : function(drinkType, target, callBack, params) {
			var data_ = activitydata.drinkInfo_;
			var vipDrinkTime = config.vip_config[PlayerModule.getVipLevel()].drinktimes;
			var vipDrinkTimeMax = config.vip_config[13].drinktimes;
			var drinkFreeTimes = config.drinkPage_freetimes.eat.times;
			
			if (data_.drinkTimes >= drinkFreeTimes + vipDrinkTimeMax) {
				// 已喝次数等于 免费+最大vip次数,提示明天再来
				common.ShowText(common.LocalizedString("daily_drinkWine_timesTotallyUsedUp"));
				return;
			}
			if (data_.drinkTimes >= drinkFreeTimes + vipDrinkTime) {
				// 已喝次数等于 免费+vip次数,提示是否充vip增加vip次数
				common.ShowText(common.LocalizedString("daily_drinkWine_timesUsedUp_UpVip"));
				return;
			}

			var maxPointDrink = DailyDrinkModule.getMaxDrinkPoint(params.heroData);
			var curPointDrink = 0;
			if (params.heroData.pointDrink != null) {
				curPointDrink = params.heroData.pointDrink;
			}
			
			if (curPointDrink >= drinkFreeTimes + maxPointDrink) {
				common.ShowText(common.LocalizedString("daily_drinkWine_pointBeyondMax"));
				return;
			}
			
			var doDrinkAction = function() {
				var onSuccess = function(dic) {
					var data_ = activitydata.drinkInfo_;
					traceTable("end   ", data_);
					callBack.call(target, dic);
				};

				traceTable("开始饮酒   ", params.heroData);
				dispatcher.doAction(ACTION.DAILY_DRING, [params.heroData.heroId], onSuccess);
			};
			
			var doChangeAction = function() {
				var onSuccess = function(dic) {
					var data_ = activitydata.drinkInfo_;
					// 更新英雄数据
					callBack.call(target, dic);
				};

				dispatcher.doAction(ACTION.DAILY_CHANGE_WINE, [], onSuccess);
			};
			
			var doOneKeyChangeAction = function() {
				var onSuccess = function(dic) {
					traceTable("one key change success ", dic);
					callBack.call(target, dic);
				};

				dispatcher.doAction(ACTION.DAILY_CHANGE_ONE_KEY, [], onSuccess);
			};

			if (data_.drinkTimes >= drinkFreeTimes) {
				// 已喝次数大于免费次数,但是还有vip次数可用
				if (drinkType == 1) {
					// 玩家按下了喝酒按钮
					var text = null;
					if (ItemModule.getItemCount("item_024") > 0) {
						// 有醒酒茶
						text = common.LocalizedString("daily_drinkWine_freeTimesUsedUp_useBag");
					} else {
						text = common.LocalizedString("daily_drinkWine_freeTimesUsedUp_buy", config.drinkPage_othercosts.tea.diamond);
					}
					var cb = new ConfirmBox({info:text, confirm:function(){
						doDrinkAction();
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
					
					return;
				} else {
					// 只提醒一次 没提醒过的话提醒一下
					if ( !target.haveWarned ) {
						
					} else {
						switch (drinkType) {
						case 2:
							doChangeAction();
							break;

						case 3:
							doOneKeyChangeAction();
							break;
						}
						
						return;
					}
				}
			}
			
			switch (drinkType) {
			case 1:
				doDrinkAction();
				break;
			case 2:
				cc.log("doChangeAction");
				doChangeAction();
				break;

			case 3:
				cc.log("doOneKeyChangeAction");
				doOneKeyChangeAction();
				break;
			}
		},
		
		/**
		 * 获取饮酒页面帮助描述
		 * 
		 * @return Array
		 */
		getDrinkHelpDesc : function() {
			var conf = config.drinkPage_adout;
			
			var tips = new Array();
			
			for ( var key in conf) {
				var tip = conf[key].talk;
				tips.push(tip);
			}
			
			return tips;
		}
}