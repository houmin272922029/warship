var SelHeroFarewellLayer = cc.Layer.extend({
	selected:-1,
	ctor:function(desHeroUid){
		this.desUid = desHeroUid;
		this._super();
		cc.BuilderReader.registerController("SelHeroFarewellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.SelHeroFarewellView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
	},
	onEnter:function(){
		this._super();
		this.heroes = HeroModule.getFarewellHeroes(this.desUid);
		trace(this.desUid)
		if (!this.heroes || this.heroes.length === 0) {
			this.cantTips2.visible = true;
		} else {
			this.displayExp();
			this.createTableView();
			this.tv.reloadData();
		}
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var topLayer = this.HBTopLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height 
				- mainBottomTabBarHeight * retina) * 0.99 - this.expLayer.getContentSize().height * retina);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:mainBottomTabBarHeight * retina,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
		var node = cell.getChildByTag(100);
		if (this.selected === cell.getIdx()) {
			this.selected = -1;
			node.unselectNode();
		} else {
			this.selected = cell.getIdx();
			node.selectNode();
		}
		this.displayExp();
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(cc.winSize.width, 170 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new OnFormCell(this.heroes[idx]);
		node.attr({
			x:cc.winSize.width / 2,
			y:170 * retina / 2,
			anchorX:0.5,
			anchorY:0.5
		});
		node.scale = retina;
		cell.addChild(node, 0, 100);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.heroes.length;
	},
	displayExp:function(){
		var desHero = HeroModule.getHeroByUid(this.desUid);
		var desNextExp = desHero.expMax - desHero.expNow;

		var selectedExp = 0;
		var hero = null;
		if (this.selected >= 0) {
			hero = this.heroes[this.selected];
			selectedExp = hero.expAll;
		}
		var total = 0;
		for (var k in this.heroes) {
			var hero = this.heroes[k];
			total += hero.expAll;
		}
		this.totalExp.setString(common.LocalizedString("被传承的伙伴将被消耗，可传承的总经验：%d", total));
		this.selExp.setString(common.LocalizedString("被选择船员总经验：%d", selectedExp));
		this.upgradeExp.setString(common.LocalizedString("底卡升级需要经验：%d", desNextExp));
		
		this.totalExp.visible = true;
		this.selExp.visible = true;
		this.upgradeExp.visible = true;
	},
	confirmItemClick:function(){
		var uid = null;
		var uiType = 0;
		if (this.selected !== -1) {
			uid = this.heroes[this.selected].id;
			uiType = 1;
		}
		postNotifcation(NOTI.GOTO_FAREWELL, {des:this.desUid, src:uid, uiType:uiType});
	}
});