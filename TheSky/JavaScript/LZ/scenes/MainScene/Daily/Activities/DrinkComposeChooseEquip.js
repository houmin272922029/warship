/**
 * 装备制造 装备选择页面
 * 
 * 单选
 */
var DrinkComposeChooseEquip = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		this.manager_ = params.manager;
		this.callBack_ = params.callBack;
		
		this.selectIndex_ = -1;
		this.items_ = new Array();	

		this.initCCBLayer(ccbi_res.DailyDrinkChoseHeroView_ccbi, "DailyDrinkChoseHeroViewOwner", this, this);

		this.swallowLayer(this.infoBg);

		this.createListView(this.contentLayer)
		
		for (var int = 0; int < this.viewData_.length; int++) {
			var item = new ComposeChooseEquipCell({
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
		if (this.selectIndex_ == -1) {
			common.ShowText(common.LocalizedString("daily_DC_haventChoose"));
			return;
		}
		
		var data = this.viewData_[this.selectIndex_];
		if (data.cdTime > 0) {
			common.ShowText(common.LocalizedString("装备合成冷却中"));
			return;
		}
		
		// 弹出一个材料确认框
		
		this.callBack_.call(this.manager_, data);
		this.closeView();
	},

	_itemSelectEvent : function(index) {
		if (index < 0) {
			return;
		}
		
		if (this.selectIndex_ != index) {
			if (this.items_[this.selectIndex_] != null) {				
				this.items_[this.selectIndex_].setSelectState(false);
			}
			this.selectIndex_ = index;
			this.items_[index].setSelectState(true);
		} else {
			this.selectIndex_ = -1;			
			this.items_[index].setSelectState(false);
		}
	},

	_touchOutside : function() {

	}
});

/**
 * 制造装备选择页面的一条
 */
var ComposeChooseEquipCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);

		this.index_ = params.index;
		this.cellData_ = params.cellData;
		this.callBack_ = params.callBack;
		this.target_ = params.target;

		this.size_ = params.size || cc.size(626,186);
		this.setContentSize(this.size_);

		cc.BuilderReader.registerController("DailyDrinkChoseHeroCellOwner", {

		});
		this.node = cc.BuilderReader.load(ccbi_res.DailyDecomposeChooseCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}

		this.node.setPosition(cc.p(this.size_.width / 2, this.size_.height / 2));

		this["bgMenu"].setSwallowTouches(false);

		this.initCell();
	},

	initCell : function() {

		this.selectBtn.setTag(this.index_);

		this.nameLabel.setString(this.cellData_.cfg.name);
		this.levelLabel.setString(1);
		this.lvLabel.setString("LV");

//		if (this.cellData_["owner"] != null) {
//			this.ownerLabel.setVisible(true);
//			this.ownerLabel.setString(this.cellData_["owner"].name);
//		} else {
//			this.ownerLabel.setVisible(false);
//		}
//
//		if (this.cellData_.cfg.nature && this.cellData_.cfg.nature > 0) {
//			this.runeSprite.visible = true;
//			this.runeSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("nature_" + this.cellData_.cfg.nature + ".png"));
//		} else {
//			this.runeSprite.visible = false;
//		}

		this["rankFrame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(this.cellData_.cfg.rank)));

		this["rankSprite"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("rank_{0}_icon.png").format(this.cellData_.cfg.rank)));

		var texture = cc.textureCache.addImage(common.getIconById(this.cellData_.cfg.icon));

		if (texture != null) {
			this["avatarSprite"].setVisible(true);
			this["avatarSprite"].setTexture(texture);
		}
		
		for (var k in this.cellData_.cfg.initial) {
			if (common.getDisplayFrame(k)) {
				this.attrSprite.visible = true;
				this.attrLabel.visible = true;
			}
			this.attrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this.attrLabel.setString("+" + this.cellData_.cfg.initial[k]);
		}

		this.valueLabel.setString(this.cellData_.info.gold);
		
		if (this.cellData_.cdTime > 0) {
			this.inCoolDown.setVisible(true);
			this.inCoolDown.setString(common.LocalizedString("daily_DC_inCoolDownRestTime"));
		} else {
			this.inCoolDown.setVisible(false);
		}
		
		// 材料不足判断
		this.itemLacked.setVisible(true);
		if (this.cellData_.isLackMaterial) {
			this.itemLacked.setString(common.LocalizedString("daily_DC_itemLacked"));
		}
		else if (this.cellData_.isLackGold) {
			this.itemLacked.setString(common.LocalizedString("daily_DC_berryLacked"));
		}																	
		else 
		{
			this.itemLacked.setVisible(false);
		}
	},

	/**
	 * 设置选中状态
	 * @param flag
	 */
	setSelectState : function(flag) {
		var stampImg = null;
		var bgImg = null;
		if (flag) {
			stampImg = "duihao_1_btn.png";
			bgImg = "equipCellSelBg.png";
		} else {
			stampImg = "duihao_0_btn.png";
			bgImg = "equipCellBg.png";
		}
		this["cellBg"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(bgImg));
		this["selectBtn"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(stampImg));
		this["selectBtn"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(stampImg));
	},

	onHeadIconClicked : function() {
		cc.log("结果");
	},

	onBgClicked : function(){
		cc.log("选择 ", this.index_);
		this.callBack_.call(this.target_, this.index_);
	},
});