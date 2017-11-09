var FightResult = cc.Layer.extend({
	g_w:{
		"1":3,
		"2":3,
		"3":2,
		"4":2,
		"5":1,
		"6":1
	},
	ctor:function(extra, result, round, bVideo){
		this._super();
		this.extra = extra;
		this.result = result;
		this.round = round;
		this.bVideo = bVideo;
		var from = extra.from;
		var file;
		var cname;
		if (from === "blood") {
			if (result === "win") {
				cname = "NewWorldWinViewOwner";
				file = ccbi_res.NewWorldWin_ccbi;
			} else {
				cname = "NewWorldLoseViewOwner";
				file = ccbi_res.NewWorldLose_ccbi;
			}
		} else {
			if (result === "win") {
				cname = "SailWinViewOwner";
				file = ccbi_res.StageWin_ccbi;
			} else {
				cname = "SailLoseViewOwner";
				file = ccbi_res.StageLost_ccbi;
			}
		}
		cc.BuilderReader.registerController(cname, {
		});
		var node = cc.BuilderReader.load(file, this);
		if (node) {
			this.addChild(node);
		}
		common.swallowLayer(this, true);
	},
	refresh:function(){
		var from = this.extra.from;
		var result = this.result;
		var gain = this.extra.gain || {};
		var pay = this.extra.pay || {};
//		this.resultLabel.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(result + "_" + (4 - this.round) + ".png"));
		this.roundLabel.setString(this.round);
		if (from === "worldwar") {
		} else if (from === "racing") {
		} else if (from === "blood") {
			//TODO
			this.starLabel.visible = false;
			this.attrLabel.visible = false;
			this.rewardLabel.visible = false;
		} else {
			this.expLabel.setString(gain.expAll || 0);
			this.berryLabel.setString(gain.gold || 0);
		}
		if (result === "win") {
			if (this.extra.result) {
				SoundUtil.playMusic("audio/sail_win_" + this.extra.result + ".mp3", false);
			}else {
				SoundUtil.playMusic("audio/sail_win_3.mp3", false);
			}
			
			for (var i = 1; i <= this.extra.result; i++) {
				this["star" + i].visible = true;
			}
			
			if (from !== "blood") {
				var form = FormModule.getForm();
				for (var i = 0; i < getJsonLength(form); i++) {
					this["heroBg" + (i + 1)].visible = true;
					var id = form[i + ""];
					var hero = HeroModule.getHeroByUid(id);
					this["rank_bg_" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + hero.rank + ".png"));
					this["rank" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + hero.rank + "_icon.png"));
					this["frame" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + hero.rank + ".png"));
					this["head" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(hero.heroId)));
					this["heroExp" + (i + 1)].setString(gain.heroExpAll || 0);
					this["name" + (i + 1)].setString(hero.name);
					this["heroLevel" + (i + 1)].setString(hero.level);
					var pbg = this["progressBg" + (i + 1)];
					
					var p = new cc.ProgressTimer(new cc.Sprite("#pro_green.png"));
					p.type = cc.ProgressTimer.TYPE_BAR;
					p.midPoint = cc.p(0, 0);
					p.barChangeRate = cc.p(1, 0);
					pbg.getParent().addChild(p);
					p.setPosition(cc.p(pbg.x, pbg.y));

					var p1 = new cc.ProgressTimer(new cc.Sprite("#pro_blue.png"));
					p1.type = cc.ProgressTimer.TYPE_BAR;
					p1.midPoint = cc.p(0, 0);
					p1.barChangeRate = cc.p(1, 0);
					pbg.getParent().addChild(p1);
					p1.setPosition(cc.p(pbg.x, pbg.y));
					var progressTo;
					var heroExp = gain.heroExpAll || 0;
					if (hero.expNow < heroExp) {
						p1.percentage = 0;
						p.percentage = 0;
						progressTo = cc.progressFromTo(0.5, 0, hero.expNow / hero.expMax * 100);
						this["levelIcon" + (i + 1)].visible = true;
					} else {
						p1.percentage = (hero.expNow - heroExp) / hero.expMax * 100;
						p.percentage = (hero.expNow - heroExp) / hero.expMax * 100;
						progressTo = cc.progressFromTo(0.5, (hero.expNow - heroExp) / hero.expMax * 100, hero.expNow / hero.expMax * 100);
					}
					p.runAction(cc.sequence(
						cc.delayTime(1),
						progressTo
					));
				}
			}else {
				// TODO 新世界结算
			}
			
			// TODO 双倍奖励
			
		} else {
			SoundUtil.playMusic("audio/sail_lose.mp3", false);
			this.tipsLabel.setString(common.LocalizedString("deadGuide_tips_" + Math.floor((Math.random() * 4 + 1))));
			var gKey =[];
			while (gKey.length < 2) {
				var rand = common.prob(this.g_w);
				if (!common.bContainObject(gKey, rand)) {
					gKey.push(rand);
				}
			}
			for (var i = 0; i < gKey.length; i++) {
				this["gotoItem" + (i + 1)].setNormalImage(new cc.Sprite("#btn_goto_" + gKey[i] + "_0.png"));
				this["gotoItem" + (i + 1)].setSelectedImage(new cc.Sprite("#btn_goto_" + gKey[i] + "_1.png"));
				this["gotoItem" + (i + 1)].setTag(parseInt(gKey[i]));
				this["gotoLabel" + (i + 1)].setString(common.LocalizedString("deadGuide_goto_" + gKey[i]));
			}
		}
	},
	onEnter:function(){
		this._super();
		var from = this.extra.from;
		if (!this.bVideo && from !== "boss") {
			var gain = deepcopy(this.extra.gain || {});
			var pay = this.extra.pay;
			common.gain(gain);
			common.pay(pay);
			gain.gold = 0;
			common.popupGain(gain);
		}
		this.refresh();
	},
	onExit:function(){
		this._super();
		
	},
	videoItemClick:function(){
		postNotifcation(NOTI.FIGHT_VEDIO);
		this.stopAllActions();
		this.removeFromParent(true);
	},
	closeItemClick:function(){
		var from = this.extra.from;
		var params = {};
		if (from === "stage") {
			params.type = this.extra.type;
			params.nextId = this.extra.nextId;
		} else if (from === "arena") {
			
		} else if (from === "blood") {
			params.page = AdventureModule.getPage(from);
		} else  if (from === "frags") {
			if (getJsonLength(chapterdata.chapters) >= 8) {
				params.page = AdventureModule.getPage("chapters");
			} else {
				params.page = AdventureModule.getPage(this.extra.book);
			}
		}
		cc.director.runScene(new MainScene(from, params));
	},
	gotoItemClick:function(sender){
		var tag = sender.getTag();
		var from;
		var params = {};
		if (tag == 1) {
			from = "equips";
			params.type = 0;
		} else if (tag == 2) {
			from = "culture";
			params.type = "hero";
		} else if (tag == 3) {
			from = "skill";
		} else if (tag == 4) {
			common.showTipText(common.LocalizedString("close_func"));
			return;
		} else if (tag == 5) {
			from = "break";
			params.type = "soul";
		} else if (tag == 6) {
			from = "shadows";
			params.type = 0;
			common.showTipText(common.LocalizedString("close_func"));
			return;
		} else if (tag == 7) {
			from = "recruit";
			params.type = 0;
			common.showTipText(common.LocalizedString("close_func"));
			return;
		} else if (tag == 8) {
			from = "box";
			params.type = 1;
			common.showTipText(common.LocalizedString("close_func"));
			return;
		}
		if (tag != 4) { //TODO 有了奥义再去判断
			cc.director.runScene(new MainScene(from, params));
		}
	},
});