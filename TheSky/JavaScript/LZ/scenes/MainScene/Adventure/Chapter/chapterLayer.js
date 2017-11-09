var chapterLayer = cc.Layer.extend({
	ctor:function(bookId){
		this._super();
		cc.BuilderReader.registerController("ChapterViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.ChapterView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		var size = this.node.getContentSize();
		this.setContentSize(size);
		this.bookId = bookId;
		this.chapterId;
		this.refresh();
	},
	refresh:function(){
		var cfg = SkillModule.getSkillConfig(this.bookId);
		this.skillName.setString(cfg.name);
		this.skillFrame.setNormalImage(new cc.Sprite("#frame_" + cfg.rank + ".png"));
		this.skillFrame.setSelectedImage(new cc.Sprite("#frame_" + cfg.rank + ".png"));
		this.rank_bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + cfg.rank + ".png"));
		this.skillIcon.visible = false;
		var res = common.getResource(cfg.icon);
		if (res.icon) {
			this.skillIcon.setTexture(res.icon);
			this.skillIcon.visible = true;
		} else {
			common.ShowText("找不到该图片")
		}
		var chapterNum = cfg.chapternum;
		this["layer_" + chapterNum].visible = true;
		this["menu_" + chapterNum].visible = true;
		this["menu_" + chapterNum].setEnabled(true);
		for (var i = 1; i < chapterNum + 1; i++) {
			var count = 0;
			var chapterPre = this.bookId.replace("book", "chapter");
			var fixI = common.fix(i, 2);
			if (chapterdata.chapters[this.bookId][chapterPre + "_" + fixI]) {
				this.chapterId = chapterPre + "_" + fixI;
				count = chapterdata.chapters[this.bookId][chapterPre + "_" + fixI];
			}
			this[chapterNum + "_" + i + "_count"].setString(count);
			var farme = this[chapterNum + "_" + i + "_frame"];
			this[chapterNum + "_" + i + "_rankbg"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + cfg.rank + ".png"));
			var item = this[chapterNum + "_" + i + "_chapterItem"];
			item.setEnabled(true);
			if (count == 0) {
				var animFrames = [];
				var cache = cc.spriteFrameCache;
				cache.addSpriteFrames(common.formatLResPath("treasureCard.plist"));
				var light = new cc.Sprite("#treasureCard_roundFrame_1.png");
				for (var j = 1; j < 4; j++) {
					var frameName = "treasureCard_roundFrame_" + j + ".png";
					var frame = cc.spriteFrameCache.getSpriteFrame(frameName);
					animFrames.push(frame);
				}
				var animation = cc.Animation(animFrames, 0.2);
				var animate =new cc.Animate(animation);
				light.runAction(cc.repeatForever(animate));
				farme.addChild(light);
				light.setPosition(cc.p(farme.getContentSize().width / 2, farme.getContentSize().height / 2));
			}
		}
	},
	skillItemClick:function(){
		cc.director.getRunningScene().addChild(new SkillDetail(SkillModule.getSkillConfigInfo(this.bookId), 2));
	},
	getChapterEnemiesCallback:function(){
		postNotifcation(NOTI.GOTO_CHAPTER_ROB,{bookId:this.bookId,chapterId:this.chapterId})
	},
	chapterClick:function(sender){
		var tag = sender.getTag();
		var fixI = common.fix(tag, 2);
		var chapterPre = this.bookId.replace("book", "chapter");
		var chapterId = chapterPre + "_" + fixI;
		var count = 0;
		if (chapterdata.chapters[this.bookId][chapterId]) {
			count = chapterdata.chapters[this.bookId][chapterId];
		}
		if (count > 0) {
			common.showTipText(common.LocalizedString("chapter_rob_haveOne"));
		} else {
			ChapterModule.doOnGetFragEnemies(this.bookId, this.getChapterEnemiesCallback.bind(this));
		}
	},
	combineSkillCallback:function(){
		//var cfg = SkillModule.getSkillConfig(this.bookId);
		//TODO palyConvAnimationOnNode(self.bookId,conf.chapternum,true, getAdventureLayer())
		common.ShowText("合成成功");
		var page = AdventureModule.getPage(this.bookId);
		postNotifcation(this.bookId);
		postNotifcation(NOTI.GOTO_ADVENTURE, {page : page});
	},
	/**
	 * 残页合成
	 */
	combineItemClick:function(){
		var cfg = SkillModule.getSkillConfig(this.bookId);
		var flag = ChapterModule.skillCanCombine(this.bookId);
		if (!flag) {
			common.showTipText(common.LocalizedString("chapter_needBook"));
		} else {
			ChapterModule.doOnFragCombine(this.bookId, this.combineSkillCallback.bind(this), function(){
				common.ShowText("合成失败");
			});
		}
	},
	onEnter:function(){
		this._super();
		addObserver(this.bookId, "refresh", this);
	},
	onExit:function(){
		this._super();
		removeObserver(this.bookId, "refresh", this);
	},
})