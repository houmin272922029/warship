var ShadowChangeSelect = cc.Layer.extend({
	selected:-1,
	/**
	 * 更换技能
	 * 
	 * @param hid 英雄id
	 * @param pos 影子位置
	 * @param sid 已装备影子
	 */
	ctor:function(hid, pos, sid, exit){
		this._super();
		this.hid = hid;
		this.pos = pos;
		this.sid = sid;
		this.exit = exit || NOTI.GOTO_TEAM;
		cc.BuilderReader.registerController("ShadowChangeOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.ShadowChangeView_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.data = ShadowModule.getChangeList(hid, sid);
		if (this.data.length === 0) {
			
		} else {
			this.createTableView();
		}
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var topLayer = this.TopLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height - 112 * retina) * 0.99);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:mainBottomTabBarHeight * retina,
			anchorX:0,
			anchorY:0
		});
		this.tv.setBounceable(true);
		this.tv.setDelegate(this);
		this.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
		var node = cell.getChildByTag(100);
		if (this.selected === -1) {
			this.selected = cell.getIdx();
			node.selectCell();
		} else {
			if (this.selected === cell.getIdx()) {
				this.selected = -1;
				node.unSelectCell();
			} else {
				var lastCell = this.tv.cellAtIndex(this.selected);
				if (lastCell) {
					var lastNode = lastCell.getChildByTag(100);
					lastNode.unSelectCell();
				}
				this.selected = cell.getIdx();
				node.selectCell();
			}
		}
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(cc.winSize.width, 125 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var shadow = this.data[idx];
		var node = new ShadowSelectCell(shadow);
		if (idx === this.selected) {
			node.selectCell();
		}
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0,
			scale:retina
		});
		cell.addChild(node, 0, 100);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.data.length;
	},
	confirmBtnClicked:function(){
		if (this.selected === - 1) {
			if (typeof this.exit === "string") {
				postNotifcation(this.exit);
			} else {
				this.exit.apply();
			}
		} else {
			var shadow = this.data[this.selected];
			HeroModule.doChangeShadow(this.hid, this.pos, shadow.shadow.id, function(dic){
				traceTable("change skill succ", dic);
				if (typeof this.exit === "string") {
					postNotifcation(this.exit);
				} else {
					this.exit.apply();
				}
			}.bind(this), function(dic){
				traceTable("change skill fail", dic);
			})
		}
	},
});