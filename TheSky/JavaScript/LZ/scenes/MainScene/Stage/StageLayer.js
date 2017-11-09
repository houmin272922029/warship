var StageLayer = cc.Layer.extend({
	STAGE_MODE:{
		normal:0,
		elite:1,
	},
	MULTI_FIGHT_ITEM:"item_025",
	ctor:function(stageId, mode){
		this._super();
		this.mode = mode || this.STAGE_MODE.normal;
		if (!stageId) {
			if (this.mode === this.STAGE_MODE.normal) {
				this.stageId = StageModule.getCurrentStage();
			} else {
				
			}
		} else {
			this.stageId = stageId;
		}

		cc.BuilderReader.registerController("StageOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.StageLayer_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.lvTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.stTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.goldTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.berryTitle.enableStroke(cc.color(32, 18, 9), 2);
		this.lvLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.stLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.stLabel.setLocalZOrder(1);
		this.goldLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.berryLabel.enableStroke(cc.color(32, 18, 9), 2);
		this.stageName.enableStroke(cc.color(73, 53, 5), 2);
		this.stProgressBg.visible = false;
		if (!this.stProgress) {
			this.stProgress = new cc.ProgressTimer(new cc.Sprite("#pro_green.png"));
			this.stProgress.type = cc.ProgressTimer.TYPE_BAR;
			this.stProgress.midPoint = cc.p(0, 0);
			this.stProgress.barChangeRate = cc.p(1, 0);
			this.stProgressBg.getParent().addChild(this.stProgress);
			this.stProgress.setPosition(cc.p(this.stProgressBg.x, this.stProgressBg.y));
		}
		this.infoLayer.x = cc.winSize.width / 2;
		this.infoLayer.y = 106 * retina;
		
		var sl = new cc.Sprite("#scroll_v_line.png");
		var height = cc.winSize.height - (30 + 58 + 80 + 106 + 308) * retina;
		sl.attr({
			x:0,
			y:(cc.winSize.height - (168 - 308 - 106) * retina) / 2,
			anchorX:0.27,
			anchorY:0.5,
			scale:height / 550
		});
		this.addChild(sl, 3);
		var la = new cc.Sprite("#map_tip_arrow.png");
		la.attr({
			x:sl.getContentSize().width / 2,
			y:sl.getContentSize().height / 2,
			anchorX:0.5,
			anchorY:0.5,
			scale:-1,
		});
		sl.addChild(la, 3);
		var rl = new cc.Sprite("#scroll_v_line.png");
		rl.attr({
			x:cc.winSize.width,
			y:(cc.winSize.height - (168 - 308 - 106) * retina) / 2,
			anchorX:0.8,
			anchorY:0.5,
			scale:height / 550
		});
		this.addChild(rl, 3);
		var ra = new cc.Sprite("#map_tip_arrow.png");
		ra.attr({
			x:rl.getContentSize().width / 2,
			y:rl.getContentSize().height / 2,
			anchorX:0.5,
			anchorY:0.5,
		});
		rl.addChild(ra, 3);
		var tl = new cc.Sprite("#scroll_h_line.png");
		tl.attr({
			x:cc.winSize.width / 2,
			y:cc.winSize.height - (30 + 58 + 80 + tl.getContentSize().height / 3) * retina,
			anchorX:0.5,
			anchorY:0,
			scale:-cc.winSize.width / 640
		});
		this.addChild(tl, 2);
		var bl = new cc.Sprite("#scroll_h_line.png");
		bl.attr({
			x:cc.winSize.width / 2,
			y:(106 + 308 + bl.getContentSize().height / 3) * retina,
			anchorX:0.5,
			anchorY:0,
			scale:cc.winSize.width / 640
		});
		this.addChild(bl, 2);
	},
	onEnter:function(){
		this._super();
		var array = this.stageId.split("_");
		this.chapterIdx = parseInt(array[1]);
		this.stageIdx = parseInt(array[2]);
		this.refresh();
		addObserver(NOTI.STAGE_REFRESH, "refresh", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.STAGE_REFRESH, "refresh", this);
	},
	refreshData:function(){
		this.lvLabel.setString(PlayerModule.getLevel());
		this.stLabel.setString(PlayerModule.getStrength() + "/" + PlayerModule.getStrengthMax());
		this.stProgress.percentage = Math.min(PlayerModule.getStrength() / PlayerModule.getStrengthMax() * 100, 100);
		this.goldLabel.setString(PlayerModule.getGold());
		this.berryLabel.setString(PlayerModule.getBerry());
		this.multiCount.setString(ItemModule.getItemCount(this.MULTI_FIGHT_ITEM));
	},
	refresh:function(){
		this.refreshData();
		if (this.mode === this.STAGE_MODE.normal) {
			this.chapters = StageModule.getChapters();
		} else {
			
		}
		this.refreshChapters();
	},
	refreshStageButton:function(move){
		var map = this.mw;
		map.removeAllChildren();
		var current = 0;
		this.right = 0;
		for (var i = 0; i < this.stages.length; i++) {
			var stage = this.stages[i];
			var id = stage.id;
			var cfg = stage.cfg;
			var pos = cfg.coordinate || {x:100, y:100};
			if (id === this.stageId) {
				current = pos.x;
			}
			this.right = pos.x;
			var button;
			if (stage.open) {
				var record = stage.record || {};
				var star = record.star || 0;
				var image = "flag_";
				if ((Number(i) + 1) === this.stageIdx) {
					image = image + "selected.png";
				} else {
					image = image + cfg.type + ".png";
				}
				button = new ccui.Button(image, image, image, ccui.Widget.PLIST_TEXTURE);
				for (var j = 0; j < 3; j++) {
					var sp = new cc.Sprite("#flag_star_0.png");
					sp.attr({
						x:button.getContentSize().width / 2 + (j - 1) * sp.getContentSize().width * 1.1,
						y:Math.abs(j - 1) * 4 + sp.getContentSize().height * 0.55,
						anchorX:0.5,
						anchorY:0.5
					});
					if (star > j) {
						var rsp = new cc.Sprite("#flag_star_1.png");
						rsp.attr({
							x:sp.getContentSize().width / 2,
							y:sp.getContentSize().height / 2
						});
						sp.addChild(rsp);
					}
					button.addChild(sp);
				}
			} else {
				var image = "flag_lock.png";
				button = new ccui.Button(image, image, image, ccui.Widget.PLIST_TEXTURE);
			}
			button.setTouchEnabled(true);
			button.setSwallowTouches(false);
			var self = this;
			button.addTouchEventListener(this.stageClick, this);
			button.setPosition(pos.x, pos.y);
			button.setAnchorPoint(0.5, 0);
			map.addChild(button, 0, Number(i) + 1);
			if (cfg.type === 2) {
				var boss = new cc.Sprite("#boss.png");
				boss.attr({
					x:pos.x,
					y:pos.y + 32,
					anchorX:0.5,
					anchorY:0,
				});
				map.addChild(boss);
			}
		}
		var height = cc.winSize.height - (30 + 58 + 80 + 106 + 308) * retina;
		var s = height / 568;
		current *= -s;
		this.right *= -s;
		this.right += cc.winSize.width / 2;
		current += cc.winSize.width / 2;
		if (move) {
			this.mapMove(current);
		}
	},
	stageClick:function(sender, type){
		if (type === ccui.Widget.TOUCH_ENDED) {
			var idx = sender.getTag();
			if (idx === this.stageIdx) {
				this.fightItemClick();
				return;
			}
			if (this.mode === this.STAGE_MODE.normal) {
				var stageId = "stage_" + common.fix(this.chapterIdx, 2) + "_" + common.fix(idx, 2);
				if (!StageModule.bStageOpen(stageId)) {
					return;
				}
				this.stageIdx = idx;
			} else {

			}
			this.refreshStage();
			this.refreshStageButton(false);
		} else if (type === ccui.Widget.TOUCH_MOVED) {
			sender.setHighlighted(false);
		}
	},
	mapMove:function(delta){
		var height = cc.winSize.height - (30 + 58 + 80 + 106 + 308) * retina;
		var self = this;
		var s = height / 568;
		var mm1 = 3000 * s - cc.winSize.width;
		var mm2 = 2500 * s - cc.winSize.width;
		var mm3 = 2000 * s - cc.winSize.width;
		if (self.map2.x + delta > 0) {
			delta = 0 - self.map2.x;
		}
		if (self.map2.x + delta < -mm2) {
			delta = -mm2 - self.map2.x;
		}
		if (self.map2.x + delta < self.right) {
			delta = self.right - self.map2.x;
		}
		self.map2.x += delta;
		self.mw.x += delta;
		self.map1.x += delta * (mm1 / mm2);
		self.map3.x += delta * (mm3 / mm2);
	},
	refreshMap:function(){
		var height = cc.winSize.height - (30 + 58 + 80 + 106 + 308) * retina;
		
		if (this.mode === this.STAGE_MODE.normal) {
			var chapter = "stage_" + common.fix(this.chapterIdx, 2);
			this.stages = StageModule.getStages(chapter);
			this.chapterInfo = StageModule.getChapterInfo(chapter);
		} else {
			
		}
		
		var bg;
		var way;
		if (this.chapterInfo) {
			bg = this.chapterInfo.pageBg || "map_001";
			way = this.chapterInfo.paged || "way_001001";
		} else {
			bg = "map_001";
			way = "way_001001";
		}
		
		if (this.map1) {
			this.map1.removeFromParent(true);
			this.map1 = null;
		}
		if (this.map2) {
			this.map2.removeFromParent(true);
			this.map2 = null;
		}
		if (this.map3) {
			this.map3.removeFromParent(true);
			this.map3 = null;
		}
		if (this.mw) {
			this.mw.removeFromParent(true);
			this.mw = null;
		}

		this.map3 = new ccui.ImageView("stage/" + bg + "_3.png");
		this.map3.attr({
			x:0,
			y:(cc.winSize.height - (168 - 308 - 106) * retina) / 2,
			anchorX:0,
			anchorY:0.5,
			scale:height / 568
		})
		this.addChild(this.map3);
		
		this.map2 = new ccui.ImageView("stage/" + bg + "_2.png");
		this.map2.attr({
			x:0,
			y:(cc.winSize.height - (168 - 308 - 106) * retina) / 2,
			anchorX:0,
			anchorY:0.5,
			scale:height / 568
		})
		this.addChild(this.map2);
		this.mw = new ccui.ImageView("stage/" + way + ".png");
		this.mw.attr({
			x:0,
			y:(cc.winSize.height - (168 - 308 - 106) * retina) / 2,
			anchorX:0,
			anchorY:0.5,
			scale:height / 568
		})
		this.addChild(this.mw);

		this.map1 = new ccui.ImageView("stage/" + bg + "_1.png");
		this.map1.attr({
			x:0,
			y:(cc.winSize.height - (168 - 308 - 106) * retina) / 2,
			anchorX:0,
			anchorY:0.5,
			scale:height / 568
		})
		this.addChild(this.map1);
		
		this.refreshStageButton(true);

		var self = this;
		
		var bTouched = false;
		cc.eventManager.addListener(cc.EventListener.create({
			event: cc.EventListener.TOUCH_ONE_BY_ONE,
			onTouchBegan:function(touch, event){
				var target = event.getCurrentTarget();
				var pos = touch.getLocation();
				var locationInNode = target.convertToNodeSpace(pos);
				var s = target.getContentSize();
				var rect = cc.rect(0, 0, s.width, s.height);
				
				if (cc.rectContainsPoint(rect, locationInNode)) {
					bTouched = true;
				}
				target.startX = pos.x; 
				return true;
			},
			onTouchMoved:function(touch, event) {
				var target = event.getCurrentTarget();
				var delta = touch.getDelta();
				if (bTouched) {
					self.mapMove(delta.x);
				}
			},
			onTouchEnded:function(touch, event){
				var target = event.getCurrentTarget();
				var pos = touch.getLocation();
				bTouched = false;
			}
		}), this.map2);
		
	},
	refreshChapters:function(){
		var offset = 0;
		if (this.clv) {
			offset = this.clv.getInnerContainer().x;
			this.clv.removeFromParent(true);
			this.clv = null;
		}
		var size = cc.size(cc.winSize.width, 80 * retina);
		this.clv = new ccui.ListView();
		this.clv.setDirection(ccui.ScrollView.DIR_HORIZONTAL);
		this.clv.setTouchEnabled(true);
		this.clv.setBounceEnabled(true);
		this.clv.setContentSize(size);
		this.addChild(this.clv);
		this.clv.attr({
			anchorX:0,
			anchorY:1,
			x:0,
			y:cc.winSize.height - 88 * retina
		});

		for (var i = 0; i < this.chapters.length; i++) {
			var c = this.chapters[i];
			var image;
			var t_color;
			if (i === this.chapterIdx - 1) {
				image = "btn_stage_1.png";
				t_color = cc.color(255, 255, 220);
			} else if (c.open) {
				image = "btn_stage_2.png";
				t_color = cc.color(251, 241, 153);
			} else {
				image = "btn_stage_3.png";
				t_color = cc.color(120, 104, 69);
			}
			var button = new ccui.Button(image, image, image, ccui.Widget.PLIST_TEXTURE);
			var label = new cc.LabelTTF(c.name, FONT_NAME, 24);
			label.setColor(t_color);
			label.enableStroke(cc.color(32, 18, 9), 2);
			button.addChild(label);
			label.attr({
				x:button.getContentSize().width / 2,
				y:button.getContentSize().height / 2,
				anchorX:0.5,
				anchorY:0.5
			});
			button.setTouchEnabled(true);
			button.setSwallowTouches(false);
			button.addTouchEventListener(function(sender, type){
				if (type === ccui.Widget.TOUCH_ENDED) {
					var idx = sender.getTag();
					if (idx === this.chapterIdx) {
						return;
					} else {
						if (this.mode === this.STAGE_MODE.normal && idx > StageModule.getChapterOpenIdx()) {
							common.showTipText(common.LocalizedString("stage_lock"));
							return;
						} else {
							
						}
					}
					
					this.chapterIdx = idx;
					this.stageIdx = 1;
					this.refreshChapters();
				}
			}, this);
			var item = new ccui.Layout();
			item.setTouchEnabled(true);
			item.setContentSize(cc.size(190 * retina, 80 * retina));
			button.attr({
				x:item.getContentSize().width / 2,
				y:item.getContentSize().height / 2,
				anchorX:0.5,
				anchorY:0.5,
				scale:retina
			});
			item.addChild(button, 0, Number(i) + 1);
			this.clv.pushBackCustomItem(item);
		}
		this.clv.getInnerContainer().x = offset;
		this.refreshMap();
		this.refreshStage();
	},
	refreshStage:function(){
		this.stage = this.stages[this.stageIdx - 1];
		this.stageId = this.stage.id;
		var cfg = this.stage.cfg;
		this.stageName.setString(cfg.stageName);
		var record = this.stage.record || {};
		var star = record.star || 0;
		var time = record.times || 0;
		for (var i = 1; i <= 3; i++) {
			this["stage_star_" + i].visible = star >= i;
		}
		this.stage_desp.setString(cfg.desp);
		this.st_need.setString(cfg.pay + "/" + PlayerModule.getStrength());
		this.challengeCount.setString(time + "/" + StageModule.getStageChallengeMax(cfg.type));
		cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("olRes/ol_public_1.plist"));
		this.refreshEnemy();
		this.refreshReward();
		
		this.multiTenItem.visible = cfg.type !== 2;
		this.multiTenLabel.visible = cfg.type !== 2;
		
		this.multiItem.visible = star === 3;
		this.oneTimeLabel.visible = star === 3;
		this.multiTenItem.visible = star === 3;
		this.multiTenLabel.visible = star === 3;
	},
	refreshEnemy:function(){
		if (this.elv) {
			this.elv.removeFromParent(true);
			this.elv = null;
		}
		this.enemies = StageModule.getStageEnemy(this.stageId);
		if (getJsonLength(this.enemies) === 0) {
			return;
		}
		this.elv = new ccui.ListView();
		this.elv.setDirection(ccui.ScrollView.DIR_HORIZONTAL);
		this.elv.setTouchEnabled(true);
		this.elv.setBounceEnabled(true);
		this.elv.setContentSize(this.form_tv_layer.getContentSize());
		this.form_tv_layer.addChild(this.elv);
		this.elv.attr({
			anchorX:0,
			anchorY:0,
			x:0,
			y:0
		});
		for (var i = 0; i < this.enemies.length; i++) {
			var hero = this.enemies[i];
			var head = HeroModule.getHeroHeadById(hero.id);
			var rankBg = new cc.Sprite("#rank_head_bg_" + hero.rank + ".png");
			var frame = new cc.Sprite("#frame_" + hero.rank + ".png");
			var icon = new cc.Sprite("#" + head);
			rankBg.addChild(icon, 0);
			rankBg.addChild(frame, 1);
			icon.attr({
				x:rankBg.getContentSize().width / 2,
				y:rankBg.getContentSize().height / 2
			});
			frame.attr({
				x:rankBg.getContentSize().width / 2,
				y:rankBg.getContentSize().height / 2
			});
			var item = new ccui.Layout();
			item.setTouchEnabled(true);
			item.setContentSize(cc.size(100, 96));
			item.addChild(rankBg);
			rankBg.attr({
				x:100 / 2,
				y:96 / 2,
				anchorX:0.5,
				anchorY:0.5
			});
			this.elv.pushBackCustomItem(item);
		}
	},
	refreshReward:function(){
		if (this.rlv) {
			this.rlv.removeFromParent(true);
			this.rlv = null;
		}
		this.rewards = StageModule.getStageReward(this.stageId);
		if (getJsonLength(this.rewards) === 0) {
			return;
		}
		this.rlv = new ccui.ListView();
		this.rlv.setDirection(ccui.ScrollView.DIR_HORIZONTAL);
		this.rlv.setTouchEnabled(true);
		this.rlv.setBounceEnabled(true);
		this.rlv.setContentSize(this.reward_tv_layer.getContentSize());
		this.reward_tv_layer.addChild(this.rlv);
		this.rlv.attr({
			anchorX:0,
			anchorY:0,
			x:0,
			y:0
		});
		
		for (var i = 0; i < this.rewards.length; i++) {
			var reward = this.rewards[i];
			var res = common.getResource(reward);
			var frame = new cc.Sprite("#frame_" + res.rank + ".png");
			var icon;
			if (res.iconType === 0) {
				icon = new cc.Sprite(res.icon);
				icon.scale = 0.35;
			} else {
				icon = new cc.Sprite("#" + res.icon);
			}
			icon.attr({
				x:frame.getContentSize().width / 2,
				y:frame.getContentSize().height / 2
			});
			frame.addChild(icon, -2);
			if (res.bShard) {
				var psp = new cc.Sprite("#portion.png");
				icon.addChild(psp);
				psp.attr({
					x:icon.getContentSize().width,
					y:0,
					anchorX:1,
					anchorY:0,
				});
			}
			if (res.bChapter) {
				// 残页
			}
			var item = new ccui.Layout();
			item.setTouchEnabled(true);
			item.setContentSize(cc.size(100, 96));
			item.addChild(frame);
			frame.attr({
				x:100 / 2,
				y:96 / 2,
				anchorX:0.5,
				anchorY:0.5
			})
			this.rlv.pushBackCustomItem(item);
		}
	},
	fightItemClick:function() {
		if (time == StageModule.getStageChallengeMax(this.stage.cfg.type)) {
			common.ShowText("挑战次数不足");
		}
		if (this.mode === this.STAGE_MODE.normal) {
			var stage = this.stage;
			var record = stage.record || {};
			var time = record.times || 0;
			if (time >= StageModule.getStageChallengeMax(stage.cfg.type)) {
//				sail_clearFightCount
//				var text = null;
//				var cb = new ConfirmBox({info:text, confirm:function(){
//					doDrinkAction();
//				}.bind(this)});
//				cc.director.getRunningScene().addChild(cb);
				// TODO 清除次数
				common.showTipText(common.LocalizedString("arena_fightCount_need"));
				return;
			}
			if (StageModule.getCurrentStage() === stage.id) {
				this.nextId = null;
			} else {
				this.nextId = stage.id;
			}
			StageModule.doFight(stage.id, this.fightCallback.bind(this), function(dic){
				
			});
		}
	},
	fightCallback:function(dic){
		var stage = this.stage;
		var info = dic.info;
		var bg = stage.cfg.bg || 1;
		var music = stage.cfg.music;
		postNotifcation(NOTI.GOTO_FIGHT, {log:info.battleLog, bg:bg, music:music, left:PlayerModule.getName(), 
			extra:{from:"stage", type:this.mode, nextId:this.nextId, result:info.battleResult, gain:info.gain, pay:info.pay}});
	},
	multiFight:function(count){
		if (this.mode === this.STAGE_MODE.normal) {
			var stage = this.stage;
			var record = stage.record || {};
			var time = record.times || 0;
			if (time + count > StageModule.getStageChallengeMax(stage.cfg.type)) {
				// TODO 清除次数
				common.showTipText(common.LocalizedString("arena_fightCount_need"));
				return;
			}
			StageModule.doMultiFight(stage.id, count, this.multiFightCallback.bind(this));
		} else {
			
		}
	},
	multiItemClick:function(sender){
		if (PlayerModule.getVipLevel() >= 3) {
			var tag = sender.getTag();
			var count = ItemModule.getItemCount(this.MULTI_FIGHT_ITEM);
			if (count < tag) {
				var text = common.LocalizedString("sail_sweep_lackOfEvidence", [count, tag - count]);
				var cb = new ConfirmBox({info:text, confirm:function(){
					this.multiFight(tag);
				}.bind(this)});
				cc.director.getRunningScene().addChild(cb);
				return;
			}
			this.multiFight(tag);
		} else {
			common.ShowText(common.LocalizedString("not_vipLevel"));
		}
	},
	multiFightCallback:function(dic){
		var info = dic.info
		common.gain(info.gain);
		common.pay(info.pay);
		this.refresh();
		cc.director.getRunningScene().addChild(new MultiFightResult(info.stageResult, info.gain, info.pay));
	},
	switchItemClick:function() {
		common.showTipText(common.LocalizedString("close_func"));
	},
});