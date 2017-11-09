/**
 *	日常页面
 *
 *  包含顶部tableview 和 底部pageview
 *  
 *  点击顶部Icon更换pageview显示，并同时调用pageviewcell的OnSelect方法。
 *  
 */

var DailyLayer = DailyBaseLayer.extend({
	
	
	ctor:function(params){
		this._super();
				
		/**
		 * 初始化变量
		 */
		this.curIndex_ = params.curindex || -1;
		
		/**
		 * 活动cell对象数组
		 */
		this.activityCellArray_ = new Array();
				
		this.initCCBLayer(ccbi_res.DailyView_ccbi, "DailyViewOwner", this, this);
		this.handleElementsPos();
		
		cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("olRes/ol_public_2.plist"));
		cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("publicRes_4.plist"));
		
		this.dailyListChange();
		
		addObserver(NOTI.ACTIVITY_DAILY_LIST_CHANGE, "dailyListChange", this);
		addObserver(NOTI.ACTIVITY_DATA_CHANGE, "activityDataChange", this);
	},
	
	/**
	 * 重新摆放元素位置
	 */
	handleElementsPos:function(){
		var winSize = cc.director.getWinSize();
		this["topContainer"].setPosition(cc.p(winSize.width / 2, winSize.height - broadCastHeight * retina ));
		this["contentLayer"].setPosition(cc.p(winSize.width / 2, winSize.height - this["teamTopBg"].getContentSize().height * retina ));
		this["contentLayer"].setContentSize(cc.size(winSize.width, (winSize.height - mainBottomTabBarHeight * retina - broadCastHeight * retina - this["teamTopBg"].getContentSize().height * retina)));
	},
	
	/**
	 * 日常列表发生改变
	 */
	dailyListChange : function() {
//		this.curIndex_ = -1;
		/**
		 * 初始化顶部图标列表
		 */
		this.addTopIconTableView();

		/**
		 * 初始化活动pageview
		 */
		this.addPageView();
		
		this.activityList_ = new Array();
		this.activityCellArray_ = new Array();
		
		var activityList = ActivityModule.getActivityList();

		for ( var key in activityList) {
			this.activityList_.push(activityList[key]);
		}

		for (var i = 0; i <= this.activityList_.length - 1; i++) {
			this.addDailyPage(this.activityList_[i]);
		}
		
		if (this.curIndex_ != null && this.curIndex_ >= this.activityList_.length) {
			this.curIndex_ = this.activityList_.length - 1;
		}
		if (this.curIndex_ == -1) {
			this.gotoPage(0);
		}
		else
		{
			this.gotoPage(this.curIndex_);
		}
	},

	/**
	 *  添加一个页面
	 */
	addDailyPage : function( activityName ){

		var activityConf = ActivityCCB[activityName];
		if (!activityConf) {
			return;
		}
		// 添加顶部icon
		var activityIcon = this.createTopIconCell({
			icon : activityConf.icon,
			name : activityConf.name,
			isTimeLimit : activityConf.isTimeLimit,
			callback : this.tableViewEvent,
			target : this
		});

		// 添加活动详情pageview
		var layout = new (this.getActivityConstructor(activityName))({
			ccbi : activityConf.ccbi,
			owner : activityConf.owner,
			size : this["contentLayer"].getContentSize()
		});
		
		this.activityCellArray_.push(layout);
		this.centerPageView_.addPage(layout);
	},
	
	/**
	 *  跳转到一个页面
	 *  @param index 可为字符串和数字
	 */
	gotoPage : function(index){
		/**
		 * 转换字符串的活动名到位置索引
		 */
		if (typeof index == "string") {
			index = this._getIndexByName(index);
		}
		this.moveToPage(index);
	},
	
	/**
	 * 根据活动名获得活动索引
	 */
	_getIndexByName : function(name) {
		var index = new Array();
		
		for (var int = 0; int < this.activityList_.length; int++) {
			var activityName = this.activityList_[int];
			if (activityName == name) {
				index.push(int);
			}
		}
		
		return index;
	},
	
	/**
	 * 跳转到一个页面
	 * @param index int类型 页面的索引
	 */
	moveToPage : function(index) {
		this.iconListView_.selectItemByIndex(index);
		if (this.activityList_[index] == "kissMermaid") {
			SoundUtil.playMusic("audio/kisslaoshi.mp3", true);
		}else {
			SoundUtil.playMusic("audio/daily.mp3", true);
		}
		this.centerPageView_.scrollToPage(index);
	},
	
	/**
	 *  移除一个页面
	 */
	removePage : function(){
		
	},
	
	/**
	 * 私有方法
	 */
	
	/**
	 * 添加页面头部tableView
	 */
	addTopIconTableView : function(){
		if (this.iconListView_ != null) {
			this.iconListView_.removeFromParent(true);
			this.iconListView_ = null;
		}
		
		var size = this["IconContainerLayer"].getContentSize();
		this.iconListView_ = new SelectableTableView({
			size : size
		});
		this.iconListView_.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		this["IconContainerLayer"].addChild(this.iconListView_);
	},
	
	/**
	 * 列表中item被选中回调
	 * @param index 
	 */
	tableViewEvent : function(index) {
		this.gotoPage(index);
	},
	
	/**
	 * 添加中间pageview
	 */
	addPageView : function(){
		if (this.centerPageView_ != null) {
			this.centerPageView_.removeFromParent(true);
			this.centerPageView_ = null;
		}
		
		this.centerPageView_ = new ccui.PageView();
		this.centerPageView_.setTouchEnabled(true);
		this.centerPageView_.setContentSize(this["contentLayer"].getContentSize());
		this.centerPageView_.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		
		this.centerPageView_.addEventListener(this.pageViewEvent, this);
		this["contentLayer"].addChild(this.centerPageView_);
	},
	
	/**
	 * pageView 滑动回调事件
	 * @param sender
	 * @param type
	 */
	pageViewEvent : function(sender, type){
		switch (type) {
		case ccui.PageView.EVENT_TURNING:
			var toIndex = sender.getCurPageIndex();
//			if (toIndex != this.curIndex_ && this.iconListView_ != null) {
			if (this.iconListView_ != null) {
				this.curIndex_ = toIndex;
				this.iconListView_.selectItemByIndex(toIndex);
				this._changePageCallBack(toIndex);
			}
			break;
		default:
			break;
		}
	},
	
	/**
	 * 生成顶部的一个cell
	 * @param params
	 * @return 单条item包含的IconCell对象
	 */
	createTopIconCell : function(params){
		this.iconListView_.addItem(params);
	},
	
	/**
	 * 获取活动视图的构造器
	 * @param string activityName 活动名
	 */
	getActivityConstructor : function(activityName){
		var viewConstructor = window[activityName + "Layer"];
		if (viewConstructor == null) {
			trace("get " + activityName + " constructor field !");
		}
		
		return viewConstructor;
	},
	
	/**
	 * 页面被切换后的回调
	 * @param index
	 */
	_changePageCallBack : function(index) {
		var activityCell = this.activityCellArray_[index];
		if (this.activityList_[index] == "kissMermaid") {
			SoundUtil.playMusic("audio/kisslaoshi.mp3", true);
		}else {
			SoundUtil.playMusic("audio/daily.mp3", true);
		}
		activityCell.onActivate();
	},
	
	/**
	 * 注册活动数据发生改变的通知
	 */
	activityDataChange : function(changeList){
		for (var int = 0; int < changeList.length; int++) {
			// 获得数据发生改变的活动索引
			var index = this._getIndexByName(changeList[int]);
			for (var int2 = 0; int2 < index.length; int2++) {
				// 获得cell
				var activityCell = this.activityCellArray_[index[int2]];
				// 开始刷新视图
				activityCell.refreshView();
			}
		}
	},
	onEnter:function(){
		this._super();
		SoundUtil.playMusic("audio/daily.mp3", true);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.ACTIVITY_DATA_CHANGE, "activityDataChange", this);
		removeObserver(NOTI.ACTIVITY_DAILY_LIST_CHANGE, "dailyListChange", this);
	},
});
