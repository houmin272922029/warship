var LoginServerView = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("LoginServerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.LoginServerView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		
		this.scList = LoginModule.getSelectedServerList();
		this.list = LoginModule.getServersList();
		this.selectedLen = Math.floor((this.scList.length + 1) / 2);
		this.listLen = Math.floor((this.list.length + 1) / 2);
		this.createTableView();
		var grayBg = new cc.Scale9Sprite(ccbi_dir + "/ccbi/ccbResources/grayBg.png");
		grayBg.setContentSize(cc.size(this.serverLayer.getContentSize().width * 0.98, this.serverLayer.getContentSize().height * 0.98));
		grayBg.setAnchorPoint(cc.p(0.5, 0.5));
		grayBg.setPosition(cc.p(this.serverLayer.getContentSize().width / 2, this.serverLayer.getContentSize().height / 2));
		this.serverLayer.addChild(grayBg, -1);
		
	},
	setServerIcon:function(sprite,status){
		var frameName;
		if (status === 1){
			frameName = "server_hot_icon.png"
		} else if (status === 2) {
			frameName = "server_new_icon.png"
		} else if (status === 3) {
			frameName = "server_full_icon.png"
		} else if (status === 4) {
			frameName = "server_maintain_icon.png"
		} else if (status === 5) {
			frameName = "server_recom_icon.png"
		}
	},
	serverClick:function(sender) {
		var tag = sender.getTag();
		var s;
		if (tag > 0 && tag <= this.scList.length === 0) {
			s = this.scList[tag - 1];
		} else if (tag > 0 && this.scList.length !== 0 && tag <= this.scList.length) {
			s = this.scList[tag - 1];
		} else if(tag > this.scList.length) {
			s = this.list[tag - 1 - this.scList.length];
		}
		if (!s) {
			return;
		}
		LoginModule.setSelectedServer(s.id);
	},
	createTableView:function() {
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		this.tv = new cc.TableView(this, this.serverLayer.getContentSize());
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:5,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.serverLayer.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(this.serverLayer.getContentSize().width, 80);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		if (idx === 0) {
			var bg = new cc.Sprite("#lanchangtiao.png");
			bg.setAnchorPoint(0,0);
			cell.addChild(bg);
			var text = new cc.Sprite("#zuijindenglu_text.png");
			text.setPosition(cc.p(bg.getContentSize().width/2 , bg.getContentSize().height / 2));
			text.setAnchorPoint(0.5, 0.5);
			bg.addChild(text);
		}else if (idx > 0 && idx <= this.selectedLen) {
			var menu = new cc.Menu();
			menu.setContentSize(cc.size(this.serverLayer.getContentSize().width, 80));
			cell.addChild(menu);
			menu.setAnchorPoint(0, 0);
			menu.setPosition(cc.p(0, 0));
			for (var i = 0; i < 2; i++) {
				var index = (idx - 1) * 2 + i;
				var serverIndex = index + 1;
				var server = this.scList[index];
				if (!server) {
					break;				
				}
				var item = new cc.MenuItemImage("#server_btn_0.png", "#server_btn_1.png", this.serverClick.bind(this), this);
				if (server.type === "1") {
					var hotSp = new cc.Sprite("#server_hot_icon.png");
					hotSp.setPosition(cc.p(hotSp.getContentSize().width, item.getContentSize().height / 3 * 2));
					item.addChild(hotSp);
				}
				item.setAnchorPoint(0, 0);
				item.setPosition(this.serverLayer.getContentSize().width / 2 * i, 0);
				menu.addChild(item, 0, serverIndex);
				
				var label = new cc.LabelTTF(server.serverName, FONT_NAME, 30);
				label.setColor(cc.color(184, 45,18));
				label.setAnchorPoint(0, 0.5);
				label.setPosition(cc.p(item.getContentSize().width * 0.29, item.getContentSize().height / 2));
				item.addChild(label);
			}
	
		} else if (idx === this.selectedLen + 1) {			
			var bg = new cc.Sprite("#lanchangtiao.png");
			bg.setAnchorPoint(0,0);
			cell.addChild(bg);
			var text = new cc.Sprite("#suoyoufuwuqi_text.png");
			text.setPosition(cc.p(bg.getContentSize().width/2 , bg.getContentSize().height / 2));
			text.setAnchorPoint(0.5, 0.5);
			bg.addChild(text);
		} else {
			var menu = new cc.Menu();
			menu.setContentSize(cc.size(cell.getContentSize().width, 66));
			for (var i = 0; i < 2; i++) {
				var index = (idx - 2 - this.selectedLen) * 2 + i;
				var serverIndex = this.scList.length + index + 1;
				var server = this.list[index];
				if (!server) {
					break;				
				}
				var norSp = new cc.Sprite("#server_btn_0.png");
				var selSp = new cc.Sprite("#server_btn_1.png");
				var item = new cc.MenuItemSprite(norSp, selSp, this.serverClick.bind(this), this);
				if (server.type === "1") {
					var hotSp = new cc.Sprite("#server_hot_icon.png");
					hotSp.setPosition(cc.p(hotSp.getContentSize().width, item.getContentSize().height / 3 * 2));
					item.addChild(hotSp);
				}
				item.setAnchorPoint(0, 0);
				item.setPosition(this.serverLayer.getContentSize().width / 2 * i, 0);
				menu.addChild(item, 0, serverIndex);
				
				var label = new cc.LabelTTF(server.serverName, FONT_NAME, 30);
				label.setColor(cc.color(184, 45,18));
				label.setAnchorPoint(0, 0.5);
				label.setPosition(cc.p(item.getContentSize().width * 0.29, item.getContentSize().height / 2));
				item.addChild(label);
			}	
			cell.addChild(menu);
			menu.setAnchorPoint(0, 0);
			menu.setPosition(cc.p(0, 0));
		}
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.selectedLen + this.listLen + 2;
	},
})