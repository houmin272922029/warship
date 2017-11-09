var RecruitHeroesView = cc.Layer.extend({
	ctor:function(param){
		this._super();
		this.param = param;
		this.tag = param.type;
		cc.BuilderReader.registerController("RecruitHeroesOwner", {
		})
		var node = cc.BuilderReader.load(ccbi_res.RecruitHeroesView_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.createTableView();
		this.tv.reloadData();
	},
	closeItemClick:function() {
		this.removeFromParent(true);
	},
	recruitSucc:function(dic) {
		postNotifcation(NOTI.RESURIT_HERO, "refersh", this);
	},
	recruitAction:function(){
		var pay = config.recruit_cost;
		if (recruitdata.shopHero.tenPickOne.isFree == 1 || recruitdata.shopHero.bestPickOne.isFree == 1 || recruitdata.shopHero.wanPickOne.isFree == 1) {
			RecruitModule.doRecruit(this.tag, "1", this.recruitSucc.bind(this));
		} else {
			if  (this.tag == 1) {
				RecruitModule.doRecruit(this.tag, "1", this.recruitSucc.bind(this));
			} else if(this.tag == 2) {
				var cost = config.recruit_cost[this.tag].cost;
				if (cost > PlayerModule.getGold()) {
					var text = common.LocalizedString("船长，重金才能招募到厉害的伙伴，但是你的金币数量不足了，快去充值招募心仪的伙伴吧！");
					var cb = new ConfirmBox({info:text, type:0, confirm:function(){
						var layer = new RechargeLayer();
						cc.director.getRunningScene().addChild(layer);
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				} else {
					var text = common.LocalizedString("船长,确定花费100个金币招募吗？");
					var cb = new ConfirmBox({info:text, type:0, confirm:function(){
						RecruitModule.doRecruit(this.tag, "1", this.recruitSucc.bind(this));
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				}
			} else if (this.tag == 3) {
				var cost = config.recruit_cost[this.tag].cost;
				if (cost > PlayerModule.getGold()) {
					var text = common.LocalizedString("船长，重金才能招募到厉害的伙伴，但是你的金币数量不足了，快去充值招募心仪的伙伴吧！");
					var cb = new ConfirmBox({info:text, type:0, close:function(){}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				} else{
					var text = common.LocalizedString("船长,确定花费300个金币招募吗？");
					var cb = new ConfirmBox({info:text, type:0, confirm:function(){
						RecruitModule.doRecruit(this.tag, "1", this.recruitSucc.bind(this));
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				}
			}
		}
	},
	initData:function(tag) {
		this.data = RecruitModule.getRecruitHeroesData(this.tag);
	},
	createTableView:function() {
		this.initData();
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		this.tv = new cc.TableView(this, this.containLayer.getContentSize());
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.containLayer.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view) {
	},
	tableCellTouched:function(table, cell) {
	},
	tableCellSizeForIndex:function(table, idx) {
		return cc.size(550, 140);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new RecruitHeroesCell(this.data[idx]);
		node.attr({
			x:275,
			y:0,
			anchorX:0.5,
			anchorY:0,
		});
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function(table) {
		return this.data.length;
		
	},
	
});