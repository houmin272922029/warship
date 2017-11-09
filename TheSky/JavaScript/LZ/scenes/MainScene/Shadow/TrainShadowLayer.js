var TrainShadowLayer = cc.Layer.extend({
	
	/**
	 * @param type 0炼影 1影纹 2影箱
	 */
	ctor:function(type){
		this._super();
		this.type = type || 0;
		this.initLayer();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("TrainShadowViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.TrainShadowView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.updataShadowLayer();
	},
	setSpriteFrame:function(sender, bool){
		if (bool) {
			sender.setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
			sender.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		} else {
			sender.setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
			sender.setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		}
	},
	updataShadowLayer:function(){
		this.TrainShadowContentLayer.removeAllChildren(true);
		if (this.type == 0) {
			var layer = new TrainView();
			this.TrainShadowContentLayer.addChild(layer);
			this.setSpriteFrame(this.TrainViewBtn, true);
			this.setSpriteFrame(this.TrainWaveBtn, false);
			this.setSpriteFrame(this.TrainBoxBtn, false);
		} else if (this.type == 1) {
			this.TrainShadowContentLayer.addChild(new ShadowWave());
			this.setSpriteFrame(this.TrainViewBtn, false);
			this.setSpriteFrame(this.TrainWaveBtn, true);
			this.setSpriteFrame(this.TrainBoxBtn, false);
		} else if (this.type == 2) {
			this.TrainShadowContentLayer.addChild(new ShadowBox());
			this.setSpriteFrame(this.TrainViewBtn, false);
			this.setSpriteFrame(this.TrainWaveBtn, false);
			this.setSpriteFrame(this.TrainBoxBtn, true);
		}
	},
	TrainShadowAction:function(){
		this.type = 0;
		this.updataShadowLayer();
	},
	shadowWaveAction:function(){
		this.type = 1;
		this.updataShadowLayer();
	},
	shadowBoxAction:function(){
		this.type = 2;
		this.updataShadowLayer();
	},
	changeShadowAction:function(){
		postNotifcation(NOTI.GOTO_TEAM, {page:0, type:1});
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});