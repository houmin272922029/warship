var SelectableTableView = cc.Layer.extend({
	
	/**
	 * 构造方法
	 */
	ctor : function(params) {
		this._super();
		
		this.margin_ = 6;
		
		this.direction_ = params.direction || ccui.ScrollView.DIR_HORIZONTAL;
		this.size_ = params.size || cc.size(100, 100);
		this.iconCellArray_ = new Array();
		this.currentSelectIndex_ = 0;
		
		this.initView();
	},
	
	initView : function() {
		this.setContentSize(this.size_);
		
		if (this.ListView_ == null) {
			this.ListView_ = new ccui.ListView();
			this.ListView_.setDirection(this.direction_);
			this.ListView_.setTouchEnabled(true);
			this.ListView_.setBounceEnabled(true);
			this.ListView_.setContentSize(this.size_);
			this.ListView_.attr({
				x:0,
				y:0,
				anchorX:0,
				anchorY:0
			});
			
			this.addChild(this.ListView_);
		}
	},
	
	/**
	 * 添加一条
	 * @param params
	 */
	addItem : function(params) {
		params.index = this.iconCellArray_.length;
		var item = new ccui.Layout();
		item.setTouchEnabled(true);

		var icon = new IconCell(params);
		item.addChild(icon);

		var iconSize = icon.getContentSize();
		icon.attr({
			x : (iconSize.width + this.margin_) / 2,
			y : this.size_.height / 2
		});
		item.setContentSize(cc.size(iconSize.width + this.margin_, this.size_.height));

		item.icon_ = icon;
		item.icon_.registeTapCallBack(params.callback, params.target);
		
		this.iconCellArray_.push(item)
		this.ListView_.pushBackCustomItem(item);
	},
	
	/**
	 * 选择一条
	 * @prama int index 索引
	 */
	selectItemByIndex : function(index) {
		var item = this.iconCellArray_[index];
		if (item == null) {
			return null
		}
		
		if (this.iconCellArray_[this.currentSelectIndex_] !== null) {
			this.iconCellArray_[this.currentSelectIndex_].icon_.setSelect(false);
		}
		this.currentSelectIndex_ = index;
		this.ListView_.refreshView();
		var icon = item.icon_;
		icon.setSelect(true);
		this._moveItemToVisibleRectByIndex(index);
	},
	
	/**
	 * 移动该条item到可见区域
	 * @param int index item索引
	 */
	_moveItemToVisibleRectByIndex : function(index) {

		var item = this.iconCellArray_[index];
		
		var container = this.ListView_.getInnerContainer();
		var bottomOffset_ = item.getContentSize().width * index;
		var topOffset_ = bottomOffset_ + item.getContentSize().width;	
		
		if (this.direction_ == ccui.ScrollView.DIR_HORIZONTAL) {
			// 水平
			var offsetBtmX = bottomOffset_ + container.x;  // 当前item相对于tableview原点的位置
			var offsetTopX = (topOffset_ + container.x) - this.ListView_.getContentSize().width; // 当前定点相对于tableView顶点的位置
			var xpos = -1;
			if (offsetBtmX < 0) {
				xpos = bottomOffset_;
			} else if(offsetTopX > 0) {
				xpos = topOffset_ - this.ListView_.getContentSize().width;
			}

			if (xpos >= 0) {
				var per = xpos / (container.getContentSize().width - this.ListView_.getContentSize().width) * 100;
				this.ListView_.scrollToPercentHorizontal(per, 0.5, true);
			}
		} else {
			// TODO 竖直
		}
	},
	
	clearUp : function() {
		this.ListView_.removeAllItems();
		this.iconCellArray_ = new Array();
		this.currentSelectIndex_ = 0;
	},
	
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});