var QuestPopup = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("QuestPopupOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.QuestPopup_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.data = QuestModule.pushComplete().date;
		this.key = QuestModule.pushComplete().key;
		this.refresh();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	refresh:function(){
		
	},
});