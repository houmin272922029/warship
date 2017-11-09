var UnionRank = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("UnionRankLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionRank_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
	},
	onEnter:function(){
		this._super();
		this.refresh();
	},
	refresh:function(){
		UnionModule.doQuery(null, function(dic){
			this.list = dic.info.leagueList;
			var data = UnionModule.getUnionData();
			this.lId = data.leaguePlayer.leagueId;
			this.createTableView();
		}.bind(this));
	},
	backToUnionBtnClicked:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:0});
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var topLayer = this.EQTopLayer;
		trace(topLayer.getContentSize().height);
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height
				- mainBottomTabBarHeight * retina + this.unionLine.y - this.unionLine.getContentSize().height / 2) * 0.99);
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
		var idx = cell.getIdx();
		var data = this.list[idx + ""];
		UnionModule.doGetUnionInfo(data.id, function(dic){
			var info = dic.info.queryLeagueInfo;
			cc.director.getRunningScene().addChild(new UnionRankInfo(info));
		});
	},
	tableCellSizeForIndex:function (table, idx) {
		var sp = new cc.Sprite("#union_cellBg_0.png");
		var size = sp.getContentSize();
		return cc.size(size.width * retina * 1.1, size.height * retina * 1.1);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new UnionRankCell(idx + 1, this.list[idx + ""], this.lId);	
		node.attr({
			x:cc.winSize.width / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
		});
		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return getJsonLength(this.list);
	},
});