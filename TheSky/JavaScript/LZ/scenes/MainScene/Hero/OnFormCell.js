var OnFormCell = cc.Node.extend({
	ctor:function(hero){
		this._super();
		this.hero = hero;
		cc.BuilderReader.registerController("OnFormCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.OnFormCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.frame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + hero.rank + ".png"));
		this.headIconBtn.setNormalImage(new cc.Sprite("#" + HeroModule.getHeroHeadById(hero.heroId)));
		var b = hero["break"];
		if (b && b > 0) {
			this.breakLevel.visible = true;
			this.breakLevelFnt.setString(b);
		}
		this.name.setString(hero.name);
		this.rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + hero.rank + "_icon.png"));
		this.hero_rank_bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + this.hero.rank + ".png"));
		this.level.setString(hero.level);
		this.price.setString(hero.price);
		
	},
	selectNode:function(){
		this.stamp.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("duihao_1_btn.png"));
		//this.bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("huobanCellBg_sel.png"));
	},
	unselectNode:function(){
		this.stamp.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("duihao_0_btn.png"));
		//this.bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("huobanCellBg.png"));
	},
	onHeadIconClicked:function(){
		cc.director.getRunningScene().addChild(new HeroDetail(this.hero, 6, this.hero.rank));
	}
});