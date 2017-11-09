/**
 * 特训单人结果页
 * 
 */
var InstructSingleResultView = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		this.manager_ = params.manager;
		this.callBack_ = params.closeCallBack;
		
		this.initCCBLayer(ccbi_res.InstructSingleResultInfoView_ccbi, "InstructSingleResultOwner", this, this);
		
		this.swallowLayer(this.infoBg);
	},
	
	refreshView : function(data) {

		this["tFrame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(data.hero.rank)));
		this["tHead"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(data.hero.heroId)));
		this["sayLabel"].setString(config.gifted_dianbo[data.hero.heroId]["desp3"]);
		this["tHead"].setVisible(true);
		
		for (var int = 0; int < data.heros.length; int++) {
			var hero = data.heros[int];
			this["bust"].setVisible(true);
			this["bust"].setTexture(HeroModule.getHeroBust1ById(hero.heroId))
			this["rank"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("rank_{0}_icon.png").format(hero.rank)));
			this["heroName"].setString(hero.name);
			this["level"].setString(hero.level);
			this["rankBg"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("hero_bg_{0}.png").format(hero.rank)));

			this["price"].setString(hero.price);
			
			this.progressBg.setVisible(true);
			this.progress = new cc.ProgressTimer(new cc.Sprite("#pro_blue.png"));
			this.progress.type = cc.ProgressTimer.TYPE_BAR;
			this.progress.midPoint = cc.p(0, 0);
			this.progress.barChangeRate = cc.p(1, 0);
			this.progressBg.getParent().addChild(this.progress);
			this.progress.setPosition(cc.p(this.progressBg.x, this.progressBg.y));
			this.progress.scale = retina;
			this.progress.percentage = hero.expNow / hero.expMax * 100;
			
			var attr = HeroModule.getHeroAttrsByHeroUId(hero.id);
			this["atk"].setString(attr.atk);
			this["def"].setString(attr.def);
			this["hp"].setString(attr.hp);
			this["mp"].setString(attr.mp);
			
			this["ori"].setString(hero.levelOri);
			this["now"].setString(hero.level);
			
			this["exp"].setString(String("EXP+{0}").format(data.exp));
		}
		
	},

	closeItemClick : function() {
		this.closeView();
	},
	
	cancelItemClick : function() {
		this.closeView();
	},
	
	confirmClick : function() {
		if (this.selectIndex_ >= 0) {
			this.callBack_.call(this.manager_, this.selectIndex_);
		}
		
		this.closeView();
	},
	
	_touchOutside : function() {
		
	}
});
