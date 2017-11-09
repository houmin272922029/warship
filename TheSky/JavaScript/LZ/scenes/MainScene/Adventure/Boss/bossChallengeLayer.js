var bossChallengeLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("BossChallengeOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.BossChallengeView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.autoTime = 2;
		this.logs = [];
		this.progress;
		this.refresh();
		common.swallowLayer(this, true);
	},
	refresh:function(){
		var bossData = bossdata.boss;
		var bossDic = BossModule.getBossAttrConfig(bossData.key);
		var boss = HeroModule.getHeroBust1ById(bossDic.npc[1].ID);
		if (boss) {
			this.bossBust.visible = true;
			this.bossBust.setTexture(boss);
			olAni.addPartical({plist : "images/eff_bossBust.plist", node : this.bossBust,
				pos : cc.p(this.bossBust.getContentSize().width / 2, this.bossBust.getContentSize().height / 2),
				 z : -1, tag : 100, scaleX : 1 / retina, scaleY: 1 / retina});
		}
		if (this.progress) {
			this.progress.removeFromParent(true);
			this.progress = null;
		}
		this.progress = new cc.ProgressTimer(new cc.Sprite("images/boss_hp.png"));
		this.progress.type = cc.ProgressTimer.TYPE_BAR;
		this.progress.midPoint = cc.p(0, 0);
		this.progress.barChangeRate = cc.p(1, 0);
		this.hpLayer.addChild(this.progress, 0, 101);
		this.progress.setPosition(cc.p(this.progress.getContentSize().width / 2, this.progress.getContentSize().height / 2));
		this.progress.percentage = Math.min(bossData.hpNow / bossData.hp * 100, 100)
		this.updateTimer();
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	updateTimer:function(){
		var playerData = bossdata.boss.playerData;
		var resurrectCD = 0;
		if (playerData && playerData[PlayerModule.getPlayerId()]) {
			resurrectCD = Math.max(0, playerData[PlayerModule.getPlayerId()].lastTime + playerData[PlayerModule.getPlayerId()].cdTime - Global.serverTime);
		}
		if (getUDBool(UDefKey.Setting_BossAuto) == "bossAuto" && resurrectCD != 0) {
			this.resurrentLabel.visible = true;
			this.resurrentLabel.setString(common.LocalizedString("boss_resurrect",DateUtil.second2hms(resurrectCD)));
		} else {
			this.resurrentLabel.visible = false;
		}
		var endCD = Math.max(0, bossdata.boss.endTime - Global.serverTime);
		this.endLabel.setString(common.LocalizedString("boss_end", DateUtil.second2hms(endCD)));
		if (endCD == 0) {
			postNotifcation(NOTI.BOSS_CLOSE_CHALLENGE);
			this.removeFromParent();
		}
		if (getUDBool(UDefKey.Setting_BossAuto) == "bossAuto") {
			this.challengeItem.enabled = false;
			this.resurrectItem.setEnabled(false);
			this.buffItem.setEnabled(false);
			this.challengeIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("tiaozhanzhong_text.png"));
		} else {
			this.challengeItem.setEnabled(true);
			this.challengeIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("boss_tiaozhan_text.png"));
			if (resurrectCD > 0) {
				this.resurrectItem.setEnabled(false);
				this.buffItem.setEnabled(true);
			} else {
				this.resurrectItem.setEnabled(true);
				this.buffItem.setEnabled(false);
			}
		}
		this.readLog();
	},
	removeNode:function(node){
		node.removeFromParent(true);
	},
	readLog:function(){
		var log = BossModule.popLog();
		if (log) {
			this.logs.push(log);
			var f = cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(log.heroId));
			if (f) {
				var sp = new cc.Sprite(f)//cc.Sprite.createWithSpriteFrameName(f);
				this.infoBg.addChild(sp, 2);
				
				var x = this.infoBg.getContentSize().width / 2 * (1 + (Math.random() - 0.5) * 2);
				var y = this.infoBg.getContentSize().height / 2 * (1 + (Math.random() - 0.5) * 2);
				sp.setPosition(cc.p(x, y));
				var move = cc.MoveTo.create(0.2, cc.p(this.bossBust.x, this.bossBust.y + this.bossBust.getContentSize().height / 5));
				var fadeIn = cc.FadeTo.create(0.2, 255);
				var spawn = cc.Spawn.create(move, fadeIn);
				var array = [];
				array.push(spawn);
				array.push(cc.FadeTo.create(0.2, 0));
				array.push(cc.DelayTime.create(0.5));
				array.push(cc.CallFunc.create(this.removeNode(sp)));
				sp.runAction(cc.Sequence.create(array));
			}
			if (this.bossBust) {
				var oriPosX = this.bossBust.x;
				var oriPosY = this.bossBust.y;
				var array = [];
				array.push(cc.DelayTime.create(0.2));
				array.push(cc.MoveBy.create(0.05, cc.p(-12, 13)));
				array.push(cc.MoveBy.create(0.05, cc.p(14, -15)));
				array.push(cc.MoveBy.create(0.05, cc.p(13, -13)));
				array.push(cc.MoveBy.create(0.05, cc.p(-15, 0)));
				array.push(cc.MoveBy.create(0.05, cc.p(0, 15)));
				array.push(cc.MoveBy.create(0.05, cc.p(-12, -12)));
				array.push(cc.MoveBy.create(0.05, cc.p(13, -13)));
				array.push(cc.MoveBy.create(0.05, cc.p(-11, 13)));
				array.push(cc.MoveBy.create(0.05, cc.p(0, 11)));
				array.push(cc.MoveTo.create(0.05, cc.p(oriPosX, oriPosY)));
				this.bossBust.runAction(cc.Sequence.create(array));
			}
			if (log.damage && log.damage > 0) {
				var font = cc.LabelTTF.create("-"+log.damage,"images/fight_Red.fnt");
				font.setPosition(cc.p(this.bossBust.x, this.bossBust.y));
				this.infoBg.addChild(font, 2);
				font.setScale(2.5);
				var array = [];
				array.push(cc.DelayTime.create(0.2));
				array.push(cc.FadeTo.create(0.05, 255));
				array.push(cc.DelayTime.create(0.5));
				var move = cc.MoveBy.create(0.1, cc.p(0, 100));
				var fadeOut = cc.FadeTo.create(0.1, 0);
				var spawn = cc.Spawn.create(move, fadeOut);
				array.push(spawn);
				array.push(cc.DelayTime.create(0.5));
				array.push(cc.CallFunc.create(this.removeNode(font)));
				font.runAction(cc.Sequence.create(array));
			}
			if (this.logs.length > 4) {
				this.logs.pop();
			}
			for (var i = 0; i < this.logs.length; i++) {
				var logLabel = this["log" + (i+1)];
				logLabel.setString(common.LocalizedString("boss_log",this.logs[i].name,this.logs[i].damage));
				logLabel.visible = true;
			}
		}
	},
	autoFight:function(){
		if (getUDBool(UDefKey.Setting_BossAuto) == "bossAuto") {
			this.autoTime -= 1;
			if (this.autoTime == 0) {
				if (PlayerModule.getGold() < BossModule.getBossChallengeConfig("3").YXFZbuff) {
					common.showTipText(common.LocalizedString("ERR_1101"));
					this.autoTime = 2;
					setUDBool(UDefKey.Setting_BossAuto, "");
					return;
				}
				//TODO this.fight();
				BossModule.doOnBossBattle(3, this.challengeCallback.bind(this));
			}
		}
	},
	fight:function(){
		//TODO 加载BattleField数据
	},
	/**
	 * 立即复活
	 */
	resurrectItemClick:function(){
		BossModule.doOnBossBattle(2, this.challengeCallback.bind(this))
	},
	challengeCallback:function(){
		//this.logs = [{"damage":27161,"name":"201511191114","heroId":"hero_000402"}];
		//TODO 播放动画
	},
	/**
	 * 挑战
	 */
	challengeItemClick:function(){
		var resurrectCD = 0;
		var playerData = bossdata.boss.playerData;
		if (playerData && playerData[PlayerModule.getPlayerId()]) {
			resurrectCD = Math.max(0, playerData[PlayerModule.getPlayerId()].lastTime + playerData[PlayerModule.getPlayerId()].cdTime - Global.serverTime);
		}
		if (resurrectCD > 0) {
			common.showTipText(common.LocalizedString("boss_resurrect_tips"));
			return;
		}
		//TODO this.fight();
		BossModule.doOnBossBattle(1, this.challengeCallback.bind(this));
		this.refresh();
	},
	
	/**
	 * 浴血奋战
	 */
	buffItemClick:function(){
		olAni.addPartical({plist : "images/eff_bornOfFire.plist", node : this.buffItem,
			pos : cc.p(this.buffItem.getContentSize().width / 2, this.buffItem.getContentSize().height / 2),
			duration : 2, z : 100, tag : 100, scaleX : 1 / retina, scaleY: 1 / retina});
		var buff = BossModule.getBossChallengeConfig("3").YXFZbuff;
		//TODO this.fight(buff)
		BossModule.doOnBossBattle(3, this.challengeCallback.bind(this));
	},
	/**
	 * 自动挑战
	 */
	autoItemClick:function(){
		var text;
		if (getUDBool(UDefKey.Setting_BossAuto) == "bossAuto") {
			text = common.LocalizedString("boss_auto_tips_close");
		} else {
			text = common.LocalizedString("boss_auto_tips")
		}
		var cb = new ConfirmBox({info:text, confirm:function(){
			this.cardConfirmAction();
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	cardConfirmAction:function(){
		if (getUDBool(UDefKey.Setting_BossAuto) == "bossAuto") {
			this.autoTime = 2;
			setUDBool(UDefKey.Setting_BossAuto, "");
			postNotifcation(NOTI.BOSS_CLOSE_CHALLENGE);
		} else {
			if (PlayerModule.getGold() >= BossModule.getBossChallengeConfig("3").YXFZcost) {
				setUDBool(UDefKey.Setting_BossAuto, "bossAuto");
				postNotifcation(NOTI.BOSS_CLOSE_CHALLENGE);
			} else {
				common.showTipText(common.LocalizedString("ERR_1101"));
				//TODO前往商店
			}
		}
	},
	onEnter:function(){
		this._super();
		var cache = cc.spriteFrameCache;
		cache.addSpriteFrames(common.formatLResPath("olRes/hero_head.plist"));
		addObserver(NOTI.BOSS_RESURRECT, "updateTimer", this);
		addObserver(NOTI.BOSS_AUTO_FIGHT, "autoFight", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.BOSS_RESURRECT, "updateTimer", this);
		removeObserver(NOTI.BOSS_AUTO_FIGHT, "autoFight", this);
	},
});