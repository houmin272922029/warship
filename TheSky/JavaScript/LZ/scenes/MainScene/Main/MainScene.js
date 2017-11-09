var MainScene = cc.Scene.extend({
	ctor:function(type, params){
		this._super();
		var layer = new MainLayer(type, params);
		this.addChild(layer);
	},
	onEnter:function(){
		this._super();
		SchedulerModule.startTimer();
	},
	onExit:function(){
		this._super();
		SchedulerModule.endTimer();
	},
});

/**
 * 全局变量
 */
var broadCastHeight = 30;           // 公告滚动条高度
var mainBottomTabBarHeight = 106;    // 底部tabbar高度

var MainLayer = cc.Layer.extend({
	bottomTag:{
		home:1,
		team:2,
		sail:3,
		adventure:4,
		daily:5,
		logue:6,
		fight:7,
		union:8,
		others:9,
		marine:10,
		ww:11
	},
	buttons:[],
	currentTag:0,
	ctor:function(type, params){
		this._super();
		this.node = cc.BuilderReader.load(ccbi_res.MainLayer_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.type = type || "home";
		this.params = params;
	},
	onEnter:function(){
		this._super();
		this.refresh();
		this.addBottomBtn();
		var type = this.type;
		var params = this.params;
		switch (this.type) {
		case "home":
			this.showHome();
			break;
		case "stage":
			this.gotoStage({stageId:params.nextId, mode:params.type});
			break;
		case "arena":
			this.gotoArena({});
			break;
		case "blood":
			this.gotoAdventure(params);
			break;
		case "frags":
			this.gotoAdventure(params);
			break;
		case "equips":
			this.gotoEquips(params);
			break;
		case "culture":
			this.gotoHeroes(params);
			break;
		case "break":
			this.gotoHeroes(params);
			break;
		case "skill":
			this.gotoSkills();
			break;
		case "shadows":
			this.gotoShadow(params);
			break;
		case "recruit":
			this.gotoLogueTown(params);
			break;
		case "box":
			this.gotoLogueTown(params);
			break;
		}
		setUDBool(UDefKey.Setting_Effect, "effect");
		addObserver(NOTI.GOTO_SKILL_BREAK_RESULT, "gotoSkillBreakResult", this);
		addObserver(NOTI.BERRY_REFRESH, "refreshBerry", this);
		addObserver(NOTI.GOLD_REFRESH, "refreshGold", this);
		addObserver(NOTI.ST_REFRESH, "refreshSt", this);
		addObserver(NOTI.GOTO_HOME, "showHome", this);
		addObserver(NOTI.GOTO_TEAM, "gotoTeam", this);
		addObserver(NOTI.GOTO_DAILY, "gotoDaily", this);
		addObserver(NOTI.GOTO_HEROES, "gotoHeroes", this);
		addObserver(NOTI.GOTO_FAREWELL, "gotoFarewell", this);
		addObserver(NOTI.GOTO_BREAK, "gotoBreakHeroLayer", this);
		addObserver(NOTI.GOTO_FAREWELLSELHERO, "gotoSelHeroFarewell", this);
		addObserver(NOTI.GOTO_ONFORM, "gotoOnForm", this);
		addObserver(NOTI.GOTO_SKILLS, "gotoSkills", this);
		addObserver(NOTI.GOTO_SKILL_BREAK, "gotoSkillBreak", this);
		addObserver(NOTI.GOTO_SKILL_BREAK_SELECT, "gotoSkillBreakSelect", this);
		addObserver(NOTI.GOTO_SKILL_BREAK_RESULT, "gotoSkillBreakResult", this);
		addObserver(NOTI.GOTO_PACKAGE, "gotoPackage", this);
		addObserver(NOTI.GOTO_EQUIPS, "gotoEquips", this);
		addObserver(NOTI.GOTO_EQUIPSELL, "gotoEquipSell", this);
		addObserver(NOTI.GOTO_EQUIPUPDATE, "gotoEquipUpdate", this);
		addObserver(NOTI.GOTO_SHADOW_UPDATE, "gotoShadowUpdate", this);
		addObserver(NOTI.GOTO_SHADOW, "gotoShadow", this);
		addObserver(NOTI.GOTO_CULTURE, "gotoCulture", this);
		addObserver(NOTI.GOTO_ATLAS, "gotoAtlas", this);
		addObserver(NOTI.GOTO_NEWS, "gotoNews", this);
		addObserver(NOTI.GOTO_ADVENTURE, "gotoAdventure", this);
		addObserver(NOTI.GOTO_FRIEND, "gotoFriend", this);
		addObserver(NOTI.GOTO_LOGUETOWN, "gotoLogueTown", this);
		addObserver(NOTI.GOTO_SKILL_CHANGE, "gotoSkillChange", this);
		addObserver(NOTI.GOTO_EQUIP_CHANGE, "gotoEquipChange", this);
		addObserver(NOTI.GOTO_SHADOW_CHANGE, "gotoShadowChange", this);
		addObserver(NOTI.GOTO_CHAPTER_ROB, "gotoChapterRob", this);
		addObserver(NOTI.GOTO_ARENA, "gotoArena", this);
		addObserver(NOTI.GOTO_CHAT, "gotoChat", this);
		addObserver(NOTI.GOTO_SYSTEM, "gotoSystem", this);
		addObserver(NOTI.FLUSH_GOLD, "refreshGold", this);
		addObserver(NOTI.GOTO_UNION, "gotoUnion", this);
		addObserver(NOTI.GOTO_QUEST, "gotoQuest", this);
		addObserver(NOTI.GOTO_STAGE, "gotoStage", this);
		addObserver(NOTI.GOTO_FIGHT, "gotoBattle", this);
		addObserver(NOTI.GOTO_HELP, "gotoHelp", this);
		addObserver(NOTI.GOTO_CUSSERVICE, "gotoCusservice", this);
		addObserver(NOTI.GOTO_ADD_FRIEND, "gotoAddFriend", this);
		addObserver(NOTI.GOTO_CHONGZHI, "gotoShop", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.BERRY_REFRESH, "refreshBerry", this);
		removeObserver(NOTI.GOLD_REFRESH, "refreshGold", this);
		removeObserver(NOTI.ST_REFRESH, "refreshSt", this);
		removeObserver(NOTI.GOTO_HOME, "showHome", this);
		removeObserver(NOTI.GOTO_TEAM, "gotoTeam", this);
		removeObserver(NOTI.GOTO_DAILY, "gotoDaily", this);
		removeObserver(NOTI.GOTO_HEROES, "gotoHeroes", this);
		removeObserver(NOTI.GOTO_FAREWELL, "gotoFarewell", this);
		removeObserver(NOTI.GOTO_BREAK, "gotoBreakHeroLayer", this);
		removeObserver(NOTI.GOTO_FAREWELLSELHERO, "gotoSelHeroFarewell", this);
		removeObserver(NOTI.GOTO_ONFORM, "gotoOnForm", this);
		removeObserver(NOTI.GOTO_SKILLS, "gotoSkills", this);
		removeObserver(NOTI.GOTO_SKILL_BREAK, "gotoSkillBreak", this);
		removeObserver(NOTI.GOTO_SKILL_BREAK_SELECT, "gotoSkillBreakSelect", this);
		removeObserver(NOTI.GOTO_SKILL_BREAK_RESULT, "gotoSkillBreakResult", this);
		removeObserver(NOTI.GOTO_PACKAGE, "gotoPackage", this);
		removeObserver(NOTI.GOTO_EQUIPS, "gotoEquips", this);
		removeObserver(NOTI.GOTO_EQUIPSELL, "gotoEquipSell", this);
		removeObserver(NOTI.GOTO_EQUIPUPDATE, "gotoEquipUpdate", this);
		removeObserver(NOTI.GOTO_SHADOW_UPDATE, "gotoShadowUpdate", this);
		removeObserver(NOTI.GOTO_SHADOW, "gotoShadow", this);
		removeObserver(NOTI.GOTO_CULTURE, "gotoCulture", this);
		removeObserver(NOTI.GOTO_ATLAS, "gotoAtlas", this);
		removeObserver(NOTI.GOTO_NEWS, "gotoNews", this);
		removeObserver(NOTI.GOTO_ADVENTURE, "gotoAdventure", this);
		removeObserver(NOTI.GOTO_FRIEND, "gotoFriend", this);
		removeObserver(NOTI.GOTO_LOGUETOWN, "gotoLogueTown", this);
		removeObserver(NOTI.GOTO_SKILL_CHANGE, "gotoSkillChange", this);
		removeObserver(NOTI.GOTO_EQUIP_CHANGE, "gotoEquipChange", this);
		removeObserver(NOTI.GOTO_SHADOW_CHANGE, "gotoShadowChange", this);
		removeObserver(NOTI.GOTO_CHAPTER_ROB, "gotoChapterRob", this);
		removeObserver(NOTI.GOTO_ARENA, "gotoArena", this);
		removeObserver(NOTI.GOTO_CHAT, "gotoChat", this);
		removeObserver(NOTI.GOTO_SYSTEM, "gotoSystem", this);
		removeObserver(NOTI.FLUSH_GOLD, "refreshGold", this);
		removeObserver(NOTI.GOTO_UNION, "gotoUnion", this);
		removeObserver(NOTI.GOTO_QUEST, "gotoQuest", this);
		removeObserver(NOTI.GOTO_STAGE, "gotoStage", this);
		removeObserver(NOTI.GOTO_FIGHT, "gotoBattle", this);
		removeObserver(NOTI.GOTO_HELP, "gotoHelp", this);
		removeObserver(NOTI.GOTO_CUSSERVICE, "gotoCusservice", this);
		removeObserver(NOTI.GOTO_ADD_FRIEND, "gotoAddFriend", this);
		removeObserver(NOTI.GOTO_CHONGZHI, "gotoShop", this);
	},
	refreshBerry:function(dic){
		var berry = PlayerModule.getBerry();
		if (dic && dic.berry) {
			berry = dic.berry;
		}
		this.berryLabel.setString(berry);
	},
	refreshGold:function(dic){
		var gold = PlayerModule.getGold();
		if (dic && dic.gold) {
			gold = dic.gold;
		}
		this.goldLabel.setString(gold);
	},
	refreshSt:function(dic){
		dic = dic || {};
		var st = dic.st || PlayerModule.getStrength();
		this.strengthLabel.setString(st + "/" + PlayerModule.getStrengthMax());
		this.strengthProgress.percentage = Math.min(st / PlayerModule.getStrengthMax() * 100, 100);
	},
	refresh:function(){
		this.nameLabel.setString(PlayerModule.getName());
		
		this.nameLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.lvTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.lvLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.expTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.expLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.strengthTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.goldTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.berryTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.energyTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.strengthLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.energyLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.berryLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.goldLabel.enableStroke(cc.color(32, 18, 9), 2);
		
		var vipLevel = PlayerModule.getVipLevel();
		this.vipIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("ol_VIP_" + vipLevel + ".png"));
		this.lvLabel.setString(PlayerModule.getLevel());
		this.expLabel.setString(Math.round(PlayerModule.getExp() / PlayerModule.getPlayerExpMax(PlayerModule.getLevel()) * 100) + "%");
		this.expLabel.setLocalZOrder(1);
		this.goldLabel.setString(PlayerModule.getGold());
		this.berryLabel.setString(PlayerModule.getBerry());
		this.strengthLabel.setString(PlayerModule.getStrength() + "/" + PlayerModule.getStrengthMax());
		this.strengthLabel.setLocalZOrder(1);
		this.energyLabel.setString(PlayerModule.getEnergy() + "/" + PlayerModule.getEnergyMax());
		this.energyLabel.setLocalZOrder(1);
		
		if (!this.expProgress) {
			this.expProgressBg.visible = false;
			this.expProgress = new cc.ProgressTimer(new cc.Sprite("#pro_yellow.png"));
			this.expProgress.type = cc.ProgressTimer.TYPE_BAR;
			this.expProgress.midPoint = cc.p(0, 0);
			this.expProgress.barChangeRate = cc.p(1, 0);
			this.expProgressBg.getParent().addChild(this.expProgress);
			this.expProgress.setPosition(cc.p(this.expProgressBg.x, this.expProgressBg.y));
			
			var yellow_head = new cc.Sprite("#pro_yellow_head.png");
			this.expProgressBg.getParent().addChild(yellow_head, 2);
			yellow_head.scaleX = PlayerModule.getExp() / PlayerModule.getPlayerExpMax(PlayerModule.getLevel());
			yellow_head.attr({
				x:this.expProgressBg.x - this.expProgressBg.getContentSize().width/2 + (this.expProgressBg.getContentSize().width  * PlayerModule.getExp() / PlayerModule.getPlayerExpMax(PlayerModule.getLevel())),
				y:this.expProgressBg.y,
				anchorX:1,
				anchorY:0.5
			});
			if (PlayerModule.getExp() / PlayerModule.getPlayerExpMax(PlayerModule.getLevel()) >= 1) {
				yellow_head.visible = false;
			}
		}
		this.expProgress.percentage = PlayerModule.getExp() / PlayerModule.getPlayerExpMax(PlayerModule.getLevel()) * 100;
		
		
		if (!this.strengthProgress) {
			this.strengthProgressBg.visible = false;
			this.strengthProgress = new cc.ProgressTimer(new cc.Sprite("#pro_purple.png"));
			this.strengthProgress.type = cc.ProgressTimer.TYPE_BAR;
			this.strengthProgress.midPoint = cc.p(0, 0);
			this.strengthProgress.barChangeRate = cc.p(1, 0);
			this.strengthProgressBg.getParent().addChild(this.strengthProgress);
			this.strengthProgress.setPosition(cc.p(this.strengthProgressBg.x, this.strengthProgressBg.y));
			
			var purple_head = new cc.Sprite("#pro_purple_head.png");
			this.strengthProgressBg.getParent().addChild(purple_head, 2);
			purple_head.scaleX = PlayerModule.getStrength() / PlayerModule.getStrengthMax();
			purple_head.attr({
				x:this.strengthProgressBg.x - this.strengthProgressBg.getContentSize().width/2 + (this.strengthProgressBg.getContentSize().width  * PlayerModule.getStrength() / PlayerModule.getStrengthMax()),
				y:this.strengthProgressBg.y,
				anchorX:1,
				anchorY:0.5
			});
			if (PlayerModule.getStrength() / PlayerModule.getStrengthMax() >= 1) {
				purple_head.visible = false;
			}
		}
		this.strengthProgress.percentage = Math.min(PlayerModule.getStrength() / PlayerModule.getStrengthMax() * 100, 100);
		if (!this.energyProgress) {
			this.energyProgressBg.visible = false;
			this.energyProgress = new cc.ProgressTimer(new cc.Sprite("#pro_blue.png"));
			this.energyProgress.type = cc.ProgressTimer.TYPE_BAR;
			this.energyProgress.midPoint = cc.p(0, 0);
			this.energyProgress.barChangeRate = cc.p(1, 0);
			this.energyProgressBg.getParent().addChild(this.energyProgress);
			this.energyProgress.setPosition(cc.p(this.energyProgressBg.x, this.energyProgressBg.y));
			
			var blue_head = new cc.Sprite("#pro_blue_head.png");
			this.energyProgressBg.getParent().addChild(blue_head, 2);
			blue_head.scaleX = PlayerModule.getEnergy() / PlayerModule.getEnergyMax();
			blue_head.attr({
				x:this.energyProgressBg.x - this.energyProgressBg.getContentSize().width/2 + (this.energyProgressBg.getContentSize().width  * PlayerModule.getEnergy() / PlayerModule.getEnergyMax()),
				y:this.energyProgressBg.y,
				anchorX:1,
				anchorY:0.5
			});
			if (PlayerModule.getEnergy() / PlayerModule.getEnergyMax() >= 1) {
				blue_head.visible = false;
			}
		}
		this.energyProgress.percentage = Math.min(PlayerModule.getEnergy() / PlayerModule.getEnergyMax() * 100, 100);

		if (PlayerModule.getFlag()) {
			this.flag.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(PlayerModule.getFlag() + ".png"));
			this.flagBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("flag_bg_" + (PlayerModule.getVipLevel() + 1) +".png"));
			if (PlayerModule.getVipLevel() < 12) {
				this.flag.setLocalZOrder(2);
				this.flagBg.setLocalZOrder(1);
			}
		}
	},
	addBottomBtn:function(){
		var offset = 0;
		if (this.lv) {
			offset = this.lv.getInnerContainer().x
			this.lv.removeFromParent(true);
		}
		var homeBtn = this.homeBtn;
		var size = cc.size(cc.winSize.width - homeBtn.getContentSize().width * retina, homeBtn.getContentSize().height * retina);
		this.lv = new ccui.ListView();
		this.lv.setDirection(ccui.ScrollView.DIR_HORIZONTAL);
		this.lv.setTouchEnabled(true);
		this.lv.setBounceEnabled(true);
		this.lv.setContentSize(size);
		this.lv.attr({
			x:homeBtn.getContentSize().width * retina,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this.lv.addEventListener(this.selectedItemEvent, this);
		this.addChild(this.lv);
		this.lv.getInnerContainer().x = offset;
		this.buttons = [];
		for (var i = 0; i < 7; i++) {
			var n = 0;
			if ((i === 0 && this.currentTag === this.bottomTag.team) 
					|| (i === 1 && this.currentTag === this.bottomTag.sail)
					|| (i === 2 && this.currentTag === this.bottomTag.adventure)
					|| (i === 3 && this.currentTag === this.bottomTag.daily)
					|| (i === 4 && this.currentTag === this.bottomTag.logue)
					|| (i === 5 && this.currentTag === this.bottomTag.fight)
					|| (i === 6 && this.currentTag === this.bottomTag.union)
					|| (i === 7 && this.currentTag === this.bottomTag.ww)) {
				n = 1;
			}
			var button = new ccui.Button("btn_btm_" + (i + 1) +"_" + n + ".png", "btn_btm_" + (i + 1) + "_1.png", "", ccui.Widget.PLIST_TEXTURE);
			this.buttons.push(button);
			button.scale = retina;
			button.setTouchEnabled(true);
			button.setSwallowTouches(false);
			button.addTouchEventListener(function(sender, type){
				if (type === ccui.Widget.TOUCH_ENDED) {
					switch (sender.getTag()) {
					case 0:
						this.gotoTeam({});
						break;
					case 1:
						this.gotoStage({});
						break;
					case 2:
						this.gotoAdventure({page:AdventureModule.adventurePage});
						break;
					case 3:
						this.gotoDaily({});
						break;
					case 4:
						this.gotoLogueTown({});
						break;
					case 5:
						this.gotoArena({});
						break;
					case 6:
						this.gotoUnion({});
						break;
					default:
						break;
					}
				}
			}, this);
			button.attr({
				anchorX:0,
				anchorY:0
			});
			var item = new ccui.Layout();
			item.setTouchEnabled(true);
			item.setContentSize(cc.size(homeBtn.getContentSize().width * retina, homeBtn.getContentSize().height * retina));
			item.addChild(button, 0, i);
			this.lv.pushBackCustomItem(item);
		}
	},
	titleBgVisible:function(dic) {
		var b;
		if (typeof dic === "Object") {
			b = dic.v;
		} else {
			b = dic;
		}
		this.titleBg.visible = b;
		this.titleMenu.visible = b;
	},
	selectedItemEvent:function(sender, type){
		switch (type) {
		case ccui.ListView.EVENT_SELECTED_ITEM:
			break;
		default:
			break;
		}
	},
	showHome:function(){
		if (this.currentTag == this.bottomTag.home) {
			return;
		}
		this.currentTag = this.bottomTag.home;
		this.changeLayer(new HomeLayer());
		this.titleBgVisible(true);
	},
	gotoAdventure:function(dic){
		if (this.currentTag == this.bottomTag.adventure) {
			return;
		}
		var adventurePage = dic.page;
		AdventureModule.doOnGetAdventureAllData(function(){
			this.currentTag = this.bottomTag.adventure;
			this.changeLayer(new AdventureLayer(adventurePage));
			this.titleBgVisible(false);
		}.bind(this));
	},
	gotoLogueTown:function(dic){
		if (this.currentTag == this.bottomTag.logue) {
			return;
		}
		var type = dic.type;
		this.currentTag = this.bottomTag.logue;
		var vipBagId = dic.vipBagId;
		this.changeLayer(new LogueTownLayer(type));
		this.titleBgVisible(true);
	},
	gotoTeam:function(dic){
		if (this.currentTag == this.bottomTag.team) {
			return;
		}
		this.currentTag = this.bottomTag.team;
		var page = dic.page;
		var type = dic.type;
		this.changeLayer(new TeamLayer(page, type));
		this.titleBgVisible(false);
	},
	gotoArena:function(dic){
		if (PlayerModule.getLevel() >= FunctionModule.openLevel("arena")) {
		} else {
			common.showTipText(common.LocalizedString("component_close_duel"));
			return;
		}
		
		if (this.currentTag == this.bottomTag.fight) {
			return;
		}
		this.currentTag = this.bottomTag.fight;
		var page = dic.page;
		this.changeLayer(new arenaLayer(page));
		this.titleBgVisible(true);
	},
	
	gotoDaily:function(dic){
		// 获取列表，当列表不为空进入日常
		var page = dic.page;
		if (this.currentTag == this.bottomTag.daily) {
			return;
		}
		
		ActivityModule.fetchActivityList([], function() {
			if (getJsonLength(ActivityModule.getActivityList()) > 0) {
				
				this.currentTag = this.bottomTag.daily;
				this.changeLayer(new DailyLayer({curindex : page}));
				this.titleBgVisible(false);
			}
		}.bind(this), function(){
			
		})
	},
	gotoShadow:function(dic){
		this.currentTag = 0;
		var type = dic.type || 0;
		this.changeLayer(new TrainShadowLayer(type));
		this.titleBgVisible(true);
	},
	gotoShadowUpdate:function(dic){
		this.currentTag = 0;
		var shadow = dic.shadow || 0;
		this.changeLayer(new UpdateShadowView(shadow));
		this.titleBgVisible(true);
	},
	gotoHeroes:function(dic){
		this.currentTag = 0;
		var type = "hero";
		if (dic) {
			if (typeof dic === "string") {
				type = dic;
			} else {
				type = dic.type;
			}
		}
		this.changeLayer(new HeroesLayer(type));
		this.titleBgVisible(true);
	},
	gotoFarewell:function(dic){
		this.currentTag = 0;
		var des = dic.des;
		var src = dic.src;
		var uiType = dic.uiType;
		var exit = dic.exit;
		this.changeLayer(new FarewellLayer(des, src, uiType, exit));
		this.titleBgVisible(true);
	},
	gotoBreakHeroLayer:function(dic){
		this.currentTag = 0;
		var hid = dic.hid;
		var soulId = dic.soulId
		var noti = dic.noti;
		this.changeLayer(new BreakHeroLayer(hid, soulId, noti));
		this.titleBgVisible(true);
	},
	gotoSelHeroFarewell:function(dic){
		this.currentTag = 0;
		var uid;
		if (typeof dic === "string") {
			uid = dic
		} else {
			uid = dic.uid;
		}
		this.changeLayer(new SelHeroFarewellLayer(uid));
		this.titleBgVisible(true);
	},
	gotoCulture:function(dic){
		this.currentTag = 0;
		var uid = dic.uid;
		var noti = dic.noti;
		this.changeLayer(new CultureLayer(uid, noti));
		this.titleBgVisible(true);
	},

	gotoOnForm:function(dic){
		this.currentTag = 0;
		var page = dic.page;
		var type = dic.type;
		this.changeLayer(new OnFormLayer(page, type));
		this.titleBgVisible(true);

	},
	gotoSkills:function(dic) {
		this.currentTag = 0;
		this.changeLayer(new SkillLayer());
		this.titleBgVisible(true);
	},
	gotoSkillBreak:function(dic) {
		this.currentTag = 0;
		var skill = dic.skill;
		var dogfood = dic.dogfood;
		var exit = dic.exit;
		this.currentTag = 0;
		this.changeLayer(new SkillBreak(skill, dogfood, exit));
		this.titleBgVisible(true);
	},
	gotoSkillBreakSelect:function(dic) {
		this.currentTag = 0;
		var skill = dic.skill;
		var dogfood = dic.dogfood;
		var exit = dic.exit;
		this.changeLayer(new SkillBreakSelect(skill, dogfood, exit));
		this.titleBgVisible(true);
	},
	gotoSkillBreakResult:function(dic){
		this.currentTag = 0;
		var oriSkill = dic.oriSkill;
		var type = dic.type;
		var exit = dic.exit;
		this.changeLayer(new SkillBreakResult(oriSkill, type, exit));
		this.titleBgVisible(true);
	},
	gotoPackage:function(dic){
		this.currentTag = 0;
		var type = dic.type;
		this.changeLayer(new PackageLayer(type));
		this.titleBgVisible(true);
	},
	gotoEquips:function(dic){
		dic = dic || {};
		this.currentTag = 0;
		var type = dic.type;
		this.changeLayer(new EquipsLayer(type));
		this.titleBgVisible(true);
	},
	gotoEquipSell:function(dic){
		dic = dic || {};
		this.currentTag = 0;
		var type = dic.type;
		this.changeLayer(new EquipSellLayer(type));
		this.titleBgVisible(true);
	},
	gotoEquipUpdate:function(dic){
		this.currentTag = 0;
		var eid = dic.eid;
		var type = dic.type;
		var exit = dic.exit;
		this.changeLayer(new EquipUpdateLayer(eid, type, exit));
		this.titleBgVisible(true);
	},
	gotoBattle:function(dic){
		cc.director.runScene(new FightScene(dic));
	},
	gotoStage:function(dic){
		if (this.currentTag == this.bottomTag.sail) {
			return;
		}
		this.currentTag = this.bottomTag.sail;
		dic = dic || {};
		var stageId = dic.stageId;
		var mode = dic.mode;
		this.changeLayer(new StageLayer(stageId, mode));
		this.titleBgVisible(false);
	},
	gotoAtlas:function(dic) {
		dic = dic || {};
		this.currentTag = 0;
		var type = dic.type;
		this.changeLayer(new HandBookLayer(type));
		this.titleBgVisible(true);
	},
	gotoNews:function(dic) {
		dic = dic || {};
		this.currentTag = 0;
		var type = dic.type;
		this.changeLayer(new NewsLayer(type));
		this.titleBgVisible(true);
	},
	gotoChat:function(dic) {
		dic = dic || {};
		this.currentTag = 0;
		var type = dic.type;
		this.changeLayer(new ChatLayer(type));
		this.titleBgVisible(true);
	},
	gotoSystem:function(dic) {
		dic = dic || {};
		this.currentTag = 0;
		this.changeLayer(new SystemLayer());
		this.titleBgVisible(true);
	},
	gotoSkillChange:function(dic){
		this.currentTag = 0;
		var hid = dic.hid;
		var pos = dic.pos;
		var sid = dic.sid;
		var exit = dic.exit;
		this.changeLayer(new SkillChangeSelect(hid, pos, sid, exit));
		this.titleBgVisible(true);
	},
	gotoShadowChange:function(dic){
		this.currentTag = 0;
		var hid = dic.hid;
		var pos = dic.pos;
		var sid = dic.sid;
		var exit = dic.exit;
		this.changeLayer(new ShadowChangeSelect(hid, pos, sid, exit));
		this.titleBgVisible(true);
	},
	gotoEquipChange:function(dic){
		this.currentTag = 0;
		var hid = dic.hid;
		var pos = dic.pos;
		var eid = dic.eid;
		var exit = dic.exit;
		this.changeLayer(new EquipChangeSelect(hid, pos, eid, exit));
		this.titleBgVisible(true);
	},
	gotoFriend:function(dic) {
		dic = dic || {};
		this.currentTag = 0;
		var type = dic.type;
		this.changeLayer(new FriendsLayer(type));
		this.titleBgVisible(true);
	},
	gotoChapterRob:function(dic){
		this.currentTag = 0;
		var bookId = dic.bookId;
		var chapterId = dic.chapterId;
		var exit = dic.exit;
		this.changeLayer(new chapterRobLayer(bookId, chapterId, exit));
		this.titleBgVisible(true);
	},
	gotoUnion:function(dic){
		common.showTipText(common.LocalizedString("close_func"));
		return;
		
		if (this.currentTag === this.bottomTag.union){
			return;
		}
		dic = dic || {};
		var type = dic.type;
		UnionModule.doGetMainInfo(function(dic){
			traceTable("union get main info succ", dic);
			this.currentTag = this.bottomTag.union;
			this.changeLayer(new UnionLayer(type));
			this.titleBgVisible(false);
		}.bind(this), function(dic){
			traceTable("union get main info fail", dic);
		}.bind(this))
	},
	gotoQuest:function(dic){
		this.currentTag = 0;
		var type = dic.type;
		this.changeLayer(new QuestLayer(type));
		this.titleBgVisible(true);
	},
	gotoAddFriend:function(){
		this.currentTag = 0;
		this.changeLayer(new AddFriendLayer());
		this.titleBgVisible(true);
	},
	gotoShop:function(){
		var layer = new RechargeLayer();
		cc.director.getRunningScene().addChild(layer);
	},
	changeLayer:function(layer){
		this["contentLayer"].removeAllChildren(true);
		this["contentLayer"].addChild(layer);
		if (this.currentTag === 1) {
			this.homeBtn.setNormalImage(new cc.Sprite("#btn_btm_0_1.png"));
		} else {
			this.homeBtn.setNormalImage(new cc.Sprite("#btn_btm_0_0.png"));
		}
		this.addBottomBtn();
	},
	titleMenuClick:function(){
		var layer = new CaptainInfoLayer();
		cc.director.getRunningScene().addChild(layer);
	},
	titleVipMenuClick:function(){
		var layer = new VipDetailLayer();
		cc.director.getRunningScene().addChild(layer);
	},
	gotoHelp:function(dic){
		this.currentTag = 0;
		this.changeLayer(new HelpView());
		this.titleBgVisible(true);
	},
	gotoCusservice:function(dic) {
		this.currentTag = 0;
		this.changeLayer(new CusserviceLayer());
		this.titleBgVisible(true);
	},
});
cc.BuilderReader.registerController("MainSceneOwner", {
	"onHomeClick":function(){
		postNotifcation(NOTI.GOTO_HOME);
	}
});