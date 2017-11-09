var bossResultLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("BossResultOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.BossResultView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.count = 0;
		this.refresh();
		common.swallowLayer(this, true);
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.BOSS_CHALLENGE, "updateTimer", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.BOSS_CHALLENGE, "updateTimer", this);
	},
	updateTimer:function(){
		this.count = (this.count + 1) % 4;
		var tmp = "";
		for (var i = 1; i < count; i++) {
			tmp = tmp + ".";
		}
		this.challenging.setString(common.LocalizedString("boss_challenge") + tmp);
	},
	refresh:function(){
		var cache = cc.spriteFrameCache;
		cache.addSpriteFrames(common.formatLResPath("images/fightingNumber.plist"));
		this.damageLayer.removeAllChildern(true);
		//TODO
		if (getUDBool(UDefKey.Setting_BossAuto) == "bossAuto") {
			this.challenging.visible = true;
		} else {
			this.challenging.visible = false;
		}
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
});