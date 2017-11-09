var HeroDetail = cc.Layer.extend({
	TYPE:{
		hero:0, 	// 伙伴 左:传承 右:关闭 属性显示:全
		recruit:1, 	// 魂魄 可招募 左:招募 右:关闭 属性显示:配置
		upgrade:2, 	// 魂魄 可突破 左:突破 右:关闭 属性显示:配置
		soul:3, 	// 魂魄 左:无 右:关闭 属性显示:配置
		handbook:4, // 图鉴 左:无 右:关闭 属性显示:配置
		team:5, 	// 阵容 左:传承 右:换伙伴	属性显示:全
		show:6,		// 展示其他玩家 左:无 右:关闭 属性显示:全
	},
	/**
	 * 
	 * @param hero {String|Object}
	 * @param rank {Number} 当前显示rank值。为了判断是否是觉醒后的英雄
	 * @param type 
	 * @param noti
	 */
	ctor:function(hero, type, rank, param){
		this._super();
		this.type = type;
		this.param = param;
		if (type === this.TYPE.hero || type === this.TYPE.team || type === this.TYPE.show) {
			this.hero = hero;
			if (typeof hero === "string") {
				// uid
				this.hero = HeroModule.getHeroByUid(hero);
			}
			this.attr = HeroModule.getHeroAttrsByHero(this.hero);
		} else {
			this.hero = hero;
			if (typeof hero === "string") {
				// heroId
				this.hero = HeroModule.getHeroConfig(hero);
			}
			this.attr = this.hero.attr;
		}
		this.rank = rank || this.hero.rank;
		this.initLayer();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("HeroDetailOwner", {
		});
		cc.BuilderReader.registerController("HeroDetailCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.HeroDetail_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.sv.getContainer().setPosition(0, -150);
		this.refresh();
		this.changeShow(1);
	},
	changeShow:function(tag){
		if (tag == 1) {
			this["showBtn1"].setNormalImage(new cc.Sprite("#ol_left_down.png"));
			this["showBtn1"].setSelectedImage(new cc.Sprite("#ol_left_up.png"));
			this["showBtn2"].setNormalImage(new cc.Sprite("#ol_right_up.png"));
			this["showBtn2"].setSelectedImage(new cc.Sprite("#ol_right_down.png"));
			this["showNode1"].visible = true;
			this["showNode2"].visible = false;
			this.jieshao.setColor(cc.color(255, 226, 122));
			this.shuxing.setColor(cc.color(255, 247, 231));
			this.jieshao.enableStroke(cc.color(178, 100, 61), 2);
			this.shuxing.enableStroke(cc.color(144, 109, 90), 2);
		} else {
			this["showBtn1"].setNormalImage(new cc.Sprite("#ol_left_up.png"));
			this["showBtn1"].setSelectedImage(new cc.Sprite("#ol_left_down.png"));
			this["showBtn2"].setNormalImage(new cc.Sprite("#ol_right_down.png"));
			this["showBtn2"].setSelectedImage(new cc.Sprite("#ol_right_up.png"));
			this["showNode1"].visible = false;
			this["showNode2"].visible = true;
			this.jieshao.setColor(cc.color(255, 247, 231));
			this.shuxing.setColor(cc.color(255, 226, 122));
			this.jieshao.enableStroke(cc.color(144, 109, 90), 2);
			this.shuxing.enableStroke(cc.color(178, 100, 61), 2);
		}
		this["menu3"].visible = tag == 1; 
	},
	changeShowClick:function(sender){
		var tag = sender.getTag()
		this.changeShow(tag);
	},
	refresh:function(){
		var self = this;
		this.jieshao.enableStroke(cc.color(32, 18, 9), 2);
		this.shuxing.enableStroke(cc.color(32, 18, 9), 2);
		function updateLabel(key, string){
			self[key].setString(string);
			self[key].visible = true;
			if (key === "levelLabel") {
				self[key].enableShadow(cc.color.GRAY, cc.size(1, -1));
			}
		}
		var keys = ["hp", "atk", "def", "mp", "hit", "cri", "cnt", "dod", "resi", "parry"];
		for (var i in keys) {
			var key = keys[i];
			updateLabel(key, common.LocalizedString(key) + " :");
			updateLabel("label_" + key, this.attr[key] || 0);
		}
		var trainLevel = HeroModule.getTrainLevel(this.hero);
		var trainKey = HeroModule.getBreakKey(this.hero.heroId);
		updateLabel("heroTrainLevel", trainLevel);
		this.heroTrainBg.y = this[trainKey].y;

		updateLabel("nameLabel", this.hero.name);
		this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + this.rank + "_icon.png"));
		this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("ol_rank_bg_" + this.rank + ".png"));
		
		if (this.type === this.TYPE.hero || this.type === this.TYPE.team || this.type === this.TYPE.show) {
			var breakLevel = this.hero["break"] || 0;
			if (breakLevel > 0) {
				this["break"].visible = true;
				this.breakFnt.setString(breakLevel);
			}
		}
		
		this.bust.setTexture(HeroModule.getHeroBust1ById(this.hero.heroId));
		this.despLabel.setString(this.hero.desp);
		
		var cfg = HeroModule.getHeroConfig(this.hero.heroId);
		var skillId = cfg.skill
		if (this.rank !== cfg.rank) {
			skillId = cfg.awaveskill[this.rank + ""];
		}
		var sCfg = SkillModule.getSkillConfig(skillId);
		this.skillName.setString(sCfg.name)
		this.skillBtn.setNormalImage(new cc.Sprite("#frame_" + sCfg.rank + ".png"));
		this.skillBtn.setSelectedImage(new cc.Sprite("#frame_" + sCfg.rank + ".png"));
		this.skillIcon.setTexture(common.getIconById(sCfg.icon));
		
		if (this.type === this.TYPE.hero || this.type === this.TYPE.team || this.type === this.TYPE.show) {
			updateLabel("levelLabel", this.hero.level);
			updateLabel("priceLabel", this.hero.price);
			this.progressBg.visible = true;
			var progress = new cc.ProgressTimer(new cc.Sprite("#team_exp_pro_red.png"));
			progress.type = cc.ProgressTimer.TYPE_BAR;
			progress.midPoint = cc.p(0, 0);
			progress.barChangeRate = cc.p(1, 0);
			this.progressBg.getParent().addChild(progress);
			progress.setPosition(cc.p(this.progressBg.x, this.progressBg.y));
			progress.percentage = this.hero.expNow / this.hero.expMax * 100;
			
			
			var red_head = new cc.Sprite("#pro_red_head.png");
			this.progressBg.getParent().addChild(red_head, 2);
			red_head.scaleX = this.hero.expNow / this.hero.expNow;
			red_head.attr({
				x:this.progressBg.x - this.progressBg.getContentSize().width/2 + (this.progressBg.getContentSize().width  * this.hero.expNow / this.hero.expMax),
				y:this.progressBg.y,
				anchorX:1,
				anchorY:0.5
			});
			if (this.hero.expNow / this.hero.expMax >= 1) {
				red_head.visible = false;
			}
		} else {
			updateLabel("levelLabel", "1");
			updateLabel("priceLabel", HeroModule.getHeroPriceConfig(this.hero.heroId));
		}
		updateLabel("hpLabel", this.attr.hp);
		updateLabel("atkLabel", this.attr.atk);
		updateLabel("defLabel", this.attr.def);
		updateLabel("mpLabel", this.attr.mp);
		
		switch (this.type) {
		case this.TYPE.soul:
		case this.TYPE.handbook:
		case this.TYPE.show:
			this.leftBtn.visible = false;
			this.leftBtnText.visible = false;
			break;
		case this.TYPE.recruit:
			this.leftBtnText.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("zhaomu_title.png"));
			break;
		case this.TYPE.upgrade:
			this.leftBtnText.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("tupo_title.png"));
			break;
		case this.TYPE.team:
			this.rightBtnText.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("huanhuoban_text.png"));
			break;
		default:
			break;
		}
		var combo = HeroModule.getComboInfoByHeroId(this.hero.heroId, this.rank);
		this.comboLabel.setString(combo);
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
//	TYPE:{
//		hero:0, 	// 伙伴 左:传承 右:关闭 属性显示:全
//		recruit:1, 	// 魂魄 可招募 左:招募 右:关闭 属性显示:配置
//		upgrade:2, 	// 魂魄 可突破 左:突破 右:关闭 属性显示:配置
//		soul:3, 	// 魂魄 左:无 右:关闭 属性显示:配置
//		handbook:4, // 图鉴 左:无 右:关闭 属性显示:配置
//		team:5, 	// 阵容 左:传承 右:换伙伴	属性显示:全
//		show:6,		// 展示其他玩家 左:无 右:关闭 属性显示:全
//	},
	onLeftClicked:function(){
		if (this.type === this.TYPE.hero || this.type === this.TYPE.team) {
			var exit = NOTI.GOTO_HEROES;
			if (this.param && this.param.exit) {
				exit = this.param.exit
			}
			postNotifcation(NOTI.GOTO_FAREWELL, {des : this.hero.id, exit : exit});
			this.closeItemClick();
		} else if (this.type === this.TYPE.recruit) {
			var soulId = this.param.soulId;
			SoulModule.doOnRecruitSoul([this.soulId], function(){
				postNotifcation(NOTI.GOTO_HEROES, {type : "soul"});
			});
		} else if (this.type === this.TYPE.upgrade) {
			var hid = this.param.hid;
			var soulId = this.param.soulId;
			postNotifcation(NOTI.GOTO_BREAK, {hid : hid, soulId : soulId, noti : NOTI.GOTO_HEROES});
		}
	},
	onRightClicked:function(){
		if (this.type === this.TYPE.team) {
			var idx = FormModule.getIndexWithUid(this.hero.id);
			postNotifcation(NOTI.GOTO_ONFORM, {page:idx, type:0});
			this.closeItemClick();
		} else {
			this.closeItemClick();
		}
	}
});