var ItemModule = {
	ITEMTYPE:{
		none:0,
		item:1,
		stuff_01:2,
		stuff_02:3,
		stuff_03:4,
		drawing:5,
		keybag:6,
		delay:7,
		vip:8,
		add:9
	},
	getItemCount:function(itemId){
		if (!itemId || itemId === "") {
			return 0;
		}
		return itemdata.items[itemId] || 0;
	},
	getItemName:function(itemId){
		var cfg = this.getItemConfig(itemId);
		if (!cfg) {
			return "null";
		}
		
		return cfg.name;
	},
	getItemDes:function(itemId){
		var cfg = this.getItemConfig(itemId);
		if (!cfg) {
			return "null";
		}
		return cfg.desp;
	},
	getItemConfig:function(itemId){
		return config.item_data[itemId];
	},
	getItemRank:function(itemId){
		var cfg = this.getItemConfig(itemId);
		if (!cfg) {
			return "null";
		}
		return cfg.rank;
	},
	
	/**	 * 获取背包里的数据
	 */
	getPackageItems:function(){
		var ret = [];
		for (var k in itemdata.items) {
			var cfg = this.getItemConfig(k);
			if (cfg.type === "chapter") {
				continue;
			}
			var item = {};
			item.id = k;
			item.itemId = k;
			var amount = itemdata.items[k];
			if (amount === 0) {
				continue;
			}
			item.amount = amount;
			item.cfg = cfg;
			item.type = this.ITEMTYPE[cfg.type];
			ret.push(item);
		}
		for (var k in itemdata.delayItems) {
			var item = {};
			var bag = itemdata.delayItems[k];
			var cfg = this.getItemConfig(bag.delayItemId);
			item.id = k;
			item.itemId = bag.delayItemId;
			item.bag = bag;
			item.cfg = cfg;
			item.type = this.ITEMTYPE.delay;
			ret.push(item);
		}
		ret.sort(function(a, b){
			if (a.type === b.type) {
				return a.cfg.rank > b.cfg.rank ? -1 : 1;
			}
			return a.type > b.type ? -1 : 1;
		});
		return ret;
	},
	/**
	 * 延时礼包剩余领取次数
	 * 
	 * @param bid 唯一id
	 */
	getDelayBagLeftTime:function(bid){
		var bag = itemdata.delayItems[bid];
		var cfg = this.getDelayBagConfig(bag.delayItemId);
		var total = getJsonLength(cfg);
		if (!bag.lastTime) {
			// 今天没有领取过
			if (DateUtil.isToday(bag.beginTime)) {
				// 购买时间是今天
				return total;
			} else {
				return total - parseInt((Global.serverBegin.ts - DateUtil.beginDay(bag.beginTime)) / (24 * 60 * 60));
			}
		} else {
			if (DateUtil.isToday(bag.lastTime)) {
				// 今天领取过
				return total - parseInt((Global.serverBegin.ts - DateUtil.beginDay(bag.beginTime)) / (24 * 60 * 60)) - 1;
			} else {
				return total - parseInt((Global.serverBegin.ts - DateUtil.beginDay(bag.beginTime)) / (24 * 60 * 60));
			}
		}
	},
	/**
	 * 延时礼包领取次数配置
	 * 
	 * @param id 配置id
	 */
	getDelayBagConfig:function(id){
		return config.item_bagDelay[id].value;
	},
	/**
	 * 图纸合成需要的数量
	 * 
	 * @param itemId
	 */
	getDrawingCombineCount:function(itemId){
		var cfg = this.getItemConfig(itemId);
		return cfg.params.piece || 0;
	},
	/**
	 * 开启箱子或者使用钥匙时，对应道具不足的数量
	 * 
	 * @param itemId
	 * @param count
	 * @returns
	 */
	getInsufficientByKeybagId:function(itemId, count){
		var cfg = this.getItemConfig(itemId);
		var id, need;
		for (var k in cfg.params) {
			id = k;
			need = cfg.params[k] * count;
		}
		var have = this.getItemCount(id);
		return Math.max(need - have, 0);
		
	},
	/**
	 * 道具依赖关系
	 * 
	 * @param itemId
	 * @returns
	 */
	getRelativeItemId:function(itemId){
		var cfg = this.getItemConfig(itemId);
		for (var k in cfg.params) {
			return k;
		}
	},
	/**
	 * 获得精炼材料
	 * 
	 * @param type
	 */
	getRefineStuffs:function(equipId){
		var eCfg = EquipModule.getEquipConfig(equipId);
		var stuff = eCfg.stuff;
		var ret = [];
		var cfg = config.item_data;
		for (var k in cfg) {
			var dic = cfg[k];
			if (common.bContainObject(stuff, dic.type)) {
				var item = deepcopy(dic);
				item.count = this.getItemCount(k);
				ret.push(item);
			}
		}
		ret.sort(function(a, b){
			return a.sort < b.sort ? -1 : 1;
		});
		return ret;
	},
	/*
	 ********************************
	 * 			  网络
	 ********************************
	 */
	/**
	 * 使用道具
	 */
	doUseItem:function(itemId, amount, succ, fail){
		dispatcher.doAction(ACTION.ITEM_USEITEM, [itemId, amount], succ, fail);
	},
	/**
	 * 使用延时道具
	 * 
	 * @param bid 唯一id
	 * @param succ
	 * @param fail
	 */
	doUseDelayItem:function(bid, succ, fail) {
		dispatcher.doAction(ACTION.ITEM_USEDELAYITEM, [bid], succ, fail);
	},
	
	/**
	 * 获取道具、装备、技能、残障的rank、name、icon
	 * @author caiyaguang
	 * @param id 配置id值
	 * 
	 * @return {name, rank, icon}
	 */
	getItemResource : function(id) {
		var conf = {};
		conf["id"] = id;
		
		var rank = 1;
		var icon = null;
		var name = "";
		
		switch (id) {
		case "gold":
			rank = 1;
			icon = common.formatLResPath("icons/berryIcon.png");
			name = common.LocalizedString("ZENI");
			break;
		case "diamond":
			rank = 4;
			icon = common.formatLResPath("icons/diamond.png");
			name = common.LocalizedString("金币");
			break;
			
		default:
			if (common.havePrefix(id, "hero_")) {
				/**
				 * 英雄
				 */
				var config = HeroModule.getHeroConfig(id);
				rank = config["rank"];
				icon = HeroModule.getHeroHeadById(id);
				name = config["name"];
			} else if (common.havePrefix(id, "shadow")) {
				/**
				 * 影子
				 */
				var config = ShadowModule.getShadowConfig(id);
				rank = config["rank"];
				icon = config["icon"];
				name = config["name"];
			} else {
				/**
				 * 道具
				 */
				var config = ItemModule.getItemConfig(id);
				if (config == null) {
					/**
					 * 装备
					 */
					config = EquipModule.getEquipConfig(id);
				}
				if (config == null) {
					/**
					 * 技能
					 */
					config = SkillModule.getSkillConfig(id);
				}
				
				if (config == null) {
					/**
					 * 碎片
					 */
					config = ShardModule.getShardConfig(id);
				}
				
				if (config != null) {
					if (common.havePrefix(id, "chapter")) {
						icon = common.formatLResPath(String("icons/{0}.png").format(config.params));
					} else {
						icon = common.formatLResPath(String("icons/{0}.png").format(config.icon));
					}
					rank = config["rank"];
					name = config["name"];
				}
			}
			break;
		}
		
		conf["icon"] = icon;
		conf["rank"] = rank;
		conf["name"] = name;
		
		return conf;
	}
}