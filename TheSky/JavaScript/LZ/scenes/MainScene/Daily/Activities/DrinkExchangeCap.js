/**
 * 饮酒交换瓶盖
 * 
 */
var DrinkExchangeCap = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		this.manager_ = params.manager;
		this.callBack_ = params.closeCallBack;
				
		this.initCCBLayer(ccbi_res.DailyExchangeCapView_ccbi, "DailyDrinkCapExchangeViewOwner", this, this);
		
		this.swallowLayer(this.infoBg);
		
		this.createListView(this.contentLayer)

		for (var int = 0; int < this.viewData_.capList.length; int++) {
			var item = new DrinkCapExchangeCell({
				index : int,
				cellData : this.viewData_.capList[int],
				callBack : this._itemSelectEvent,
				target   : this
			});
			
			this.listView_.pushBackCustomItem(item);
		}
		
		this.refreshView();
	},
	
	refreshView : function(data) {
		if (data != null) {
			this.viewData_["data"] = data;
		}

		if (this.viewData_["data"]) {
			this.todaysCapNum.setString(this.viewData_["data"].capToday);
			this.totalCapNum.setString(this.viewData_["data"].capAll);
		}
	},

	closeItemClick : function() {
		this.closeView();
	},
	
	cancelItemClick : function() {
		this.closeView();
	},
	
	drinkAgainBtnClick : function() {
		this.closeView();
	},
	
	_itemSelectEvent : function(index) {
		if (index < 0) {
			return;
		}
		
		DailyDrinkModule.doCapExchange(index);
	},
	
	_touchOutside : function() {
		
	}
});

/**
 * 瓶盖兑换页面的一条
 */
var DrinkCapExchangeCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);
		
		this.index_ = params.index;
		this.cellData_ = params.cellData;
		this.callBack_ = params.callBack;
		this.target_ = params.target;
		
		this.size_ = params.size || cc.size(600,130);
		this.setContentSize(this.size_);
		
		cc.BuilderReader.registerController("DailyDrinkCapExchangeCellOwner", {
			
		});
		this.node = cc.BuilderReader.load(ccbi_res.DailyCapExchangeCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		
		this["menu"].setSwallowTouches(false);
		
		this.initCell();
	},
	
	initCell : function() {
		this.countLabel.setString(this.cellData_.count);
		this.capNum.setString(this.cellData_.capNum);
		this.need.setString(this.cellData_.need);
		this.icon.setTexture(this.cellData_.icon);
		
		this.avatar.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + this.cellData_.rank + ".png"));
		this.activity.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + this.cellData_.rank + ".png"));
		
		this.avatarBtn.setNormalImage(cc.Sprite("#frame_" + this.cellData_.rank + ".png"));
		this.avatarBtn.setSelectedImage(cc.Sprite("#frame_" + this.cellData_.rank + ".png"));
	},
	
	avatarBtnClick : function() {

	},
	
	exChangeBtnClick : function(){
		this.callBack_.call(this.target_, this.index_);
	},
});