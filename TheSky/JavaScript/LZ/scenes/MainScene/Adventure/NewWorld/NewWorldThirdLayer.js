var NewWorldThirdLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("NewWorldThirdViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.NewWorldThirdView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.refresh();
	},
	refresh:function(){
		var bloodDatas = blooddata.datas;
		traceTable("---bloodDatas---",bloodDatas)
		this.islandCountLabel.setString(bloodDatas.outpostNum);
		this.starGetLabel.setString(bloodDatas.recordAll);
		this.starLeftLabel.setString(bloodDatas.recordAll - bloodDatas.recordUsed);
		this.nextIslandLabel.setString(5 - (bloodDatas.outpostNum - 1) % 5);
		for (var i = 0; i < 3; i++) {
			var dic = bloodDatas.battleInfo[(i + 1) + ""];
			var npcCfg = BloodModule.getBloodConfig(dic.npcGroupID);
			var heroId = npcCfg.head;
			var cfg = HeroModule.getHeroConfig(heroId);
			this["frame" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_"+ cfg.rank + ".png"));
			this["head" + (i + 1)].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame( HeroModule.getHeroHeadById(heroId)));
			this[(i + 1) + "_left_label"].setString(dic.playerCount);
			this[(i + 1) + "_right_label"].setString(dic.npcCount);
			if (dic.award && getJsonLength(dic.award) > 0) {
				var award = this["award" + (i + 1)];
				for ( var k in dic.award) {
					var cfg = common.getResource(k)
					if (cfg.icon) {
						award.setTexture(cfg.icon);
						award.visible = true;
					}
				}
			}
		}
		for ( var k in bloodDatas.dayBuff) {
			this[k + "Label"].setString("+" + bloodDatas.dayBuff[k] + "%");
		}
		this.passIslandLabel.setString(bloodDatas.best.bestOutpostNum);
		this.totalStarLabel.setString(bloodDatas.best.bestRecord);
	},
	bloodBattleCallback:function(dic){
		traceTable("NewWorldThirdLayer--ceshi---", dic);
		postNotifcation(NOTI.BLOOD_REFRESH_STATE);
		var info = dic.info
		postNotifcation(NOTI.GOTO_FIGHT, {log:info.battleLog, bg:1, left:PlayerModule.getName(),
			extra:{from:"blood", result:{}}});
	},
	fightItemClick:function(sender){
		var tag = sender.getTag();
		var dic = blooddata.datas.battleInfo[tag + ""];
		
		BloodModule.doOnBloodBattle(blooddata.datas.outpostNum, tag, this.bloodBattleCallback.bind(this))
	},
	sweepOnceItemClick:function(sender){
		//TODO 先判断vip然后再刷新页面
		var tag = sender.getTag();
		BloodModule.doOnBloodBattle(blooddata.datas.outpostNum, tag, this.bloodBattleCallback.bind(this))
	},
	rankItemClick:function(){
		cc.director.getRunningScene().addChild(new NewWorldRankLayer());
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});