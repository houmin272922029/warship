var arenaLayer = cc.Layer.extend({
	ctor:function(type){
		this._super();
		this.type = type || "fight"; // 1 决斗 2 领奖
		this.isNetwork = false;
		this.rankArray = [];
		this.awardArray = [];
		cc.BuilderReader.registerController("ArenaViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.ArenaView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
	},
	onEnter:function(){
		this._super();
		var seq = cc.Sequence.create(cc.DelayTime.create(0.5),cc.CallFunc.create(this.updateArenaInfo()));
		addObserver(NOTI.REFRESH_ARENA_INFO, "updateArenaInfo", this);
		addObserver(NOTI.REFRESH_ARENA_INFO, "refreshItemClick", this);
		addObserver(NOTI.REFRESH_ARENA_CALLBACK, "refreshData", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.REFRESH_ARENA_INFO, "updateArenaInfo", this);
		removeObserver(NOTI.REFRESH_ARENA_INFO, "refreshItemClick", this);
		removeObserver(NOTI.REFRESH_ARENA_CALLBACK, "refreshData", this);
	},
	updateTab:function(){
		if (this.type === "fight") {
			this.arenaItem.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.arenaItem.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.awardItem.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.awardItem.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "award") {
			this.arenaItem.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.arenaItem.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.awardItem.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.awardItem.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
	},
	refreshData:function(){
		this.createTableView();
		if (this.type == "fight") {
			this.despLayer1.visible = true;
			this.despLayer2.visible = false;
			this.refreshItem.visible = false;
			this.updateTab();
			this.tv.reloadData();
			for (var i = 0; i < this.rankArray.length; i++) {
				if (this.rankArray[i].type == 4) {
					this.rankLabel.setString( this.rankArray[i].rank);
					break;
				}
			}
			this.countLabel.setString(ArenaModule.getFightCount());
		} else if (this.type == "award") {
			this.updateTab();
			this.despLayer1.visible = false;
			this.despLayer2.visible = true;
			this.refreshItem.visible = true;
			this.scoreLabel.setString(common.LocalizedString("arena_score", PlayerModule.getPlayerArenaScore()));
			ArenaModule.doOnArenaRecord(this.getArenaRecordsCallback.bind(this));
		}
	},
	getArenaRecordsCallback:function(){
		this.awardArray = ArenaModule.getRecordAward();
		this.createTableView();
	},
	getRankInfoCallback:function(){
		this.isNetwork = false;
		this.rankArray = ArenaModule.getRankInfoArray();
		this.refreshData();
	},
	menuEnabled:function(enable){
		this.menu.setEnabled(enable);
	},
	updateArenaInfo:function(){
		this.menuEnabled(true);
		if (!this.isNetwork && this.type == "fight") {
			ArenaModule.doOnArenaMainInfo(this.getRankInfoCallback.bind(this));
			this.isNetwork = true;
		}
	},
	tabClick:function(sender){
		var tag = sender.getTag();
		var type = tag == 1 ? "fight" : "award";
		if (this.type == type) {
			return;
		}
		this.type = type;
		this.refreshData();
	},
	getArenaScoreCallback:function(){
		this.tv.reloadData();
	},
	refreshItemClick:function(){
		ArenaModule.doOnArenaScore(this.getArenaScoreCallback.bind(this))
	},
	initData:function(){
		if (this.type == "fight") {
			this.initdata = this.rankArray;
		} else if (this.type = "award") {
			this.initdata = this.awardArray;
		}
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var TopLayer = this.TopLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - TopLayer.getContentSize().height - ( mainBottomTabBarHeight* retina)) );
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
		this.refreshOffset();
		this.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function(table, idx){
		return cc.size(cc.winSize.width, 125 * retina);
	},
	tableCellAtIndex:function(table, idx){
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node;
		if (this.type == "fight") {
			var player = this.initdata[idx];
			if (player.type == 4) {
				node = new ArenaInfoCell(player);
			} else {
				node = new ArenaEnemyCell(player);
			} 
		} else if (this.type == "award") {
			var award;
			if (idx < getJsonLength(ArenaModule.getExchangeAwardConfig())) {
				award = ArenaModule.getExchangeAwardConfig()[idx];
			} else {
				award = this.initdata[idx - getJsonLength(ArenaModule.getExchangeAwardConfig())];
			}
			node = new ArenaAwardCell(award, idx);
		}
		node.attr({
			x:cc.winSize.width / 2,
			y:170 / 2 * retina,
			anchorX:0.5,
			anchorY:0.5
		});
		node.scale = retina;
		cell.addChild(node,100,10);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.initdata.length;
	},
	refreshOffset:function(){
		if (this.type == "fight") {
			var height = cc.winSize.height - this.TopLayer.getContentSize().height - (this.despLayer1.getContentSize().height + 112) * retina;
			for (var i = 0; i < this.initdata.length; i++) {
				if (this.initdata[i].type == 4) {
					this.tv.setContentOffsetInDuration(cc.p(0, Math.max(-175 * retina * (this.initdata.length - i - 1), -175 * retina * this.initdata.length + height)), 0.1);
					break;
				}
			}
		}
	},
});