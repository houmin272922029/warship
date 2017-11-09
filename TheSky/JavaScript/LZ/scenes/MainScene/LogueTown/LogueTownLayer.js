var LogueTownLayer = cc.Layer.extend({
	/**
	 * 
	 * @param type 0招募 1道具 2礼包 3vip
	 */
	ctor:function(type, vipBagId){
		this._super();
		this.type = type || 0
		this.vipBagId = vipBagId;
		cc.BuilderReader.registerController("LogueTownViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.LogueTownView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.updateBtn();
	},
	onEnter:function(){
		this._super();
		SoundUtil.playMusic("audio/zhanbuwu.mp3", true);
	},
	onExit:function(){
		this._super();
	},
	setSpriteFrame:function(sender, bool){
		if (bool) {
			sender.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			sender.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else {
			sender.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			sender.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
	},
	updateBtn:function() {
		this.LogueContentLayer.removeAllChildren(true);
		if (this.type === 0) {
			var layer = new RecruitLayer();
			this.LogueContentLayer.addChild(new RecruitLayer);
			this.setSpriteFrame(this.RecruitBtn, true);
			this.setSpriteFrame(this.ItemBtn, false);
			this.setSpriteFrame(this.GiftBagBtn, false);
			this.setSpriteFrame(this.VipBtn, false);
			this.btnName1.setColor(cc.color(255, 226, 122));
			this.btnName2.setColor(cc.color(230, 214, 191));
			this.btnName3.setColor(cc.color(230, 214, 191));
			this.btnName4.setColor(cc.color(230, 214, 191));
			this.btnName1.enableStroke(cc.color(32, 18, 9), 2);
			this.btnName2.enableStroke(cc.color(32, 18, 9), 2);
			this.btnName3.enableStroke(cc.color(32, 18, 9), 2);
			this.btnName4.enableStroke(cc.color(32, 18, 9), 2);
		} else if (this.type === 1) {
			this.LogueContentLayer.addChild(new ItemBagLayer);
			this.setSpriteFrame(this.RecruitBtn, false);
			this.setSpriteFrame(this.ItemBtn, true);
			this.setSpriteFrame(this.GiftBagBtn, false);
			this.setSpriteFrame(this.VipBtn, false);
			this.btnName1.setColor(cc.color(230, 214, 191));
			this.btnName2.setColor(cc.color(255, 226, 122));
			this.btnName3.setColor(cc.color(230, 214, 191));
			this.btnName4.setColor(cc.color(230, 214, 191));
		} else if (this.type === 2) {
			this.LogueContentLayer.addChild(new GiftBagLayer);
			this.setSpriteFrame(this.RecruitBtn, false);
			this.setSpriteFrame(this.ItemBtn, false);
			this.setSpriteFrame(this.GiftBagBtn, true);
			this.setSpriteFrame(this.VipBtn, false);
			this.btnName1.setColor(cc.color(230, 214, 191));
			this.btnName2.setColor(cc.color(230, 214, 191));
			this.btnName3.setColor(cc.color(255, 226, 122));
			this.btnName4.setColor(cc.color(230, 214, 191));
		} else if (this.type === 3) {
			trace(PlayerModule.getVipLevel())
			this.LogueContentLayer.addChild(new VipBagLayer);
			this.setSpriteFrame(this.RecruitBtn, false);
			this.setSpriteFrame(this.ItemBtn, false);
			this.setSpriteFrame(this.GiftBagBtn, false);
			this.setSpriteFrame(this.VipBtn, true);
			this.btnName1.setColor(cc.color(230, 214, 191));
			this.btnName2.setColor(cc.color(230, 214, 191));
			this.btnName3.setColor(cc.color(230, 214, 191));
			this.btnName4.setColor(cc.color(255, 226, 122));
		}
	},
	RecruitBtnAction:function() {
		this.type = 0;
		this.updateBtn();
	},
	itemBtnAction:function() {
		this.type = 1;
		this.updateBtn();
	},
	GiftBagBtnAction:function() {
		this.type = 2;
		this.updateBtn();
	},
	VipBtnAction:function(succ,fail) {
		this.type = 3;
		ShopModule.doVipshop(this.updateBtn.bind(this), succ, fail);
	
	},
	payBtnAction:function() {
		var layer = new RechargeLayer();
		cc.director.getRunningScene().addChild(layer);
	},
	
});