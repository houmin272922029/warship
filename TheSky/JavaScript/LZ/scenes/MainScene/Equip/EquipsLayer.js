var EquipsLayer = cc.Layer.extend({
	EQUIP_TYPE:{
		all:0,
		weapon:1,
		armour:2,
		jewelry:3,
		rune:4,
	},
	type:0,
	ctor:function(type){
		this._super();
		this.type = type || 0;
		cc.BuilderReader.registerController("EquipmentsViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.EquipsLayer_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.changeType(this.type);
	},
	changeTypeClick:function(sender){
		var tag = sender.getTag();
		if (this.type === tag) {
			return;
		}
		this.changeType(tag);
	},
	changeType:function(type){
		var btn = this["btn" + this.type];
		if (btn) {
			btn.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			btn.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
		this.type = type;
		btn = this["btn" + this.type];
		if (btn) {
			btn.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			btn.setSelectedImage(new cc.Sprite("#btn_fenye_0.png"));
		}
		this.refresh();
	},
	refresh:function(){
		this.data = EquipModule.getEquipsWithSort(this.type - 1);
		this.createTableView();
	},
	createTableView:function(){
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topLayer = this.LogueTitleLayer;
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
	},
	tableCellSizeForIndex:function (table, idx) {
		var height;
		switch (idx) {
		case 0:
			height = 100;
			break;
		case this.data.length + 1:
			height = 80;
			break;
		default:
			height = 125;
			break;
		}
		return cc.size(cc.winSize.width, height * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node;
		if (idx === this.data.length + 1) {
			cc.BuilderReader.registerController("GotoQihangCellOwner", {
			});
			node = cc.BuilderReader.load(ccbi_res.GotoSailCell_ccbi, this);
		} else if (idx === 0) {
			var owner = {};
			var self = this;
			cc.BuilderReader.registerController("EquipSellCellOwner", {
				"onEquipSellClick":function(){
					postNotifcation(NOTI.GOTO_EQUIPSELL, {type:self.type});
				}
			});
			node = cc.BuilderReader.load(ccbi_res.EquipSellCell_ccbi, owner);
			owner.topLabel.setString(common.LocalizedString("开金银沉船宝箱可以获得S、A级装备。"));
		} else {
			node = new EquipCell(this.data[idx - 1], this.type);
		}
		node.attr({
			x:cc.winSize.width / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
			scale:retina
		})
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.data.length + 2;
	},
	gotoQihang:function(){
		trace("postNotifcation(NOTI.GOTO_STAGE)")
		postNotifcation(NOTI.GOTO_STAGE);
	}
});