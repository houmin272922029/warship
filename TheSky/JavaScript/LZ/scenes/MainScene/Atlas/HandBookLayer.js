var HandBookLayer = cc.Layer.extend({
	ctor:function(type){
		this._super();
		this.type = type || "hero";
		cc.BuilderReader.registerController("HandBookViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.HandBookView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.updateBtn();
		this.createTableView()
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	updateBtn:function(){
		if (this.type === "hero") {
			this.Btn1.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn3.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "equip") {
			this.Btn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn3.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "skill") {
			this.Btn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
	},
	HeroBtnAction:function() {
		if (this.type === "hero") {
			return;
		}
		this.type = "hero";
		this.updateBtn();
		this.initData();
		this.tv.reloadData();
	},
	itemBtnAction:function() {
		if (this.type === "equip") {
			return;
		}
		this.type = "equip";
		this.updateBtn();
		this.initData();
		this.tv.reloadData();
	},
	ChapterBtnAction:function() {
		if (this.type === "skill") {
			return;
		}
		this.type = "skill";
		this.updateBtn();
		this.initData();
		this.tv.reloadData();
	},
	initData:function() {
		if (this.type == "hero") {
			this.data = HeroModule.getHandBookViewData();
		} else if (this.type == "equip") {
			this.data = EquipModule.getHandBookViewData();
		} else if (this.type == "skill") {
			this.data = SkillModule.getHandBookViewData();
		} else {
			this.data = HeroModule.getHandBookViewData();
		}
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topLayer = this.handBookTitleLayer;
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
	scrollViewDidZoom:function(view) {
	},
	tableCellTouched:function(table, cell) {
	},
	tableCellSizeForIndex:function() {
		return cc.size(cc.winSize.width, 140 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
			var node = new HandBookCell(this.data[idx], this.type);
			node.attr({
				x:0,
				y:0,
				anchorX:0,
				anchorY:0,
				scale:retina
			});
			cell.addChild(node);
			return cell;
		
	},
	numberOfCellsInTableView:function(table) {
		return this.data.length
	},
});