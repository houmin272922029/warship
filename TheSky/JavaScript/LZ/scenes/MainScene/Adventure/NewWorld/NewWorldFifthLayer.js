var NewWorldFifthLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("NewWorldFifthViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.NewWorldFifthView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.refresh();
	},
	refresh:function(){
		var bloodDatas = blooddata.datas;
		for ( var k in bloodDatas.dayBuff) {
			this[k + "Label"].setString("+" + bloodDatas.dayBuff[k] + "%");
		}
		this.passIslandLabel.setString(bloodDatas.best.bestOutpostNum);
		this.totalStarLabel.setString(bloodDatas.best.bestRecord);
		this.passLabel.setString(common.LocalizedString("已征服 %d 个岛屿",bloodDatas.outpostNum));
		this.getStarLabel.setString(bloodDatas.recordAll);
		this.leftLabel.setString(bloodDatas.recordAll - bloodDatas.recordUsed);
		for (var i = 0; i < getJsonLength(bloodDatas.buff); i++) {
			for ( var k in bloodDatas.buff[i]) {
				if (bloodDatas.recordAll - bloodDatas.recordUsed < bloodDatas.buff[i][k]) {
					this["attrBtn" + (i + 1)].setEnabled(false);
					this["attrBtn" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(k + "_btn_2.png"));
				} else {
					this["attrBtn" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(k + "_btn_0.png"));
				}
				this["attrKeyLabel" + (i + 1)].setString(common.LocalizedString(k));
				this["attrBtn" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(k + "_btn_1.png"));
			}
		}
	},
	rankItemClick:function(){
		cc.director.getRunningScene().addChild(new NewWorldRankLayer());
	},
	attrItemClick:function(sender){
		var tag = sender.getTag();
		BloodModule.doOnAddBuff(tag, this.addBuffCallback);
	},
	addBuffCallback:function(){
		postNotifcation(NOTI.BLOOD_REFRESH_STATE);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});