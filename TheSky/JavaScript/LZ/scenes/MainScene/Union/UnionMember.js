var UnionMember = cc.Layer.extend({
	selected:{},
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("unionMemberLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionMember_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.UNION_MEMBER_REFRESH, "refresh", this);
		this.refresh();
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.UNION_MEMBER_REFRESH, "refresh", this);
	},
	refresh:function(){
		var data = UnionModule.getUnionData();
		var info = data.leagueInfo;
		this.members = info.members;
		this.countLabel.setString(common.LocalizedString("成员数 %d/%d", [info.memberCount, UnionModule.getUnionPlayerMax(info.level)]));
		this.createTableView();
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var size = cc.size(cc.winSize.width, (cc.winSize.height - this.countLabel.getContentSize().height 
				* retina - this.BSTopLayer.getContentSize().height - mainBottomTabBarHeight * retina - this.titleBg.getContentSize().height * retina));
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:(mainBottomTabBarHeight + this.countLabel.getContentSize().height) * retina,
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
		var node = cell.getChildByTag(100);
		if (this.selected[idx]) {
			this.selected[idx] = false;
			node.unSelectCell();
		} else {
			this.selected[idx] = true;
			node.selectCell();
		}
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(cc.winSize.width, 105 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new UnionMemberManageCell(this.members[idx + ""]);	
		node.attr({
			x:cc.winSize.width / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
			scale:retina
		});
		cell.addChild(node, 0, 100);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return getJsonLength(this.members);
	},
	onExitTaped:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:0});
	}
});