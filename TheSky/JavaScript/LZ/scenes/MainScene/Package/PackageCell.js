var PackageCell = cc.Node.extend({
	ctor:function(item){
		this._super();
		this.item = item;
		
		cc.BuilderReader.registerController("WarehouseCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.PackageCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.setContentSize(this.node.getContentSize());
		
		var type = item.cfg.type;
		var dontDic = ["item_025", "item_024", "item_004", "item_016", "item_011", "item_012", 
		               "item_013", "item_014", "itemcamp_009", "itemcamp_011", "itemcamp_001"];
		if (common.bContainObject(dontDic, item.itemId)) {
			this.updateBtnState(false, false, false);
		} else if (item.itemId === "boxrandom1_043") {
			this.updateBtnState(true, false, false);
		} else {
			if (type === "keybag" || type === "soulbag" || type === "boxrandom" || type === "boxrandom1") {
				this.updateBtnState(false, true, true);
			} else if (type === "item" || type === "box") {
				this.updateBtnState(true, false, false);
			} else if (type === "vip") {
				this.updateBtnState(true, false, false);
				this.useBtnTitle1.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("kaiqi_text.png"));
			} else if (type === "add") {
				this.updateBtnState(true, false, false);
			} else if (type === "stuff_01" || type === "stuff_02" || type === "stuff_03") {
				this.updateBtnState(true, false, false);
				this.levelSprite.visible = true;
				this.levelSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + item.cfg.rank + ".png"));
				this.rbLabel.setString(item.cfg.sort);
			} else if (type === "drawing") {
				this.updateBtnState(true, false, false);
				this.useBtnTitle1.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("pinghe_text.png"));	
			} else if (type == "delay") {
				this.countTitle.visible = false;
				this.countLabel.visible = false;
				this.useTImeTitle.visible = true;
				this.useTitleLabel.visible = true;
			}
		}
		this.nameLabel.setString(item.cfg.name);
		this.despLabel.setString(item.cfg.desp);
		if (type !== "delay") {
			this.countLabel.setString(item.amount);
		} else {
			if (item.bag.lastTime && DateUtil.isToday(item.bag.lastTime)) {
				this.updateBtnState(false, false, false);
				this.nextUseTip.visible = true;
			} else {
				this.updateBtnState(true, false, false);
				this.nextUseTip.visible = false;
			}
			this.useTitleLabel.setString(common.LocalizedString("bagDelay_cnt", ItemModule.getDelayBagLeftTime(item.id)));
		}
		this.rankFrame.setNormalImage(cc.Sprite("#frame_" + item.cfg.rank + ".png"));
		this.rankFrame.setSelectedImage(cc.Sprite("#frame_" + item.cfg.rank + ".png"));
		this.rank_bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_"+ item.cfg.rank +".png"));
		this.avatarSprite.visible = true;
		this.avatarSprite.setTexture(common.getIconById(item.cfg.icon));
		if (item.cfg.rank === 4) {
			olAni.addPartical({
				plist:"images/purpleEquip.plist", 
				node:this.avatarSprite,
				pos:cc.p(this.avatarSprite.getContentSize().width / 2, this.avatarSprite.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		} else if (item.cfg.rank === 5) {
			olAni.addPartical({
				plist:"images/goldEquip.plist", 
				node:this.avatarSprite,
				pos:cc.p(this.avatarSprite.getContentSize().width / 2, this.avatarSprite.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		}
	},
	updateBtnState:function(a, b, c){
		this.useBtn.visible = a;
		this.useBtnTitle1.visible = a;
		this.openOneBtn.visible = b;
		this.openOneTitle3.visible = b;
		this.openTenBtn.visible = c;
		this.openTenTitle2.visible = c;
	},
	useBtnTaped:function(){
		var item = this.item;
		var type = item.cfg.type;
		if (type === "add" || type === "vip" || type === "box" || type === "boxrandom1") {
			ItemModule.doUseItem(item.id, 1, NOTI.REFRESH_PACKAGE, function(dic) {
				traceTable("fail", dic);
			});
		} else if (type === "drawing") {
			var count = ItemModule.getDrawingCombineCount(item.itemId);
			if (item.amount >= count) {
				ItemModule.doUseItem(item.id, 1, NOTI.REFRESH_PACKAGE, function(dic) {
					traceTable("fail", dic);
				});
			} else {
				common.showTipText(common.LocalizedString("drawing_notEnoughTips", count - item.amount));
			}
		} else if (type === "item") {
			if (item.itemId === "item_005") {
				// TODO 更名卡
			} else if (item.itemId === "item_006" || item.itemId === "item_008" || item.itemId === "item_009") {
				postNotifcation(NOTI.GOTO_HEROES);
			} else if (item.itemId === "item_028" || item.itemId === "item_029" || 
					item.itemId === "item_030" || item.itemId === "item_031" || item.itemId === "item_032") {
				// TODO 装备合成
			} else if (item.itemId === "item_007") {
				// TODO 聊天
			} else if (item.itemId === "item_010") {
				// TODO 无风带
			} else if (item.itemId === "item_022" || item.itemId === "item_023") {
				// TODO 拼图活动
			} else if (item.itemId === "itemcamp_002" || item.itemId === "itemcamp_003" || 
					item.itemId === "itemcamp_004" || item.itemId === "itemcamp_005" || 
					item.itemId === "item_006") {
				// TODO 海战
			} else {
				ItemModule.doUseItem(item.id, 1, NOTI.REFRESH_PACKAGE, function(dic){
					traceTable("fail", dic);
					var titleStr;
					if (dic.code === 1120) {
						titleStr = common.LocalizedString("道具不足");
					}
				});
			}
		} else if (type === "stuff_01" || type === "stuff_02" || type === "stuff_03") {
			// TODO 装备页面
		} else if (type === "delay") {
			ItemModule.doUseDelayItem(item.id, NOTI.REFRESH_PACKAGE, function(dic){
				traceTable("fail", dic);
			});
		}
	},
	open:function(count){
		var item = this.item;
		var type = item.cfg.type;
		if (type === "keybag") {
			var need = ItemModule.getInsufficientByKeybagId(item.itemId, count);
			var id = ItemModule.getRelativeItemId(item.itemId);
			if (need > 0) {
				var cfg = ItemModule.getItemConfig(id);
				if (id === "keybag_002" || id === "keybag_001") {
					var info = common.LocalizedString("船长，您需要 %s 才能使用此钥匙，去新世界冒险可以有机会得到此箱子，快去试试吧！", cfg.name);
					var cb = new ConfirmBox({info:info, confirm:function(){
						// TODO 去大冒险
					}});
					cc.director.getRunningScene().addChild(cb);
				} else {
					var tipsStr;
					if (id.indexOf("bag") === 0) {
						tipsStr = common.LocalizedString("船长，您需要购买 %s 把 %s 才能打开此箱子，不然得不到里面的财宝，有付出才能有大收获哦！", [need, cfg.name]);
					} else {
						tipsStr = common.LocalizedString("船长，您需要购买 %s 个 %s 才能使用这把钥匙，不然得不到里面的财宝，有付出才能有大收获哦！", [need, cfg.name]);
					}
					// TODO 购买箱子和钥匙
					var cb = new ConfirmBox({info:tipsStr, confirm:function(){
						// TODO 去大冒险
					}});
					cc.director.getRunningScene().addChild(cb);
				}
			} else {
				ItemModule.doUseItem(item.itemId, count, NOTI.REFRESH_PACKAGE, function(dic){
					traceTable("fail", dic);
			
				});
			}
		} else if (type === "soulbag" || type === "boxrandom" || type === "boxrandom1") {
			ItemModule.doUseItem(item.itemId, count, NOTI.REFRESH_PACKAGE, function(dic){
				traceTable("fail", dic);
			
			});
		}
	},
	openOneBtnTaped:function(){
		this.open("1");
	},
	openTenBtnTaped:function(){
		// TODO vip等级
		var item = this.item;
		var amount = ItemModule.getItemCount(item.itemId);
		if (amount >= 10) {
			this.open(10);
		} else {
			var need = 10 - amount;
			var cfg = ItemModule.getItemConfig(item.itemId);
			if (item.itemId === "keybag_002" || item.itemId === "keybag_001") {
				var info = common.LocalizedString("船长，您的 %s 不够，去新世界冒险可以有机会得到此箱子，快去试试吧！", cfg.name);
				var cb = new ConfirmBox({info:info, confirm:function(){
					if (FunctionModule.bOpen("blood")) {
						AdventureModule.adventurePage = 0;
						postNotifcation(NOTI.GOTO_ADVENTURE, {page:AdventureModule.adventurePage});
					} else {
						common.ShowText("大冒险未开启！")
					}
				}});
				cc.director.getRunningScene().addChild(cb);
			} else {
				var id = ItemModule.getRelativeItemId(item.itemId);
				var titleStr, tipsStr;
				if (id.indexOf("bag") === 0) {
					titleStr = common.LocalizedString("箱子不足");
					tipsStr = common.LocalizedString("船长，您需要购买 %s 把 %s 才能打开此箱子，不然得不到里面的财宝，有付出才能有大收获哦！", [need, cfg.name]);
				} else {
					titleStr = common.LocalizedString("钥匙不足");
					tipsStr = common.LocalizedString("船长，您需要购买 %s 个 %s 才能使用这把钥匙，不然得不到里面的财宝，有付出才能有大收获哦！", [need, cfg.name]);
				}
				// TODO 购买箱子和钥匙
				common.ShowText(titleStr)
			}
		}
	}
});