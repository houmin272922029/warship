var ArenaEnemyCell = cc.Node.extend({
	ctor:function(player){
		this._super();
		cc.BuilderReader.registerController("ArenaEnemyCellOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.ArenaEnemyCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.menu.setSwallowTouches(false)
		this.player = player;
		this.refresh();
	},
	onEnter:function(){
		this._super();
	},
	onEnter:function(){
		this._super();
	},
	refresh:function(){
		var player = this.player;
		this.name.setString(player.name);
		this.scoreLabel.setString(common.LocalizedString("arena_rankScore",player.awardScore));
		this.level.setString(player.level);
		for (var i = 0; i < 3; i++) {
			var heroId;
			if (player.heros[i]) {
				heroId = player.heros[i].heroId;
				var rank = player.heros[i].rank;
				this["rankBg_" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + rank + ".png"));
				this["rankBg_" + (i + 1)].visible = true;
				this["frame" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + rank + ".png"));
				this["frame" + (i + 1)].visible = true;
				this["head" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(heroId)));
				this["head" + (i + 1)].visible = true;
			}
			
		}
		if (player.type == 0) {
			this.viewItem.visible = true;
			this.viewText.visible = true;
		} else {
			if (player.type != 3) {
				this.fightItem.visible = true;
			}
			if (player.type == 1) {
				this.fightText.visible = true;
			} 
			//TODO -------
		}
		var rank = player.rank;
		var grade = 1;
		var tempRank = rank;
		while (true) {
			if (Math.floor(tempRank / 10) == 0) {
				break;
			}
			grade += 1;
			if (grade == 5) {
				break;
			}
			tempRank = Math.floor(tempRank / 10);
		}
		if (rank > 0 && rank <= 3) {
			this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("arena_rank_big_" + rank + ".png"));
			this.rankSprite.visible = true;
			this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("arena_rank_" + rank + "_bg.png"));
			this.rankBg.visible = true;
		} else if (rank > 3 && rank < 10) {
			this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("arena_rank_" + rank + ".png"));
			this.rankSprite.visible = true;
		} else {
			this["rank" + grade].setString(rank);
			this["rank" + grade].visible = true;
		}
	},
	arenaMenuClick:function(){
		cc.director.getRunningScene().addChild(new ArenaMenuLayer(this.player));
	},
	getBattleInfoCallback:function(dic){
		var info = dic.info;
		postNotifcation(NOTI.GOTO_FIGHT, {log:info.battleLog, bg:1, left:PlayerModule.getName(), right:this.player.name,
			extra:{from:"arena", result:info.result, gain:info.gain, pay:info.pay}});
	},
	fightItemClick:function(){
		ArenaModule.doOnArenaBattle(this.player.rank, this.getBattleInfoCallback.bind(this))
	},
	viewItemClick:function(){
		common.ShowText(common.LocalizedString("close_func"));
	},
});