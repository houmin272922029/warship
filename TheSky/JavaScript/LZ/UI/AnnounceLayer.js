var AnnounceLayer = cc.Layer.extend({
	/**
	 * 通用公告弹框，显示一个文本列表
	 * 
	 * @param Array info 需要显示的文本数组 new Array("tip1", "tip2")
	 * @param cc.size margin 每条帮助label与边框的边距
	 * @param close 关闭回调
	 */
	ctor:function(param) {
		this._super();
		this.close_ = param.close;
		this.margin_ = param.margin || cc.size(10, 10);
		
		cc.BuilderReader.registerController("AnnounceLayerViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.AnnounceLayerView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true);
	},

	closeItemClick:function() {
		if (this.close_) {
			this.close_();
		}
		this.removeFromParent(true);
	},
})