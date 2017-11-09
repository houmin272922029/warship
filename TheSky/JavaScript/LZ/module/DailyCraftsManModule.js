/**
 * 工坊逻辑处理Module
 */
var DailyCraftsManModule = {
		/**
		 * 当前选择待分解的装备列表
		 */
		
		/**
		 * 当前准备制造的装备id
		 */
		currentMadeEquipId : null,
		
		/**
		 * 获取帮助内容
		 */
		getCraftsManHelpDesc : function() {
			var conf = config.equip_message;

			var tips = new Array();

			for ( var key in conf) {
				var tip = conf[key].say;
				tips.push(tip);
			}

			return tips;
		},
		
		/**
		 * 切换视图
		 */
		// 当前视图状态  0:工坊主页  1:分解页面  2:制造页面
		viewState : 0,
		
		/**
		 * 前往视图
		 * 
		 * @param int state  视图状态索引
		 */
		gotoView : function(state) {
//			if (state == this.viewState) {
//				return;
//			}
			this.viewState = state;
			postNotifcation(NOTI.DAILY_CREAFTS_MAN_CHANGE_VIEW, state);	
		},
		
		/**
		 * 获取工坊原始数据
		 */
		fetchCraftsManData : function() {
			var onSuccess = function(dic) {
			};

			var onError = function(dic) {
			};
			dispatcher.doAction(ACTION.DAILY_GET_CRAFTS_MAN_DATA, [], onSuccess, onError);
		},
		
		/**
		 * 获取全部视图数据
		 */
		getCraftsManData : function() {
			var viewData = {};
			
			viewData["main"] = DailyCraftsManModule.getMainData();
			viewData["deComposeData"] = DailyCraftsManModule.getDecomposeData();
			viewData["composeData"] = DailyCraftsManModule.getComposeData();

			return viewData;
		},
		
		getMainData : function() {
			return {};
		},
		
		/*
		 * 获取分解视图的数据
		 */
		getDecomposeData : function() {

			var viewData = {}
			var equipList = new Array();
			
			this.decomposeEquipIdList = this.decomposeEquipIdList || new Array();
			if (this.decomposeEquipIdList.length > 0) {
				for (var int = 0; int < this.decomposeEquipIdList.length; int++) {
					var eid = this.decomposeEquipIdList[int];
					if (int <= 2) 
					{
						var equip = EquipModule.getEquip(eid);
						equipList.push(equip);
					}
				}
			}
						
			// 得到品质最好的装备
			var bestEquip = equipList[0];
			for (var int2 = 1; int2 < equipList.length; int2++) {
				var equip = equipList[int2];
				if (equip.rank > bestEquip.rank) {
					bestEquip = equip;
				}
				
				if (equip.rank == bestEquip.rank && equip.silver > bestEquip.silver) {
					bestEquip = equip;
				}
			}
			viewData["equip"] = bestEquip;
			
			viewData["amount"] = equipList.length;
			
			return viewData;
		},
		
		/*
		 * 获取制造页面数据
		 */
		getComposeData : function() {
			var viewData = {};
			
			if (this.currentMadeEquipId != null) {
				var equip = {};
				var conf = EquipModule.getEquipConfig(this.currentMadeEquipId);
				var madeConf1 = config.equip_made1;
				var madeConf2 = config.equip_made2;
				
				var equipMadeConf;
				
				if (madeConf1[this.currentMadeEquipId] != null) {
					equipMadeConf = madeConf1[this.currentMadeEquipId]
				}
				
				if (madeConf2[this.currentMadeEquipId] != null) {
					equipMadeConf = madeConf2[this.currentMadeEquipId]
				}
				
				equip.madeConf = equipMadeConf;
				equip["conf"] = conf;
				
				viewData["equip"] = equip;
			}
			
			// 可以制造的材料
			var materialArray = new Array();
			materialArray.push("whitecost");
			materialArray.push("greencost");
			materialArray.push("bluecost");
			materialArray.push("purplecost");
			materialArray.push("purplecostes");
			
			var material = new Array();
			for (var int = 0; int < materialArray.length; int++) {
				var item = {}
				var itemId = config.equip_compoundItems[materialArray[int]].itemId;
				var amount = ItemModule.getItemCount(itemId);
				var conf = ItemModule.getItemConfig(itemId);
				traceTable(itemId, conf);
				item["amount"] = amount;
				item["conf"] = conf;
				item["rank"] = int + 1;
				material.push(item);
			}
			
			viewData["material"] = material;

			return viewData;
		},
		/**
		 * 获取一个视图的所有数据
		 * 
		 * @param index 视图索引
		 */
		getViewData : function(index) {
			var viewData = {};
			
			return viewData;
		},
		
		/**
		 * 获取分解装备选择列表
		 */
		getDecomposeListData : function() {
			// 所有未穿装备
			return EquipModule.getNotOnEquips();;
		},
		
		/**
		 * 制作装备列表
		 */
		getComposeListData : function() {
			// 配置中made1 加上 按月份的made2
			var viewData = new Array();

			var conf1 = config.equip_made1;
			var conf2 = config.equip_made2;

			for ( var cid in conf1) {
				var item = {};
				item.cfg = EquipModule.getEquipConfig(cid);
				item.info = conf1[cid];
				viewData.push(item);
			}
			
			for ( var cid in conf2) {
				var item = {};
				if (conf2.team == activitydata.craftsman_.currMonth) {
					var item = {};
					item.cfg = EquipModule.getEquipConfig(cid);
					item.info = conf2[cid];
					viewData.push(item);
				}
			}
			
			var materialType = new Array("whitecost", "greencost", "bluecost", "purplecost", "purplecostes");
			var materialCountArray = {};    // 当前拥有的所有材料数目
			for (var int = 0; int < materialType.length; int++) {
				var itemId = config.equip_compoundItems[materialType[int]].itemId;
				var count = ItemModule.getItemCount(itemId);
				materialCountArray[materialType[int]] = count;
			}
			
			var madeData = activitydata.craftsman_.madeData || {}
			var serverTime = Global.serverTime;
			for (var int = 0; int < viewData.length; int++) {
				// 冷却
				var cid = viewData[int].cfg.id;
				var cdTime_ = 0;
				if (madeData[cid]) {
					var cdTime =  viewData[int].info.wastes * 3600 - (serverTime - madeData[cid].lastTime);
					cdTime_ = cdTime > 0 ? cdTime : 0;
				}
				
				viewData[int]["cdTime"] = cdTime_;
				
				// 材料是否足够
				var isLackMaterial = false;
				var isLackGold = false;
				
				var needConf = viewData[int].info;
				for ( var needType in needConf) {
					if (needType == "gold") {
						// 金币花费判断
						if (needConf["gold"] > PlayerModule.getGold()) {
							isLackGold = true;
						}
					} else if (needType != "wastes") {
						// 材料判断
						var needCount = needConf[needType];
						if (needCount > materialCountArray[needType]) {
							isLackMaterial = true;
						}
					}
				}

				viewData[int]["isLackMaterial"] = isLackMaterial;
				viewData[int]["isLackGold"] = isLackGold;
			}
				
			return viewData;
		},
		
		/**
		 * 分解装备选择页面
		 * @param data
		 */
		showDailyDeComposeChooseEquipPopView : function(target, callBack) {
			var data = this.getDecomposeListData();
			if (this.dailyDeComposeview_ != null) {
				this.dailyDeComposeview_ = null;
			}
			// 返回所有选择的装备列表
			var closeCallBack = function(equips) {
				if (this.dailyDeComposeview_ != null) {
					this.dailyDeComposeview_ = null;
				}
				if (equips != null && equips.length > 0) {					
					this.decomposeEquipIdList = new Array();
					
					for (var int = 0; int < equips.length; int++) {
						this.decomposeEquipIdList.push(equips[int].id);
					}
				}
				
				if (callBack) {
					callBack.call(target);
				}
			}

			var params = {};
			params["viewData"] = data;
			params["manager"] = this;
			params["callBack"] = closeCallBack;

			this.dailyDeComposeview_ = new DrinkDecomposeChooseEquip(params);
			cc.director.getRunningScene().addChild(this.dailyDeComposeview_);
		},
		
		/*
		 * 分解装备
		 */
		doDecomposeAction : function(target, callBack) {
			
			if (this.decomposeEquipIdList == null || this.decomposeEquipIdList.length <= 0) {
				common.ShowText(common.LocalizedString("daily_DC_haventChooseEquip"));
				return;
			}

			var onSuccess = function(dic) {
				this.decomposeEquipIdList = new Array();
				if (callBack) {
					callBack.call(target);
				}
				this._ShowSuccessText(dic);
			};

			var onError = function(dic) {
			};
			
			dispatcher.doAction(ACTION.DAILY_CRAFT_MAN_DECOMPOSE_ACTIONG, [this.decomposeEquipIdList], onSuccess, onError);
		},
		
		/*
		 * 一键装备分解
		 * 
		 * @param rank int 装备的品阶
		 */
		doOneKeyDecomposeAction : function(rank) {
			var text;
			switch (rank) {
			case 1:
				text = common.LocalizedString("daily_DC_DecomposeAllWhite?");
				break;
				
			case 2:
				text = common.LocalizedString("daily_DC_DecomposeAllGreen?");
				break;
				
			case 3:
				text = common.LocalizedString("daily_DC_decomposeAllBlue?");
				break;
				
			default:
				text = "";
			break;
			}
			
			var cb = new ConfirmBox({info:text, confirm:function(){
				var equips = EquipModule.getEquips(-1);
				
				var totalCount = 0;
				for (var int = 0; int < equips.length; int++) {
					var equip = equips[int];
					if (equip["rank"] == rank) {
						totalCount++;
					}
				}
				
				if (totalCount <= 0) {
					var text;
					switch (rank) {
					case 1:
						text = common.LocalizedString("daily_DC_haveNotWhite");
						break;

					case 2:
						text = common.LocalizedString("daily_DC_haveNotGreen");
						break;

					case 3:
						text = common.LocalizedString("daily_DC_haveNotBlue");
						break;

					default:
						text = "";
					break;
					}
					
					common.ShowText(text);
					
					return;
				}
				
				var onSuccess = function(dic) {
					this._ShowSuccessText(dic);
				};
				
				var onError = function(dic) {
				};
				
				dispatcher.doAction(ACTION.DAILY_CRAFT_MAN_DECOMPOSE_BY_RANK_ACTIONG, [rank], onSuccess, onError);
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
			
		}, 
		
		/*
		 * 分解成功处理
		 */
		_ShowSuccessText : function(dic) {
			if (dic.info != null && dic.info.gain != null && dic.info.gain.items != null) {
				if (getJsonLength(dic.info.gain.items) > 1) {
					common.ShowText(common.LocalizedString("daily_DC_CongratulationsDecomposeSuccess"))
				} else {
					for ( var key in dic.info.gain.items) {
						common.ShowText(common.LocalizedString("daily_DC_CongratulationsDecomposeSuccessSingle", [dic.info.gain.items.key]));
					}
				}
			}
		},
		
		/**
		 * 制造装备选择页面
		 */
		showComposeEquipChooseView : function(target, callback) {
			var data = this.getComposeListData();

			if (this.dailyComposeview_ != null) {
				this.dailyComposeview_ = null;
			}
			// 返回所有选择的装备列表
			var closeCallBack = function(madeData) {
				if (this.dailyComposeview_ != null) {
					this.dailyComposeview_ = null;
				}
				
				// TODO 弹出确认弹窗
				
				if (madeData != null) {					
					this.currentMadeEquipId = madeData.cfg.id;
				}

				if (this.currentMadeEquipId != null && callback != null) {
					callback.call(target);
				}
			}

			var params = {};
			params["viewData"] = data;
			params["manager"] = this;
			params["callBack"] = closeCallBack;

			this.dailyComposeview_ = new DrinkComposeChooseEquip(params);
			cc.director.getRunningScene().addChild(this.dailyComposeview_);
		}, 
		
		/**
		 * 装备执照
		 */
		doComposeAction : function(target, callback) {
			var onSuccess = function(dic) {
				common.ShowText(common.LocalizedString("daily_DC_CongratulationsComposeSuccess"));
				traceTable("制造结果", dic);
				this.currentMadeEquipId = null;
				callback.call(target);
			};

			var onError = function(dic) {
			};
			if (this.currentMadeEquipId != null)
			{				
				common.ShowText(common.LocalizedString("daily_DC_haveBegunCompose"));
				dispatcher.doAction(ACTION.DAILY_GET_CRAFTS_MADE_EQUIP, [[this.currentMadeEquipId]], onSuccess, onError);
			}
			else
			{
				common.ShowText(common.LocalizedString("daily_DC_haventChooseEquip"));
			}
		},
}