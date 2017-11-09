var FriendsLayer = cc.Layer.extend( {
	ctor:function(type) {
		this._super();
		cc.BuilderReader.registerController("FriendViewOwner",{
		});
		this.node = cc.BuilderReader.load(ccbi_res.FriendView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.type = type || "friends";
		this.friendCountLabel.visible = true;
		this.friendCountLabel.setPosition(cc.p(this.friendCountLabel.x, 112 * retina + 20));
		this.updateBtn();
		this.createTableView();
	},
	onEnter:function(){
		this._super();
		FriendModule.doOnGetFriendList(this.getFriendListSucc.bind(this));
		addObserver(NOTI.FRFRESH_FRIEND_LAYER, "getFriendListSucc", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.FRFRESH_FRIEND_LAYER, "getFriendListSucc", this);
	},
	updateBtn:function(){
		if (this.type === "friends") {
			this.Btn1.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn3.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "enemy") {
			this.Btn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn3.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "attention") {
			this.Btn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
	},
	getFriendListSucc:function(){
		this.initData(this.type);
		this.tv.reloadData();
		this.emptyLabel.visible = false;
		this.friendCountLabel.setString(FriendModule.getFriendCount(this.type) + "/" + VipModule.getFriendLimitByVipLevel(PlayerModule.getVipLevel() + 1));
		if (FriendModule.getFriendCount() < 0) {
			this.emptyLabel.visible = true;
			if (this.type == "friends") {
				this.emptyLabel.setString("报告船长，您还没有结交任何好友，点击加好友，可以查找其他海贼团！");
			} else if (this.type == "enemy") {
				this.emptyLabel.setString("报告船长，本团暂时还木有仇敌，决斗战斗结束后可添加！");
			} else if (this.type == "attention") {
				this.emptyLabel.setString("报告船长，本团暂时还没有关注仇敌，可在仇敌内选择一个海贼团关注，轻松关注ta的一举一动，时机成熟立即消灭！");
			}
		}
	},
	FriendsBtnAction:function() {
		if (this.type === "friends") {
			return;
		} else {
			this.type = "friends";
		}
		this.updateBtn();
		this.friendCountLabel.visible = true;
		this.getFriendListSucc();
	},
	
	EnemyBtnAction:function() {
		if (this.type === "enemy") {
			return;
		} else {
			this.type = "enemy";
		}
		this.updateBtn();
		this.friendCountLabel.visible = false;
		this.getFriendListSucc();
	},
	AttentionBtnAction:function() {
		if (this.type === "attention") {
			return;
		} else {
			this.type = "attention";
		}
		this.updateBtn();
		this.friendCountLabel.visible = false;
		this.getFriendListSucc();
	},
	AddBtnAction:function(){
		postNotifcation(NOTI.GOTO_ADD_FRIEND);
	},
	initData:function(type){
		this.data = FriendModule.getFriendList(type);
	},
	createTableView:function() {
		this.initData(this.type);
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topLayer = this.FriendTitleLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height - 112 * retina) * 0.99);
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
		var node = new FriendViewCell(this.type, this.data[idx]);
		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function(table) {
		return FriendModule.getFriendCount(this.type);
	},
});