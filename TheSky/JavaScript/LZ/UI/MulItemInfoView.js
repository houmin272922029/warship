var MutiItemInfoView = cc.Layer.extend({
	ctor:function(itemArray){
		this._super();
		this.itemArray = itemArray;
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("MultiItemOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.MultiItemPopUp_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.refresh();
	},
	refresh:function(){
		this.createTableView();
	},
	initData:function(){
		this.data = [];
		for (var k in this.itemArray) {
			this.data.push(this.itemArray[k]);
		}
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var size = cc.size(this.containLayer.getContentSize().width, this.containLayer.getContentSize().height);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:0,
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
		return cc.size(600, 120);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new MulItemInfoCell(this.data[idx]);
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return getJsonLength(this.data);
	},
});