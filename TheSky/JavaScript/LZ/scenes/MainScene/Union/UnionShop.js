var UnionShop = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("UnionShopViewLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionShop_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.refresh();
	},
	refresh:function(){
		var data = UnionModule.getUnionData();
		var info = data.leagueInfo;
		this.shop = info.shop;
		this.shopLevelTTF.setString(common.LocalizedString("商城等级:%s", this.shop.level));
		this.createTableView();
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.UNION_SHOP_REFRESH, "refresh", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.UNION_SHOP_REFRESH, "refresh", this);
	},
	onExitTaped:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:0});
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var size = cc.size(cc.winSize.width, (cc.winSize.height - mainBottomTabBarHeight * retina - 
				this.BSTopLayer.getContentSize().height - this.titleBg.getContentSize().height * retina));
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:mainBottomTabBarHeight * retina,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(cc.winSize.width, 190 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var index = idx + 1;
		var node = new UnionShopCell(this.shop.items[index + ""]);	
		node.attr({
			x:cc.winSize.width / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
			scale:retina
		});
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return getJsonLength(this.shop.items);
	},
	nextRefreshTaped:function(){
		cc.director.getRunningScene().addChild(new UnionShopPre());
	},
});