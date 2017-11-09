var NewWorldHelpLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("NewWorldFirstViewHelpOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.NewWorldFirstViewHelp_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		//this.registerScriptTouchHandler(this.onTouch());
		//this.menu.setSwallowTouches(false);
	},
	onTouchBegan:function(x, y){
		var touchLocation = this.convertToNodeSpace(cc.p(x, y));
		var infoBg = this.infoBg;
		var rect = infoBg.bondingBox();
		if (!rect.containsPoint(touchLocation)) {
			this.removeFromParent(true);
			return true;
		}
		return true;
	},
	onTouch:function(eventType, x, y){
		if (eventType == "began") {
			return this.onTouchBegan(x, y);
		} else {}
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});