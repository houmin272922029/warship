/**
 * 日常弹窗类
 * @param params 
 *  	closeCallBack 当关闭视图的时候，需要调用的管理器方法
 */
var DailyPopUpLayer = DailyBaseLayer.extend({
	ctor : function(params){
		this._super(params);
		// 关闭后回调给管理模块的方法
		this.closeCallBack_ = params.closeCallBack || function() {};
		this.target_ = params.manager;    // 回调函数的执行范围，保证回调函数被正常执行
	},
	
	// 创建一个listView(默认是node大小的 98%， 方向竖直)
	// 会自动在本视图类中保存listView_对象
	createListView : function(node, size, direction) {
		if (node == null) {
			trace("no node find in createListView");
			return;
		}
		if (this.listView_ != null) {
			this.listView_.removeFromParent(true);
			this.listView_ = null;
		}
		var contentSize = node.getContentSize();
		size = size || cc.size(contentSize.width, contentSize.height);
		direction = direction || ccui.ScrollView.DIR_VERTICAL;

		this.listView_ = new ccui.ListView();
		this.listView_.setDirection(direction);
		this.listView_.setTouchEnabled(true);
		this.listView_.setBounceEnabled(true);
		this.listView_.setContentSize(size);		
		this.listView_.addEventListener(this._selectedItemEvent, this);
		this.listView_.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});

		node.addChild(this.listView_);
	},
	
	_selectedItemEvent: function (sender, type) {
		cc.log("类型 ", type);
		switch (type) {
		case ccui.ListView.EVENT_SELECTED_ITEM:
			var listViewEx = sender;
			cc.log("select child index = " + listViewEx.getCurSelectedIndex(), sender.index_);
			break;

		default:
			break;
		}
	},
	
	swallowLayer : function(content){
		common.swallowLayer(this, true, content, this._touchOutside);
	},
	
	// 关闭
	closeView : function() {
		this.removeFromParent(true);
	},
	
	// 点击外部回调函数
	_touchOutside : function() {
		
	},
	
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
		if (this.target_ != null && this.closeCallBack_ != null) {
			this.closeCallBack_.apply(this.target_);
		}
	},
});