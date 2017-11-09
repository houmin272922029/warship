var bossLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("BossViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.BossView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		var size = this.node.getContentSize();
		this.setContentSize(size);
		//this.refresh();
	},
	refresh:function(){
		var bossData = bossdata.boss;
		var bossCfg = BossModule.getBossAttrConfig(bossData.key);
		var boss = HeroModule.getHeroBust1ById(bossCfg.npc[1].ID);
		if (boss) {
			this.bossBust.visible = true;
			this.bossBust.setTexture(boss);
			olAni.addPartical({plist : "images/eff_bossBust.plist", node : this.bossBust,
				pos : cc.p(this.bossBust.getContentSize().width / 2, this.bossBust.getContentSize().height / 2),
				 z : -1, tag : 100, scaleX : 1 / retina, scaleY: 1 / retina});
		}
		this.bossDesp.visible = true;
		this.bossDesp.setString(bossCfg.desp);
		var last = "";
		if (bossData) {
			last = common.LocalizedString("boss_last_challengeTime", DateUtil.second2hms(bossData.endTime - bossData.beginTime))
			var ranks = "";
			var rankArray = BossModule.getLastRank();
			for (var i = 1; i < 4; i++) {
				var dic = rankArray[i - 1];
				if (dic) {
					ranks = ranks + dic.name;
					if (i < Math.min(3, rankArray.length)) {
						ranks = ranks + ",";
					}
				}
			}
			last = last + "\r\n" + (common.LocalizedString("boss_last_rank", ranks));
			var defeat = "";
			if (bossData.finalKeller) {
				defeat = bossData.finalKiller.name;
			}
			last = last + "\r\n" + (common.LocalizedString("boss_last_defeat", defeat));
		}
		this.challengeInfo.visible = true;
		this.challengeInfo.setString(last);
		this.updateAutoIcon();
	},
	updateAutoIcon:function(){
		
	},
	updateTimer:function(){
		if (!bossdata.boss) {
			this.openTime.visible = false;
			return;
		} else {
			this.openTime.visible = true;
			var cd = Math.max(0, bossdata.boss.beginTime - Global.serverTime)
			if (cd > 0) {
				this.openTime.setString(common.LocalizedString("boss_openTime",DateUtil.second2hms(cd)));
			} else {
				this.openTime.setString(common.LocalizedString("boss_open"));
			}
		}
	},
	cardConfirmAction:function(){
		if (PlayerModule.getGold() >= BossModule.getBossChallengeConfig("3").YXFZcost) {
			cc.director.getRunningScene().addChild(new bossChallengeLayer());
		} else {
			common.showTipText(common.LocalizedString("ERR_1101"));
			//TODO 进入商店
		}
	},
	onEnterClick:function(){
		var cd = Math.max(0, bossdata.boss.beginTime - Global.serverTime)
		if (cd > 0) {
			common.showTipText(common.LocalizedString("boss_close"));
			var rankArray = BossModule.getRank();
			if (rankArray.length > 0) {
				cc.director.getRunningScene().addChild(new bossRankLayer());
			}
		} else {
			if (getUDBool(UDefKey.Setting_BossAuto) == "bossAuto") {
				var text = common.LocalizedString("boss_auto_tips");
				var cb = new ConfirmBox({info:text, confirm:function(){
					this.cardConfirmAction();
				}.bind(this)});
				cc.director.getRunningScene().addChild(cb);
			} else {
				cc.director.getRunningScene().addChild(new bossChallengeLayer());
			}
		}
	},
	onAutoClick:function(){
		this.checkIcon.visible = this.checkIcon.visible ? false : true;
		if (this.checkIcon.visible) {
			setUDBool(UDefKey.Setting_BossAuto, "bossAuto");
		} else {
			setUDBool(UDefKey.Setting_BossAuto, "");
		}
	},
	getBossInfoCallback:function(){
		bossdata.hasCheckedFirst = BossModule.isBossFight() == 1;
		bossdata.hasCheckedSecond = BossModule.isBossFight() == 2;
		this.refresh();
	},
	getBossInfo:function(){
		BossModule.doOnBossGetBossInfo(this.getBossInfoCallback.bind(this))
	},
	enterRefresh:function(){
		BossModule.doOnBossGetBossInfo(this.refresh.bind(this));
	},
	onEnter:function(){
		this._super();
		addObserver("boss", "enterRefresh", this);
		addObserver(NOTI.BOSS_TIME_REFRESH, "updateTimer", this);
		addObserver(NOTI.BOSS_CLOSE_CHALLENGE, "getBossInfo", this);//杀死boss 或者 活动时间已到 刷新到第一个页面来 也用于刷新页面
	},
	onExit:function(){
		this._super();
		removeObserver("boss", "enterRefresh", this);
		removeObserver(NOTI.BOSS_TIME_REFRESH, "updateTimer", this);
		removeObserver(NOTI.BOSS_CLOSE_CHALLENGE, "getBossInfo", this);
	},
});