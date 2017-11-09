var SkillLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("SkillViewLayerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.SkillView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
	},
	onEnter:function(){
		this._super();
		this.createTableView();
		this.tv.reloadData();
	},
	onExit:function(){
		this._super();
	},
	initData:function(){
		this.skills = SkillModule.getAllSkills();
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var topLayer = this.SkillTopLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height - mainBottomTabBarHeight * retina) * 0.99);
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
	},
	tableCellSizeForIndex:function (table, idx) {
		if (idx === this.skills.length) {
			return cc.size(cc.winSize.width, 80 * retina);
		} else {
			return cc.size(cc.winSize.width, 125 * retina);
		}
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node;
		if (idx === this.skills.length) {
			cc.BuilderReader.registerController("GotoDaMaoXianCellOwner", {
				"gotoDamaoxian":function(){
					postNotifcation(NOTI.GOTO_ADVENTURE, {page:AdventureModule.adventurePage});
					postNotifcation(NOTI.MOVETO_PAGE, {page : AdventureModule.getUserAdventureList().length - 1});
				}
			});
			node = cc.BuilderReader.load(ccbi_res.GotoAdventure_ccbi, this);
		} else {
			node = new SkillCell(this.skills[idx]);	
		}
		node.attr({
			x:cc.winSize.width / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
		});
		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.skills.length + 1;
	},
});