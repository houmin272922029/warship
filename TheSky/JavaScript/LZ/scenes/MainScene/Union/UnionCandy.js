var UnionCandy = cc.Layer.extend({
	selected:{},
	ctor:function(){
		this._super();

		cc.BuilderReader.registerController("UnionCandyLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionCandy_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		
		this.ed = new cc.EditBox(this.textBoxBg.getContentSize(), new cc.Scale9Sprite("#chat_bg.png"), new cc.Scale9Sprite("#chat_bg.png"));
		this.ed.setPosition(this.textBoxBg.getContentSize().width / 2, this.textBoxBg.getContentSize().height / 2);
		this.ed.setAnchorPoint(0.5, 0.5);
		this.ed.setFont(common.formatLResPath("FZCuYuan-M03S.ttf"), 27 * retina);
		this.textBoxBg.addChild(this.ed);
		this.bottomLayer.y = mainBottomTabBarHeight * retina;
		this.refreshCandyTime();
		this.distributeCandyTime.visible = false;
		var data = UnionModule.getUnionData();
		var info = data.leagueInfo;
		this.members = info.members;
		this.createTableView();
	},
	refreshCandyTime:function(){
		
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.UNION_CANDY_REFRESH, "refreshCandyTime", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.UNION_CANDY_REFRESH, "refreshCandyTime", this);
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var size = cc.size(cc.winSize.width, (cc.winSize.height - mainBottomTabBarHeight * retina - 
				this.BSTopLayer.getContentSize().height * retina - 
				this.bottomLayer.getContentSize().height * retina - this.titleBg.getContentSize().height * retina));
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:(mainBottomTabBarHeight + this.bottomLayer.getContentSize().height) * retina,
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
		var data = this.members[idx + ""];
		if (this.selected[data.id]) {
			this.selected[data.id] = false;
			node.unSelectCell();
		} else {
			this.selected[data.id] = true;
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
		var node = new UnionDistributeCell(this.members[idx + ""]);	
		node.attr({
			x:cc.winSize.width / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
		});
		cell.addChild(node, 0, 100);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return getJsonLength(this.members);
	},
	onDistributeTaped:function(){
		var count = Number(this.ed.string);
		if (typeof count === "number" && count > 0) {
			var ids = [];
			for (var k in this.selected) {
				if (this.selected[k]) {
					ids.push(k);
				}
			}
			if (ids.length > 0) {
				UnionModule.doSweetDistribute(ids, count, function(dic){
					common.showTipText(common.LocalizedString("联盟糖果发放成功"));
					this.selected = {};
					this.tv.reloadData();
				}.bind(this));
			} else {
				common.showTipText(common.LocalizedString("请选择联盟成员"))
			}
		} else {
			common.showTipText(common.LocalizedString("请输入数字"));
		}
	},
	onExitTaped:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:0});
	}
});