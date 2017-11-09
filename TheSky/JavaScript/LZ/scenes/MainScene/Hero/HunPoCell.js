var HunPoCell = cc.Node.extend({
	ctor:function(soul){
		this._super();
		this.soul = soul;
		this.soulId = soul.id;
		this.hero = HeroModule.getHeroConfigById(soul.heroId);
		cc.BuilderReader.registerController("HunPoCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.HunPoCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.name.setString(soul.name);
		this.rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + this.hero.rank + "_icon.png"));
		this.amount.setString(soul.amount);
		this.iconBg.setNormalImage(new cc.Sprite("#frame_" + this.hero.rank + ".png"));
		this.headIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(soul.heroId)));
		this.hero_rank_bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + this.hero.rank + ".png"));
		if (soul["break"] && soul["break"] > 0 ) {
			this.breakLevelFnt.visible = true;
			this.breakLevel.visible = true;
			this.breakLevelFnt.setString(soul["break"]);
		}
		if (soul.sortFlag == 0) {
			this.breakBtn.visible = true;
			this.breakTitle.visible = true;
		}else if(soul.sortFlag == 2){
			this.amountTipTitle.visible = true;
			this.amountTipTitle.setString(common.LocalizedString("加%d可突破", soul.breCount));
		}else if (soul.sortFlag == 1) {
			this.recruitBtn.visible = true;
			this.recruitTitle.visible = true;
		}else if (soul.sortFlag == 3){
			this.amountTipTitle.visible = true;
			this.amountTipTitle.setString(common.LocalizedString("加%d可招募", soul.amount));
		}
	},
	onHunPoHeadClicked:function(){
		if (this.soul.sortFlag === 0) {
			var hero = HeroModule.getHeroByHeroId(this.hero.heroId);
			cc.director.getRunningScene().addChild(new HeroDetail(this.hero.heroId, 2, null, {soulId : this.soulId, hid : hero.id}))
		} else if (this.soul.sortFlag === 1) {
			cc.director.getRunningScene().addChild(new HeroDetail(this.hero.heroId, 1, null, {soulId : this.soulId}))
		} else {
			cc.director.getRunningScene().addChild(new HeroDetail(this.hero.heroId, 3))
		}
	},
	onBreakClicked:function(){
		var hero = HeroModule.getHeroByHeroId(this.hero.heroId);
		postNotifcation(NOTI.GOTO_BREAK, {hid : hero.id, soulId : this.soulId, noti : NOTI.GOTO_HEROES});
	},
	onRecuitClicked:function(){
		// TODO 招募动画
		SoulModule.doOnRecruitSoul([this.soulId], this.onRecuitSucc.bind(this));
	},
	onRecuitSucc:function(){
		trace("onRecuitSucc");
		postNotifcation(NOTI.GOTO_HEROES, {type : "soul"});
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	}
});