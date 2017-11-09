var UnionJoin = cc.Layer.extend({
	ctor:function(list){
		this._super();
		this.list = list;
		cc.BuilderReader.registerController("UnionRankLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionJoin_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true);

		this.ed = new cc.EditBox(this.searchUnionBg.getContentSize(), new cc.Scale9Sprite("#chat_bg.png"), new cc.Scale9Sprite("#chat_bg.png"));
		this.ed.setPlaceHolder(common.LocalizedString("union_printUnionName"));
		this.ed.setPosition(this.searchUnionBg.getPosition());
		this.ed.setAnchorPoint(0.5, 0.5);
		this.ed.setFont(common.formatLResPath("FZCuYuan-M03S.ttf"), 26 * retina);
		this.searchUnionBg.getParent().addChild(this.ed);
		this.createTableView();
	},
	backBtnFun:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:0});
		this.removeFromParent(true);
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var topLayer = this.TopLayer;
		var SearchLayer = this.SearchLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height * 
				retina - SearchLayer.getContentSize().height * retina) * 0.99);
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
		var idx = cell.getIdx();
		cc.director.getRunningScene().addChild(new UnionJoinInfo(this.list[idx + ""], function(){
			this.ed.visible = true;
		}.bind(this)));
		this.ed.visible = false;
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
		var node = new UnionRankCell(idx + 1, this.list[idx + ""]);	
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
	searchBtnFun:function(){
		var name = this.ed.string;
		trace(name);
		UnionModule.doQuery(name, function(dic){
			this.list = dic.info.leagueList;
			this.createTableView();
		}.bind(this));
	},
});