var ConfirmBox = cc.Layer.extend({
	/**
	 * 
	 * @param param
	 * type 0 确定取消， 1只有关闭, 2 只有确定
	 */
	ctor:function(param){
		this._super();
		this.param = param;
		var info = param.info;
		var type = param.type || 0;
		this.confirm = param.confirm;
		this.close = param.close;
		cc.BuilderReader.registerController("SimpleConfirmCardOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ConfirmCard_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true);
		this.simpleText.setString(info);
		
		if (type === 0) {
			this.closeText.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("quxiao_text_ol.png"));
			this.confirmText.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("queding_text.png"));
		} else if (type === 1) {
			this.confirmBtn.visible = false;
			this.confirmText.visible = false;
			var size = this.cardContent.getContentSize();
			this.cancelBtn.x = size.width / 2;
			this.closeText.x = size.width / 2;
		} else if (type === 2) {
			this.cancelBtn.visible = false;
			this.closeText.visible = false;
			var size = this.cardContent.getContentSize();
			this.confirmBtn.x = size.width / 2;
			this.confirmText.x = size.width / 2;
		}
	},
	closeItemClick:function(){
		if (this.close) {
			this.close();
		}
		this.removeSelf();
		
	},
	confirmBtnAction:function(tag){
		if (this.confirm) {
			this.confirm();
		}
		this.removeSelf();
	},
	removeSelf:function(){
		this.removeFromParent(true);
	},
});