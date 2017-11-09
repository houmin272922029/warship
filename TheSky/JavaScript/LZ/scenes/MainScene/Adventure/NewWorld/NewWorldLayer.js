var NewWorldLayer = cc.Layer.extend({
	ctor:function(state){
		this._super();
		cc.BuilderReader.registerController("NewWorldFirstViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.NewWorldFirstView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		var size = this.node.getContentSize();
		this.setContentSize(size);
		this.state = state || blooddata.datas.flag;
		AdventureModule.adventurePage = 0;
		this.changeState();
	},
	changeState:function(dic){

		traceTable("----", dic);
		if (dic && dic.info) {
			this.state = dic.info.flag;
		} else if (dic && dic.flag) {
			this.state = dic.flag;
		}
		
		if (!this.state) {
			this.state = blooddata.datas.flag;
		}
		//{"home":1,"dayBuff":2,"fight":3,"tempBuff":4,"reward":5,"lose":6}
		if (this.state == blooddata.blooddataFlag.home || this.state == blooddata.blooddataFlag.lose) {
			this.addChild(new NewWorldFirstLayer());
		} else if (this.state == blooddata.blooddataFlag.dayBuff) {
			this.addChild(new NewWorldSecondLayer());
		} else if (this.state == blooddata.blooddataFlag.fight) {
			this.addChild(new NewWorldThirdLayer());
		} else if (this.state == blooddata.blooddataFlag.reward) {
			this.addChild(new NewWorldFourthLayer());
		} else if (this.state == blooddata.blooddataFlag.tempBuff) {
			this.addChild(new NewWorldFifthLayer());
		}
	},
	refresh:function(){
		BloodModule.doOnGetBloodInfo(this.changeState.bind(this));
	},
	onEnter:function(){
		this._super();
		BloodModule.doOnGetBloodInfo(this.changeState.bind(this));
		addObserver("blood", "refresh", this);
		addObserver(NOTI.BLOOD_REFRESH_STATE, "changeState", this);
	},
	onExit:function(){
		this._super();
		removeObserver("blood", "refresh", this);
		removeObserver(NOTI.BLOOD_REFRESH_STATE, "changeState", this);
	},
});