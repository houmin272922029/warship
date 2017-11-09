var RecruitHeroesCell = cc.Node.extend({
	ctor:function(data){
		this._super();
		this.data = data;
		cc.BuilderReader.registerController("RecruitHeroesCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.RecruitHeroesCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.cellMenu.setSwallowTouches(false);
		this.setContentSize(node.getContentSize());
		for (i = 0; i < 5; i++) {
			var heroId = data[i];
			if (heroId) {
				var hero = HeroModule.getHeroConfig(heroId);
				var name = hero.name;
				this["rank_head_bg_" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + hero.rank + ".png"));
				this["nameLabel" + (i + 1)].setString(name);
				this["rankSprite" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame((HeroModule.getHeroHeadById(heroId))));
				this["avatarBtn" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ hero.rank + ".png"));
				this["avatarBtn" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + hero.rank + ".png"));
			} else {
				this["rank_head_bg_" + (i + 1)].visible = false;
				this["nameLabel" + (i + 1)].visible = false;
				this["rankSprite" + (i + 1)].visible = false;
				this["avatarBtn" + (i + 1)].visible = false;
			}
			
		}
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	heroBookBtnAction:function() {
		common.showTipText(common.LocalizedString("close_func"));
		return;
//		var cb = new HeroDetail({info:1, type:1, close:function(){}.bind(this)});
//		cc.director.getRunningScene().addChild(cb);

	},
});