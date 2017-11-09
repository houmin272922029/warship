var MainPageHeroBgView = cc.Node.extend({
	ctor:function(rank){
		this._super();
		this.node = cc.BuilderReader.load(ccbi_res["MainPageHeroBgView" + rank + "_ccbi"], this);
		if(this.node != null) {
			this.addChild(this.node);
		}
	}
});