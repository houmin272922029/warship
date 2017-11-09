/**
 *  日常顶部一个Icon
 */
var IconCell = ccui.Layout.extend({
		Tags:{
			Frame     : 1,
			Icon      : 2,
			Name      : 3,
			TimeLimit : 4,
			Select    : 5,
			Hight     : 6
		},
		/**
		 *  初始化
		 *  
		 *  @param icon
		 *  @param name 显示的活动名字
		 *  @param rank 边框颜色
		 *  @param isSelect 是否正在被选中
		 *  @param isHight  是否高亮（）
		 */
		ctor:function(params){
			this._super();
			params = params || {};
			this.icon_ = params.icon || "";
			this.name_ = params.name || "";
			this.rank_ = params.rank || "";
			this.isSelect_ = params.isSelect || false;
			this.isHight_ = params.isHight || false;
			this.isTimeLimit_ = params.isTimeLimit || false;
			this.index_ = params.index || 0;
			this.callBack_ = null;
			this.target_ = null;

			this.initView();
		},
		initView:function(){
			this.setCustomFrame(this.rank_);
			this.setName(this.name_);
			this.setSelect(this.isSelect_);
			this.showTimeLimit(this.isTimeLimit_);
			
//			this.scale = this.scale / retina;
		},
		/**
		 * 设置背景frame显示
		 */
		setCustomFrame:function(rank){
			
			if (this.frame_) {
				
			}

			this.frame_ = new ccui.Button(this.icon_, this.icon_, "", ccui.Widget.PLIST_TEXTURE);
			this.frame_.setTouchEnabled(true);
			this.frame_.setSwallowTouches(false);
			
			this.frame_.addTouchEventListener(function(sender, type){
				if (type === ccui.Widget.TOUCH_ENDED) {
					var idx = sender.getTag();
					this.callBack_.call(this.target_, this.getIndex());
				}
			}, this).bind(this);
			
			this.frame_.attr({
				anchorX: 0.5,
				anchorY: 0.5,
				x: 0,
				y: 0
			});

//			this.frame_.scale = retina;
			this.addChild(this.frame_, this.Tags.Frame, this.Tags.Frame);
		},
		
		setIcon:function(icon){
			
		},
		
		setName:function(name){
			if (typeof name != "string") {
				return;
			}
			
			if (this.nameBg_ == null) {
				this.nameBg_ = cc.Sprite("#dailyNameBg.png");
				this.nameBg_.attr({
					x: this.getContentSize().width / 2,
					y: - this.getContentSize().height / 2,
					anchorX: 1,
					anchorY: 0,
					scale : 1
				});
				this.addChild(this.nameBg_, this.Tags.Name, this.Tags.Name);
			}
			
			if (this.nameLabel_ == null){
				this.nameLabel_ = new cc.LabelTTF("", FONT_NAME, 18, cc.size(100, 0), cc.TEXT_ALIGNMENT_CENTER );
				this.nameLabel_.attr({
					x: this.nameBg_.getContentSize().width / 2,
					y: this.nameBg_.getContentSize().height / 2,
					anchorX: 0.5,
					anchorY: 0.5,
					scale : 1
				});
				this.nameBg_.addChild(this.nameLabel_);
			}
			
			this.nameLabel_.setString(common.LocalizedString(name));
		},
		
		setSelect:function(state){
				if (this.select_ == null) {
					this.select_ = cc.Sprite("#selFrame.png");
					this.select_.attr({
						anchorX: 0.5,
						anchorY: 0.5,
						x: 0,
						y: 0,
						scale: 1
					});
					this.addChild(this.select_, this.Tags.Select, this.Tags.Select);
				}
			
				this.select_.setVisible(state)
		},
		
		showTimeLimit : function(isTimeLimit) {
			if (this.timeBg_ == null) {
				this.timeBg_ = cc.Sprite("#timer_bg.png");
				this.timeBg_.attr({
					x: -this.getContentSize().width / 2,
					y: this.getContentSize().height / 2,
					anchorX: 0,
					anchorY: 1,
					scale : 1
				});
				this.addChild(this.timeBg_, this.Tags.TimeLimit, this.Tags.TimeLimit);
			}
			
			this.timeBg_.setVisible(isTimeLimit);

			if (this.timeLimitLabel_ == null){
				this.timeLimitLabel_ = new cc.LabelTTF(common.LocalizedString("daily_timelimit"), FONT_NAME, 15, cc.size(100, 0), cc.TEXT_ALIGNMENT_LEFT );
				this.timeLimitLabel_.attr({
					x: 0,
					y: this.timeBg_.getContentSize().height / 2,
					anchorX: 0,
					anchorY: 0.5,
					scale : 1
				});
				this.timeBg_.addChild(this.timeLimitLabel_);
			}
		},
		
		setHight:function(flag){
			
		},
		/**
		 * 获得icon大小
		 */
		getContentSize:function(){
			return this.frame_.getContentSize();
		},
		/**
		 * 获取在tableview中的索引
		 */
		getIndex : function() {
			return this.index_;
		},
		/**
		 * 注册点击回调事件
		 */
		registeTapCallBack:function(callBack, target){
			this.callBack_ = callBack;
			this.target_ = target;
		},
		
		onEnter:function(){
			this._super();
		},
		onExit:function(){
			this._super();
		},
});