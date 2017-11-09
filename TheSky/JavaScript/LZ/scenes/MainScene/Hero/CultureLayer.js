var CultureLayer = cc.Layer.extend({
	ctor:function(heroUid, exitNoti) {
		this._super();
		this.heroUid = heroUid;
		this.exitNoti = exitNoti || NOTI.GOTO_HEROES;
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("CultureLayerOwner",{
		});
		this.node = cc.BuilderReader.load(ccbi_res.CultureView_ccbi, this);
		if(this.node != null)
		{
			this.addChild(this.node);
		}
		this.updateCulUI();
	},
	updateCulUI:function(sender){
		var heroInfo = HeroModule.getHeroByUid(this.heroUid);
		if(!this.pedestal.getChildByTag(123)){
			var cfg = HeroModule.getHeroBoneRes(heroInfo.heroId);
			var node = common.createBone(cfg.name, cfg.amount);
			this.pedestal.addChild(node, 0, 123);
			node.puppet.getAnimation().play("Idle");
			node.scale = 0.7;
			var size = this.pedestal.getContentSize();
			node.attr({
				x:size.width / 2,
				y:size.height / 3 * 2,
				anchorX:0.5,
				anchorY:0
			})
		}
		this.rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + heroInfo.rank +"_icon.png"));
		this.name.setString(heroInfo.name);
		this.point.setString(heroInfo.point);
		this.pydan.setString(ItemModule.getItemCount("item_006"));
		var attrsInfo = HeroModule.getHeroBasicAttrsByUid(this.heroUid);
		this.hp.setString(attrsInfo.hp);
		this.atk.setString(attrsInfo.atk);
		this.def.setString(attrsInfo.def);
		this.mp.setString(attrsInfo.mp);
		this.cultureFrame2.visible = getJsonLength(heroInfo.adjust) > 0;
		this.cultureFrame1.visible = getJsonLength(heroInfo.adjust) === 0;
		var keys = ["hp", "atk", "def", "mp"];
		var adjust = heroInfo.adjust || {hp:0, atk:0, def:0, mp:0};
		for (var i in keys) {
			var key = keys[i];
			this[key].setString(attrsInfo[key]);
			var a = adjust[key] || 0;
			this["arrow_" + key].visible = a !== 0;
			this["adjust_" + key].visible = a !== 0;
			var str = a >= 0 ? "+" + a : String(a);
			this["adjust_" + key].setString(str);
			this["adjust_" + key].color = a >= 0 ? cc.color(0, 255, 0) : cc.color(255, 0, 0);
			var arrow = a > 0 ? "arrow_3.png" : "arrow_4.png";
			this["arrow_" + key].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(arrow));
		}
	},	
	onCultureClicked:function(sender){
		var tag = sender.getTag();
		this.type = tag;
		HeroModule.doCulture(this.heroUid, this.type, this.updateCulUI.bind(this));
	},
	onBackClicked:function(){
		postNotifcation(this.exitNoti);
	},
	onConfirmClicked:function(){
		HeroModule.doCulCofirm(this.heroUid, 1, this.updateCulUI.bind(this));
	},
	onCancelClicked:function(heroUid, type){
		this.updateCulUI();
		HeroModule.doCulCofirm(this.heroUid, 0, this.updateCulUI.bind(this));
	},
});