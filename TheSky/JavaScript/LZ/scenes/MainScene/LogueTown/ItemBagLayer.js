var ItemBagLayer = cc.Layer.extend({
	ctor:function(type){
		this._super();
		this.initLayer();
		this.type = type;
		this.createTableView();
	},
	initLayer:function() {
		cc.BuilderReader.registerController("ItemsViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ItemsView_ccbi, this);
		if (this != null) {
			this.addChild(this.node);
		}
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initData:function() {
		this.data = ShopModule.getItemShopData();
	},
	createTableView:function() {
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topLayer = this.titleLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height - 112 * retina) * 0.99);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:110 * retina,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view) {
	},
	tableCellTouched:function(table, cell) {
	},
	tableCellSizeForIndex:function(table, idx) {
		return cc.size(cc.winSize.width, 125 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new ItemTableCell(this.data[idx], idx);
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0,
			scale:retina
		});
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function(table) {
		return this.data.length;
	},
});