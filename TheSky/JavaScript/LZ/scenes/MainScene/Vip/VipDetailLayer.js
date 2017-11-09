var VipDetailLayer = cc.Layer.extend ({
	ctor:function(type){
		this._super();
		this.type = type || "Privilege";
		cc.BuilderReader.registerController("vipDetailOwner", {
		})
		this.node = cc.BuilderReader.load(ccbi_res.vipDetailView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
		
		this.refreshProgress();
		this.vipLevel = PlayerModule.getVipLevel();
		
		if (this.vipLevel == 0) {
			this.vipLevel = 1;
		}
		this.updateBtn();
	},
	refreshProgress:function(){
		this.ExpProgress = new cc.ProgressTimer(new cc.Sprite("#vip_progress_red.png"));
		this.ExpProgress.type = cc.ProgressTimer.TYPE_BAR;
		this.ExpProgress.midPoint = cc.p(0, 0);
		this.ExpProgress.barChangeRate = cc.p(1, 0);
		this.proBg.getParent().addChild(this.ExpProgress , 2);
		this.proLabel.setLocalZOrder(3);
		this.ExpProgress.setPosition(cc.p(this.proBg.x, this.proBg.y));
		this.ExpProgress.percentage = (PlayerModule.getVipPro()) * 100;
	},
	updateBtn:function(){
		if (this.type === "Privilege") {
			this.tabBtn1.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.tabBtn0.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.vipGiftBagLayer.visible = true;
			this.vipPrivilegeLayer.visible = true;
			this.despStrLabel.visible = false;
			this.vip_detial_bg_0.visible = true;
			this.vip_detial_bg_1.visible = false;
		} else if (this.type === "reward") {
			this.tabBtn1.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			this.tabBtn0.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			this.vipGiftBagLayer.visible = false;
			this.vipPrivilegeLayer.visible = false;
			this.despStrLabel.visible = true;
			this.despStrLabel.setString(VipModule.getVipDesp(this.vipLevel));
			this.vip_detial_bg_0.visible = false;
			this.vip_detial_bg_1.visible = true;
		}
	},
	onEnter:function() {
		this._super();
		this.refresh();
	},
	onExit:function(){
		this._super();
	},
	lookPrivilegeBtnClick:function(){
		if (this.type === "reward") {
			return;
		}
		this.type = "reward"
			this.updateBtn();
	},
	lookRewardBtnClick:function(){
		if (this.type === "Privilege") {
			return;
		}
		this.type = "Privilege"
			this.updateBtn();
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	refresh:function(){
		this.vip_tequan.enableStroke(cc.color(40, 23, 17), 4);
		this.proLabel.setString(playerdata.vipScore + "/" + PlayerModule.getNextVipScore());
		this.giftTitle.setString("VIP" + (this.vipLevel) + "礼包");
		this.giftTitle.enableStroke(cc.color(173, 75, 9), 2);
		this.dayTitle.enableStroke(cc.color(173, 75, 9), 2);
		this.haveGetGiftRewardLabel.enableStroke(cc.color(173, 75, 9), 2);
		this.haveGetDayRewardLabel.enableStroke(cc.color(173, 75, 9), 2);
		this["nowlv"].setString("VIP " + PlayerModule.getVipLevel());
		if (PlayerModule.getVipLevel() < 13) {
			this["nextlv"].setString("VIP " + (PlayerModule.getVipLevel() + 1));
		} else{
			this["nextlv"].setString("VIP " + (PlayerModule.getVipLevel()));
		}
		
		var VipAwardCfg =  VipModule.getVipAwardConfig();
		var award = VipAwardCfg[(this.vipLevel) + ""].award;
		for (var i = 1; i <= 4; i++) {
			var item = award["" + i];
			this["itemBtn" + i].visible = item !== null;
			this["contentLayer" + i].visible = item !== null;
			if (item) {
				var itemId = item.itemId;
				var res = common.getResource(itemId);
				this["nameLabel" + i].setString(res.name);
				this["bigSprite" + i].visible = res.iconType === 0;
				this["littleSprite" + i].visible = res.iconType !== 0;
				this["soulIcon" + i].visible = res.iconType !== 0;
				if (res.iconType === 0) {
					this["bigSprite" + i].setTexture(res.icon);
				} else {
					this["littleSprite" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(itemId)));
				}
				this["countLabel" + i].setString(item.amount);
			}
		}
		var VipDayGiftCfg = VipModule.getVipDayGiftAwardConfig();
		var peraward = VipDayGiftCfg[(this.vipLevel) + ""].award;
		for(var i = 1; i <= 3; i++) {
			var item = peraward["" + i];
			this["dayItemBtn" + i].visible = false;
			this["dayContentLayer" + i].visible = false;
			this["dayRedSprite" + i].visible = false;
			if (item) {
				this["dayItemBtn" + i].visible = true;
				this["dayContentLayer" + i].visible = true;
				this["dayRedSprite" + i].visible = true;
				var itemId = item.itemId;
				var res = common.getResource(itemId);
				this["dayNameLabel" + i].setString(res.name);
				this["dayBigSprite" + i].visible= res.iconType === 0;
				this["dayLittleSprite" + i].visible = res.iconType !== 0 ;
				this["daySoulIcon" + i].visible = res.iconType !== 0;
				if(res.iconType === 0) {
					this["dayBigSprite" + i].setTexture(res.icon);
				} else {
					this["dayLittleSprite" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(itemId)));
				}
				this["dayCountLabel" + i].setString(item.amount);
			}
		}
		if(VipModule.getdailyRecord(this.vipLevel)){
			this.getDayGiftBtn.enabled = true;
		} else {
			this.getDayGiftBtn.enabled = false;
		}
		var index = (this.vipLevel >= 10) ? this.vipLevel : ("0" + this.vipLevel);
		
		var lastTime;
		var isDaily = false;
		for (var k in vipdata.vip.dailyRcord) {
			if (k) {
				if (vipdata.vip.dailyRcord[k+""].lastTime) {
					var last = vipdata.vip.dailyRcord[k+""].lastTime;
					lastTime = last;
					isDaily = true;
				}
			}
		}
		if (!isDaily) {
			
			if ( this.vipLevel == PlayerModule.getVipLevel()) {
				this.getDayGiftBtn.enabled = true;
			} else {
				this.getDayGiftBtn.enabled = false;
			}
		} else {
//			if ((Global.serverTime - lastTime) >= 3600 * 24 && this.vipLevel == PlayerModule.getVipLevel()) {
//				this.getDayGiftBtn.enabled = true;
//			} else {
//				this.getDayGiftBtn.enabled = false;
//			}
			this.getDayGiftBtn.enabled = false;
		}
		var isVipReward = false;
		for (var k in vipdata.vip.rewardRcord) {
			if (vipdata.vip.rewardRcord[k+""] == this.vipLevel) {
				isVipReward = true;//已经领取该this.level的奖励
			}
		}
		if (!isVipReward) {
			if (this.vipLevel <= PlayerModule.getVipLevel()) {
				this.getRewardBtn.enabled = true;
			} else {
				this.getRewardBtn.enabled = false;
			}
		} else {
			//modified by songjing
//			if(VipModule.getRewardRcord(this.vipLevel) || this.vipLevel > PlayerModule.getVipLevel()){
//				this.getRewardBtn.enabled = false;
//			} else {
//				this.getRewardBtn.enabled = true;
//			}
			this.getRewardBtn.enabled = false;
		}
		
	},
	dayItemClick:function(sender) {
		var tag = sender.getTag();
		var VipDayGiftCfg = VipModule.getVipDayGiftAwardConfig();
		var peraward = VipDayGiftCfg[(this.vipLevel) + ""].award;
		var itemId = peraward["" +  tag].itemId;
		
		cc.director.getRunningScene().addChild(new ItemDetailInfoView(this.itemId, 1));
		},
	itemClick:function(sender) {
		var tag = sender.getTag();
		var VipAwardCfg =  VipModule.getVipAwardConfig();
		var award = VipAwardCfg[(this.vipLevel) + ""].award;
		var itemId = award["" +  tag].itemId;
		var res = common.getResource(itemId);
		if (itemId === "gold" && itemId === "berry" && itemIid === "silver") {
			return;
			} else {
		cc.director.getRunningScene().addChild(new ItemDetailInfoView(this.itemId, 1));
				
		}
	},
	teamLeftBtnClick:function() {
		if(this.vipLevel > 1) {
			this.vipLevel = this.vipLevel - 1;
		} else {
			this.vipLevel = 13;
		}
		
		if (this.type === "Privilege") {	
			this.refresh();
		} else if (this.type === "reward") {
			this.despStrLabel.setString(VipModule.getVipDesp(this.vipLevel));
		}
	},
	teamRightBtnClick:function() {
		if(this.vipLevel < 13) {
			this.vipLevel = this.vipLevel + 1;
		} else {
			this.vipLevel = 1;
		}
		if (this.type === "Privilege") {		
			this.refresh();
		} else if (this.type === "reward") {
			this.despStrLabel.setString(VipModule.getVipDesp(this.vipLevel));
		}
	},
	getDayGiftItemClick:function() {
		VipModule.doVipReward(this.getRewardSucc.bind(this));
	},
	getRewardSucc:function(dic){
		this.refresh();
		var self = this;
		var cb = new GetSomeRewardLayer({info:this.item, type:0, close:function(){
			self.getDayGiftBtn.enabled = false;
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	getRewardItemClick:function(vipLevel) {
		VipModule.doVipLevelReward(this.vipLevel, this.getVipLevelRewardSucc.bind(this));
	},
	getVipLevelRewardSucc:function() {
		this.refresh();
		var self = this;
		
		var cb = new GetSomeRewardLayer({info:this.item, type:0, close:function(){
			self.getRewardBtn.enabled = false;
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	}
});
