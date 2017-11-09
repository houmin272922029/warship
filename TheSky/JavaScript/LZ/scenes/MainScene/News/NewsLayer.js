var NewsLayer = cc.Layer.extend({
	ctor:function(type) {
		this._super();
		this.type = type || "system";
		cc.BuilderReader.registerController("NewsViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.NewsView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.sysCount = getJsonLength(MailModule.getSystemMails());
		this.awardCount = getJsonLength(MailModule.getAwardMails());
		this.messCount = getJsonLength(MailModule.getMessage());
		this.updateBtn();
		this.creatTableView();
		this.refersh();
	},
	onEnter:function() {
		this._super();
		addObserver(NOTI.REFRESH_MAIL_LAYER, "postRefresh", this);
	},
	onExit:function() {
		this._super();
		removeObserver(NOTI.REFRESH_MAIL_LAYER, "postRefresh", this);
	},
	postRefresh:function(){
		this.updateBtn();
		this.refersh();
		this.tv.reloadData();
	},
	updateBtn:function() {
		if (this.type === "system") {
			this.Btn1.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn3.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "award") {
			this.Btn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn3.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else if (this.type === "message") {
			this.Btn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.Btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.Btn3.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
	},
	SystemBtnAction:function() {
		if (this.type === "system") {
			return;
		}
		this.type = "system";
		this.updateBtn();
		this.refersh();
		this.tv.reloadData();
	},
	awardBtnAction:function() {
		if (this.type === "award") {
			return;
		}
		this.type = "award";
		this.updateBtn();
		this.refersh();
		this.tv.reloadData();
	},
	MessageBtnAction:function() {
		if (this.type === "message") {
			return;
		}
		this.type = "message";
		this.updateBtn();
		this.refersh();
		this.tv.reloadData();
	},
	initData:function() {
		if (this.type == "system") {
			this.data = MailModule.getSystemMails();
		} else if  (this.type == "award") {
			this.data = MailModule.getAwardMails();
		} else if (this.type == "message") {
			this.data = MailModule.getMessage();
		} else {
			this.data = MailModule.getSystemMails();
		}
	},
	refersh:function() {
		this.initData();
		this.lengthStr = [this.sysCount,
		                  this.awardCount,
		                  this.messCount
		                 ];
		for (i = 0; i < 3; i++) {
			var length = this.lengthStr[i];
			if (length == 0) {
				this["countBg" + (i + 1)].visible = false;
			} else {
				this["countBg" + (i + 1)].visible = true;
				this["label" + (i + 1)].setString(length);
			}
		}
		if (this.type == "system") {
			if (getJsonLength(MailModule.getSystemMails()) == 0) {
				this.emptyLabel.visible = true;
				this.emptyLabel.setString("报告船长，最近没有收到任何新闻，我们一直在风平浪静的海面上航行着，一切正常！");
			} else {
				this.emptyLabel.visible = false;
			}
			
		} else if  (this.type == "award") {
			if (getJsonLength(MailModule.getAwardMails()) == 0) {
				this.emptyLabel.visible = true;
				this.emptyLabel.setString("报告船长，本团没有收到任何领奖信息，快去冒险战斗，提高威望，获得奖励吧！");
			} else {
				this.emptyLabel.visible = false;
			}
		} else if (this.type == "message") {
			if (getJsonLength(MailModule.getMessage()) == 0) {
				this.emptyLabel.visible = true;
				this.emptyLabel.setString("报告船长，您的威望还没有远播，快去战斗，干出一番惊天的事迹吧！");
			} else {
				this.emptyLabel.visible = false;
			}
		} 
	},
	creatTableView:function() {
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topLayer = this.NewsTitleLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height - mainBottomTabBarHeight * retina) * 0.99);
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
	scrollViewDisScroll:function(view) {
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
		var node = new NewsViewTableCell(idx, this.type ,this.data[idx]);
		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function(table) {
		if (this.type == "system") {
			return getJsonLength(MailModule.getSystemMails());
		} else if (this.type == "award") {
			return getJsonLength(MailModule.getAwardMails());
		} else if (this.type == "message") {
			return getJsonLength(MailModule.getMessage());
		}
	},
	
});