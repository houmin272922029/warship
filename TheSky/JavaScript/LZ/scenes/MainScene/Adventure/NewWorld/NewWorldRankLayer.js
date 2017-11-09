var NewWorldRankLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("NewWorldRankViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.NewWorldRankView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.currenTag = 0;
		this.onTouch.bind(this);
	},
	onEnter:function(){
		this._super();
		var seq = cc.Sequence.create(cc.DelayTime.create(0.2),cc.CallFunc.create(this.setMenuPriority()));
		this.runAction(seq);
		BloodModule.doOnBloodRankInfo(this.rankInfoCallback.bind(this));
	},
	onExit:function(){
		this._super();
	},
	onTouchBegan:function(x, y){
		var touchLocation = this.convertToNodeSpace(cc.p(x, y));
		var infoBg = this.infoBg;
		var rect = infoBg.bondingBox();
		if (!rect.containsPoint(touchLocation)) {
			this.removeFromParent(true);
			return true;
		}
		return true;
	},
	onTouch:function(eventType, x, y){
		if (eventType == "began") {
			return this.onTouchBegan(x, y);
		} else {}
	},
	setMenuPriority:function(){
		this.menu.setSwallowTouches(true);
		if (this.tv) {
			//this.tv.setTouchPriority(20);
		}
	},
	rankInfoCallback:function(){
		this.rankInfo = blooddata.yesterdayRankInfo;
		this.currenTag = FormModule.getFormMax() - 4;
		this.changeRank(this.currenTag);
	},
	changeRank:function(index){
		this.initData = [];
		var dic = this.rankInfo[(index+4).toString()];
		if (this["tab" + this.currenTag]) {
			item = this["tab" + this.currenTag].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn_fenye_0.png"));
		}
		this.currenTag = index;
		if (this["tab" + this.currenTag]) {
			item = this["tab" + this.currenTag].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn_fenye_1.png"));
		}
		if (this.tv) {
			this.tv.removeFromParent(true);
			this.tv = null;
		}
		for ( var k in dic) {
			this.initData.push(dic[k])
		}
		this.createTableView();
		var seq = cc.Sequence.create(cc.DelayTime.create(0.2),cc.CallFunc.create(this.setMenuPriority()));
		this.runAction(seq);
		if (index != FormModule.getFormMax() - 4) {
			this.rankTitleLabel.visible = false;
			this.rankLabel.visible = false;
			this.todayTitleLabel.visible = false;
			this.todayLabel.visible = false;
		} else {
			
			this.rankTitleLabel.visible = true;
			this.rankLabel.visible = true;
			this.todayTitleLabel.visible = true;
			this.todayLabel.visible = true;
			var rank = -1;
			if (dic) {
				for ( var k in dic) {
					if (dic[k].id == playerdata.id) {
						rank = k + 1;
						break;
					}
				}
			}
		}
		
		if (rank > 0) {
			this.rankLabel.setString(parseInt(rank));
		} else {
			this.rankLabel.setString(common.LocalizedString("newworld_outofrank"));
		}
		if (!blooddata.datas.todayRank || blooddata.datas.todayRank == "") {
			this.todayLabel.setString(common.LocalizedString("newworld_outofrank"));
		} else {
			this.todayLabel.setString(blooddata.datas.todayRank);
		}
	},
	formItemClick:function(sender){
		var tag = sender.getTag();
		if (tag == this.currenTag) {
			return
		}
		this.changeRank(tag);
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	createTableView:function(){
		if (this.tv) {
			this.tv.removeFromParent(true);
			this.tv.reloadData();
		}
		if (!this.initData || this.initData.length < 1) {
			return;
		}
		var contentLayer = this.contentLayer.getContentSize();
		var size = cc.size(contentLayer.width , contentLayer.height );
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.contentLayer.addChild(this.tv, 10, 10);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function(table, cell) {
	},
	tableCellSizeForIndex:function(table, idx){
		return cc.size(cc.winSize.width / retina, 170);
	},
	tableCellAtIndex:function(table, idx){
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new NewWorldRankCell(this.initData[idx], idx);
		node.attr({
			x:this.contentLayer.getContentSize().width / 2,
			y:175 / 2,
			anchorX:0.5,
			anchorY:0.5
		});
		node.scale = retina;
		cell.addChild(node, 0, 1);
		return cell;
	},
	numberOfCellsInTableView:function(table){
		return this.initData.length;
	},
});