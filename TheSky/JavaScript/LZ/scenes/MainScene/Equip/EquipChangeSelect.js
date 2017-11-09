var EquipChangeSelect = cc.Layer.extend({
	selected:-1,
	ctor:function(hid, pos, eid, exit){
		this._super();
		this.hid = hid;
		this.pos = pos;
		this.eid = eid;
		this.exit = exit || NOTI.GOTO_TEAM;
		cc.BuilderReader.registerController("EquipChangeSelectLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.EquipChangeSelect_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.data = EquipModule.getChangeList(pos, eid);
		if (this.data.length === 0) {
			var text = common.LocalizedString("报告船长，您已经没有多余的装备了，去【罗格镇】买配对的箱子和钥匙可以开出极品装备噢！");
			var cb = new ConfirmBox({info:text, type:1, close:function(){
				trace("close box and goto logue");
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		} else {
			this.createTableView();
		}
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var topLayer = this.EQTopLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height 
				- mainBottomTabBarHeight * retina) * 0.99);
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
		var node = cell.getChildByTag(100);
		if (this.selected === -1) {
			this.selected = cell.getIdx();
			node.selectItem();
		} else {
			if (this.selected === cell.getIdx()) {
				this.selected = -1;
				node.unSelectItem();
			} else {
				var lastCell = this.tv.cellAtIndex(this.selected);
				if (lastCell) {
					var lastNode = lastCell.getChildByTag(100);
					lastNode.unSelectItem();
				}
				this.selected = cell.getIdx();
				node.selectItem();
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
		var equip = this.data[idx];
		var node = new EquipSellSelectCell(equip);
		if (idx === this.selected) {
			node.selectItem();
		}
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
			var equip = this.data[this.selected];
			HeroModule.doChangeEquip(this.hid, this.pos, equip.id, function(dic){
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