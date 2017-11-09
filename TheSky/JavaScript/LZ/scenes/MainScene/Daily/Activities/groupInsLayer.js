var groupInsLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
		
//		this.createListView(this.owner["contentLayer"], cc.size(613, 110), ccui.ScrollView.DIR_HORIZONTAL);
		
//		for (var int = 0; int < 10; int++) {
//			this.listView_.pushBackCustomItem(new singleInstructCell());
//		}
		this.uid_ = null;
		
		// 初始化显示
		this.showCD_ = true;
		this["cdLayer"].setVisible(true);
		this["cdLabel"].setString("");
		this["resultLayer"].setVisible(false);
		this["resultMenu"].setVisible(false);
		
		// 添加对时间变化的监听
		addObserver(NOTI.ACIVITY_TIME_UPDATE, "timeUpdate", this);
	},
	
	onActivate : function() {
		DailyInstructModule.fetchSingleInstructData();
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
	
	refreshView : function() {
		this.data_ = DailyInstructModule.getGroupInstructData(this.uid_);
		this.uid_ = this.data_.uid;
		this["rank_bg"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.data_.headBg));
		this["frame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.data_.frame));
		this["head"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.data_.head));
		this["head"].setVisible(true);
		
		this["cdTips"].setString(this.data_.cdTips);
		this["cdSayLabel"].setString(this.data_.cdSayLabel);
		this["resultSayLabel"].setString(this.data_.resultSayLabel);
		this["expLabel"].setString(this.data_.expLabel);
		this["itemLabel"].setString(this.data_.itemLabel);
		
		this.timeUpdate();
	},
	
	timeUpdate : function() {
		if (this.uid_ == null) {
			return;
		}
		
		var time = DailyInstructModule.getSingleInstructCDTime(this.data_.endTime);
		if (time != null) {
			// 在cd中
			if (!this.showCD_) {
				this.showCD_ = true;
				this["cdLayer"].setVisible(true);
				this["resultLayer"].setVisible(false);
				this["resultMenu"].setVisible(false);
			}
			
			this["cdLabel"].setString(time);
		} else {
			if (this.showCD_) {
				this.showCD_ = false;
				this["cdLayer"].setVisible(false);
				this["resultLayer"].setVisible(true);
				this["resultMenu"].setVisible(true);
			}
		}
	},
	
	awardItemClick : function() {
		// 普通答谢
		DailyInstructModule.doInstructNetworkAction(this.uid_, 0);
	},
	
	doubleItemClick : function() {
		// 使用道具
		DailyInstructModule.doInstructNetworkAction(this.uid_, 1);
	},
	
	_selectedItemEvent : function(sender, type) {
		
	},
	
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.ACIVITY_TIME_UPDATE, "timeUpdate", this);
	},
});

