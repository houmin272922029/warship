var CommonHelpView = cc.Layer.extend({
	/**
	 * 通用帮助弹框，显示一个文本列表
	 * 
	 * @param Array info 需要显示的文本数组 new Array("tip1", "tip2")
	 * @param cc.size margin 每条帮助label与边框的边距
	 * @param close 关闭回调
	 */
	ctor:function(param){
		this._super();
		
		var infoList = param.info;
		this.close_ = param.close;
		this.margin_ = param.margin || cc.size(10, 10);
		
		cc.BuilderReader.registerController("CommonHelpViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.CommonHelp_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		
		common.swallowLayer(this, true);
		
		/**
		 * 文本列表
		 */
		this.ListView_ = null;
		
		this.addTableView();
		
		this.refreshView(infoList);
	},

	/**
	 * 添加帮助文本列表
	 */
	addTableView : function() {
		if (this.ListView_ == null) {
			var contentLayer = this["tableViewContentView"];
			var contentSize = contentLayer.getContentSize();
			
			this.ListView_ = new ccui.ListView();
			this.ListView_.setDirection(ccui.Layout.LINEAR_VERTICAL);
			this.ListView_.setTouchEnabled(true);
			this.ListView_.setBounceEnabled(true);
			this.ListView_.setContentSize(contentSize);
			this.ListView_.attr({
				x:0,
				y:0,
				anchorX:0,
				anchorY:0
			});

			contentLayer.addChild(this.ListView_);
		}
	},
	
	/**
	 * 刷新文本列表
	 */
	refreshView : function(infoList) {
		if (infoList == null) {
			return;
		}
		
		if (this.ListView_ == null) {
			return;
		}
		
		this.ListView_.removeAllItems();
		
		var tableWidth = this["tableViewContentView"].getContentSize().width - this.margin_.width;
		/**
		 * 生成每一条label, 同时设置label与cell边距
		 */
		for (var int = 0; int < infoList.length; int++) {
			var tip = infoList[int];
			
			var item = new ccui.Layout();
			item.setTouchEnabled(true);
			var tipLabel = new cc.LabelTTF(tip, FONT_NAME, 23,
					cc.size(tableWidth, 0), 
					cc.TEXT_ALIGNMENT_LEFT, 
					cc.VERTICAL_TEXT_ALIGNMENT_CENTER
			);
			item.addChild(tipLabel);
			
			var itemContentSize = cc.size(
					this["tableViewContentView"].getContentSize().width, 
					tipLabel.getContentSize().height + this.margin_.height
					);
			item.setContentSize(itemContentSize);
			tipLabel.setPosition(cc.p(itemContentSize.width / 2, itemContentSize.height / 2));
			this.ListView_.pushBackCustomItem(item);
		}
	},
	
	closeItemClick:function(){
		if (this.close_) {
			this.close_();
		}
		
		this.ListView_.removeAllItems();
		this.removeFromParent(true);
	}
});