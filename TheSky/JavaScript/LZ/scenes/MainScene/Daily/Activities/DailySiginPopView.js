/**
 * 签到购买弹框
 * 
 */
var DailySiginPopView = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		this.manager_ = params.manager;
		this.callBack_ = params.closeCallBack;
	
		this.initCCBLayer(ccbi_res.DailySignInPopUpView_ccbi, "DailySignInPopUpViewOwner", this, this);
		
		this.swallowLayer(this.infoBg);
		
		this.createListView(this.containLayer)


		var item = new DailySiginPopCell({
			index : 1,
			cellData : this.viewData_,
			callBack : this._itemSelectEvent,
			target   : this
		});

		this.listView_.pushBackCustomItem(item);
		
		this.refreshView(this.viewData_);
			
	},
	
	refreshView : function(viewData) {
		this.signInLabel.setString(viewData.day);
		var state = viewData["state"];
		this.stateBtnLabel.enableStroke(cc.color(32, 18, 9), 2);
		switch (state) {
		case 0:
			this.stateBtnLabel.setVisible(false);
			this.stateLabel.setString(common.LocalizedString("Daily_haveGetReward"));
			this.stateBtn.setVisible(false);
			
			break;
		case 1:
			this.stateLabel.setString(common.LocalizedString("Daily_getTodayReward"));
			this.stateBtnLabel.setString(common.LocalizedString("Daily_nameOfSignIn"));

			break;
		case 2:
			if (PlayerModule.getVipLevel() > 0) {				
				this.stateLabel.setString(common.LocalizedString("Daily_ICansuppl"));
				this.stateBtnLabel.setString(common.LocalizedString("Daily_nameOfSuppl"));
			}
			else 
			{
				this.stateLabel.setString(common.LocalizedString("Daily_signInCantReSign"));
				this.stateBtnLabel.setString(common.LocalizedString("Daily_chongzhi"));
			}		

			break;
		case 3:
			if (PlayerModule.getVipLevel() >= viewData["doubledVipLevel"]) {
				this.stateLabel.setString(common.LocalizedString("Daily_getVipReward"));
				this.stateBtnLabel.setString(common.LocalizedString("Daily_lingqu"));
			} else {
				this.stateLabel.setString(common.LocalizedString("Daily_NotgetVipReward"));
				this.stateBtnLabel.setString(common.LocalizedString("Daily_chongzhi"));
			}
			
			break;
		case 4:
			this.stateBtnLabel.setVisible(false);
			this.stateLabel.setString(common.LocalizedString("Daily_signInUnconditional"));
			this.stateBtn.setVisible(false);

			break;
		case 5:
			this.stateBtnLabel.setVisible(false);
			this.stateLabel.setString(common.LocalizedString("Daily_signInconditional"));
			this.stateBtn.setVisible(false);

			break;

		default:
			break;
		}
	},
	
	closeItemClick : function() {
		this.closeView();
	},
	
	cancelItemClick : function() {
		this.closeView();
	},
	
	confirmBtnTaped : function() {
		
		ActivityModule.onSiginPopViewConfirmTaped(this.viewData_);
		
		this.callBack_.call(this.manager_);
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
var DailySiginPopCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);
		
		this.index_ = params.index;
		this.cellData_ = params.cellData;
		this.callBack_ = params.callBack;
		this.target_ = params.target;
		
		this.size_ = params.size || cc.size(600, 120);
		this.setContentSize(this.size_);
		
		cc.BuilderReader.registerController("MultiItemCellOwner", {
			
		});
		this.node = cc.BuilderReader.load(ccbi_res.MultiItemCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
				
		this.initCell();
	},
	
	initCell : function() {
		var viewData = this.cellData_["view"];
		var itemId = viewData.id;
		this.itemName.setString(viewData.name);
		this.countLabel.setString(viewData.count);
		
		this.chipIcon.setVisible(false);
		
		if (common.havePrefix(itemId, "weapon_") || common.havePrefix(itemId, "belt_") || common.havePrefix(itemId, "armor_")) {
			this.bigSprite.setVisible(true);
			var texture;
			if (common.havePrefix(itemId, "_shard")) {
				texture = cc.textureCache.addImage(String("ccbResources/icons/{0}.png").format(viewData.icon));
				this["chip_icon"].setVisible(true);
			} else {
				texture = cc.textureCache.addImage(viewData.icon);
			}

			if (texture != null) {
				this["bigSprite"].setVisible(true);
				this["bigSprite"].setTexture(texture);
			}
			
		} else if(common.havePrefix(itemId, "item")) {
			var texture = cc.textureCache.addImage(viewData.icon);
	
			if (texture != null) {
				this["bigSprite"].setVisible(true);
				this["bigSprite"].setTexture(texture);
			}
		} else if(common.havePrefix(itemId, "shadow")) {
			this.rankFrame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("s_frame.png"));
			this.rankBg.visible = false;
			this.rankFrame.setPosition(cc.p(this.rankFrame.getPositionX() + 5, this.rankFrame.getPositionY() + 5));
			if (viewData.icon) {
				olAni.playFrameAnimation("yingzi_" + viewData.icon + "_", this.contentLayer,
						cc.p(this.contentLayer.getContentSize().width / 2, this.contentLayer.getContentSize().height / 2), 1, 4,
						common.getColorByRank(viewData.rank));
			}
		} else if(common.havePrefix(itemId, "hero")) {
			this.littleSprite.setVisible(true);
			this.littleSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(viewData.icon));
		} else {
			var texture = cc.textureCache.addImage(viewData.icon);

			if (texture != null) {
				this["bigSprite"].setVisible(true);
				this["bigSprite"].setTexture(texture);
			}
		}
		
		if(!common.havePrefix(itemId, "shadow")) {
			this.rankFrame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(viewData.rank)));
			this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("rank_head_bg_{0}.png").format(viewData.rank)));
		}
	},
	
	onHeadIconClicked : function() {
		cc.log("结果");
	},
	
	onBgClicked : function(){
		cc.log("选择 ", this.index_);
		this.callBack_.call(this.target_, this.index_);
	},
});