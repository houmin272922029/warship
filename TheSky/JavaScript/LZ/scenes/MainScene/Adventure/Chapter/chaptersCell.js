var chaptersCell = cc.Node.extend({
	ctor:function(chapters){
		this._super();
		cc.BuilderReader.registerController("ChaptersCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ChaptersCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.chapters = chapters;
		this.bookId;
		this.chapterId;
		this.refresh();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	refresh:function(){
		for (var i = 0; i < this.chapters.length; i++) {
			if (this.chapters[i]) {
				var bookId = this.chapters[i].bookId;
				var cfg = SkillModule.getSkillConfig(bookId);
				this["layer_" + (i + 1)].visible = true;
				this["rankSprite" + (i + 1)].setNormalImage(new cc.Sprite("#frame_" + cfg.rank + ".png"));
				this["rankSprite" + (i + 1)].setSelectedImage(new cc.Sprite("#frame_" + cfg.rank + ".png"));
				var res = common.getResource(cfg.icon);
				if (res.icon) {
					this["skill" + (i + 1)].setTexture(res.icon);
					this["skill" + (i + 1)].visible = true;
				}
				if (ChapterModule.skillCanCombine(bookId)) {
					this["combine_t_" + (i + 1)].visible = true;
					this["combine" + (i + 1)].visible = true;
				} else {
					this["rob_t_" + (i + 1)].visible = true;
					this["rob" + (i + 1)].visible = true;
				}
				this["pro" + (i + 1)].setString(ChapterModule.getChapterPro(bookId) + "/" + cfg.chapternum);
				this["name" + (i + 1)].setString(cfg.name);
				var bookCount = SkillModule.getSkillCount(bookId);
				if (bookCount > 0) {
					this["countBg" + (i + 1)].visible = true;
					this["count" + (i + 1)].setString(bookCount);
				}
			}
		}
	},
	skillClick:function(sender){
		var idx = sender.getTag();
		var bookId = this.chapters[idx - 1].bookId;
		cc.director.getRunningScene().addChild(new chapterDetailInfoLayer(bookId));
	},
	getChapterEnemiesCallback:function(){
		postNotifcation(NOTI.GOTO_CHAPTER_ROB,{bookId:this.bookId,chapterId:this.chapterId})
	},
	robClick:function(sender){
		var idx = sender.getTag() - 4;
		this.bookId = this.chapters[idx - 1].bookId;
		var fixI = common.fix(idx, 2);
		var chapterPre = this.bookId.replace("book", "chapter");
		this.chapterId = chapterPre + "_" + fixI;
		ChapterModule.doOnGetFragEnemies(this.bookId, this.getChapterEnemiesCallback.bind(this));
	},
	combineSkillCallback:function(dic){
		var cfg = SkillModule.getSkillConfig(this.bookId);
		common.ShowText("合成成功");
		//TODO 合成动画 palyConvAnimationOnNode(this.bookId,cfg.chapternum,true,{exit : function(){ postNotifcation(NOTI.GOTO_ADVENTURE, {page : this.page});}.bind(this)})
		var pages;
		var page;
		if (getJsonLength(chapterdata.chapters) >= 8) {
			pages = "chapters";
			page = AdventureModule.getPage("chapters");
		} else {
			pages = this.bookId;
			page = AdventureModule.getPage(this.bookId);
		}
		postNotifcation(pages);
		postNotifcation(NOTI.GOTO_ADVENTURE, {page : page});
	},
	combineSkillFailCallback:function(){
		common.ShowText("合成失败");
		var pages;
		var page;
		if (getJsonLength(chapterdata.chapters) >= 8) {
			pages = "chapters";
			page = AdventureModule.getPage("chapters");
		} else {
			pages = this.bookId;
			page = AdventureModule.getPage(this.bookId);
		}
		postNotifcation(pages);
		postNotifcation(NOTI.GOTO_ADVENTURE, {page : page});
	},
	combineClick:function(sender){
		var idx = sender.getTag() - 8;
		this.bookId = this.chapters[idx - 1].bookId;
		ChapterModule.doOnFragCombine(this.bookId, this.combineSkillCallback.bind(this), this.combineSkillFailCallback.bind(this));
	},
});