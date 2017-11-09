var OnFormLayer = cc.Layer.extend({
	selected:-1,
	ftype:{
		form:0,
		lala:1
	},
	ctor:function(page, type){
		this._super();
		this.page = page;
		this.type = type || 0;
		cc.BuilderReader.registerController("OnFormOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.OnFormView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
	},
	onEnter:function(){
		this._super();
		this.offForm = FormModule.getHeroOffForm();
		this.createTableView();
		if (this.offForm.length == 0) {
			this.noHeroTips();
		}
	},
	onExit:function(){
		this._super();
	},
	noHeroTips:function(){
		var text = common.LocalizedString("team_need_partner");
		var cb = new ConfirmBox({info:text, type:1, close:function(){
			trace("close box and goto logue");
			this.confirmItemClick();
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
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
				- mainBottomTabBarHeight * retina) * 0.99);
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
		if (this.selected === -1) {
			this.selected = cell.getIdx();
			node.selectNode();
		} else {
			if (this.selected === cell.getIdx()) {
				this.selected = -1;
				node.unselectNode();
			} else {
				var lastCell = this.tv.cellAtIndex(this.selected);
				if (lastCell) {
					var lastNode = lastCell.getChildByTag(100);
					lastNode.unselectNode();
				}
				this.selected = cell.getIdx();
				node.selectNode();
			}
		}
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
		var node = new OnFormCell(this.offForm[idx]);
		node.attr({
			x:cc.winSize.width / 2,
			y:170 * retina / 2,
			anchorX:0.5,
			anchorY:0.5
		});
		node.scale = retina;
		if (idx === this.selected) {
			node.selectNode();
		}
		cell.addChild(node, 0, 100);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.offForm.length;
	},
	confirmItemClick:function(){
		if (this.selected == -1) {
			var page = this.page;
			if (this.type == this.ftype.lala) {
				page = FormModule.getFormMax() + 1;
			}
			postNotifcation(NOTI.GOTO_TEAM, {page:page});
		} else {
			var hid = this.offForm[this.selected].id;
			if (this.type === this.ftype.lala) {
				FormModule.doOnSevenForm(this.page, hid, this.onFormSucc.bind(this));
			} else {
				FormModule.doOnForm(this.page, hid, this.onFormSucc.bind(this));
			}
		}
	},
	onFormSucc:function(dic){
		var page = this.page;
		if (this.type == this.ftype.lala) {
			page = FormModule.getFormMax() + 1;
		}
		postNotifcation(NOTI.GOTO_TEAM, {page:page});
	}
});