var AdventureLayer = cc.Layer.extend({
	/**
	 * 
	 * @param page页码 从0开始
	 */
	ctor:function(page){
		this._super();
		this.currentPage = page || 0;
		this.initLayer();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("AdventureViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.AdventureView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.adventureList = AdventureModule.getUserAdventureList();
		this.adventureNumber = this.adventureList.length;//大冒险关卡的数量
		
		var sp = new cc.Sprite("#frame_1.png");
		this.leftArrow.setPosition(cc.p(this.leftArrow.x, cc.winSize.height - sp.getContentSize().height * retina * 0.43 - 30 *retina));
		this.rightArrow.setPosition(cc.p(this.rightArrow.x, cc.winSize.height - sp.getContentSize().height * retina * 0.43 - 30 *retina))
	},
	refreshAdventureLayer:function(){
		if (this.pageView) {
			this.pageView.removeFromParent(true);
			this.pageView = null;
		}
		if (this.tv) {
			this.tv.removeFromParent(true);
			this.tv = null;
		}
		if (this.adventureList.length > 1) {
			if (this.currentPage >= this.adventureList.length) {
				this.currentPage = this.adventureList.length - 1;
			}
		}
		this.createPageView();
		this.createTableView();
		this.refreshTableViewOffset();
	},
	onEnter:function(){
		this._super();
		SoundUtil.playMusic("audio/adverture.mp3", true);
		if (!this.currentPage) {
			this.currentPage = 0;
		}
		this.refreshAdventureLayer();
		addObserver(NOTI.MOVETO_PAGE, "notiMoveToPage", this);
		this.pageView.scrollToPage(this.currentPage)
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.MOVETO_PAGE, "notiMoveToPage", this);
	},
	notiMoveToPage:function(dic){
		this.currentPage = dic.page;
	},
	createTableView:function(){
		var sp = new cc.Sprite("#frame_1.png");
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var size = cc.size(cc.winSize.width - this.leftArrow.getContentSize().width * 2 * retina,
		sp.getContentSize().height * retina * 1.2);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL);
		this.tv.attr({
			x:this.leftArrow.x + this.leftArrow.getContentSize().width * retina  ,
			y:cc.winSize.height - sp.getContentSize().height * retina * 0.41,
			anchorX:0,
			anchorY:0,
		});
		this.tv.setBounceable(true);
		this.tv.setDelegate(this);
		this.contentLayer.addChild(this.tv);
		this.tv.reloadData();
	},
	scrollViewDisScroll:function(view) {
	},
	scrollViewDidZoom:function(view) {
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
		var sp = new cc.Sprite("#frame_1.png");
		var size = sp.getContentSize();
		return cc.size(size.width * retina * 1.1, size.height * retina * 1.2);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var button;
		
		var key = this.adventureList[idx];
		if (key == "blood") {
			button = new ccui.Button("adventure_icon.png", "adventure_icon.png", "", ccui.Widget.PLIST_TEXTURE);
		} else if (key == "SSA") {
			button = new ccui.Button("ssa_icon.png", "ssa_icon.png", "", ccui.Widget.PLIST_TEXTURE);
		} else if (key == "boss") {
			button = new ccui.Button("boss_icon.png", "boss_icon.png", "", ccui.Widget.PLIST_TEXTURE);
		} else if (key == "veiledSea") {
			button = new ccui.Button("veiledSea_icon.png", "veiledSea_icon.png", "", ccui.Widget.PLIST_TEXTURE);
		} else if (key == "awake") {
			button = new ccui.Button("awakening_icon.png", "awakening_icon.png", "", ccui.Widget.PLIST_TEXTURE);
		} else if (key == "uninhabited") {
			button = new ccui.Button("uninhabited_icon.png", "uninhabited_icon.png", "", ccui.Widget.PLIST_TEXTURE);
		} else if (key == "calmbelt") {
			button = new ccui.Button("wufengdai_icon.png", "wufengdai_icon.png", "", ccui.Widget.PLIST_TEXTURE);
		} else if (key == "xunbao") {
			button = new ccui.Button("marine_icon.png", "marine_icon.png", "", ccui.Widget.PLIST_TEXTURE);
		} else if (key == "chapters") {
			button = new ccui.Button("chapters_all.png", "chapters_all.png", "", ccui.Widget.PLIST_TEXTURE);
		} else if (key.indexOf("book_") != -1) {
			var cfg = SkillModule.getSkillConfig(key);
			button = new ccui.Button("frame_" + cfg.rank + ".png", "frame_" + cfg.rank + ".png", "", ccui.Widget.PLIST_TEXTURE);
			if (cfg.icon) {
				var sp = new cc.Sprite(ccbi_dir + "/ccbi/ccbResources/icons/" + cfg.icon + ".png");
				var rankbg = new cc.Sprite("#frame_" + cfg.rank + ".png");
				if (sp) {
					button.addChild(sp, 1, 10);
					sp.setScale(0.35);
					sp.setPosition(button.getContentSize().width / 2, button.getContentSize().height / 2);
				}
				if (rankbg) {
					button.addChild(rankbg, 2, 1000);
					rankbg.setPosition(button.getContentSize().width / 2, button.getContentSize().height / 2);
				}
			}
		}
		var item = new ccui.Layout();
		item.addChild(button, 1, idx);
		item.setPosition(cc.p(0, 0));
		item.setAnchorPoint(cc.p(0, 0));
		item.setScale(retina);
		cell.addChild(item,1,10);
		button.setTouchEnabled(true);
		button.setSwallowTouches(false);
		button.addTouchEventListener(function(sender, type){
			if (type === ccui.Widget.TOUCH_ENDED) {
				var idx = this.currentPage;
				this.pageView.scrollToPage(sender.getTag());
				this.selectLogo(sender.getTag())
			}
		}, this);
		var sp = new cc.Sprite("#frame_1.png");
		button.setAnchorPoint(cc.p(0, 0));
		button.attr({
			x:sp.getContentSize().width * 0.05 * retina,
			y:sp.getContentSize().height * 0.02 * retina,
			anchorX:0,
			anchorY:0
		});
		var menuBg = new cc.Sprite("#dailyNameBg.png");
		menuBg.setPosition(cc.p(button.getContentSize().width - menuBg.getContentSize().width * 0.6, menuBg.getContentSize().height * 0.71));
		button.addChild(menuBg);
		var label = cc.LabelTTF.create("", "ccbResources/FZCuYuan-M03S.ttf", 18);
		label.setColor(cc.color(221, 233, 73));
		label.setPosition(cc.p(button.getContentSize().width - menuBg.getContentSize().width*1.63, menuBg.y / 1.5));
		menuBg.addChild(label);
		if (key == "blood") {
			label.setString(common.LocalizedString("冒险"));
		} else if (key == "SSA") {
			label.setString(common.LocalizedString("SSA.server_pkName"));
		} else if (key == "veiledSea") {
			label.setString(common.LocalizedString("adventure_veiledSea"));
		} else if (key == "boss") {
			label.setString(common.LocalizedString("daily_emogu"));
		} else if (key == "awake") {
			label.setString(common.LocalizedString("adventure_awake"));
		} else if (key == "calmbelt") {
			label.setString(common.LocalizedString("daily_wufengdai"));
		} else if (key == "xunbao") {
			label.setString(common.LocalizedString("支部"));
		} else if (key == "chapters") {
			label.setString(common.LocalizedString("残页"));
		} else if (key == "uninhabited") {
			label.setString(common.LocalizedString("haki_uninhabited_name"));
		}
		if (idx == this.currentPage) {
			var sel =  new cc.Sprite("#selFrame.png");
			button.addChild(sel, -1, 11);
			sel.attr({
				x:button.getContentSize().width / 2,
				y:button.getContentSize().height / 2,
				anchorX:0.5,
				anchorY:0.5
			});
		}
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.adventureList.length;
	},
	createPageView:function(){
		var cache = cc.spriteFrameCache;
		cache.addSpriteFrames(common.formatLResPath("publicRes_4.plist"));
		cache.addSpriteFrames(common.formatLResPath("newworld.plist"));
		var sp = new cc.Sprite("#newworld_bg_0.png");
//		var size = cc.size(cc.winSize.width, sp.getContentSize().height * retina)
		var sizess = cc.size(cc.winSize.width, 781 * retina)
		this.pageView = new ccui.PageView();
		this.pageView.setTouchEnabled(true);
		this.pageView.setContentSize(sizess);
		var pageViewX = (cc.winSize.width - sizess.width * retina) / 2;
//		var pageViewY = (cc.winSize.height - broadCastHeight * retina + mainBottomTabBarHeight * retina - this.teamTopBg.getContentSize().height - size.height - 2 * retina) / 2;
		var pageViewYY = cc.winSize.height - this.teamTopBg.getContentSize().height - 35 *retina;
		this.pageView.attr({
			x:cc.winSize.width / 2,
			y:pageViewYY,
			anchorX:0.5,
			anchorY:1
		});
		for (var i = 0; i < this.adventureNumber; i++) {
			var layout = new ccui.Layout();
			
			layout.setContentSize(sizess);
			var node;
			if (this.adventureList[i] == "blood") {
				node = new NewWorldLayer();
			} else if (this.adventureList[i] == "SSA") {
			} else if (this.adventureList[i] == "boss") {
				node = new bossLayer();
			} else if (this.adventureList[i] == "veiledSea") {
			} else if (this.adventureList[i] == "awake") {
			} else if (this.adventureList[i] == "uninhabited") {
			} else if (this.adventureList[i] == "calmbelt") {
			} else if (this.adventureList[i] == "xunbao") {
			} else if (this.adventureList[i] == "chapters") {
				node = new chaptersLayer();
			} else if (this.adventureList[i].indexOf("book_") != -1) {
				node = new chapterLayer(this.adventureList[i]);
			}
			if (node) {
				node.attr({
					anchorX:0.5,
					anchorY:0.5,
					x:(sizess.width - node.getContentSize().width * retina) / 2,
					y:(781* retina - node.getContentSize().height * retina) / 2,
				});
				
				
				layout.addChild(node, -1);
			}
			this.pageView.addPage(layout);
		}
		this.pageView.addEventListener(this.pageViewEvent, this);
		this.addChild(this.pageView);
		this.pageView.setCustomScrollThreshold(this.pageView.width * 0.3); // 设置滑动pageView的0.3宽度就翻页
	},
	refreshTableViewOffset:function(){
		var width = this.contentLayer.getContentSize().width - this.leftArrow.getContentSize().width * 2 * retina;
		var sp = new cc.Sprite("#frame_1.png");
		if (this.tv.getContentOffset().x >= - this.currentPage * sp.getContentSize().width * 1.1 * retina && 
				this.tv.getContentOffset().x < (width - this.currentPage * sp.getContentSize().width * 1.1 * retina)) {
			return;
		}
		var x = Math.min(this.currentPage * sp.getContentSize().width * 1.1 * retina, this.adventureList.length * sp.getContentSize().width * 1.1 * retina - width);
		this.tv.setContentOffsetInDuration(cc.p(-x, 0), 0.2);
		this.pageView.scrollToPage(this.currentPage);
		this.runAction(cc.Sequence.create(cc.DelayTime.create(0.2),cc.CallFunc.create(this.selectLogo(this.currentPage))));
	},
	pageViewEvent:function(sender, type){
		switch (type) {
		case ccui.PageView.EVENT_TURNING:
			var postString = this.adventureList[this.pageView.getCurPageIndex()];
			if (AdventureModule.adventurePage != this.pageView.getCurPageIndex()) {
				postNotifcation(postString);
				AdventureModule.adventurePage = this.pageView.getCurPageIndex();
			}
			if (this.adventureList[this.pageView.getCurPageIndex()] == "boss") {
				SoundUtil.playMusic("audio/boss.mp3", true);
			}else {
				SoundUtil.playMusic("audio/adverture.mp3", true);
			}
			this.selectLogo(this.pageView.getCurPageIndex());
			break;
		default:
			break;
		}
	},
	selectLogo:function(currentPage){
		this.currentPage = currentPage;
		var cell = this.tv.cellAtIndex(currentPage);
		this.tv.reloadData();
		this.currentPage = currentPage;
		this.refreshTableViewOffset();
	},
});