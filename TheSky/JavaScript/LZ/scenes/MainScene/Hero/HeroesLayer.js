var HeroesLayer = cc.Layer.extend({
	type:null,
	ctor:function(type){
		this._super();
		this.type = type || "hero";
		cc.BuilderReader.registerController("HeroesLayerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.HeroesView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.updateBtn();
		this.createTableView();
	},
	updateBtn:function(){
		if (this.type === "hero") {
			this.HuoBanBtn.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.HuoBanBtn.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.HunPoBtn.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.HunPoBtn.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "soul") {
			this.HuoBanBtn.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.HuoBanBtn.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.HunPoBtn.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.HunPoBtn.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
	},
	onEnter:function(){
		this._super();
		this.tv.reloadData();
	},
	onExit:function(){
		this._super();
	},
	initData:function(){
		if (this.type === "hero") {
			this.data = HeroModule.getAllHeroes();
		} else if (this.type === "soul") {
			this.data = SoulModule.getAllSouls();
		}
	},
	onHunPoClicked:function(){
		if (this.type === "soul") {
			return;
		}
		this.type = "soul";
		this.updateBtn();
		this.createTableView();
	},
	onHuoBanClicked:function(){
		if (this.type === "hero") {
			return;
		}
		this.type = "hero";
		this.updateBtn();
		this.createTableView();
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topLayer = this.HBTopLayer;
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
		if (idx === this.data.length) {
			return cc.size(cc.winSize.width, 80 * retina);
		} else {
			return cc.size(cc.winSize.width, 170 * retina);
		}
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node;
		if (idx === this.data.length) {
			cc.BuilderReader.registerController("GotoLogueCellOwner", {
			});
			node = cc.BuilderReader.load(ccbi_res.GotoLogueCell_ccbi, this);
			node.attr({
				x:cc.winSize.width / 2,
				y:0,
				anchorX:0.5,
				anchorY:0
			});
		} else {
			if (this.type === "hero") {
				node = new HuoBanCell(this.data[idx]);
			} else if (this.type === "soul") {
				node = new HunPoCell(this.data[idx]);
			}
			node.attr({
				x:cc.winSize.width / 2,
				y:170 / 2 * retina,
				anchorX:0.5,
				anchorY:0.5
			});
		}
		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.data.length + 1;
	},
	onGotoLogueClicked:function(){
		postNotifcation(NOTI.GOTO_LOGUETOWN, {type : 0});
	}
});