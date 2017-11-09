var RewardsLayer = cc.Layer.extend({
	ctor:function(array){
		this._super();
		this.array = array;
		cc.BuilderReader.registerController("GetSomeRewardOwner", {
		})
		var node = cc.BuilderReader.load(ccbi_res.GetSomeRewardPopUp_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.createTableView();
		this.tv.reloadData();
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		this.tv = new cc.TableView(this, this.containLayer.getContentSize());
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.containLayer.addChild(this.tv);
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
		var node = new RewardCell(this.array[idx]);	
		node.attr({
			x:300,
			y:0,
			anchorX:0.5,
			anchorY:0,
		});
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.array.length;
	},
});