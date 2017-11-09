var AddFriendLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		this.initLayer();
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.REFRESH_ADDFRIEND_LAYER, "searchByLevelCallBack", this);
		
		FriendModule.resetFriendData();
		//TODO FriendModule.doOnGetPlayersByLevel(PlayerModule.getLevel(), this.searchByLevelCallBack.bind(this));
		// ce shi
		FriendModule.doOnGetPlayersByLevel(1, this.searchByLevelCallBack.bind(this));
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.REFRESH_ADDFRIEND_LAYER, "searchByLevelCallBack", this);
	},
	searchByLevelCallBack:function(){
		if (FriendModule.getFriendCountOnAdd() < 1) {
			this.addFriendLabel.visible = true;
			this.addFriendLabel.setString(common.LocalizedString("报告船长，无同等级海贼团踪迹"));
		}
		this.createTableView();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("AddFrienndLayerOwner",{
		});
		this.node = cc.BuilderReader.load(ccbi_res.AddFriendLayer_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.editBox;
		this.refresh();
	},
	refresh:function(){
		var editBoxBg = this.editBoxBg;
		var editBg = cc.Sprite.createWithSpriteFrameName("chat_bg.png");
		this.editBox = new cc.EditBox(cc.size(this.chat_Bg.getContentSize().width / 2, this.chat_Bg.getContentSize().height / 2), editBg);
		this.editBox.attr({
			x:this.chat_Bg.x,
			y:this.chat_Bg.y,
			anchorX:1,
			anchorY:1
		})
		this.editBox.setFont("ccbResources/FZCuYuan-M03S.ttf", 32 * retina);
		editBoxBg.addChild(this.editBox);
		this.editBox.setPlaceHolder(PlayerModule.getLevel());
	},
	onExitBtnTaped:function(){
		postNotifcation(NOTI.GOTO_HOME);
	},
	ConfirmSucc:function(){
		this.initData();
		this.tv.reloadData();
	},
	onConfirmTaped:function(){
		var level = this.editBox.getString();
		if (this.editBox.getString()) {
			FriendModule.doOnGetPlayersByLevel(level, this.ConfirmSucc());
		} else {
			FriendModule.doOnGetPlayersByLevel(playerdata.level, this.ConfirmSucc());
		}
	},
	initData:function(){
		this.data = FriendModule.getFriendListOnAdd();
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var BSTopLayer = this.BSTopLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - this.editBoxBg.getContentSize().height * retina - BSTopLayer.getContentSize().height - 112 * retina) * 0.99);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:112 * retina,
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
		return cc.size(cc.winSize.width, 125 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new AddFriendCell(this.data[idx], idx);
		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function(table) {
		return FriendModule.getFriendCountOnAdd();
	},
});