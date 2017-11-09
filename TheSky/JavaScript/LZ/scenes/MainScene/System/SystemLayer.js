var SystemLayer = cc.Layer.extend({
	ctor:function(type){
		this._super();
		this.type = type;
		cc.BuilderReader.registerController("SystemSettingLayerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.SystemSettingView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.createTableView();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	BackAction:function() {
		postNotifcation(NOTI.GOTO_HOME);
	},
	createTableView:function(){
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topLayer = this.BSTopLayer;
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
		var idx = cell.getIdx();
//		if (idx == 2) {
//			var layer = new AnnounceLayer(AnnounceModule.getNotice());
//			cc.director.getRunningScene().addChild(layer);
//		} else if (idx == 3) {
//			postNotifcation(NOTI.GOTO_HELP);
//		} else if (idx == 4) {
//			var layer = new FeedBackLayer();
//			cc.director.getRunningScene().addChild(layer);
//		} else if (idx == 5) {
//			var layer = new CDKeyLayer();
//			cc.director.getRunningScene().addChild(layer);
//		} else if (idx == 6) {
//			postNotifcation(NOTI.GOTO_CUSSERVICE);
//		} else if (idx == 8) {
//			cc.director.runScene(new LoginScene);
//		}
		if (idx == 0) {
			ssoGlobal.ssoLogoutCallback();
		}
	},
	tableCellSizeForIndex:function() {
		return cc.size(cc.winSize.width, 125 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new SystemSettingViewCell(idx);
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
//		return 9;
		return 1;
	},
	
});