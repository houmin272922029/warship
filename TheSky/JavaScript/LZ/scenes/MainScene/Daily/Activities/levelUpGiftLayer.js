var levelUpGiftLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
		
		this.viewData_ = null;

		this.createListView(this.contentLayer)
		this.listView_.setSwallowTouches(true);
	},
	
	onActivate : function() {
		ActivityModule.fetchLevelUpData();
	},
	
	refreshView : function(viewData) {
		
		if (this.listView_) {
			this.listView_.removeAllItems();
		}
		
		if (viewData == null) {
			viewData = ActivityModule.getLevelUpMainData();
		}

		this.viewData_ = viewData;
		
		for (var int = 1; int < viewData.length ; int++) {
			var cellView = new LevelUpGiftCell(
					{
						width : this.contentLayer.getContentSize().width,
						index : int + 1,
						cellData : viewData[int],
						target : this,
						callBack : this.onItemTaped
					});
			this.listView_.pushBackCustomItem(cellView);
			this.listView_.setSwallowTouches(true);
		}
		
	},
	
	onItemTaped : function(index) {
		var data = this.viewData_[index - 1];
		if (data.isCondition) {
			ActivityModule.doGetLevelUpRewardAction(data.level);
		} else {
			common.ShowText(common.LocalizedString("level_update_reward", [data.level]));
		}
	},
});

/**
 * 升级送礼页面的一条
 */
var LevelUpGiftCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);

		this.index_ = params.index;
		this.cellWidth_ = params.width;
		this.cellData_ = params.cellData;
		this.callBack_ = params.callBack;
		this.target_ = params.target;
		
		var ccb = "";
		var owner = "";
		var cellSize;
				
//		switch (this.index_) {
//		case 1:
//			ccb = ccbi_res.LevelUpdateAwardTopDespCell_ccbi;
//			owner = "LevelUpdateAwardTopDespCellOwner";
//			cellSize = cc.size(this.cellWidth_,100);
//			break;
//
//		default:
			ccb = ccbi_res.LevelUpdateAwardCell_ccbi;
			owner = "LevelUpdateAwardCellOwner";
			cellSize = cc.size(this.cellWidth_,126);
//			break;
//		}
		
		this.setContentSize(cellSize);

		cc.BuilderReader.registerController(owner, {

		});
		this.node = cc.BuilderReader.load(ccb, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		if (this.bgMenu != null) {
			this.bgMenu.setSwallowTouches(false);
			this.initCell();
		}
	},

	initCell : function() {

		this.btn.setTag(this.index_);
		
		this.label1.setString(common.LocalizedString("升级到 %s 级,送", [this.cellData_.level]));
		
		if (this.cellData_.VIP != null) {
			this.vipIcon.setVisible(true);
			this.label3.setString("+" + this.cellData_.VIP);
			this.label3.visible = true;
		}
		if (this.cellData_.diamond != null) {
			this.goldIcon1.setVisible(true);
			this.label2.setVisible(true);
			this.label2.setString(this.cellData_.diamond);
		}
		trace(this.cellData_.isCondition)
		var buttonNormalImg = this.cellData_.isCondition ? "btn_10_1.png" : "btn_10_0.png";
		var buttonSelectImg = this.cellData_.isCondition ? "btn_10_0.png" : "btn_10_1.png";

		this["btn"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(buttonNormalImg));
		this["btn"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(buttonSelectImg));
		
		this.btn.setVisible(!this.cellData_.isGet);
		this.label4.setVisible(this.cellData_.isGet);
		this.getSprite.setVisible(!this.cellData_.isGet);
	},
	
	onGetBtnTaped : function(sender) {
		var index = sender.getTag();
		this.callBack_.call(this.target_, index);
	}
});