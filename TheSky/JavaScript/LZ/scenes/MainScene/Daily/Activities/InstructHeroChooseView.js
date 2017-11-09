/**
 * 特训英雄选择页面
 * 
 */
var InstructHeroChooseView = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		this.manager_ = params.manager;
		this.callBack_ = params.closeCallBack;
		
		this.selectIndex_ = -1;
		this.items_ = new Array();	
		
		this.initCCBLayer(ccbi_res.InstructSelectHeroView_ccbi, "InstructSelectHeroOwner", this, this);
		
		this.swallowLayer(this.infoBg);
		
		this.createListView(this.contentLayer)

		for (var int = 0; int < this.viewData_.length; int++) {
			var item = new InstruceChooseHeroCell({
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
	
	confirmClick : function() {
		if (this.selectIndex_ >= 0) {
			this.callBack_.call(this.manager_, this.selectIndex_);
		}
		
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
var InstruceChooseHeroCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);
		
		this.index_ = params.index;
		this.cellData_ = params.cellData;
		this.callBack_ = params.callBack;
		this.target_ = params.target;
		
		this.size_ = params.size || cc.size(585,120);
		this.setContentSize(this.size_);
		
		cc.BuilderReader.registerController("InstructSelectHeroCellOwner", {
			
		});
		this.node = cc.BuilderReader.load(ccbi_res.InstructSelectHeroCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		
		this["bgMenu"].setSwallowTouches(false);
		this.initCell();
		this.setSelectState(false);
	},
	
	initCell : function() {
		
		this["heroName"].setString(this.cellData_.name);
		this["exp"].setString(this.cellData_.exp);
		this["level"].setString(this.cellData_.level);

		this["frame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.cellData_.frame));
		this["head"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.cellData_.head));
		this["head"].setVisible(true);
		this["rank"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.cellData_.rank));
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
			menuImg = "newworld_rank_tbBg.png";
		} else {
			stampImg = "duihao_0_btn.png";
			menuImg = "newworld_rank_tbBg.png";
		}
		
		this["stamp"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(stampImg));
//		this["bgItem"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(menuImg));
//		this["bgItem"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(menuImg));
	},
	
	onHeadIconClicked : function() {
		cc.log("结果");
	},
	
	onCellClick : function(){
		this.callBack_.call(this.target_, this.index_);
	},
});