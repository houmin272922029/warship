var PackageLayer = cc.Layer.extend({
	ctor:function(type){
		this._super();
		this.type = type || "item";
		
		cc.BuilderReader.registerController("WarehouseViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.PackageLayer_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		
		this.updateBtn();
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.REFRESH_PACKAGE, "refresh", this);
		this.refresh();
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.REFRESH_PACKAGE, "refresh", this);
	},
	updateBtn:function(){
		if (this.type === "item") {
			this.btn1.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
//			this.btn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
//			this.btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "shard") {
			this.btn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
//			this.btn2.setNormalImage(new cc.Sprite("#btn_fenye_1.png")); //TODO 暂时隐藏碎片
//			this.btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
	},
	onWeraHouseTaped:function(){
		if (this.type === "item") {
			return;
		}
		this.type = "item";
		this.updateBtn();
		this.refresh();
	},
	onShuiPianTaped:function(){
		if (this.type === "shard") {
			return;
		}
		this.type = "shard";
		this.updateBtn();
		this.refresh();
	},
	refresh:function(){
		this.initData();
		this.createTableView();
		if (this.tv) {
			this.tv.reloadData();
		}
	},
	initData:function(){
		if (this.type === "item") {
			this.data = ItemModule.getPackageItems();
		} else if (this.type === "shard") {
			this.data = ItemModule.getPackageItems(); // TODO for test
		}
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);
			return;
		}
		var topLayer = this.titleLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height - mainBottomTabBarHeight * retina) * 0.99);
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
		return cc.size(cc.winSize.width, 125 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new PackageCell(this.data[idx]);
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
		return this.data.length;
	},
});