var StageTalkView = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("StageTalkOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.StageTalkView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});