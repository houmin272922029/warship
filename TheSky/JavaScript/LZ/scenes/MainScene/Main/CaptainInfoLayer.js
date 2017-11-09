var CaptainInfoLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("CaptainInfoOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.CaptainInfoView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
	},
	onEnter:function(){
		this._super();
		this.refresh();
		addObserver(NOTI.STRENGTH, "refresh", this);
		
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.STRENGTH, "refresh", this);
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	onPayClicked:function(){
		var layer = new RechargeLayer();
		cc.director.getRunningScene().addChild(layer);
	},
	refresh:function(){
		this.name.setString(PlayerModule.getName());
		this.vip.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("ol_VIP_" + PlayerModule.getVipLevel() + ".png"));
		this.level.setString(PlayerModule.getLevel());
		this.exp.setString(PlayerModule.getExp() + "/" + PlayerModule.getPlayerExpMax(PlayerModule.getLevel()));
		this.form.setString(FormModule.getOnFormCount() + "/" + FormModule.getFormMax());
		this.gold.setString(PlayerModule.getGold());
		this.berry.setString(PlayerModule.getBerry());
		this.strength.setString(PlayerModule.getStrength() + "/" + PlayerModule.getStrengthMax());
		this.energy.setString(PlayerModule.getEnergy() + "/" + PlayerModule.getEnergyMax());
		cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("fontPic_2.plist"));
		this.firstPaySpr.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("shouchongfanbei_pic.png"));
		this.firstPaySpr.setVisible(PlayerModule.isFirstRecharge());
		this.updateCD();
	},
	updateCD:function(){
		var nextStrengthTimer = 0;
		var allStrengthTimer = 0;
		var nextEnergyTimer = 0;
		var allEnergyTimer = 0;
		if (playerdata.strength < PlayerModule.getStrengthMax()) {
			nextStrengthTimer = PlayerModule.getNextStrengthTime();
			allStrengthTimer = PlayerModule.getAllStrengthTime();
		}
		if (playerdata.energy < PlayerModule.getEnergyMax()) {
			nextEnergyTimer = PlayerModule.getNextEnergyTime();
			allEnergyTimer = PlayerModule.getAllEnergyTime();
		}
		this.nextStrength.setString(DateUtil.second2hms(nextStrengthTimer));
		this.allStrength.setString(DateUtil.second2hms(allStrengthTimer));
		this.nextEnergy.setString(DateUtil.second2hms(nextEnergyTimer));
		this.allEnergy.setString(DateUtil.second2hms(allEnergyTimer));
	}
});