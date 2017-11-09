var bossRankLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("BossRankViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.BossRankView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true);
		this.data = BossModule.getRank();
		this.createTableView();
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var size = cc.size(cc.winSize.width, this.contentLayer.getContentSize().height);
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
		this.contentLayer.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx){
		return cc.size(cc.winSize.width / retina, 170);
	},
	tableCellAtIndex:function (table, idx){
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new bossRankCell(this.data[idx]);
		if (idx == 0) {
			node.showFontLabel();
		}
		node.attr({
			x:this.contentLayer.getContentSize().width / 2,
			y:170 / 2,
			anchorX:0.5,
			anchorY:0.5
		});
		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.data.length;
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
});