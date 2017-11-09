var ShadowBox = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("ShadowBoxViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShadowBoxView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.createTableView();
	},
	onEnter:function(){
		this._super();
		this.tv.reloadData();
	},
	onExit:function(){
		this._super();
	},
	initData:function(){
		this.data = ShadowModule.getAllShadowData(1);
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var titleLayer = this.titleLayer;
		var size = cc.size(cc.winSize.width, cc.winSize.height - titleLayer.getContentSize().height - mainBottomTabBarHeight *retina);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:mainBottomTabBarHeight * retina,
			anchorX:0,
			anchorY:0
		});
		this.tv.setBounceable(true);
		this.tv.setDelegate(this);
		this.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx){
		return cc.size(cc.winSize.width, 125 *retina);
	},
	tableCellAtIndex:function (table, idx){
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new ShadowBoxTableCell(this.data[idx]);
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
	numberOfCellsInTableView:function (table) {
		return this.data.length;
	},
});