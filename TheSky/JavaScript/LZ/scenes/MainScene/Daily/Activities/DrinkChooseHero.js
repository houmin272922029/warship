/**
 * 饮酒英雄选择页面
 * 
 */
var DrinkChooseHero = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		this.manager_ = params.manager;
		this.callBack_ = params.closeCallBack;
		
		this.selectIndex_ = -1;
		this.items_ = new Array();	
		
		this.initCCBLayer(ccbi_res.DailyChoseHeroView_ccbi, "DailyDrinkChoseHeroViewOwner", this, this);
		
		this.swallowLayer(this.infoBg);
		
		this.createListView(this.contentLayer)

		for (var int = 0; int < this.viewData_.length; int++) {
			var item = new DrinkChooseHeroCell({
				index : int,
				cellData : this.viewData_[int],
				callBack : this._itemSelectEvent,
				target   : this
			});
			
			this.items_.push(item);
			this.listView_.pushBackCustomItem(item);
		}
	},

	closeItemClick : function() {
		this.closeView();
	},
	
	cancelItemClick : function() {
		this.closeView();
	},
	
	confirmItemClick : function() {
		if (this.selectIndex_ < 0) {
			common.ShowText(common.LocalizedString("daily_drinkW_ChoseHero_haventChose"));
			return;
		}

		this.callBack_.call(this.manager_, this.selectIndex_);
		this.closeView();
	},
	
	_itemSelectEvent : function(index) {
		if (index < 0) {
			return;
		}
		
		if (this.selectIndex_ >= 0) {
			this.items_[this.selectIndex_].setSelectState(false);
			if (index == this.selectIndex_) {
				this.selectIndex_ = -1;
				return;
			}
		}
		
		if (this.items_[index]) {
			this.selectIndex_ = index;
			this.items_[this.selectIndex_].setSelectState(true)
		}
	},
	
	_touchOutside : function() {
		
	}
});

/**
 * 英雄选择页面的一条
 */
var DrinkChooseHeroCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);
		
		this.index_ = params.index;
		this.cellData_ = params.cellData;
		this.callBack_ = params.callBack;
		this.target_ = params.target;
		
		this.size_ = params.size || cc.size(620,125);
		this.setContentSize(this.size_);
		
		cc.BuilderReader.registerController("DailyDrinkChoseHeroCellOwner", {
			
		});
		this.node = cc.BuilderReader.load(ccbi_res.DailyChoseHeroViewCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		
		this["bgMenu"].setSwallowTouches(false);
		
		this.initCell();
	},
	
	initCell : function() {
		
		for ( var key in this.cellData_["labels"]) {
			var data = this.cellData_["labels"][key];
			if (this[key]) {
				this[key].setString(data);
			}
		}
		
		this["headIconBtn"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.cellData_.headImg));
		this["headIconBtn"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.cellData_.headImg));
		this["rankBg"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("rank_head_bg_{0}.png").format(this.cellData_.rank)));
		this["frame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.cellData_.frameImg));
		this["rank"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("rank_{0}_icon.png").format(this.cellData_.rank)));
		
		if (this.cellData_.breakLevel != null && this.cellData_.breakLevel != 0 ) {
			this.breakLevel.setVisible(true);
			this.breakLevelFnt.setString(this.cellData_.breakLevel);
		}
	},
	
	/**
	 * 设置选中状态
	 * @param flag
	 */
	setSelectState : function(flag) {
		var stampImg = null;
		var menuImg = null;
		if (flag) {
			stampImg = "duihao_1_btn.png";
			menuImg = "tongyong_CellBg.png";
		} else {
			stampImg = "duihao_0_btn.png";
			menuImg = "tongyong_CellBg.png";
		}
		this["stamp"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(stampImg));
		this["bgMenuItem"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(menuImg));
		this["bgMenuItem"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(menuImg));
	},
	
	onHeadIconClicked : function() {
		cc.log("结果");
	},
	
	onBgClicked : function(){
		cc.log("选择 ", this.index_);
		this.callBack_.call(this.target_, this.index_);
	},
});