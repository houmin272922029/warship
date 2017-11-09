var UnionManage = cc.Layer.extend({
	sortKey:"level",
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("UnionManageLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionManage_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
	},
	onEnter:function(){
		this._super();
		this.refreshData();
		addObserver(NOTI.UNION_MANAGE_REFRESH, "refreshData", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.UNION_MANAGE_REFRESH, "refreshData", this);
	},
	sortData:function(){
		this.list = [];
		for (var k in this.askList) {
			var dic = this.askList[k];
			this.list.push(dic);
		}
		this.list.sort(function(a, b){
			return a[this.sortKey] > b[this.sortKey] ? -1 : 1;
		}.bind(this));
		this.createTableView();
	},
	refreshData:function(){
		UnionModule.doGetApplicant(function(dic){
			this.askList = dic.info.askList;
			this.sortData();
		}.bind(this));
	},
	backUnionBtnClicked:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:0});
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var size = this.tableLayer.getContentSize();
		this.tv = new cc.TableView(this, cc.size(size.width, size.height * 0.99));
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.tableLayer.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(622, 103);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new UnionApplicantCell(this.list[idx]);	
		node.attr({
			x:622 / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
		});
//		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.list.length;
	},
	rejectAllBtnClicked:function(){
		var ids = [];
		for (var k in this.list) {
			var dic = this.list[k];
			ids.push(dic.id);
		}
		UnionModule.doProcessApplicants(ids, false, function(){
			this.refreshData();
		}.bind(this));
	},
	levelRankBtnClicked:function(){
		this.sortKey = "level";
		this.refreshData();
	},
	DuelRankBtnClicked:function(){
		this.sortKey = "arenaRank";
		this.refreshData();
	}
	
});