var ChatLayer = cc.Layer.extend({
	ctor:function(item, type){
		this._super();
		this.type = type || "allServer";
		this.item = item;
		cc.BuilderReader.registerController("ChatViewLayerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ChatView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.allCellHeightArray = [];
		this.leagueCellHeightArray  = [];
		chatFont = "ccbResources/FZCuYuan-M03S.ttf";
		chatContentHeight = (cc.winSize.height - this.ChatTopLayer.getContentSize().height - this.bottomLayer.getContentSize().height * retina - 10 * retina) * 99 / 100;
		this.editBg = cc.Sprite.createWithSpriteFrameName("chat_bg.png");
		editBox = new cc.EditBox(cc.size(this.chat_Bg.getContentSize().width / 2, this.chat_Bg.getContentSize().height / 2), this.editBg);
		editBox.attr({
			x:this.chat_Bg.x,
			y:this.chat_Bg.y,
			anchorX:1,
			anchorY:1
		})
		editBox.setFont("ccbResources/FZCuYuan-M03S.ttf", 30 * retina);
		this.bottomLayer.addChild(editBox);
		this.refreshCount();
		this.updateBtn();
		this.getAllChatData();
	},
	refreshCount:function(){
		this.countLabel.setString(ItemModule.getItemCount("item_007"));
	},
	onEnter:function(){
		this._super();
		this.initData();
		addObserver(NOTI.REFRESH_ALLCHATDATA, "getAllChatData", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.REFRESH_ALLCHATDATA, "getAllChatData", this);
	},
	updateBtn:function() {
		if (this.type === "allServer") {
			this.btn1.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn4.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.btn4.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.announceLayer.visible = false;
			this.bottomLayer.visible = true;
		} else if (this.type === "union") {
			this.btn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn2.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn4.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.btn4.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.announceLayer.visible = false;
			this.bottomLayer.visible = true;
		} else if (this.type === "horn") {
			this.btn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.btn1.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn2.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.btn2.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn4.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.btn4.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
			this.announceLayer.visible = false;
			this.bottomLayer.visible = false;
		}

	},
	refreshCountBg:function() {
		if (this.type == "allServer") {
			this.countBg.visible = true;
		} else {
			this.countBg.visible = false;
		}
	},
	onAllServerChatClicked:function() {
		if (this.type === "allServer") {
			return;
		}
		this.type = "allServer";
		this.updateBtn();
		this.getAllChatData();
	},
	onUniteChatClicked:function() {
		if (this.type === "union") {
			return;
		}
		this.type = "union";
		this.updateBtn();
		this.getAllChatData();
	},
	onCampChatClicked:function() {
		if (this.type === "horn") {
			return;
		}
		this.type = "horn";
		this.updateBtn();
		this.getAllChatData();
	},
	onSenderTaped:function() {
		var message = encodeURI(editBox.getString());
		if (getJsonLength(message) > 0) {
			if (this.type == "allServer") {
				ChatModule.doSendAllserver(message, function(dic){
					if (dic.code == 200) {
						common.ShowText(common.LocalizedString("发送成功"));
						editBox.setString("");
						this.getAllChatData();
					}
				}.bind(this), function(dic) {
//					common.ShowText(common.LocalizedString("您通讯仪不足，发送失败"));
				}.bind(this));
			} else if (this.type == "union"){
				ChatModule.doSendLeaguemessage(message, function(dic){
					if (dic.code == 200) {
						common.ShowText(common.LocalizedString("发送成功"));
						editBox.setText("");
						this.countBg.setString(ItemModule.getItemCount(item.itemId == "item_007"));
						this.getAllChatData();
					}
				}.bind(this), function(dic) {
//					common.ShowText(common.LocalizedString("您通讯仪不足，发送失败"));
				}.bind(this));
			} else if (this.type == "horn"){
				ChatModule.doGetHornMessage(message, function(dic){
					if (dic.code == 200) {
						editBox.setText("");
						this.countBg.setString(ItemModule.getItemCount(item.itemId == "item_007"));
						this.getAllChatData();
					}
				}.bind(this), function(dic) {
					common.ShowText(common.LocalizedString("读取历史消息记录失败"));
				}.bind(this));
			} else {
				common.ShowText(common.LocalizedString("亲，不能发空的哦~"));
			}
		}
	},
	getAllChatData:function() {
		time = (parseInt(new Date().getTime() / 1000));
		if (this.type == "allServer") {
			ChatModule.doGetPublicMessage(time, this.getMessageCallBack.bind(this));
		} else if (this.type == "union") {
			ChatModule.doGetLeagueMessage(time,this.getMessageCallBack.bind(this));
		} else if (this.type == "horn") {
			ChatModule.doGetHornMessage(time, this.getMessageCallBack.bind(this));
		}
	},
	getMessageCallBack:function(rtnData) {
		this.refreshCount();
		if (this.type == "allServer") {
			time == rtnData.info.time;
			if (this.getContentSize().height < chatContentHeight) {
				this.tv.setContentOffset(cc.p(0, 0));
			}
		} else if (this.type == "union") {
			time == rtnData.info.time;
			if (this.getContentSize().height < chatContentHeight) {
				this.tv.setContentOffset(cc.p(0, 0));
			}
		} else if (this.type == "horn") {
			time == rtnData.info.time;
			if (this.getContentSize().height < chatContentHeight) {
				this.tv.setContentOffset(cc.p(0, 0));
			}
		}
		if (this.tv) {
			this.initData();
			this.tv.reloadData();
		} else {
			this.createTableView();
		}
	},
	getCellHeight:function(string, width, fontSize, fontName) {
		if (!fontName) {
			fontName = chatFont;
		}
		var tempLabel = new cc.LabelTTF(string , fontName, fontSize, cc.size(width, 0), cc.TEXT_ALIGNMENT_LEFT, cc.VERTICAL_TEXT_ALIGNMENT_CENTER);
		tempLabel.visible = false;
		this.addChild(tempLabel, 200, 8888);
		var height = tempLabel.getContentSize().height;
		tempLabel.removeFromParent(true);
		return height;
	},
	getSpeaceCount:function(string, fontSize) {
		var tempLabel = new cc.LabelTTF("s", FONT_NAME, fontSize, cc.size(0, 0), cc.TEXT_ALIGNMENT_LEFT, cc.VERTICAL_TEXT_ALIGNMENT_CENTER);
		this.addChild(tempLabel);
		tempLabel.visible = false;
		var spaceWidth = tempLabel.getContentSize().width;
		tempLabel.removeFromParent(true);
		var tempLabel = new cc.LabelTTF(string, FONT_NAME, fontSize, cc.size(0, 0), cc.TEXT_ALIGNMENT_LEFT, cc.VERTICAL_TEXT_ALIGNMENT_CENTER);
		this.addChild(tempLabel);
		tempLabel.visible = false;
		var stringWidth = tempLabel.getContentSize().width;
		tempLabel.removeFromParent(true);
		var num = Math.ceil(stringWidth / spaceWidth) * 2;
		return num;
	},
	backToLeague:function() {
		postNotifcation(NOTI.GOTO_UNION);
	},
	initData:function() {
		if (this.type == "allServer") {
			this.data = ChatModule.getPublicMessage();
		} else if  (this.type == "union") {
			this.data = ChatModule.getLeagueMessage();
		} else if (this.type == "horn") {
			this.data = ChatModule.getTrumepeMessage();
		} else {
			this.data = ChatModule.getPublicMessage();
		}
	},
	createTableView:function() {
		this.initData();
		this.getAllChatData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var topLayer = this.ChatTopLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height - (mainBottomTabBarHeight + 80) * retina - this.bottomLayer.getContentSize().height) * 0.99);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:(mainBottomTabBarHeight + 80) * retina + this.bottomLayer.getContentSize().height,
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
		var cellHeight;
		if (this.allCellHeightArrayidx) {
			cellHeight = this.allCellHeightArrayidx;
		} else {
			cellHeight = this.getCellHeight((this.getSpeaceCount(this.name, "24")) + this.message, 620, 24, "ccbResources/FZCuYuan-M03S.ttf") + 20 * retina;
			this.allCellHeightArrayidx = cellHeight;
		}
		return cc.size(cc.winSize.width, cellHeight * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		this.name = ChatModule.getPublicMessage()[idx].name;
		this.message = ChatModule.getPublicMessage()[idx].message;
		this.allCellHeightArrayidx = this.allCellHeightArray[idx];
		var chatContent = this.getSpeaceCount(ChatModule.getPublicMessage()[idx].name, "23", ChatModule.getPublicMessage()[idx].message);
		var cellHeight;
		if (this.allCellHeightArray[idx + 1]) {
			cellHeight = this.allCellHeightArray[idx + 1];
		} else {
			cellHeight = this.getCellHeight(chatContent, 620, 24, chatFont) + 20 * retina;
			this.allCellHeightArray[idx + 1] = cellHeight;
		}
		hbCell = new cc.TableViewCell();
		hbCell.setContentSize(cc.size(640, cellHeight));
		hbCell.attr({
			x: cc.winSize.width - hbCell.getContentSize().width / 2,
			y: 50,
			anchorX: 0.5,
			anchorY: 0.5
		});

		nameLabel = cc.LabelTTF(decodeURI(ChatModule.getPublicMessage()[idx].name), chatFont, 23, cc.size(620, 0), cc.TEXT_ALIGNMENT_LEFT, cc.VERTICAL_TEXT_ALIGNMENT_CENTER);
		nameLabel.setAnchorPoint(cc.p(0.5, 0));
		nameLabel.setPosition(cc.p(10 * retina, cellHeight - 10 * retina));
		hbCell.addChild(nameLabel);
		nameLabel.setColor(cc.color(255, 124, 20));
		
		temp = cc.LabelTTF(decodeURI(ChatModule.getPublicMessage()[idx].message), this.chatFont, 23, cc.size(620, 0),  cc.TEXT_ALIGNMENT_LEFT, cc.VERTICAL_TEXT_ALIGNMENT_CENTER);
		temp.setAnchorPoint(cc.p(0, 1));
		temp.setPosition(cc.p(10 * retina, cellHeight - 10 * retina));
		hbCell.addChild(temp);
		temp.setColor(cc.color(124, 255, 10));
		hbCell.setScale(retina);
		cell.addChild (hbCell, 0, 1);
		cell.setAnchorPoint(cc.p(0.5, 0));
		cell.setPosition(0,-10);
		return cell;
	},
	numberOfCellsInTableView:function(table) {
		if (this.type == "allServer") {
			return getJsonLength(ChatModule.getPublicMessage());
		} else if (this.type == "union") {
			return getJsonLength(ChatModule.getLeagueMessage());
		} else if (this.type == "horn") {
			return getJsonLength(ChatModule.getTrumepeMessage());
		}
	},
});