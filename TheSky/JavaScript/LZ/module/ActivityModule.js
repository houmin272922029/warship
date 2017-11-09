var ActivityModule = {

		/**
		 * 吃体力类型
		 */
		EatType : {
			NormalEat1 : 1,   // 普通12 ~ 13
			NormalEat2 : 2,   // 普通18 ~ 19
			GoldEat1 : 3,     // 额外金币吃
			GoldEat2 : 4,
		},
		
		fetchActivityList : function(param, successCallBack, errorCallBack) {
			dispatcher.doAction(ACTION.DAILY_LIST, param, successCallBack, errorCallBack);
		},
		
		getActivityList : function() {
			return activitydata.dailyList_;
		},
		
		/**
		 * 体力数据
		 */
		getEatOiginalData : function(param, successCallBack, errorCallBack) {
			var onSuccess = function(dic) {
				if (typeof successCallBack == "function") {
					successCallBack();
				}
			};
			
			var onError = function(dic) {
				if (typeof errorCallBack == "function") {
					errorCallBack();
				}
			};
			dispatcher.doAction(ACTION.DAILY_EAT_INFO, param, onSuccess, onError);
		},
		
		/**
		 * 组装体力视图数据
		 * @param type
		 */
		getEatViewData : function(type) {
			var eatData = {};
			var soureData = activitydata.dayEnergy_;
			eatData.status1 = 0       // 当前时间是否在第一顿饭的时间内  0：时间没到 1：时间到了 2：时间过了
			eatData.status2 = 0       // 当前时间是否在第二顿饭的时间内  0：时间没到 1：时间到了 2：时间过了
			
			var eatConf = config.everydayEnergy_openTime;
			var serverTime = Global.serverTime;
			
			var getTimeNum = function(timeStr) {
				var numArray = timeStr.split(":");
				return numArray[0];
			}

			for (var int = 1; int <= 2; int++) {
				var openTime = soureData.openTime["begin" + int];
				var endTime	= openTime + eatConf.keep;
				
				if (serverTime < openTime) {
					eatData["status" + int] = 0;
				} else if (serverTime <= endTime) {
					eatData["status" + int] = 1;
				} else {
					eatData["status" + int] = 2;
				}
				
				var keepTime = Math.floor(eatConf.keep / 3600); 
				eatData["timeLabel" + int] = String("({0}~{1}:00)").format([eatConf[("begin" + int)], parseInt(keepTime) + parseInt(getTimeNum(eatConf[("begin" + int)]))]);
			}
			
			var freeEatStatus = soureData.freeEatStatus;
			eatData.isShowExtra = false;
			for (var int2 = 1; int2 <= 2; int2++) {
				if (eatData["status" + int2] == 1 && freeEatStatus["begin" + int2] >= 0) {
					// 还处于可吃时间并且已经吃了免费的
					eatData.isShowExtra = true;
				}
			}
			
			if (eatData.isShowExtra) {
				var extraConf = config.everydayEnergy_extra;
				// 显示额外购买页
				var diamondEatStatus = soureData.diamondEatStatus;
				for (var int = 1; int <= 2; int++) {
					eatData["diamondBtnStatus" + int] = diamondEatStatus["begin" + int] >= 0;
					eatData["str" + int] = extraConf.diamond["extraEnergy" + int];
					eatData["gold" + int] = extraConf.energy["extraEnergy" + int];
					eatData["vip" + int] = extraConf.VIPLimit["extraEnergy" + int];
				}
			}

			return eatData;
		},
		
		/**
		 * 点击吃体力
		 * @param eatType 类型
		 */
		doEatAction : function(eatType, successCallBack, errorCallBack) {
			var eat;
			
			if (eatType == ActivityModule.EatType.GoldEat1 || eatType == ActivityModule.EatType.GoldEat2) {
				var extraConf = config.everydayEnergy_extra;
				var vipLimit  = extraConf.VIPLimit["extraEnergy" + (eatType - 2)];
				var goldLimit = extraConf.energy["extraEnergy" + (eatType - 2)];
				
				if (PlayerModule.getVipLevel() < vipLimit) {
					common.ShowText(common.LocalizedString("extra_vip", vipLimit));
					return;
				}
				
				if (PlayerModule.getGold() < goldLimit) {
					cc.log(common.LocalizedString("ERR_1101"));
					common.ShowText(common.LocalizedString("ERR_1101"));
					// 添加金币购买弹窗
					return;
				}
			}
			
			switch (eatType) {
			case ActivityModule.EatType.NormalEat1:
				eat = "freeEnergy";
				break;
			case ActivityModule.EatType.NormalEat2:
				eat = "freeEnergy";
				break;
			case ActivityModule.EatType.GoldEat1:
				eat = "extraEnergy1";
				break;
			case ActivityModule.EatType.GoldEat2:
				eat = "extraEnergy2";
				break;

			default:
				break;
			}
			
			var onSuccess = function(dic) {
				traceTable("吃体力  ", dic)
				if (typeof successCallBack == "function") {
					successCallBack();
				}
			};

			var onError = function(dic) {
				if (typeof errorCallBack == "function") {
					errorCallBack();
				}
			};
			
			dispatcher.doAction(ACTION.DAILY_EAT_ACTION, [eat], onSuccess, onError);
		},
		
		/**
		 * 邀请数据
		 * @param param
		 */
		fetchInviteData : function() {
			var onSuccess = function(dic) {

			};
			
			var onError = function(dic) {

			};
			
			dispatcher.doAction(ACTION.DAILY_INVITE_INFO, [], onSuccess, onError);                            
		},
		
		/**
		 * 获取邀请页面视图数据
		 */
		getInvitationData : function() {
			var viewData = {};
			
			var data = activitydata.invitation_;
			
			// 自己是否已经输入过邀请码
			viewData["isInvited"] = false;
			if (data.accept) {
				viewData["isInvited"] = true;
			}
			
			// 自己的邀请码
			viewData["selfCode"] = data.code;
			
			// 接受自己邀请的数目
			viewData["acceptCount"] = 0;
			if (data.invited) {
				viewData["acceptCount"] = getJsonLength(data.invited);
			}
			
			var arrayContainValue = function(array, value) {
				for (var int = 0; int < array.length; int++) {
					if (array[int] == value) {
						return true;
					}
				}
				return false;
			}
			
			// 拼装奖励列表和领状态
			var rewardConf = config.invitation_Award;
			var rewardList = new Array();
			
			var keyArray = ["1", "3", "5", "10", "15"]
			
			
			for (var int2 = 0; int2 < keyArray.length; int2++) {
				var rewardCount = keyArray[int2];
				var oneItem = {};
				oneItem["count"] = rewardCount;
				oneItem["items"] = new Array();
				oneItem["lackCount"] = rewardCount >= viewData["acceptCount"] ? rewardCount - viewData["acceptCount"]: 0;
				
				if (oneItem["lackCount"] > 0) {
					oneItem["state"] = 3;   // 不可领
				} else {
					
					if (data.period != null && arrayContainValue(data.period, rewardCount)) {
						oneItem["state"] = 2; // 已领取 
					} else {
						oneItem["state"] = 1; // 可以领取
					}
				}
				
				
				for (var int = 0; int < getJsonLength(rewardConf[rewardCount].items); int++) {
					var item = rewardConf[rewardCount].items[int];
					var itemId = item.itemId;
					
					var view = {};
					view["amount"] = item.amount;
					view["name"] = item.name;
					view["view"] = ItemModule.getItemResource(itemId);
					
					oneItem["items"].push(view);
				}
				
				if (oneItem["state"] != 2) {
					rewardList.push(oneItem);
				}
			}
			
			viewData["rewardList"] = rewardList;
			
			return viewData;
		},
		
		/**
		 * 显示奖励列表
		 */
		showInvitionReswardView : function(viewData) {
			if (viewData.state == 1) {
				// 可领，直接领取
				var onSuccess = function(dic) {
				};

				var onError = function(dic) {
				};

				dispatcher.doAction(ACTION.DAILY_INVITE_GET_REWARD, [viewData.count], onSuccess, onError); 
			} else {
				// 不可领，显示一个预览列表
				var view = new DailyInviationPreViewLayer({viewData : viewData});
				cc.director.getRunningScene().addChild(view);
			
				common.ShowText(common.LocalizedString("daily_invite_inviteNumNotEnough"));
			}
		},
		
		/**
		 * 接受邀请
		 */
		acceptInvitation : function(inviteCode) {
			var onSuccess = function(dic) {
				common.ShowText("daily_invite_getRewardSuccess");
			};

			var onError = function(dic) {
//				common.ShowText("daily_invite_getRewardFailed");
			};

			dispatcher.doAction(ACTION.DAILY_INVITE_ACCEPT, [inviteCode], onSuccess, onError); 
		},
		
		/**
		 * 亲吻人鱼
		 */
		
		fetchKissMermaidData : function(param, successCallBack, errorCallBack) {
			var onSuccess = function(dic) {
				if (typeof successCallBack == "function") {
					successCallBack();
				}
			};

			var onError = function(dic) {
				if (typeof errorCallBack == "function") {
					errorCallBack();
				}
			};     
			dispatcher.doAction(ACTION.DAILY_KISS_MERMAID, param, onSuccess, onError);
		},
		
		getKissMermaidData : function() {
			var data_ = activitydata.killMermaid_;
			var mermaidData = {};
			mermaidData["days"] = data_.days;
			mermaidData["successionDays"] = data_.successionDays;
			mermaidData["isKissToday"] = data_.isKissToday;
			return mermaidData;
		},
		
		kissMermaidAction : function(target, successCallBack, errorCallBack){
			
			var data_ = ActivityModule.getKissMermaidData();

			if (data_.isKissToday == 1) {
				var random = common.getRandomNum(0, 2);
				var tipArray = [common.LocalizedString("不要再占公主便宜啦！"),
				                common.LocalizedString("公主害羞了，放过她吧！"),
				                common.LocalizedString("亲多了公主会生气哦！"),];
				common.ShowText(tipArray[random]);
				return;
			} else {
				var onSuccess = function(dic) {
					traceTable("亲吻结果  ", dic);
					if (typeof successCallBack == "function") {
						successCallBack.call(target, dic);
					}
				};
				
				var onError = function(dic) {
					if (typeof errorCallBack == "function") {
						errorCallBack.call(target, dic);
					}
				};
				dispatcher.doAction(ACTION.DAILY_KISS, [], onSuccess, onError);	
			}
			
		},
		
		/**
		 * 获取签到数据
		 */
		fetchSignInData : function() {
			var onSuccess = function(dic) {
//				if (typeof successCallBack == "function") {
//					successCallBack();
//				}
			};

			var onError = function(dic) {
//				if (typeof errorCallBack == "function") {
//					errorCallBack();
//				}
			};
			dispatcher.doAction(ACTION.DAILY_GET_SIGNIN_DATA, [], onSuccess, onError);
		},
		
		getSignInData : function() {
			var viewData = {};
			var data = activitydata.signIn_;

			var month = data.month;
			var conf = config["OL_SignIn_reward_" + month];
			
			var getRewardCount = getJsonLength(data.signInRecord);
			var supplCount = 0;
			
			var tday = true;
			if (data["tday"] == 0) {
				tday = false;
			}
			
			if (tday) {
				supplCount = data.day - getRewardCount;
			} else {
				supplCount = data.day - getRewardCount - 1;
			}
			
			viewData["getRewardCount"] = getRewardCount;
			viewData["supplCount"] = supplCount;
			
			viewData["list"] = new Array();

			for (var int = 0; int < getJsonLength(conf); int++) {
				var cell = {};
				viewData["list"].push(cell);
				
				if (data.signInRecord[int+1] != null) {
					cell["signIn"] = data.signInRecord[int+1];
					
				}
				cell["conf"] = conf[int+1];
				var itemId = conf[int+1].rewardsID;
				var itemCount = conf[int+1].quantity;
				
				cell["view"] = ItemModule.getItemResource(itemId);
				cell["view"].count = itemCount;
				
				var rate = 1;
				var doubledVipLevel = 0;
				var count = getJsonLength(cell["conf"]);
				for (var int2 = 0; int2 < (count - 2); int2++) {
					if (cell["conf"]["VIP" + int2] && cell["conf"]["VIP" + int2] > rate) {
						rate = cell["conf"]["VIP" + int2];
						doubledVipLevel = int2;
					}
				}
				
				cell["rate"] = rate;
				cell["doubledVipLevel"] = doubledVipLevel;
				
				cell["day"] = int+1;  // 是第几天
				
				var state = 0;    // 0 过期 1 当天未签可领 2 补签可领 3 VIP补领奖 4 不可签到 5 当天已签到，但不存在补签次数
				if (int < getRewardCount) {
					var record = data.signInRecord[int+1];
					if (rate > record.mul) {
						if (DateUtil.beginDay(record.time) == DateUtil.beginDay(data.lastTime)) {
							state = 3;
						} else {
							state = 0;
						}
					} else {
						state = 0;
					}
				} else {
					if ((int + 1) == (getRewardCount + 1)) {
						if (!tday) {
							state = 1;
						} else if (supplCount > 0) {
							state = 2
						} else {
							state = 5;
						}
					} else {
						state = 4;
					}
				}
				
				cell["state"] = state;
			}
						
			return viewData;
		},
		
		showDailySiginPopView : function(data) {
			if (this.dailySiginPopview_ != null) {
				this.dailySiginPopview_ = null;
			}
			var closeCallBack = function(index) {
				if (DailyDrinkModule.dailySiginPopview_ != null) {
					DailyDrinkModule.dailySiginPopview_ = null;
				}
			}
			
			var params = {};
			params["viewData"] = data;
			params["manager"] = this;
			params["closeCallBack"] = closeCallBack;
			
			this.dailySiginPopview_ = new DailySiginPopView(params);
			cc.director.getRunningScene().addChild(this.dailySiginPopview_);
		},
		
		onSiginPopViewConfirmTaped : function(viewData) {

			var state = viewData["state"];
			
			var data = activitydata.signIn_;
			var month = data.month;

			var getRewardCount = getJsonLength(data.signInRecord);
			var supplCount = 0;

			var tday = true;
			if (data["tday"] == 0) {
				tday = false;
			}

			if (tday) {
				supplCount = data.day - getRewardCount;
			} else {
				supplCount = data.day - getRewardCount - 1;
			}
			
			switch (state) {
			case 1:
				// 正常签到
				ActivityModule.doSignorSupplSigninAction(1);
				break;

			case 3:
				if (PlayerModule.getVipLevel() >= viewData["doubledVipLevel"]) {
					//"玩家vip等级大于领取双倍等级"
					// 直接补签 			
					ActivityModule.doSignorSupplSigninAction(2, viewData.day);
				} else {
					// 打开充值页面
					cc.director.getRunningScene().addChild(new RechargeLayer());
				}

				break;

			default:
				if (PlayerModule.getVipLevel() <= 0) {
					// 打开充值页面
					cc.director.getRunningScene().addChild(new RechargeLayer());
					break;
				}
			
				var price = config["OL_SignIn_Price"][data.supplTimes + 1].diamond;
				var text = common.LocalizedString("Daily_signInSpent", price);
				var cb = new ConfirmBox({info:text, type:0, confirm:function() {
					if (PlayerModule.getGold() < price) {
						// 打开充值页面
						cc.director.getRunningScene().addChild(new RechargeLayer());
					} else {
						ActivityModule.doSignorSupplSigninAction(2, viewData.day);
					}
				}.bind(this), close:function(){
				}.bind(this)});
	
				cc.director.getRunningScene().addChild(cb);

				break;
			}
		},
		
		/**
		 * 签到 或者 补签
		 * 
		 * @params signType int
		 * 		 1 签到
		 *	 	 2 补签
		 * @params day 补签的是第几天，可以为空
		 */ 
		doSignorSupplSigninAction : function(signType, day) {
			var actionUrl;
			var params = [];
			
			switch (signType) {
			case 1:
				actionUrl = ACTION.DAILY_SIGNIN;
				break;

			default:
				actionUrl = ACTION.DAILY_SUPER_SIGNIN;
				params = [day];
				break;
			}
			
			var onSuccess = function(dic) {
				trace("结果   ", dic);
			};

			var onError = function(dic) {

			};

			dispatcher.doAction(actionUrl, params, onSuccess, onError);
		},
		
		/**
		 * 获取升级送礼数据
		 */
		fetchLevelUpData : function() {
			var onSuccess = function(dic) {
			};

			var onError = function(dic) {
			};
			dispatcher.doAction(ACTION.DAILY_LEVELUP_GIFT_GET_INFO, [], onSuccess, onError);
		},
		
		/**
		 * 组合升级送礼页面视图数据
		 */
		getLevelUpMainData : function() {
			var viewData = new Array();
			
			var data = activitydata.levelUpGift_;
			var conf = config.upgrade_reward1;
			viewData.push({});   // 添加一条空数据，用于顶部描述cell
			
			for ( var levelKey in conf) {
				var cellData = {};
				cellData["level"] = levelKey;
				cellData["isGet"] = false;
				if (data.records[levelKey] && data.records[levelKey] != 0) {
					cellData["isGet"] = true;
				}
				cellData["VIP"] = conf[levelKey].VIP ? conf[levelKey].VIP: null;
				cellData["diamond"] = conf[levelKey].diamond;
				cellData["isCondition"] = false;     // 是否可以领取
				
				var playerLevel = PlayerModule.getLevel();
				if (playerLevel >= levelKey) {
					cellData["isCondition"] = true;
				}
				
				viewData.push(cellData);
			}
									
			return viewData;
		},
		
		doGetLevelUpRewardAction : function (level){
			var onSuccess = function(dic) {
			};

			var onError = function(dic) {
			};
			dispatcher.doAction(ACTION.DAILY_LEVELUP_GET_REWARD, [level], onSuccess, onError);
		},
		
		/**
		 * 获取月卡数据
		 */
		fetchMonthCardData:function(){
			var onSuccess = function(dic) {
			};

			var onError = function(dic) {
			};
			dispatcher.doAction(ACTION.DAILY_CASH_MONTHLIST, [], onSuccess, onError);		},
		
		/**
		 * 组合月卡页面数据
		 */
		getMonthData : function() {
			var viewData = new Array();
			
			var data = activitydata.monthCard_;
			var conf = new Array(); ;
			
			// 拼装无限月卡数据
			for ( var key in config.cashShop_items) {
				var value = config.cashShop_items[key];
				if (value.type == 3 || value.type == 2) {
					conf.push(value);
				}
			}
			
			conf.sort(function(a, b) {
				return a.sort > b.sort;
			})
			
			for ( var key in conf) {
				var oneCell = {};
				var value = conf[key];
				oneCell["name"] = value.name;
				oneCell["dayAward"] = value.dayAward.diamond;
				oneCell["priceShow"] = value.priceShow;
				oneCell["alreadyBuyDay"] = data.existDays || 0;
				oneCell["remainDays"] = data.remainDays || 0;
				oneCell["status"] = data.status[value.itemId];
				oneCell["cardType"] = value.type;
				oneCell["itemId"] = value.itemId;
				
				viewData.push(oneCell);
			}
			
			return viewData;
		}, 
		
		/**
		 * 进行月卡操作
		 */
		doMonthCardOperation : function(data) {
			if (data == null) {
				return;
			}
						
			switch (data.status) {
			case 1:
				// 1可以买
				var onSuccess = function(dic) {
				};
				
				var onError = function(dic) {
				};
				
				function BuyMonthCard() {
					// 执行购买月卡动作
//					dispatcher.doAction(ACTION.DAILY_CASH_GAINMONTHCARD, [data.itemId], onSuccess, onError);
				}
				
				if (data.cardType == 3) {
					// 无限月卡
					// 先判断是否可以买
					var onIsBuySuccess = function(dic) {
						if (dic.code == 200 && dic.info.unlimitCard == 1) {							
							BuyMonthCard();
						}
					};

					var onIsBuyError = function(dic) {
					};
					dispatcher.doAction(ACTION.DAILY_IS_BUY, [data.itemId], onIsBuySuccess, onIsBuyError);
				} else {
					BuyMonthCard();
				}
					
				break;
			case 2:
				// 2不可以买
				common.ShowText(common.LocalizedString("月卡不可以买"));
				break;
			case 3:
				// 3可以领
				var onSuccess = function(dic) {
				};
	
				var onError = function(dic) {
				};
	
				if (data.cardType == 3) {
					// 无限月卡
					dispatcher.doAction(ACTION.DAILY_CASH_GAIN_UNLIMIT, [], onSuccess, onError);
				} else {
					dispatcher.doAction(ACTION.DAILY_CASH_GAINMONTHCARD, [], onSuccess, onError);
				}
				break;
			case 4:
				// 4不可以领
				common.ShowText(common.LocalizedString("已经领取"));
				break;

			default:
				break;
			}
		}
};









