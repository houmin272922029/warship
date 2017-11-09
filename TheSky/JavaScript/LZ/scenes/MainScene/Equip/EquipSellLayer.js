var EquipSellLayer = cc.Layer.extend({
	selected:{},
	ctor:function(type){
		this._super();
		this.type = type || 0;

		cc.BuilderReader.registerController("EquipSellLayerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.EquipSellLayer_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
	},
	onEnter:function(){
		this._super();
		this.createTableView();
	},
	createTableView:function(){
		this.selected = {};
		this.data = EquipModule.getEquipsCallSellWithSort(this.type - 1);
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topLayer = this.EQTopLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height - mainBottomTabBarHeight * retina) * 0.99);
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
		var equip = this.data[idx];
		var node = cell.getChildByTag(100);
		if (this.selected[equip.id]) {
			delete this.selected[equip.id];
			node.unSelectItem();
		} else {
			this.selected[equip.id] = true;
			node.selectItem();
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
		if (this.selected[equip.id]) {
			node.selectItem();
		}
		cell.addChild(node, 0, 100);
		node.attr({
			x:cc.winSize.width / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
			scale:retina
		});
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.data.length;
	},
	quitBtnClicked:function(){
		postNotifcation(NOTI.GOTO_EQUIPS, {type:this.type}); 
	},
	confirmBtnClicked:function(){
		if (getJsonLength(this.selected) === 0) {
			common.ShowText(common.LocalizedString("您还未选择出售的装备"));
			return;
		}
		var selected = [];
		for (var k in this.selected) {
			if (this.selected[k]) {
				selected.push(k);
			}
		}
		EquipModule.doSellEquips(selected, function(dic){
			postNotifcation(NOTI.GOTO_EQUIPS, {type:this.type}); 
		}.bind(this), function(dic){
			traceTable("sell equip fail", dic);
		}.bind(this));
	}
	
});