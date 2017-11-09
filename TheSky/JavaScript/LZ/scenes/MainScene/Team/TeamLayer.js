var TeamLayer = cc.Layer.extend({
	/**
	 * 
	 * @param page 页码
	 * @param type 0伙伴1影子2霸气
	 */
	ctor:function(page, type){
		this._super();
		this.page = page || 0;
		this.type = type || 0;
		this.initLayer();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("TeamViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.TeamView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
	},
	refresh:function(){
		if (this.pv) {
			this.pv.removeFromParent(true);
			this.pv = null;
		}
		if (this.lv) {
			this.lv.removeFromParent(true);
			this.lv = null;
		}
		this.createPageView();
		this.createTabelView();
	},
	createPageView:function() {
		var cache = cc.spriteFrameCache;
		cache.addSpriteFrames(common.formatLResPath("team.plist"));
		var sp = new cc.Sprite("#team_hero_bg.png");
		var size = cc.size(cc.winSize.width, sp.getContentSize().height * retina);
		this.pv = new ccui.PageView();
		this.pv.setTouchEnabled(true);
		this.pv.setContentSize(cc.size(size.width, size.height));
		this.pv.attr({
			x:0,
			y:(cc.winSize.height - broadCastHeight * retina + mainBottomTabBarHeight * retina - this.teamTopBg.getContentSize().height * retina
					- sp.getContentSize().height * retina) / 2,
			anchorX:0,
			anchorY:0
		});
		
		var inFormCount = FormModule.getFormMax();
		var pagesCount = inFormCount + 2; // 总览 啦啦队
		for (var i = 0; i < pagesCount; i++) {
			var layout = new ccui.Layout();
			layout.setContentSize(size);
			var layoutRect = layout.getContentSize();
			
			var node
			
			if (i < inFormCount) {
				// team
				var hero = FormModule.getHeroUidWithFormIndex(i);
				if (this.type === 0) {
					node = new TeamViewCell(hero, i);
				} else if (this.type === 1) {
					node = new ShadowViewCell(hero, i);
				} else if (this.type === 2) {
					node = new HakiViewCell(hero, i);
				}
			} else if (i === inFormCount) {
				// 总览
				node = new TeamAllViewCell();
			} else if (i === inFormCount + 1) {
				// 啦啦队
				node = new LaLaViewCell();
			}
			if (node) {
				node.attr({
					anchorX:0,
					anchorY:0,
					x:(size.width - node.getContentSize().width * retina) / 2,
					y:(size.height - node.getContentSize().height * retina) / 2,
				});
				layout.addChild(node, -1);
			}
			this.pv.addPage(layout);
		}
		this.pv.addEventListener(this.pageViewEvent, this);
		this.addChild(this.pv);
		this.pv.setCustomScrollThreshold(this.pv.width * 0.3);
	},
	pageViewEvent:function(sender, type){
		switch (type) {
		case ccui.PageView.EVENT_TURNING:
			this.selectHead(this.pv.getCurPageIndex());
			break;
		default:
			break;
		}
	},
	selectHead:function(page){
		var node = this.lv.getItem(this.page);
		var sel = node.getChildByTag(123);
		if (sel) {
			sel.removeFromParent(true);
		}
		this.page = page;
		var next = this.lv.getItem(this.page);
		var sel = new cc.Sprite("#selFrame.png");
		next.addChild(sel, -1, 123);
		sel.scale = retina;
		sel.attr({
			x:node.getContentSize().width / 2,
			y:node.getContentSize().height / 2,
			anchorX:0.5,
			anchorY:0.5
		});
		this.refreshListViewOffset();
	},
	refreshListViewOffset:function(){
		var leftArrow = this.leftArrow;
		var rightArrow = this.rightArrow;
		var width = rightArrow.x - leftArrow.x - leftArrow.getContentSize().width * 2 * retina;
		var sp = new cc.Sprite("#frame_1.png");
		var swidth = sp.getContentSize().width * 1.1 * retina;
		var inFormCount = FormModule.getFormMax();
		var count = inFormCount + 2;
		var container = this.lv.getInnerContainer();
		if (container.x >= -1 * this.page * swidth && container.x < (width - this.page * swidth)) {
			return;
		}
		var x;
		if (this.page + 1 < count / 2) {
			x = Math.max(this.page * swidth, width - count * swidth);
		} else {
			x = Math.max((this.page + 1) * swidth, width - count * swidth - swidth);
		}
		this.lv.scrollToPercentHorizontal(x / container.getContentSize().width * 100, 0.5, true);
	},
	createTabelView:function(){
		var leftArrow = this.leftArrow;
		var rightArrow = this.rightArrow;
		var sp = new cc.Sprite("#frame_1.png");
		var contentLayer = this.contentLayer;
		var size = cc.size(rightArrow.x - leftArrow.x - leftArrow.getContentSize().width * 2 * retina, 
				sp.getContentSize().height * retina * 1.1);
		this.lv = new ccui.ListView();
		this.lv.setDirection(ccui.ScrollView.DIR_HORIZONTAL);
		this.lv.setTouchEnabled(true);
		this.lv.setBounceEnabled(true);
		this.lv.setContentSize(size);
		this.lv.attr({
			x:leftArrow.x + leftArrow.getContentSize().width * retina,
			y:cc.winSize.height - sp.getContentSize().height * retina * 0.43,
			anchorX:0,
			anchorY:0
		});
		contentLayer.addChild(this.lv, 10, 10);
		
		var inFormCount = FormModule.getFormMax();
		var pagesCount = inFormCount + 2; // 总览 啦啦队
		
		for (var i = 0; i < pagesCount; i++) {
			var t = new cc.Sprite("#frame_1.png");
			var button;
			if (i < inFormCount) {
				var uid = FormModule.getHeroUidWithFormIndex(i);
				if (uid && uid !== "") {
					var hero = HeroModule.getHeroByUid(uid);
					button = new ccui.Button("rank_head_bg_"+ hero.rank+".png", "rank_head_bg_"+ hero.rank+".png", "", ccui.Widget.PLIST_TEXTURE);
					var sp = new cc.Sprite("#frame_" + hero.rank + ".png");
					var head = new cc.Sprite("#"+ HeroModule.getHeroHeadById(hero.heroId));
					button.addNode(head);
					button.addNode(sp);
					sp.attr({x:button.getContentSize().width / 2, y:button.getContentSize().height / 2});
					head.attr({x:button.getContentSize().width / 2, y:button.getContentSize().height / 2});
				} else {
					button = new ccui.Button("ol_hero_select.png", "ol_hero_select.png", "", ccui.Widget.PLIST_TEXTURE);
				}
			} else if (i == inFormCount) {
				button = new ccui.Button("allView.png", "allView.png", "", ccui.Widget.PLIST_TEXTURE);
			} else if (i == inFormCount + 1) {
				button = new ccui.Button("lalaView.png", "lalaView.png", "", ccui.Widget.PLIST_TEXTURE);
			} else {
				button = new ccui.Button("home_frame_lock.png", "home_frame_lock.png", "", ccui.Widget.PLIST_TEXTURE);
			}
			var t = new cc.Sprite("#frame_1.png");
			
			button.scale = retina;
			button.setTouchEnabled(true);
			button.setSwallowTouches(false);
			button.addTouchEventListener(function(sender, type){
				if (type === ccui.Widget.TOUCH_ENDED) {
					var idx = sender.getTag();
					if (idx < inFormCount + 2) {
						this.pv.scrollToPage(idx);
					} else {
						common.showTipText(common.LocalizedString("team_lock_next", FormModule.getNextFormMax()));
					}
				}
			}, this);
			var item = new ccui.Layout();
			item.setTouchEnabled(true);
			item.setContentSize(cc.size(t.getContentSize().width * retina * 1.1, t.getContentSize().height * retina * 1.1));
			button.attr({
				x:item.getContentSize().width / 2,
				y:item.getContentSize().height / 2,
				anchorX:0.5,
				anchorY:0.5
			});
			item.addChild(button, 0, i);
			this.lv.pushBackCustomItem(item);
		}
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.TEAM_CHANGE_TYPE, "changeType", this);
		addObserver(NOTI.FORM_CHANGE_SUCC, "refresh", this);
		this.refresh();
		this.pv.scrollToPage(this.page);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.TEAM_CHANGE_TYPE, "changeType", this);
		removeObserver(NOTI.FORM_CHANGE_SUCC, "refresh", this);
	},
	formItemClick:function(){
		cc.director.getRunningScene().addChild(new ChangeTeamLayer());
	},
	changeType:function(dic){
		this.type = dic.type
		this.refresh();
		this.pv.scrollToPage(this.page);
	}
});