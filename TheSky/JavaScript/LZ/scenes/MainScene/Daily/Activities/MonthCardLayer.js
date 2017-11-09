var monthCardLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
		this.createListView(this["listContentView"], null, ccui.ScrollView.DIR_VERTICAL);
//		this.maskMenu.setSwallowTouches(true);
		this.listView_.setSwallowTouches(false);
	},
	
	onActivate : function() {
		ActivityModule.fetchMonthCardData();
	},
	
	refreshView : function( viewData ) {
		if (viewData == null) {
			viewData = ActivityModule.getMonthData();
		}
		
		this.listView_.removeAllItems();
		
		for (var int = 0; int < viewData.length; int++) {
			var cell = new DailyMonthCardCell({
				size : cc.size(this["listContentView"].getContentSize().width, 121),
				cellData : viewData[int],
				target : this,
				index : int,
				callBack : this.onItemTaped
			});

			this.listView_.pushBackCustomItem(cell);
		}
	},
	
	onItemTaped : function(data) {
		ActivityModule.doMonthCardOperation(data);
	}
});

/**
 * 月卡页面的一条
 */
var DailyMonthCardCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);
		this.index_ = params.index;
		this.cellData_ = params.cellData;
		this.callBack_ = params.callBack;
		this.target_ = params.target;

		this.size_ = params.size || cc.size(620,170);
		this.setContentSize(this.size_);

		cc.BuilderReader.registerController("DailyMothCardCellOwner", {

		});
		this.node = cc.BuilderReader.load(ccbi_res.DailyMothCardCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}

		this["menu"].setSwallowTouches(false);

		this.initCell();
	},

	initCell : function() {
		this.cellName.setString(this.cellData_.name);
		this.goldCount.setString(this.cellData_.dayAward);
		this.gainTips.setString(String("每天领取{0}金币").format(this.cellData_.dayAward));
//		
		this.dayTips.setString(String("已买 {0} 天剩余 {1} 天!").format(this.cellData_.alreadyBuyDay, this.cellData_.remainDays));
		this.peiceShow.setString(this.cellData_.priceShow);
		this.setStatus(this.cellData_.status);
	},

	/**
	 * 设置当前状态
	 * @param int status
	 */
	setStatus : function(status) {
		switch (status) {
		case 1:
			// 可以买
			this.NotGainLayer.setVisible(true);
			this.btnLabelSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("goumai_text.png"));
			this["getItemBtn"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn_10_1.png"));
			this["getItemBtn"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn_10_1.png"));
			
			break;
		case 2:
			// 不可以买
			this.NotGainLayer.setVisible(true);
			this.btnLabelSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("goumai_text.png"));
			this["getItemBtn"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn_10_2.png"));
			this["getItemBtn"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn_10_2.png"));
			
			break;
		case 3:
			// 可以领
			this.GainLayer.setVisible(true);
			this.btnLabelSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("lingqu_1_text.png"));
			this["getItemBtn"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn_10_0.png"));
			this["getItemBtn"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn_10_1.png"));
			
			break;
		case 4:
			// 已领取
			if (this.cellData_.cardType == 3) {
				this.NotGainLayer.setVisible(true);
				this.btnLabelSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("lingqu_mark_0.png"));
			} else {				
				this.GainLayer.setVisible(true);
				this.btnLabelSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("lingqu_mark_1.png"));
			}
			
			this["getItemBtn"].setVisible(false);

			break;

		default:
			break;
		}

	},

	onHeadIconClicked : function() {
		cc.log("结果");
	},

	onGetItemClicked : function(){
		this.callBack_.call(this.target_, this.cellData_);
	},
});