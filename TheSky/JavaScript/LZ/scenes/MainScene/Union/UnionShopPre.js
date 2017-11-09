var UnionShopPre = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("RefreshPreViewOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionShopPre_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		var union = UnionModule.getUnionData();
		this.data = union.leagueInfo.shop.itemsNext;
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
		var array = [];
		for (var i = 0; i < 4; i++) {
			var index = idx * 4 + i + 1;
			var dic = this.data[index + ""];
			if (dic) {
				array.push(dic);
			}
		}
		var node = new UnionShopPreCell(array);	
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
		return Math.ceil(getJsonLength(this.data) / 4);
	},
});