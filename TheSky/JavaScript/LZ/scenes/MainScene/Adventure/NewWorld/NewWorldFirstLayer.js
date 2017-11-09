var NewWorldFirstLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("NewWorldFirstViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.NewWorldFirstView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		var datas = blooddata.datas;
		this.alreadyLabel.setString(datas.count);
		this.leftLabel.setString(3 - datas.count);
		this.islandLabel.setString(datas.best.bestOutpostNum);
		this.starLabel.setString(datas.best.bestRecord);
		if (!datas.todayRank || datas.todayRank == "") {
			this.rankLabel.setString(common.LocalizedString("20开外"));
		} else {
			this.rankLabel.setString(datas.todayRank);
		}
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	beginCallback:function(){
		trace("beginCallback")
		postNotifcation(NOTI.BLOOD_REFRESH_STATE);
	},
	errorCallback:function(){
		BloodModule.doOnBloodRankInfo(this.beginCallback)
	},
	adventureItemClick:function(){
		traceTable("------", blooddata.datas);
		if (blooddata.datas.count >= 3) {
			common.showTipText(common.LocalizedString("blood_count_limit"))
			return;
		}
		BloodModule.doOnBeginBlood(this.beginCallback.bind(this), this.errorCallback.bind(this));
	},
	rankItemClick:function(){
		cc.director.getRunningScene().addChild(new NewWorldRankLayer());
	},
	infoClick:function(){
		cc.director.getRunningScene().addChild(new NewWorldHelpLayer());
	}
});