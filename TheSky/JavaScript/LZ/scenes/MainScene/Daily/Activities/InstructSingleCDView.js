/**
 * 单人特训英雄冷却页面
 * 
 */
var InstructSingleCDView = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		this.manager_ = params.manager;
		this.callBack_ = params.closeCallBack;
		
		this.heroUid_ = null;
		
		this.isShowingCDView_ = true;
		
		this.initCCBLayer(ccbi_res.InstructSingleCDView_ccbi, "InstructSingleCDViewOwner", this, this);

		this["endInstructBtn"].setVisible(false);
		this["useItemBtn"].setVisible(false);
		this["cdLabel"].setVisible(true);
		this["heroChoseBtn"].setVisible(true);
		
		this.swallowLayer(this.infoBg);
		
		this.timeUpdate();
		
		// 添加对时间变化的监听
		addObserver(NOTI.ACIVITY_TIME_UPDATE, "timeUpdate", this);
	},
	
	setHeroId : function(uid) {
		this.heroUid_ = uid;

		if ((this.heroUid_ != null) && this.isShowingCDView_) {
			this.isShowingCDView_ = false;
		}
	},
	
	timeUpdate : function() {
		var time = DailyInstructModule.getSingleInstructCDTime(this.viewData_.endTime);
		
		var btnNormalImg = "btn7_2.png";
		var btnSelectImg = "btn7_2.png";
		if (time == null) {
			btnNormalImg = "btn7_0.png";
			btnSelectImg = "btn7_1.png";
			
			if (this.isShowingCDView_) {
				this.isShowingCDView_ = false;
				this["endInstructBtn"].setVisible(true);
				this["useItemBtn"].setVisible(true);
				
				this["cdLabel"].setVisible(false);
				this["heroChoseBtn"].setVisible(false);
			}
			
		} else {
			this["cdLabel"].setString( time );
			if (!this.isShowingCDView_) {
				this.isShowingCDView_ = true;
				this["endInstructBtn"].setVisible(false);
				this["useItemBtn"].setVisible(false);
				
				this["cdLabel"].setVisible(true);
				this["heroChoseBtn"].setVisible(true);
			}
		}
		
		this["heroChoseBtn"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(btnNormalImg));
		this["heroChoseBtn"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(btnSelectImg));	
	},
	
	onHeroChoseTaped : function() {
		var time = DailyInstructModule.getSingleInstructCDTime(this.viewData_.endTime);
		if (time != null) {
			// 正在倒计时
		} else {
			// 选英雄
			DailyInstructModule.doHeroChoseShow(this.viewData_);
		}
	},
	
	/**
	 * 直接结束
	 */
	onEndInstructBtnTaped : function() {
		DailyInstructModule.doInstructNetworkAction(this.viewData_.id, 0, this.heroUid_);
		this.closeView();
	},
	
	/**
	 * 使用道具
	 */
	onUseItemBtnTaped : function() {
		DailyInstructModule.doInstructNetworkAction(this.viewData_.id, 1, this.heroUid_);
		this.closeView();
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
	
	_touchOutside : function() {
		
	},
	
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.ACIVITY_TIME_UPDATE, "timeUpdate", this);
	},
});