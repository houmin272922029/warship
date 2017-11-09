var chaptersLayer = cc.Layer.extend({
	ctor:function(bookId){
		this._super();
		cc.BuilderReader.registerController("ChaptersViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.ChaptersView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		var size = this.node.getContentSize();
		this.setContentSize(size);
		this.chapters = ChapterModule.getAllChapters();
	},
	refresh:function(){
		this.createTableView();
	},
	createTableView:function(){
		if (this.tv) {
			this.tv.reloadData();	
			return;
		}
		var contentLayer = this.contentLayer.getContentSize();
		var size = cc.size(contentLayer.width , contentLayer.height );
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
	scrollViewDisScroll:function(view) {
	},
	scrollViewDidZoom:function(view) {
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(613, 280);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new chaptersCell(this.chapters[idx]);
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		cell.addChild(node, 0, 1);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.chapters.length;
	},
	onEnter:function(){
		this._super();
		addObserver("chapters", "refresh", this);
	},
	onExit:function(){
		this._super();
		removeObserver("chapters", "refresh", this);
	},
});