var chapterRobLayer = cc.Layer.extend({
	ctor:function(bookId, chapterId, exit){
		this._super();
		this.bookId = bookId;
		this.chapterId = chapterId;
		this.exit = exit || NOTI.GOTO_ADVENTURE;
		this.enemies = chapterdata.fragEnemies;
		cc.BuilderReader.registerController("ChapterRobViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.ChapterRobView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.refresh();
	},
	refresh:function(){
		for (var i = 1; i < 4; i++) {
			var dic = this.enemies[(i - 1) + ""];
			var enemy = this["enemy" + i];
			if (dic) {
				enemy.visible = true;
				if (dic.name != null) {
					this["name" + i].setString(dic.name);
				}
				this["level" + i].setString(common.LocalizedString("LV:%d",dic.level));
				var chapterId = dic.frag
				var chapterName = ItemModule.getItemConfig(chapterId).name;
				this["chapter" + i].setString(common.LocalizedString("chapter_name",chapterId[chapterId.length - 1]));
				for (var j = 0; j < 3; j++) {
					var hid = dic.info.form[j + ""];
					if (hid) {
						var hero = dic.info.heros[hid];
						var cfg = HeroModule.getHeroConfig(hero.heroId);
						var frame = this[i + "_" +(j+1) + "_frame"];
						var rankBg = this["rank_bg_" + i +"_" + ( j + 1 )];
						frame.visible = true;
						rankBg.visible = true;
						frame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + hero.rank + ".png"));
						rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + hero.rank + ".png"));
						var head = this[i + "_" + (j + 1) + "_head"];
						head.visible = true;
						var f = HeroModule.getHeroHeadById(hero.heroId);
						if (f) {
							head.setSpriteFrame(f);
						} else {
							head.visible = false;
						}
					}
				}
			}
		}
	},
	backClick:function(){
		var AdventureList = AdventureModule.getUserAdventureList();
		postNotifcation(NOTI.GOTO_ADVENTURE, {page : AdventureModule.adventurePage})
	},
	chapterFightCallback:function(dic){
		var info = dic.info;
		postNotifcation(NOTI.GOTO_FIGHT, {log:info.battleLog, bg:1, left:PlayerModule.getName(), right:this.info.name, 
			extra:{from:"frags", book:this.bookId, result:info.battleResult, gain:info.gain, pay:info.pay}});
	},
	failCallBack:function(dic){
		traceTable("failCallBack")
	},
	fightClcik:function(sender){
		var tag = sender.getTag();
		this.info = this.enemies[tag - 1 + ""];
		ChapterModule.doOnGetFragBattle(tag - 1, this.info.frag, this.chapterFightCallback.bind(this), this.failCallBack.bind(this))
	},
	/**换一组对手
	 */
	getChapterEnemiesCallback:function(){
		this.refresh();
	},
	changeClick:function(){
		ChapterModule.doOnGetFragEnemies(this.bookId, this.getChapterEnemiesCallback.bind(this));
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});