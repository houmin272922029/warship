var NewWorldFourthLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("NewWorldFourthViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.NewWorldFourthView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.refresh();
	},
	refresh:function(){
		var bloodDatas = blooddata.datas;
		this.stageLabel.setString(common.LocalizedString("%d~%d关得星数：", [bloodDatas.outpostNum - 4, bloodDatas.outpostNum]));
		this.starLabel.setString(bloodDatas.thisRecord);
		this.noRewardTitle.setString(common.LocalizedString("未超出今天最佳成绩%d颗星，无奖励获得",bloodDatas.historyRecord));
		this.perstar.setString(bloodDatas.awardConfig.perstar);
		if (bloodDatas.thisRecord > bloodDatas.historyRecord) {
			this.rewardTitle1.visible = true;
			this.rewardTitle2.visible = true;
			var award = BloodModule.getBloodAward();
			var i = 1;
			for ( var k in award) {
				for ( var kk in award[k]) {
					var cfg = common.getResource(kk);
					if (common.havePrefix(kk, "shadow")) {
						var cache = cc.spriteFrameCache;
						cache.addSpriteFrames(common.formatLResPath("ccbResources/shadow.plist"));
						this["rewardIcon" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("#s_frame.png"));
						var shadowContent = this["shadowContent" + i];
						if (cfg.icon) {
							olAni.playFrameAnimation("yingzi_" + cfg.icon + "_", shadowContent,
									cc.p(shadowContent.getContentSize().width / 2, shadowContent.getContentSize().height / 2), 1, 4,
									common.getColorByRank(cfg.rank));
						}
					} else if (common.havePrefix(kk, "_shard")) {
						this["rewardIcon" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + cfg.rank + ".png"));
						if (cfg.icon) {
							this["reward" + i].setTexture(cfg.icon);
							this["reward" + i].visible = true;
						}
						this["rewardIcon" + i].visible =true;
						this["chipIcon" + i].visible = true;
					} else {
						this["rewardIcon" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + cfg.rank + ".png"));
						if (cfg.icon) {
							this["reward" + i].setTexture(cfg.icon);
							this["reward" + i].visible = true;
						}
						this["rewardIcon" + i].visible = true;
					}
					this["rewardCountLabel" + i].visible = true;
					this["rewardCountLabel" + i].setString(award[k][kk]);
					i++;
				}
			}
		} else {
			this.noRewardTitle = visible = true;
		}
	},
	addAwardCallback:function(dic){
		traceTable("NewWorldFourthLayer--ceshi---", dic);
		postNotifcation(NOTI.BLOOD_REFRESH_STATE, {flag : dic.info.flag});
	},
	getRewardItemClick:function(){
		BloodModule.doOnAddAward(this.addAwardCallback.bind(this));
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});