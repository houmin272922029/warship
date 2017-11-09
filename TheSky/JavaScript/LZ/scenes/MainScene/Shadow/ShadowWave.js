var ShadowWave = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("ShadowWaveViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShadowWaveView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.updateUI();
		this.createTableView();
	},
	updateUI:function(){
		var shadowCoin = ShadowModule.getShadowCoin();
		this.breakShadowCount.setString(shadowCoin);
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.SHADOW_WAVE_REFRESH, "updateUI", this);
		this.tv.reloadData();
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.SHADOW_WAVE_REFRESH, "updateUI", this);
	},
	initData:function(){
		this.data = ShadowModule.getWaveConfigData();
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topTitleLayer = this.topTitleLayer;
		var titleLayer = this.titleLayer;
		var size = cc.size(cc.winSize.width, cc.winSize.height - broadCastHeight * retina - 
				topTitleLayer.getContentSize().height * retina - titleLayer.getContentSize().height - mainBottomTabBarHeight *retina);

		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:mainBottomTabBarHeight * retina,
			anchorX:0,
			anchorY:0
		});
		traceTable("this.tv", this.tv.getPosition())
		this.tv.setBounceable(true);
		this.tv.setDelegate(this);
		this.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function(table, cell) {
	},
	tableCellSizeForIndex:function (table, idx){
		return cc.size(cc.winSize.width, 125 *retina);
	},
	tableCellAtIndex:function(table, idx){
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new ShadowWaveTableCell(this.data[idx]);
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0,
			scale:retina
		});
		traceTable(node.getPosition())
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function(table) {
		return this.data.length;
	},
});