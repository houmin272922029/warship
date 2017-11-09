var QuestCell = cc.Node.extend({
	Compose:{
		STAGE : "stage", // 关卡
		RECRUIT : "recruit", // 招募
		NEWWORLD : "newworld", // 大冒险新世界
		HERO : "hero",          // 伙伴
		CHAPTER : "chapter",    // 大冒险残章
		UNION : "union",        // 联盟
		WW : "sea",             // 星战
		TREASURE : "treasure",  // 幸运卡牌
		EQUIP : "equip",        // 装备
		PACKAGE : "package",    // 背包
		DUEL : "duel"          // 武馆
	},
	ctor:function(itemData, type){
		this._super();
		cc.BuilderReader.registerController("QuestCellOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.QuestCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.itemData = itemData;
		this.type = type;
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		this.rewardText.visible = this.itemData.status == 1;
		this.gotoText.visible = this.itemData.status == 0;
		var cfg = QuestModule.getQuestConfig(this.itemData.missionId, this.type);
		this.cfg = cfg;
		var comp = cfg["goto"].comp; // 前往
		this.title.setString(cfg.name + "(" + this.itemData.progress + "/" + cfg.progress["end"] + ")");
		var replaceString  = (cfg.desp).replace("%d",cfg.progress.end);
		this.desp.setString((cfg.desp).replace("%d",cfg.progress.end));
		if (common.havePrefix((cfg.desp), "%s") && cfg.progress.stage) {
			var stage = cfg.progress.stage;
			var stageName = config.stageConfig_data[stage].stageName;
			this.desp.setString(replaceString.replace("%s",stageName + " "));
		}
		if (getJsonLength(this.itemData.reward) > 1) {
			//显示礼包
			this.bigSprite.visible = true;
			this.bigSprite.setTexture("res/ccbi/ccbResources/icons/vip_001.png");
			this.rankBg.setSpriteFrame("rank_head_bg_3.png");
			this.rankBg.visible = true;
			this.rewardItem.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_4.png"));
			this.rewardItem.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_4.png"));
		} else {
			// 显示单个道具
			var itemId;
			var count;
			for (var k in cfg.reward) {
				itemId = k;
				count = cfg.reward[k];
			}
			var resDic = common.getResource(itemId);
			this.id = resDic.id;
			if (common.havePrefix(itemId, "shadow")) {//影子
				this.rewardItem.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("s_frame.png"));
				this.rewardItem.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("s_frame.png"));
				this.rewardItem.setPosition(cc.p(this.rewardItem.x + 5, this.rewardItem.y - 5));
				if (resDic.icon) {
					olAni.playFrameAnimation("yingzi_" + resDic.icon + "_", this.contentLayer,
							cc.p(this.contentLayer.getContentSize().width / 2, this.contentLayer.getContentSize().height / 2), 1, 4,
							common.getColorByRank(resDic.rank));
				}
			} else if (common.havePrefix(itemId, "hero")) {//魂魄
				this.littleSprite.visible = true;
				this.soulIcon.visible = true;
				this.littleSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(resDic.icon));
			} else {
				var texture;
				if (common.havePrefix(itemId, "_shard")) {
					this.chipIcon.visible = true;
					texture = "res/ccbi/ccbResources/icons/" + resDic.icon + ".png";
				} else {
					texture = resDic.icon;
				}
				if (texture) {
					this.bigSprite.visible = true;
					this.bigSprite.setTexture(texture);
					this.bigSprite.setScale(0.33)
				}
			}
			if (!common.havePrefix(itemId, "shadow")) {
				this.rewardItem.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ resDic.rank +".png"));
				this.rewardItem.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ resDic.rank +".png"));
			}
			this.countBg.visible = true;
			this.countLabel.setString(count);
		}
	},
	getRewardSucc:function(){
		postNotifcation(NOTI.REFRESH_QEUEST);
	},
	menuItemClick:function(){
		if (this.itemData.status == 0) {
			var cfg = this.cfg;
			var comp =cfg["goto"].comp;
			if (comp == this.Compose.STAGE) {
				postNotifcation(NOTI.GOTO_STAGE);
			} else if (comp == this.Compose.RECRUIT) {
				postNotifcation(NOTI.GOTO_LOGUETOWN, {type : 0})
			} else if (comp == this.Compose.NEWWORLD) {
				if (FunctionModule.bOpen("blood")) {
					AdventureModule.adventurePage = 0;
					postNotifcation(NOTI.GOTO_ADVENTURE, {page:AdventureModule.adventurePage});
				}
			} else if (comp == this.Compose.UNION) {
				postNotifcation(NOTI.GOTO_UNION);
			} else if (comp == this.Compose.CHAPTER) {
				if (getJsonLength(chapterdata.chapters) > 0) {
					postNotifcation(NOTI.GOTO_ADVENTURE, {page:AdventureModule.adventurePage});
					postNotifcation(NOTI.MOVETO_PAGE, {page : AdventureModule.getUserAdventureList().length - 1});
				}
			} else if (comp == this.Compose.EQUIP) {
				postNotifcation(NOTI.GOTO_EQUIPS); 
			} else if (comp == this.Compose.PACKAGE) {
				postNotifcation(NOTI.GOTO_PACKAGE, {type : "item"});
			} else if (comp == this.Compose.DUEL) {
				postNotifcation(NOTI.GOTO_ARENA, {page : "fight"});
			} else if (comp == this.Compose.HERO) {
				postNotifcation(NOTI.GOTO_HEROES);
			} else if (comp == this.Compose.TREASURE) {
				postNotifcation(NOTI.GOTO_DAILY, {page : DailyName.Treasure});
			}
		} else {
			//领奖
			var quest = this.type == "once" ? 1 : 2;
			QuestModule.reduceQuest()
			QuestModule.doOnGetReward(quest, this.itemData.missionId, this.getRewardSucc.bind(this));
		}
	},
	rewardItemClick:function(){
		if (getJsonLength(this.cfg.reward) > 1) {
			var array = [];
			for (var k in this.cfg.reward) {
				array.push({itemId : k, count : this.cfg.reward[k]});
			}
			traceTable(array);//礼包展示
			//TODO就差数据 cc.director.getRunningScene().addChild(new MulItemInfoView(array));
		} else {
			//单个物品
			var itemId;
			var count;
			for (var k in this.cfg.reward) {
				itemId = k;
				count = this.cfg.reward[k];
			}
			if (common.havePrefix(itemId, "weapon_") || common.havePrefix(itemId, "belt_") ||
					common.havePrefix(itemId, "armor_") || common.havePrefix(itemId, "rune_")) {
				//装备
				if (common.havePrefix(itemId, "_shard")) {
					itemId = itemId.substring(0, 6);
				}
				var equip = EquipModule.getEquipConfig(itemId);
				cc.director.getRunningScene().addChild(new EquipDetail(equip, 1));
			} else if (common.havePrefix(itemId, "item") || common.havePrefix(itemId, "key") ||
					common.havePrefix(itemId, "bag") || common.havePrefix(itemId, "stuff") || common.havePrefix(itemId, "drawing")) {
				//道具
				cc.director.getRunningScene().addChild(new ItemDetailInfoView(itemId, itemId));
			} else if (common.havePrefix(itemId, "shadow")) {
				//影子
				var item = ShadowModule.getOneShadowConfig(itemId);
				cc.director.getRunningScene().addChild(new ShadowDetail(item, 1));
			} else if (common.havePrefix(itemId, "hero")) {
				//魂魄
				//TODO
			} else if (common.havePrefix(itemId, "book")) {
				cc.director.getRunningScene().addChild(new SkillDetail(itemId, 1));
			} else if (common.havePrefix(itemId, "chapter_")) {
				cc.director.getRunningScene().addChild(new chapterDetailInfoLayer(itemId));
			} else {
				trace("金币or银币");
			}
		}
	},
});