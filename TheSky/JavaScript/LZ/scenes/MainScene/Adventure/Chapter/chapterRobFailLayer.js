var chapterRobFailLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("ChapterRobFailViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.ChapterRobFailView_ccbi, this);
		if (this.node != null) {
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