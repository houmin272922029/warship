/**
 * 特训群体结果页
 * 
 */
var InstructGroupResultView = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		this.manager_ = params.manager;
		this.callBack_ = params.closeCallBack;
		
		this.initCCBLayer(ccbi_res.InstructGroupResultInfoView_ccbi, "InstructGroupResultOwner", this, this);
		
		this.swallowLayer(this.infoBg);
	},
	
	refreshView : function(data) {

		this["tFrame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(data.hero.rank)));
		this["tHead"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(data.hero.heroId)));
		this["sayLabel"].setString(config.gifted_dianbo[data.hero.heroId]["desp3"]);
		this["tHead"].setVisible(true);
		
		for (var int = 0; int < data.heros.length; int++) {
			var hero = data.heros[int];
			this["hero" + (int + 1)].setVisible(true);
			this["frame" + (int + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(hero.rank)));
			this["head" + (int + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(hero.heroId)));
			this["head" + (int + 1)].setVisible(true);
			
			this["name" + (int + 1)].setString(hero.name);
			
			this["rank" + (int + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("rank_{0}_icon.png").format(hero.rank)));

			this["ori" + (int + 1)].setString(hero.levelOri);
			this["now" + (int + 1)].setString(hero.level);
			this["exp" + (int + 1)].setString(String("EXP+{0}").format(data.exp));
			
			if (hero.levelOri < hero.level) {
				this["now" + (int + 1)].setVisible(true);
				this["to" + (int + 1)].setVisible(true);
			}
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
