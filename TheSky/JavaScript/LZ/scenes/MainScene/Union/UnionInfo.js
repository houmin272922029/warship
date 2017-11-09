var UnionRankInfo = cc.Layer.extend({
	ctor:function(data){
		this._super();
		this.data = data;
		cc.BuilderReader.registerController("UnionInfoViewOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionInfo_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		
		this.unionRankLabel.setString(data.level);
		this.unionNameLabel.setString(data.name);
		this.unionMemebersLabel.setString(common.LocalizedString("union_rank_membersCount_info", 
				[data.memberCount, UnionModule.getUnionPlayerMax(data.level)]));
		var notice = new cc.LabelTTF(data.notice, common.formatLResPath("FZCuYuan-M03S.ttf"), 20, 
				this.noticeArea.getContentSize(), cc.TEXT_ALIGNMENT_LEFT);
		notice.setAnchorPoint(0, 1);
		notice.setPosition(0, this.noticeArea.getContentSize().height);
		this.noticeArea.addChild(notice);
		this.createTableView();
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
		this.tv = new cc.TableView(this, this.unionMemberContentLayer.getContentSize());
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.unionMemberContentLayer.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(this.unionMemberContentLayer.getContentSize().width, 35);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new UnionMemberCell(this.data.members[idx]);	
		node.attr({
			x:this.unionMemberContentLayer.getContentSize().width / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
		});
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return getJsonLength(this.data.members);
	},
});