var singleInsLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
				
		this.createListView(this["contentLayer"], null, ccui.ScrollView.DIR_VERTICAL);
	},
	
	onActivate : function() {
		DailyInstructModule.fetchSingleInstructData();
	},
	
	refreshView : function() {
		if (this.listView_ == null) {
			return;
		}
		this.listView_.removeAllItems();
		
		var viewData = DailyInstructModule.getSingleInstructData();
		
		if (viewData == null) {
			// remove self
			return;
		}
		
		var cellCount =  viewData.length % 4 > 0 ? (viewData.length / 4) : ((viewData.length - viewData.length % 4) / 4 + 1);
		
		for (var int = 0; int < cellCount; int++) {
			var cellData = new Array();
			for (var int2 = 0; int2 < 4; int2++) {
				if (viewData[int * 4 + int2] != null) {
					cellData.push(viewData[int * 4 + int2]);
				}
			}
			
			this.listView_.pushBackCustomItem(new singleInstructCell({
				cellData : cellData,
				index : int
			}));
		}
	},
	
//	createListView : function(node, size, direction) {
//		if (node == null) {
//			trace("no node find in createListView");
//			return;
//		}
//		if (this.listView_ != null) {
//			this.listView_.removeFromParent(true);
//			this.listView_ = null;
//		}
//		var contentSize = node.getContentSize();
//		size = size || cc.size(contentSize.width, contentSize.height);
//		direction = direction || ccui.ScrollView.DIR_VERTICAL;
//
//		this.listView_ = new ccui.ListView();
//		this.listView_.setDirection(direction);
//		this.listView_.setTouchEnabled(true);
//		this.listView_.setBounceEnabled(true);
//		this.listView_.setContentSize(size);		
//		this.listView_.addEventListener(this._selectedItemEvent, this);
//		this.listView_.attr({
//			x:0,
//			y:0,
//			anchorX:0,
//			anchorY:0
//		});
//
//		node.addChild(this.listView_);
//	},
//	
//	_selectedItemEvent : function(sender, type) {
//		
//	}
});

var singleInstructCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);
		
		this.index_ = params.index;
		this.cellData_ = params.cellData;

		this.size_ = params.size || cc.size(500,110);
		this.setContentSize(this.size_);

		cc.BuilderReader.registerController("InstructCellOwner", {

		});
		this.node = cc.BuilderReader.load(ccbi_res.InstructHeroCellView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}

		this["bgMenu"].setSwallowTouches(false);

		this.initCell();
	},
	
	initCell : function() {
		for (var int = 0; int < 4; int++) {
			if (this.cellData_[int] != null) {
				var itemData = this.cellData_[int];
				var frame = this["frame" + (int + 1)];
				var rankbg = this["headbg_" + (int + 1)];
				var head = this["head" + (int + 1)];
				frame.setTag(this.index_ * 4 + int);
				frame.setVisible(true);
				head.setVisible(true);
				rankbg.visible = true;
				if (itemData.frameImg != null) {
					frame.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(itemData.frameImg));
					frame.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(itemData.frameImg));
					
				}
				if (itemData.rankBgImg != null) {
					rankbg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(itemData.rankBgImg));
				}
				if (itemData.headImg != null) {
					head.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(itemData.headImg));
				}
			}
		}
	},
	
	itemClick : function(sender) {
		var tag = sender.getTag();
		DailyInstructModule.doSingleInstruceAction(tag);
	}
});

