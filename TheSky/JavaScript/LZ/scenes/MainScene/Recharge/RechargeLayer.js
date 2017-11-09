var RechargeLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("ShopChargePopUpOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShopChargePopUp_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
		
		this.initLayer();
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		this.vip_title.enableStroke(cc.color(40, 23, 17), 4);
		var str = common.LocalizedString("vip_full");
		if (PlayerModule.getNextVipNeedGold() != -1) {
			//str = common.LocalizedString("vip_need", [PlayerModule.getVipLevel(), PlayerModule.getNextVipNeedGold(), PlayerModule.getVipLevel() + 1]);
			this.vipLevel0.setString("vip" + PlayerModule.getVipLevel());
			this.vipLevel0.visible = true;
			this.vipLabel1.setString(common.LocalizedString("vip_need",PlayerModule.getNextVipNeedGold()));
			this.vipLabel1.visible = true;
			this.vipLevel1.setString("vip" + (PlayerModule.getVipLevel() + 1) + "!!");
			this.vipLevel1.visible = true;
		} else {
			//TODO 多国货币适配
			this.vipLabel0.setString(str);
		}
		
		var cashCfg1 = ShopModule.getCashShopFirstConfig();
		this["name1"].setString(cashCfg1.name);
		this["count1"].setString("×" + cashCfg1.multiple);
		
		var cashCfg2 = ShopModule.getCashShopSecondConfig();
		for (var i = 0; i < 3; i++) {
			var cfg = cashCfg2[(i + 1) + ""];
			this["frame_level" + (i + 2)].visible = cfg.show == 1;
			this["count" + (i + 2)].visible = cfg.show == 1;
			this["count" + (i + 2)].setString("×" + cfg.items[0].amount);
			var icon = ShopModule.getCashShopIcon(cfg.items[0].itemId);
			if (cfg.items[0].itemId.indexOf("hero") == 0) {
				this["head" + (i + 2)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(icon));
				this["soul" + (i + 2)].visible = true;
				this["head" + (i + 2)].scale = 1;
			}else {
				this["head" + (i + 2)].setTexture(icon);
				this["head" + (i + 2)].scale = 0.35;
			}
			this["name" + (i + 2)].setString(cfg.items[0].name);
		}
		
		this.createTableView();
	},
	LookUpVipDetail:function() {
		var layer = new VipDetailLayer();
		cc.director.getRunningScene().addChild(layer);
		this.removeFromParent(true);
	},
	payMoreDetail:function(){
		common.ShowText(common.LocalizedString("component_close"));
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		this.tv = new cc.TableView(this, this.tableLayer.getContentSize());
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.tableLayer.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
//		if (idx === 0) {
//			 return cc.size(600, 340);
//		} else {
//			 return cc.size(600, 120);
//		}
		return cc.size(550, 80);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
//		if (idx === 0){
//			var node = new ShopRechargeCell(idx);	
//			node.attr({
//				x:0,
//				y:0,
//				anchorX:0,
//				anchorY:0,
//			});
//			cell.addChild(node);
//			return cell;
//		} else {
//			var node = new RechargeBottomCell(idx);	
//			node.attr({
//				x:0,
//				y:0,
//				anchorX:0,
//				anchorY:0,
//			});
//			cell.addChild(node);
//			return cell;
//		}
		var node = new RechargeBottomCell(idx);	
		node.attr({
		x:0,
		y:0,
		anchorX:0,
		anchorY:0,
		});
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
//		return getJsonLength(ShopModule.getCashShopdata() + 1);
		return getJsonLength(ShopModule.getCashShopdata());
	},
});