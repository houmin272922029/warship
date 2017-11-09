var BreakHeroLayer = cc.Layer.extend({
	/**
	 *  @param heroid 
	 */
	ctor:function(hid, soulId, exitNoti){
		this._super();
		this.hid = hid;
		this.soulId = soulId
		this.exitNoti = exitNoti || NOTI.GOTO_HEROES;
		this.initData();
		this.initLayer();
	},
	initData:function(){
		this.hero = HeroModule.getHeroByUid(this.hid);
		this.heroCfg = HeroModule.getHeroConfig(this.hero.heroId);
		this.attr = HeroModule.getHeroAttrsByHeroUId(this.hid);
		this.breakgrow = HeroModule.getBreakAttr(this.hero);
		this.upPoint = SoulModule.getBreakedPoints(this.heroCfg.rank, this.hero.rank);
		this.breakNeed = SoulModule.getBreakNeedSoulCount(this.heroCfg.rank, this.hero.rank, this.hero["break"]);
		this.soulCount = SoulModule.getBreakSoulCount(this.soulId);
	},
	initLayer:function(){
		cc.BuilderReader.registerController("BreakLayerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.BreakHeroView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.updataBreakHeroUI();
	},
	updataBreakHeroUI:function(){
		var hero = this.hero
		if (hero) {
			if (!this.pedestal.getChildByTag(123)) {
				var cfg = HeroModule.getHeroBoneRes(hero.heroId);
				var node = common.createBone(cfg.name, cfg.amount);
				this.pedestal.addChild(node);
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
		}
		this.rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + hero.rank + "_icon.png"));
		this.name.setString(hero.name);
		this.lv.setString(hero.level);
		this.need.setString(this.breakNeed);
		this.have.setString(this.soulCount);
		this.bNow.setString(hero["break"]);
		this.bNext.setString(hero["break"] === 19 ? 20 : (this.hero["break"] + 1));
		this.hp.setString(this.attr.hp);
		this.atk.setString(this.attr.atk);
		this.def.setString(this.attr.def);
		this.mp.setString(this.attr.mp);
		this.point.setString(hero.point);
		this.hpUp.setString("+ " + parseInt(this.breakgrow.hp));
		this.atkUp.setString("+ " + parseInt(this.breakgrow.atk));
		this.defUp.setString("+ " + parseInt(this.breakgrow.def));
		this.mpUp.setString("+ " + parseInt(this.breakgrow.mp));
		this.pointUp.setString("+ " + this.upPoint);
		if (this.breakNeed == -1) {
			this.hpUp.visible = false;
			this.atkUp.visible = false;
			this.defUp.visible = false;
			this.mpUp.visible = false;
			this.pointUp.visible = false;
			this.breakBtn.visible = false;
			this.tupoSprite.visible = false;
		}
	},
	onBreakClicked:function(){
		SoulModule.doOnBreakHero([this.soulId], this.onBreakSucc.bind(this));
	},
	onBreakSucc:function(){
		trace("onBreakSucc");
		this.initData();
		this.updataBreakHeroUI();
	},
	onCancelClicked:function(){
		postNotifcation(this.exitNoti, {type : "soul"});
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	}
});