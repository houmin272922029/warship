var HomeLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		var self = this;
		cc.BuilderReader.registerController("HomeSceneOwner", {
			"heroItemClick":function(){
				self.heroItemClick();
			},
			"equipItemClick":function(){
				self.equipItemClick();
			},
			"skillItemClick":function(){
				self.skillItemClick();
			},
			"warshipItem":function(){
				self.warshipItem();
			},
			"packageItemClick":function(){
				self.packageItemClick();
			},
			"rosterItemClick":function() {
				self.rosterItemClick();
			},
			"mailItemClick":function() {
				self.mailItemClick();
			},
			"questItemClick":function(){
				self.questItemClick();
			},
		});
		this.node = cc.BuilderReader.load(ccbi_res.HomeLayer_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("olRes/ol_home.plist"));
		
		if (retina == 1) {
			this.btn_bg.attr({
				x:cc.winSize.width / 2,
				y:cc.winSize.height * 0.304,
				anchorX:0.5,
				anchorY:0.5,
			});
			if (cc.winSize.height <= 968) {
				this.right_longzhu.attr({
					x:cc.winSize.width + 45,
					y:cc.winSize.height * 0.083,
					anchorX:1,
					anchorY:0,
				});
				this.left_longzhu.attr({
					x:-45,
					y:cc.winSize.height * 0.083,
					anchorX:0,
					anchorY:0,
				});
			}
		}
		
	},
	onEnter:function(){
		this._super();
		SoundUtil.playMusic("audio/home_" + Math.floor(Math.random()*3+1) + ".mp3", true);
		this.createTableView();
		this.createPageView();
	},
	onExit:function(){
		this._super();
	},
	heroItemClick:function(){
		postNotifcation(NOTI.GOTO_HEROES);
	},
	skillItemClick:function(){
		postNotifcation(NOTI.GOTO_SKILLS);
	},
	warshipItem:function(){
		common.showTipText(common.LocalizedString("close_func"));
	},
	packageItemClick:function(){
		postNotifcation(NOTI.GOTO_PACKAGE, {type:"item"});
	},
	equipItemClick:function(){
		postNotifcation(NOTI.GOTO_EQUIPS); 
	},
	rosterItemClick:function(){
		postNotifcation(NOTI.GOTO_ATLAS, {type:"hero"});
	},
	mailItemClick:function(){
		postNotifcation(NOTI.GOTO_NEWS, {type:"system"});
	},
	logItemClick:function(){
		postNotifcation(NOTI.GOTO_FRIEND, {type:"friends"});
	},
	chatItemClick:function(){
		postNotifcation(NOTI.GOTO_CHAT, {type:"0"});
	},
	optionItemClick:function(){
		postNotifcation(NOTI.GOTO_SYSTEM);
	},
	purchaseItemClick:function(){
		postNotifcation(NOTI.GOTO_CHONGZHI);
	},
	questItemClick:function(){
		postNotifcation(NOTI.GOTO_QUEST, {type:"once"});
	},
	eventItemClick:function(){
		common.showTipText(common.LocalizedString("close_func"));
	},
	warshipItem:function(){
		common.showTipText(common.LocalizedString("close_func"));
	},
	/**
	 * 阵型数量
	 */
	getHeroFrameCount:function(){
		var count = this.formMax;
		// 上阵人数未满加一把锁
		if (count < 8) {
			count++;
		}
		// 加上总览和啦啦队
		count+=2;
		return count;
	},
	createTableView:function(){
		this.formMax = FormModule.getFormMax();
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var sp = new cc.Sprite("#home_frame_hero.png");
		var size = cc.size(cc.winSize.width, (sp.getContentSize().height + 5) * retina);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL);
		this.tv.attr({
			x:0,
			y:cc.winSize.height - 110 * retina - size.height,
			anchorX:0,
			anchorY:0,
		});
		this.tv.setDelegate(this);
		this.titleLayer.addChild(this.tv);
		this.tv.reloadData();
		this.menuLayer.setLocalZOrder(1);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
		var sp = new cc.Sprite("#home_frame_hero.png");
		var size = sp.getContentSize();
		return cc.size(size.width * retina, (size.height + 5) * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		if (idx < this.formMax) {
			// 半身像
			var sp = new cc.Sprite("#home_frame_null.png");
			sp.attr({
				x:0,
				y:0,
				anchorX:0,
				anchorY:0
			});
			sp.scale = retina;
			cell.addChild(sp, 1);
			var uid = FormModule.getHeroUidWithFormIndex(idx);
			if (uid) {
				var hero = HeroModule.getHeroByUid(uid);
				var bust = HeroModule.getHeroBust2ById(hero.heroId);
				if (bust) {
					var bustSp = new cc.Sprite(bust);
					var heroBg = new cc.Sprite("#rank_bust_bg_" + hero.rank + ".png");
					if (bustSp) {
						bustSp.attr({
							x:0,
							y:0,
							anchorX:0,
							anchorY:0
						});
						heroBg.attr({
							x:0,
							y:0,
							anchorX:0,
							anchorY:0
						});
						sp.addChild(bustSp, 1);
						sp.addChild(heroBg, 0);
					}
				}
			}
		} else {
			var name = "";
			if (idx === this.formMax) {
				// 总览
				name = "#home_frame_all.png";
			} else if (idx === this.formMax + 1) {
				name = "#home_frame_lala.png";
			} else if (this.formMax < 8 && idx === this.formMax + 2) {
				name = "#home_frame_lock.png";
			}
			var sp = new cc.Sprite(name);
			sp.attr({
				x:0,
				y:0,
				anchorX:0,
				anchorY:0
			});
			sp.scale = retina;
			cell.addChild(sp, 1);
		}
		var button = new ccui.Button("home_frame_hero.png", "home_frame_hero.png", "", ccui.Widget.PLIST_TEXTURE);
		this.button = button;
		button.setTouchEnabled(true);
		button.setSwallowTouches(false);
		button.addTouchEventListener(function(sender, type){
			if (type === ccui.Widget.TOUCH_MOVED) {
				button.setTouchEnabled(false);
			} else if (type === ccui.Widget.TOUCH_ENDED) {
				var idx = sender.getTag();
				if (this.formMax < 8 && idx === this.formMax + 2) {
					trace(common.LocalizedString("team_lock_next", FormModule.getNextFormMax()));
					common.showTipText(common.LocalizedString("team_lock_next", FormModule.getNextFormMax()));
					return;
				}
				postNotifcation(NOTI.GOTO_TEAM, {page : idx});
			}
		}, this);
		button.attr({
			anchorX:0,
			anchorY:0,
			scale:retina
		});
		cell.addChild(button, 1, idx);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.getHeroFrameCount();
	},
	createPageView:function(){
		var pageLayer = this["pageLayer"];
		var size = pageLayer.getContentSize();
		var sp = new cc.Sprite("#btn_icon_1.png");
		this.pageView = new ccui.PageView();
		this.pageView.setTouchEnabled(true);
		this.pageView.setContentSize(cc.size(size.width * retina, size.height * retina));
		this.pageView.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		for (var i = 0; i < 7; i++) {
			var layout = new ccui.Layout();
			layout.setContentSize(size);
			layout.scale = retina;
			var layoutRect = layout.getContentSize();
			
			var button = new ccui.Button("btn_icon_" + (i + 1) +".png", "btn_icon_" + (i + 1) +".png", "", ccui.Widget.PLIST_TEXTURE);
			button.setTouchEnabled(true);
			button.attr({
				x:size.width / retina / 2,
				y:retina == 1 ? size.height * 1.08 / 2 : size.height / 2,
			});
			
			button.scale = 0.66;
			
			button.addTouchEventListener(this.pageItemClick, this);
			layout.addChild(button);
			
			var image = new ccui.ImageView("home_gy_text_" + (i + 1) + ".png", ccui.Widget.PLIST_TEXTURE);
			image.attr({
				x: button.getContentSize().width / 2,
				y: retina == 1 ? 28 : 25 * retina,
				anchorX:0.5,
				anchorY:0
			});
			button.addChild(image);
			
			this.pageView.addPage(layout);
		}
		this.pageView.addEventListener(this.pageViewEvent, this);
		pageLayer.addChild(this.pageView);
		this.pageView.setCustomScrollThreshold(this.pageView.width * 0.3);
	},
	pageItemClick:function(sender, type){
		if (type === ccui.Widget.TOUCH_ENDED) {
			var page = this.pageView.getCurPageIndex();
			cc.log("page = " + this.pageView.getCurPageIndex());
			switch (page) {
			case 0:
				postNotifcation(NOTI.GOTO_STAGE);
				break;
			case 1:
				postNotifcation(NOTI.GOTO_ADVENTURE, {page:AdventureModule.adventurePage});
				break;
			case 2:
				postNotifcation(NOTI.GOTO_SHADOW, {type : 0});
				break;
			case 3:
				postNotifcation(NOTI.GOTO_UNION);
				break;
			case 4:
				postNotifcation(NOTI.GOTO_ARENA, {page : "fight"});
				break;
			case 5:
				postNotifcation(NOTI.GOTO_LOGUETOWN, {type : 0});
				break;
			case 6:
				common.showTipText(common.LocalizedString("close_func"));
				break;
			default:
				break;
			}
			
		}
	},
	pageViewEvent:function(sender, type){
		switch (type) {
		case ccui.PageView.EVENT_TURNING:
			var pageView = sender;
//			cc.log("page = " + pageView.getCurPageIndex());
			break;
		default:
			break;
		}
	},
	
});