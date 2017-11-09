var QuestLayer = cc.Layer.extend({
	ctor:function(type){
		this._super();
		cc.BuilderReader.registerController("QuestOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.QuestLayer_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.type = type || "once";
		this.refresh();
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.REFRESH_QEUEST, "refresh", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.REFRESH_QEUEST, "refresh", this);
	},
	updateTab:function(){
		if (this.type === "once") {
			this.tabBtn1.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.tabBtn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.tabBtn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.tabBtn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "daily") {
			this.tabBtn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.tabBtn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.tabBtn2.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.tabBtn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
	},
	questItemClick:function(sender){
		var tag = sender.getTag();
		var type = tag == 1 ? "once" : "daily";
		if (this.type == type) {
			return;
		}
		this.type = type;
		this.updateTab();
		this.refresh();
	},
	refresh:function(){
		this.createTableView();
	},
	initData:function(){
		if (this.type === "once") {
			this.data = QuestModule.getQuestOnce();
		} else if (this.type === "daily") {
			this.data = QuestModule.getQuestDaily();
		}
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var size = cc.size(cc.winSize.width, cc.winSize.height - this.BSTopLayer.getContentSize().height - mainBottomTabBarHeight * retina - 10 * retina);
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
		return cc.size(cc.winSize.width, 125 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node;
		if (this.type == "once") {
			node = new QuestCell(this.data[idx], this.type);
		} else if (this.type === "daily") {
			node = new QuestCell(this.data[idx], this.type);
		}
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return getJsonLength(this.data);
	},
});