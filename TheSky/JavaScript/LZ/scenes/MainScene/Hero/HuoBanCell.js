var HuoBanCell = cc.Node.extend({
	ctor:function(hero){
		this._super();
		this.hero = hero;
		cc.BuilderReader.registerController("HuoBanCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.HuoBanCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.name.setString(hero.name)
		this.rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + hero.rank + "_icon.png"));
		this.level.setString(hero.level);
		this.price.setString(HeroModule.getHeroAttrPrice(hero));
		this.iconBg.setNormalImage(new cc.Sprite("#frame_" + hero.rank + ".png"));
		this.hero_rank_bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + this.hero.rank + ".png"));
		this.headIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(hero.heroId)));
		if (hero["break"] && hero["break"] > 0) {
			this.breakLevel.visible = true;
			this.breakLevelFnt.setString(hero["break"]);
		}
		this.inFormTip.visible = hero.form === 1;
	},
	onFarewellClicked:function(){
		postNotifcation(NOTI.GOTO_FAREWELL, {des : this.hero.id, exit : NOTI.GOTO_HEROES});
	},
	onCultureClicked:function(){
		trace("onCultureClicked");
		postNotifcation(NOTI.GOTO_CULTURE, {uid : this.hero.id, noti : NOTI.GOTO_HEROES});
	},
	onHuoBanHeadClicked:function(){
		cc.director.getRunningScene().addChild(new HeroDetail(this.hero.id, 0, this.hero.rank, {exit : NOTI.GOTO_TEAM}));
	}
});