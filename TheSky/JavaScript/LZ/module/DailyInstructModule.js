/**
 *   高人特训
 */
var DailyInstructModule = {
		/**
		 * 获取单人特训数据
		 */
		
		fetchSingleInstructData : function() {
			
			var onSuccess = function(dic) {
			};

			var onError = function(dic) {
			};
			dispatcher.doAction(ACTION.DAILY_Instruct_List_EXCHANGE, [], onSuccess, onError);
		},
		
		getSingleInstructData : function() {
			var data = activitydata.getSingleInstructData();
			
			var viewData = new Array();
			
			for ( var key in data) {
				var cellData = data[key];
				var oneHero = {};
				oneHero["id"] = cellData.id;
				oneHero["instructId"] = cellData.instructId;
				oneHero["beginTime"] = cellData.beginTime;
				oneHero["cacheHeroId"] = cellData.cacheHeroId;
				oneHero["heroId"] = cellData.instructIcon;
				
				var heroConf = HeroModule.getHeroConfig(oneHero["heroId"]);
				oneHero["conf"] = heroConf;
				
				oneHero["frameImg"] = String("frame_{0}.png").format(heroConf.rank);
				oneHero["rankBgImg"] = String("rank_head_bg_{0}.png").format(heroConf.rank);
				oneHero["headImg"] = HeroModule.getHeroHeadById(heroConf.heroId);
				
				viewData.push(oneHero);
			}
			
			return viewData;
		}, 
		
		/**
		 * 进行单人特训
		 */
		doSingleInstruceAction : function(index) {
//			var instructResult = {
//					hero : "hero_000108",
//					heros : ["hero5684e86d3f95e", "hero5684e86d3f95e"],
//					exp : 100,
//					type : 2
//			}
//			DailyInstructModule.showInstructResultView(instructResult);
//			return;
			
			var data = DailyInstructModule.getSingleInstructData()
			
			var instructInfo = data[index];
			
			if (instructInfo != null) {

				var beginTime = instructInfo.beginTime;
				var endTime = beginTime + instructInfo.instructId * 60 * 60;
				instructInfo["endTime"] = endTime;
				
				if (Global.serverTime >= endTime) {
					/**
					 * 倒计时完成，直接进入人物选择页面
					 */
					DailyInstructModule.showHeroListAction(this.onSelectHeroEnd, this, instructInfo);
				} else {
					/**
					 * 显示倒计时界面
					 */
					var params = {
							callBack : this.onCDViewChange,
							instructInfo : instructInfo,
							target : this,
					}
					DailyInstructModule.showSingleCDViewAction(params);
				}
			}
		},
		
		/**
		 * 显示结果特训结果页
		 * @param instructResult
		 */
		showInstructResultView : function(instructResult) {
			var layer = null;
			switch (instructResult.type) {
			case 1:
				layer = new InstructSingleResultView({});
				break;

			default:
				layer = new InstructGroupResultView({});
			break;
			}

			var viewData = {};

			var heroDatas = new Array();

			for (var int = 0; int <  getJsonLength(instructResult.heros); int++) {
				var uid = instructResult.heros[int];
				var hero = HeroModule.getHeroByUid(uid);
				
				var cfg = HeroModule.getHeroConfigById(hero.heroId);
				hero["levelOri"] = HeroModule.getHeroLevel(cfg.exp, hero.exp -instructResult.exp );
				
				heroDatas.push(hero);
			}
			viewData["heros"] = heroDatas;

			var expAll = instructResult.exp;
			viewData["exp"] = expAll;
			
			viewData["hero"] = HeroModule.getHeroConfigById(instructResult.icon) ;

			layer.refreshView(viewData);
			
			cc.director.getRunningScene().addChild(layer);
		},
		
		doInstructNetworkAction : function(instructId, type, heroUid) {
			var onSuccess = function(dic) {
				traceTable("特训结果页面 ", dic);
				if (dic.info.instructResult) {
					DailyInstructModule.showInstructResultView(dic.info.instructResult);
				}
			};

			var onError = function(dic) {
			};
			
			var param = [];
			if (heroUid != null) {
				param = [instructId, type, heroUid];
			} else {
				param = [instructId, type];
			}

			dispatcher.doAction(ACTION.DAILY_Instruct_Use_EXCHANGE, param, onSuccess, onError);
		},
		
		// 英雄选择页面回调
		onSelectHeroEnd : function(hero, instructInfo) {
			var params = {
					callBack : this.onCDViewChange,
					instructInfo : instructInfo,
					target : this,
					heroUid : hero.id
			}
			DailyInstructModule.showSingleCDViewAction(params);

		}, 
		
		getSingleInstructCDTime : function(endTime) {
			var lastTime = endTime - Global.serverTime;
			if (lastTime > 0) {
				return DateUtil.second2hms(lastTime);
			}
			return null;
		},
		
		doHeroChoseShow : function(instructInfo) {
			DailyInstructModule.showHeroListAction(this.onSelectHeroEnd, this, instructInfo);
		},
		
		showHeroListAction : function(callBack, target, instructInfo, heroUid) {
			var closeCallBack = function(index) {
				if (this.choseHeroView_ != null) {
					this.choseHeroView_ = null;
				}

				if (index >= 0) {
					var heroListData = HeroModule.getNotFullLevelHeroes();
					var heroData = heroListData[index];
					callBack.call(target, heroData, instructInfo);
				}
			}

			if (this.choseHeroView_ == null) {
				var heroListData = DailyInstructModule.getInstructHeroListData();
				var params = {
						closeCallBack : closeCallBack,
						manager : this,
						viewData : heroListData
				};

				this.choseHeroView_ = new InstructHeroChooseView(params);
				cc.director.getRunningScene().addChild(this.choseHeroView_);
			}
		},
		
		// cd回调
		onCDViewChange : function(instructId, instructType, heroUid) {
			if (this.singleCDView_ != null) {
				this.singleCDView_ = null;
			}
			
		},
		
		/**
		 * @params callBack, target, instructInfo, heroUid
		 */
		showSingleCDViewAction : function(params) {
			
			if (params.instructInfo == null) {
				return;
			}

			if (this.singleCDView_ == null) {
				var result = {
						closeCallBack : this.onCDViewChange,
						manager : this,
						viewData : params.instructInfo,
						heroUid : params.heroUid
				};

				this.singleCDView_ = new InstructSingleCDView(result);
				cc.director.getRunningScene().addChild(this.singleCDView_);
			}
			
			if (params.heroUid != null) {
				this.singleCDView_.setHeroId(params.heroUid);
			}
		},
		
		
		/**
		 * 获取单人特训可特训的英雄列表
		 */
		getInstructHeroListData : function() {
			var heroListData = HeroModule.getNotFullLevelHeroes();
			
			var displayData = new Array();
			
			for (var int = 0; int < heroListData.length; int++) {
				var heroData = heroListData[int];
				var displyHero = {}
				
				displyHero["frame"] = String("frame_{0}.png").format(heroData.rank);
				displyHero["head"] = HeroModule.getHeroHeadById(heroData.heroId);
				displyHero["name"] = heroData.name;
				displyHero["rank"] = String("rank_{0}_icon.png").format(heroData.rank);
				displyHero["exp"] = String("{0}/{1}").format(heroData.expNow, heroData.expMax);
				displyHero["level"] = String("LV：{0}").format(heroData.level);
				
				displayData.push(displyHero);
			}
			
			return displayData;
		}, 
		
		
		/**
		 * 群组特训
		 */
		
		getGroupInstructData : function(uid){
			var data = null;
			if (uid != null) {
				data = activitydata.getGroupInstructDataById(uid);
			} else {
				data = activitydata.getGroupInstructDataAboutIndex()
			}

			var viewData = {};
			var heroId = data["data"].instructIcon;
			var heroConf = HeroModule.getHeroConfigById(heroId);
			viewData["uid"] = data.uid
			viewData["headBg"] = String("rank_head_bg_{0}.png").format(heroConf.rank);
			viewData["frame"] = String("frame_{0}.png").format(heroConf.rank);
			viewData["head"] = HeroModule.getHeroHeadById(heroConf.heroId);
			var beginTime = data["data"].beginTime;
			var endTime = beginTime + data["data"].instructId * 60 * 60;
			viewData["endTime"] = endTime;

			if (config.gifted_dianbo[heroConf.heroId] != null) {				
				viewData["cdSayLabel"] = config.gifted_dianbo[heroConf.heroId].desp1;
			} else {
				viewData["cdSayLabel"] = "";
			}
			
			if (config.gifted_dianbo[heroConf.heroId] != null) {				
				viewData["resultSayLabel"] = config.gifted_dianbo[heroConf.heroId].desp2;
			} else {
				viewData["resultSayLabel"] = "";
			}
			
			var param = data["data"]["param"];
			viewData["expLabel"] = String(common.LocalizedString("上阵伙伴获得%d点经验")).format(param.exp);
			var item = ItemModule.getItemConfig(param.itemId);
			viewData["itemLabel"] = String(common.LocalizedString("奉上%d碗%s，得双倍经验。")).format([param.amount, item.name]);
			viewData["cdTips"] = String(common.LocalizedString("特训倒计时结束后，谢谢前辈，即可让所有上阵伙伴获得%d经验")).format(param.exp);
			
			return viewData;
		}
};