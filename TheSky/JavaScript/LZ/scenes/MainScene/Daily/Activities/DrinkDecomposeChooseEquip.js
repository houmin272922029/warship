/**
 * 装备分解 装备选择页面
 * 
 * 多选，可以任意多个
 */
var DrinkDecomposeChooseEquip = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		this.manager_ = params.manager;
		this.callBack_ = params.callBack;
		
		this.selectIndex_ = {};
		this.items_ = new Array();	

		this.initCCBLayer(ccbi_res.DailyDrinkChoseHeroView_ccbi, "DailyDrinkChoseHeroViewOwner", this, this);
		
		this.swallowLayer(this.infoBg);
		
		this.createListView(this.contentLayer)

		for (var int = 0; int < this.viewData_.length; int++) {
			var item = new DeComposeChooseEquipCell({
				index : int,
				cellData : this.viewData_[int],
				callBack : this._itemSelectEvent,
				target   : this
			});
			
			this.items_.push(item);
			this.listView_.pushBackCustomItem(item);
		}
		
		// 是否有装备可供分解
		if (this.viewData_.length <= 0) {
			this.isHaveEquip.setVisible(true);
			this.isHaveEquip.setString(common.LocalizedString("daily_craftman_is_no_equip"));
		}
		
		this.bottomTips.setString(common.LocalizedString("daily_craftman_choose_btn_tips"));
	},

	closeItemClick : function() {
		this.closeView();
	},
	
	cancelItemClick : function() {
		this.closeView();
	},
	
	confirmItemClick : function() {
		var selectEquips = new Array();
		for ( var key in this.selectIndex_) {
			if (this.selectIndex_[key]) {
				selectEquips.push(this.viewData_[key]);
			}
		}
		
		if (selectEquips.length <= 0) {
			common.ShowText(common.LocalizedString("daily_DC_haventChoose"));
			return;
		}
		
		this.callBack_.call(this.manager_, selectEquips);
		this.closeView();
	},
	
	_itemSelectEvent : function(index) {
		if (index < 0) {
			return;
		}
		if (this.selectIndex_[index] != null && this.selectIndex_[index]) {
			this.selectIndex_[index] = false;
			this.items_[index].setSelectState(false);
		} else {
			this.selectIndex_[index] = true;
			this.items_[index].setSelectState(true);
		}
	},
	
	_touchOutside : function() {
		
	}
});

/**
 * 分解装备选择页面的一条
 */
var DeComposeChooseEquipCell = ccui.Layout.extend({
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
		this.levelLabel.setString(this.cellData_.level);
		this.lvLabel.setString("LV");
		
		if (this.cellData_["owner"] != null) {
			this.ownerLabel.setVisible(true);
			this.ownerLabel.setString(this.cellData_["owner"].name);
		} else {
			this.ownerLabel.setVisible(false);
		}
		
		if (this.cellData_.cfg.nature && this.cellData_.cfg.nature > 0) {
			this.runeSprite.visible = true;
			this.runeSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("nature_" + this.cellData_.cfg.nature + ".png"));
		} else {
			this.runeSprite.visible = false;
		}
		
		this["rankFrame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(this.cellData_.rank)));
		
		this["rankSprite"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("rank_{0}_icon.png").format(this.cellData_.rank)));
		
		var texture = cc.textureCache.addImage(common.getIconById(this.cellData_.cfg.icon));

		if (texture != null) {
			this["avatarSprite"].setVisible(true);
			this["avatarSprite"].setTexture(texture);
		}
		for (var k in this.cellData_.attr) {
			if (common.getDisplayFrame(k)) {
				this.attrSprite.visible = true;
				this.attrLabel.visible = true;
			}
			this.attrSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this.attrLabel.setString("+" + this.cellData_.attr[k]);
		}
		
		this.valueLabel.setString(this.cellData_.price);
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