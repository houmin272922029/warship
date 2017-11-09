var ArenaAwardCell = cc.Node.extend({
	ctor:function(award, idx){
		this._super();
		cc.BuilderReader.registerController("ArenaAwardCellOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.ArenaAwardCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.award = award;
		this.idx = idx;
		this.cost;
		this.awardId;
		this.refresh();
	},
	refresh:function(){
		var award = this.award;
		if (award.id) {
			this.awardId = award.id;
			var item;
			var count;
			for (var k in award.gain) {
				item = k;
				count = award.gain[k];
			}
			this.awardItem.visible = true;
			this.awardText.visible = true;
			if (award.state == 1) {
				this.awardItem.setEnabled(true);
			}else if (award.state == 0) {
				this.awardItem.setEnabled(false);
			}else if (award.state == 2) {
				this.menu.visible = false;
				this.awardText.visible = false;
				this.label.visible = true;
			}

			var cfg = ItemModule.getItemConfig(item);
			this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + cfg.rank + ".png"));
			this.frame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + cfg.rank + ".png"));
			this.icon.visible = true;
			this.icon.setTexture(common.getIconById(item));
			this.awardName.setString(count + ItemModule.getItemConfig(item).name);
			this.scoreLabel.setString(common.LocalizedString("arena_exchange", 0));
			this.despLabel.setString(award.text);
		} else {
			var heroId = award.head;
			var cfg = HeroModule.getHeroConfig(heroId);
			this.exchangeItem.visible = true;
			this.exchangeText.visible = true;
			this.frame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + cfg.rank + ".png"));
			this.hero.visible = true;
			this.hero.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(heroId)));
			this.awardName.setString(award.name);
			this.scoreLabel.setString(common.LocalizedString("arena_exchange",award.cost));
			this.cost = award.cost;
			this.despLabel.setString(award.text);
		}
	},
	exchangeCallback:function(dic){
		PlayerModule.reducePlayerArenaScore(this.cost);
		postNotifcation(NOTI.REFRESH_ARENA_CALLBACK);
		//TODO 动画
	},
	exchangeItemClick:function(){
		if (PlayerModule.getPlayerArenaScore() < this.cost) {
			common.showTipText(common.LocalizedString("arena_needScore"));
			return;
		}
		ArenaModule.doOnExchangeItem(this.idx, this.exchangeCallback.bind(this))
	},
	getAwardCallback:function(){
		postNotifcation(NOTI.REFRESH_ARENA_CALLBACK);
		//TODO 动画
	},
	awardItemClick:function(){
		ArenaModule.doOnArenaReward(this.awardId, this.getAwardCallback.bind(this))
	},
	onEnter:function(){
		this._super();
	},
	onEnter:function(){
		this._super();
	},
});