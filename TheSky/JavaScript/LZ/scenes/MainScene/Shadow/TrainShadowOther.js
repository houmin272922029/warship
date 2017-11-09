var TrainShadowOther = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("TrainShadowTrainOtherOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.TrainShadowTrainOther_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.showTrainBtn();
		this.createTableView();
	},
	initData:function(){
		this.ruleNotic = ShadowModule.trainShadowRule();
	},
	createTableView:function(table, idx){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var height = 0;
		for (var i = 0; i < this.ruleNotic.length; i++) {
			height += common.getFontHeight(this.ruleNotic[i], 295, 23, FONT_NAME);
		}
		this.cellHeight = common.getFontHeight(this.ruleNotic[0], 295, 23, FONT_NAME);
		
		var size = cc.size(300,300);
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
		this.tableViewContentView.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function(table, cell){
	},
	tableCellSizeForIndex:function (table, idx){
		var height = common.getFontHeight(this.ruleNotic[idx], 295, 23, FONT_NAME);
		return cc.size(300, height * retina);
	},
	tableCellAtIndex:function(table, idx){
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new cc.Layer();
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0,
			scale:retina
		});
		var label = cc.LabelTTF.create(this.ruleNotic[idx], FONT_NAME, 23, cc.size(295, 0), cc.TEXT_ALIGNMENT_LEFT);
		label.setAnchorPoint(cc.p(0, 1));
		var height = common.getFontHeight(this.ruleNotic[idx], 295, 23, FONT_NAME);
		label.setPosition(cc.p(0, height - 10 *retina));
		label.setColor(cc.color(255, 204, 0));
		node.addChild(label);
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function(table) {
		return this.ruleNotic.length;
	},
	showTrainBtn:function(){
		var vipLevel = 11;//TODO 获取vip等级
		var pingMingTen = 5;//TODO 通过vip数据类获取拼命10次是否可用
		var pinMingThirty = 10;//TODO 通过vip数据类获取拼命30次是否可用
		if (vipLevel >= pingMingTen) {
			this.trainTenTimesBtn.visible = true;
			this.trainTenTimesLabel.visible = true;
			if (vipLevel >= pinMingThirty) {
				this.trainThirtyTimesBtn.visible = true;
				this.trainThirtyTimes.visible = true;
			} else {
				this.trainThirtyTimesBtn.visible = false;
				this.trainThirtyTimes.visible = false;
			}
		} else {
			this.trainTenTimesBtn.visible = false;
			this.trainTenTimesLabel.visible = false;
		}
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	trainHundredTimesCallBack:function(){
		postNotifcation(NOTI.REFRESH_SHADOW_VIEW);
		trace("trainHundredTimesCallBack")
	},
	trainHundredTimesShadow:function(){
		ShadowModule.doOnShadowExercise([100], this.trainHundredTimesCallBack.bind(this));
	},
	trainTenTimesCallBack:function(){
		postNotifcation(NOTI.REFRESH_SHADOW_VIEW);
		trace("trainTenTimesCallBack")
	},
	trainTenTimesShadow:function(){
		if (playerdata.gold < 600000) {
			common.showTipText(common.LocalizedString("ERR_1102"));
			return;
		}
		if (playerdata.diamond < 5000) {
			common.showTipText(common.LocalizedString("ERR_1101"));
			return;
		}
		var info = common.LocalizedString("sureCostGoldAndBerry?",[5000,600000]);
		var cb = new ConfirmBox({info:info, confirm:function(){
			ShadowModule.doOnShadowExerciseWithStatus(5, 10, this.trainTenTimesCallBack.bind(this))
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	trainThirtyTimesCallBack:function(){
		postNotifcation(NOTI.REFRESH_SHADOW_VIEW);
		trace("trainThirtyTimesCallBack")
	},
	trainThirtyTimesShadow:function(){
		if (playerdata.gold < 1800000) {
			common.showTipText(common.LocalizedString("ERR_1102"));
			return;
		}
		if (playerdata.diamond < 15000) {
			common.showTipText(common.LocalizedString("ERR_1101"));
			return;
		}
		var info = common.LocalizedString("sureCostGoldAndBerry?",[15000,1800000]);
		var cb = new ConfirmBox({info:info, confirm:function(){
			ShadowModule.doOnShadowExerciseWithStatus(5, 30, this.trainThirtyTimesCallBack.bind(this))
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});