/**
 *  日常pageview的一条 完成适配功能
 *  生成一个固定大小的layer，
 *  
 *  onSelect 被选定显示
 *  onLeave  离开该页面
 *  refreshView 数据更新，刷新页面
 *  
 */


var DailyPageViewCell = ccui.Layout.extend({
	/**
	 * 初始化方法
	 * 设置cell大小，并加载ccbi文件
	 * @param params dic
	 * @param ccbi
	 * @param size
	 * @param 
	 */
	ctor : function(params){
		this._super();
		
		if (params.size){
			this.setContentSize(params.size)
		}
		
		if (params.ccbi && params.owner) {
			cc.BuilderReader.registerController(params.owner, {
			});
			this.node = cc.BuilderReader.load(params.ccbi, this);
			if(this.node != null) {
				this.addChild(this.node);
			}
		}
		
		var contentSize = this.getContentSize()
		this.node.attr({
			x:((contentSize.width - this.node.getContentSize().width * retina) / 2),
			y:((contentSize.height - this.node.getContentSize().height * retina) / 2)
		});
		
		this.initView();
	},
	
	/**
	 * 活动页面初始化设置
	 */
	initView : function(){
		
	},
	
	/**
	 * 切换到该cell时的回调
	 */
	onActivate : function() {
		
	},
	
	/**
	 * 活动数据更新，刷新页面
	 * @param data 活动数据
	 * 如果数据为空，将调用module中的方法获取组装好的数据，再刷新页面，获取失败，不进行刷新
	 */
	refreshView : function(data){
		
	},
	
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
	
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	
});

