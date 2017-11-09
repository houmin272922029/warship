var ShopModule = {
	getItemPrice:function(itemId){
		return config.shop_diamond[itemId].price.diamond;
	},
	
	//获取购买道具信息
	getItemShopData:function(itemId) {
		var goldcfg = config.shop_diamond;
		var itemCfg = config.item_data;
		var ret = [];
		for (var k in goldcfg) {
			var itemId = goldcfg[k].itemId;
			var cellData = itemCfg[itemId];
			cellData.sort =  goldcfg[k].sort;
			cellData.price = goldcfg[k].price.diamond;
			ret.push(cellData);
		}
		ret.sort(function(a, b){
			return a.sort > b.sort;
		});
		return ret;
	},
	//获取购买礼包信息
	getGiftBagData:function(itemId) {
		var giftcfg = config.shop_vip;
		var itemCfg = config.item_data;
		var ret = [];
		for (var k in giftcfg) {
			var itemId = giftcfg[k].itemId;
			var cellsData = itemCfg[itemId];
			ret.push(cellsData);
		}
		return ret;
	},
	//获取vip商店信息
	getVipBagData:function() {
		var vipdatas = shopdata.vipshop;
		var ret = [];
		for (var k in vipdatas) {
			var vipcfg = config.vipshop_id[k];
			if (vipdatas[k].canBuyNum) {
				vipcfg.canBuyNum = vipdatas[k].canBuyNum || 0;
				ret.push(vipcfg);
			}
		}
		return ret;
	},
	
	//获得现金商城数据[审核服屏蔽月卡]
	getCashShopdata:function() {
		var ret = [];
		var cfg = config.cashShop_items;
		for (var k in cfg){
			if (cfg[k].type == 2 && 3) {
				break;
			}
			ret.push(cfg[k]);
		}
		ret.sort(function(a, b){
			return a.sort > b.sort;
		});
		return ret;
	},
//	getCashShopdata:function() {
//		var ret = [];
//		var cfg = config.cashShop_items;
//		for (var k in cfg){
//			ret.push(cfg[k]);
//		}
//		ret.sort(function(a, b){
//			return a.sort > b.sort;
//		});
//		return ret;
//	},
	
	//获得最大充值额度
	getMaxRecharge:function() {
		var array = {};
		var cfg = config.cashShop_items;
		for(var k in cfg) {
			ret.push(cfg);
		}
		array.sort(function(a, b){
			return a.sort > b.sort;
		});
		return array;
	},
	/**
	 *  获取充值首冲配置1
	 */
	getCashShopFirstConfig:function() {
		var cfg = config.cashshop_firstCashAward1;
		return cfg["1"];
	},
	/**
	 *  获取充值首冲配置2
	 */
	getCashShopSecondConfig:function() {
		var cfg = config.cashshop_firstCashAward2;
		return cfg;
	},
	/**
	 *  获取充值首冲配置图片
	 */
	getCashShopIcon:function(id){
		var icon;
		if (id === "diamond") {
			icon = common.formatLResPath("icons/diamond.png");
		} else if (id === "gold") {
			icon = common.formatLResPath("icons/berryIcon.png");
		} else if (id.indexOf("hero") == 0){
			icon = HeroModule.getHeroHeadById("hero_" + id.slice(-6));
		} else {
			icon = common.formatLResPath("icons/" + id + ".png");
		}
		return icon;
	},
/*****************************网络**************************************/  
	//vip礼包购买
	doBuy:function(vipBagId, succ, fail){
		dispatcher.doAction(ACTION.VIPBUY, [vipBagId], succ, fail);
	},
	
	//进入vip礼包界面
	doVipshop:function(succ, fail) {
		dispatcher.doAction(ACTION.VIPSHOP, [], succ, fail);
	},
	
	//道具购买
	doBuyItems:function(itemId, amount, succ, fail) {
		dispatcher.doAction(ACTION.BUYSHOPITEM, [itemId, amount], succ, fail);
	},
	
	//礼包购买
	doBuyBags:function(vipGiftId, amount, succ, fail) {
		trace("礼包购买" + amount)
		dispatcher.doAction(ACTION.BUYVIPBAGS, [vipGiftId, amount], succ, fail);
	},
}