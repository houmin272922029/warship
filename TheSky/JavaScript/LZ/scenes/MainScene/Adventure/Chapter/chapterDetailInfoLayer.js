var chapterDetailInfoLayer = cc.Layer.extend({
	ctor:function(bookId){
		this._super();
		this.bookId = bookId;
		this.initLayer();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("ChapterDetailInfoViewOwner", {
		});
		cc.BuilderReader.registerController("ChapterDetailInfoCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.ChapterDetailInfoView_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.refresh();
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	refresh:function(){
		var self = this;
		var updateLabel = function(key, string){
			self[key].setString(string);
			self[key].visible = true;
		};
		var cfg = SkillModule.getSkillConfig(this.bookId);
		//this.itemInfoBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + cfg.rank + ".png"));
		this.skillIcon.setTexture(common.getIconById(cfg.icon));
		this.rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + cfg.rank + "_icon.png"));
		updateLabel("name_s",cfg.name);
		updateLabel("name",cfg.name);
		for (var k in cfg.attr) {
			var v = cfg.attr[k];
			this.attrIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			if (cfg.type == 5 || cfg.type == 1) {
				this.attrValue.setString("+" + v * 100 + "%");
			} else {
				this.attrValue.setString("+" + v);
			}
		}
		updateLabel("desp", cfg.intro1);
		if (cfg.type == 2) {
			this.attrType.visible = true;
			this.attrType.setString(common.LocalizedString("attrType_all"));
		} else if (cfg.type == 3){
			this.attrType.visible = true;
			this.attrType.setString(common.LocalizedString("attrType_single"));
		} 
		this["countLabel"].setString(common.LocalizedString("当前拥有数量：%d",SkillModule.getSkillCount(this.bookId)));
		var chapterNum = cfg.chapternum;
		this["layer_" + chapterNum].visible = true;
		for (var i = 1; i < chapterNum + 1; i++) {
			var count = 0;
			var fixI = common.fix(i, 2);
			var chapterPre = this.bookId.replace("book", "chapter");
			var chapterId = chapterPre + "_" + fixI;
			if (chapterdata.chapters[this.bookId][chapterId]) {
				count = chapterdata.chapters[this.bookId][chapterId];
			}
			this[chapterNum + "_" + i + "_count"].setString(count);
			this[chapterNum + "_" + i + "_countBg"].visible = true;
		}
	},
	combineItemClick:function(){
		if (ChapterModule.skillCanCombine(this.bookId)) {
			ChapterModule.doOnFragCombine(this.bookId, this.combineSkillCallback.bind(this));
		} else {
			common.showTipText(common.LocalizedString("chapter_needBook"));
		}
	},
	combineSkillCallback:function(){
		var cfg = SkillModule.getSkillConfig(this.bookId);
		//TODO palyConvAnimationOnNode(self.bookId,conf.chapternum,true, getAdventureLayer())
		ChapterModule.reduceCombineTime(this.bookId);
		postNotifcation(NOTI.GOTO_ADVENTURE);
	},
});