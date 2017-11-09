var drinkInfoLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
		
		this.isFirstIn_ = true;
		this.currenetHeroData_ = null
		
		this._last_drinkRank = 1; // 上次喝酒的品阶
		this.isAnimation = false;
		
		this["mainLayer"].setVisible(false);
		this["enterLayer"].setVisible(true);
		
	},
	
	onActivate : function() {
		DailyDrinkModule.fetchDrinkData([], this, function() {
			this._putWinesPos();
		});
	},
	
	// 摆放酒的位置
	_putWinesPos : function() {
		var _winePosition = [ 0.645, 0.703, 0.758, 0.786, 0.808 ];
		var _wineMoveLeftW = 0.4; // 酒从右边移动到左边的移动宽度
		var _wineMoveCenterH = 2;
		var _size = this.mainLayer.getContentSize();
		
		var drinkRank = DailyDrinkModule.getDrinkRank();
		
		this.wine11.setVisible(false);
		this.wine11.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("meat_{0}.png").format(drinkRank)));
		
		for (var int = 1; int <= getJsonLength(config.drinkPage_tabodds); int++) {
			var wine = this["wine" + int];
			if (int < drinkRank) {   // 左边的酒
				wine.setVisible(true);
				wine.setScale(0.7);
				wine.setPosition(cc.p((_winePosition[int - 1] - _wineMoveLeftW) * _size.width, 0.37 * _size.height));
			} else if (int > drinkRank) {     // 右边的酒
				wine.setVisible(true);
				wine.setScale(0.7);
				wine.setPosition(cc.p(_winePosition[int - 1] * _size.width, 0.37 * _size.height));
			} else {
				wine.setScale(1);
				wine.setPosition(cc.p(0.51 * _size.width, 0.35 * _size.height));
			}
		}
	},
	
	// 酒的移位
	_showNowWine : function() {
		this.isAnimation = true;
		var time = 0.4;
		var time1 = 0.3;
		var _winePosition = [ 0.69, 0.75, 0.81, 0.87, 0.93 ];
		var _wineMoveLeftW = 0.4; // 酒从右边移动到左边的移动宽度
		var _wineMoveCenterH = 2;
		var _size = this.mainLayer.getContentSize();
		
		var drinkRank = DailyDrinkModule.getDrinkRank();

		this.wine11.setVisible(false);
		this.wine11.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("meat_{0}.png").format(drinkRank)));
		
		var winePrevious = this["wine" + this._last_drinkRank]
		var desPos;
		if (drinkRank > this._last_drinkRank) {
			desPos = cc.p((_winePosition[this._last_drinkRank] - _wineMoveLeftW) * _size.width, 0.37 * _size.height);
		} else if (drinkRank < this._last_drinkRank) {
			desPos = cc.p(_winePosition[this._last_drinkRank] * _size.width, 0.37 * _size.height);
		}
		
		var rotoZoom = cc.sequence(
			cc.spawn(cc.scaleTo(time1, 0.7), cc.moveTo(time1, desPos)),
			cc.callFunc(function() {
				this.isAnimation = false;
			}, this)
		);

		winePrevious.runAction(rotoZoom);
		
		
		var wineNow = this["wine" + drinkRank]
		var desPos = cc.p(0.51 * _size.width, 0.35 * _size.height);

		var rotoZoom = cc.sequence(
				cc.spawn(cc.scaleTo(time1, 1.0),
						cc.moveTo(time1, desPos))
		);

		wineNow.runAction(rotoZoom);
		
	},
	
	
	// 刷新饮酒数据
	refreshView : function(viewData) {
		if (viewData == null) {
			viewData = DailyDrinkModule.getDrinkData(this.isFirstIn_);
		}
		// 设置label显示
		if (viewData != null && viewData["labels"] != null) {
			for ( var name in viewData["labels"]) {
				if (this[name] != null) {
					this[name].setString(viewData["labels"][name]);
				}
			}
		}
		
//		if (this.currenetHeroData_ != null) {
//			var heroUid = this.currenetHeroData_.uid;
//			var hero = HeroModule.getHeroByUid(heroUid);
//			this.refreshHeroView(hero);
//		}
	},
	
	// 刷新主页人物选择数据
	refreshHeroView : function(heroData) {
		if (heroData != null) {
			var heroViewData = DailyDrinkModule.getDrinkHeroViewData(heroData);
			if (heroViewData.frameImg != null) {
				this["frame"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(heroViewData.frameImg));
				this["frame"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(heroViewData.frameImg));
				this["rankBg"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + heroData.rank + ".png"));
			}
			if (heroViewData.headImg != null) {
				this["head"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(heroViewData.headImg));
			}
			
			this["playersPotentialInfo"].setString(heroViewData.playersPotentialInfo);
		}
	},
	
	// 
	
	changeState : function(state, heroData) {
		var showFlag = false;
		if (state == "main" && heroData != null) {
			this.currenetHeroData_ = heroData;
			showFlag = true;
		} else {
			this.currenetHeroData_ = null;
		}
		
		this.mainLayer.setVisible(showFlag);
		this.enterLayer.setVisible(!showFlag);
		
		this.refreshHeroView(heroData);
	},
	
	_onChangeHero : function(heroData){
		this.changeState("main", heroData);
	},
	
	/**
	 * 进入页面点击回调
	 */
	descBtnTaped : function(){
		
		var param = {
				info : DailyDrinkModule.getDrinkHelpDesc()
		};
		cc.director.getRunningScene().addChild(new CommonHelpView(param));
	},
	
	onEnterBtnTaped : function() {
		DailyDrinkModule.showHeroListAction(this._onChangeHero, this);
	},
	
	/**
	 * 饮酒主页
	 */
	// 饮酒
	drinkBtnClick : function(){
		
		this._last_drinkRank = DailyDrinkModule.getDrinkRank();
		
		DailyDrinkModule.doDrink(1, this, function() {
			if (this.currenetHeroData_ != null) {
				var heroUid = this.currenetHeroData_.id;
				var hero = HeroModule.getHeroByUid(heroUid);
				this.currenetHeroData_ = hero;
				this.refreshHeroView(hero);
				// 玩家潜力值增加多少弹字   
				var point = config.drinkPage_tabodds[this._last_drinkRank].point;
				common.ShowText(common.LocalizedString("daily_drinkWine_drinkSuc", [point]));
				this._last_drinkRank = DailyDrinkModule.getDrinkRank();
				this._putWinesPos();
			}
		}, {heroData : this.currenetHeroData_});
	},
	
	// 换酒
	changeWineBtnClick : function(){
		if (this.isAnimation) {
			return;
		}
		
		if (DailyDrinkModule.getDrinkRank() == getJsonLength(config.drinkPage_tabodds)) {
			common.ShowText(common.LocalizedString("daily_drinkWine_nowIsTop"))
			return;
		}
		this._last_drinkRank = DailyDrinkModule.getDrinkRank();
		
		this.isFirstIn_ = false;   // 换完肉后就不是第一次进了
		DailyDrinkModule.doDrink(2, this, function() {
			var ifChangeSuc = "";
			if (DailyDrinkModule.getDrinkRank() > this._last_drinkRank) {
				ifChangeSuc = common.LocalizedString("daily_drinkWine_changeSuc");
			} else if (DailyDrinkModule.getDrinkRank() < this._last_drinkRank) {
				ifChangeSuc = common.LocalizedString("daily_drinkWine_changeFail");
			}
			
			common.ShowText(ifChangeSuc + common.LocalizedString("daily_drinkWine_getACap"));
			
			this._showNowWine();
			
			this._last_drinkRank = DailyDrinkModule.getDrinkRank();
		}, {heroData : this.currenetHeroData_});
	},
	
	// 一键换酒
	oneBtnChangeWineBtnClick : function(){
		if (this.isAnimation) {
			return;
		}
		
		if (DailyDrinkModule.getDrinkRank() == getJsonLength(config.drinkPage_tabodds)) {
			common.ShowText(common.LocalizedString("daily_drinkWine_nowIsTop"))
			return;
		}
		
		DailyDrinkModule.doDrink(3, this, function() {
			common.ShowText(common.LocalizedString("daily_drinkWine_getTenCap"));
			this._putWinesPos();
		}, {heroData : this.currenetHeroData_});
	},
	
	// 瓶盖兑换
	capExchangeBtnClick : function(){
		DailyDrinkModule.showCapExchangeView();
	},
	
	// 人物头像
	onHeadClicked : function(){
		DailyDrinkModule.showHeroListAction(this._onChangeHero, this);
	},

	onEnter : function(){
		this._super();
	},
	onExit : function(){
		this._super();
		this.isFirstIn_ = true;
		this.currenetHeroData_ = null
	},
	
});