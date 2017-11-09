var DailyOneKeyDeComposeChooseView = cc.Layer.extend({
	/**
	 * 日常一键分解功能，rank选择页面
	 */
	ctor:function(param){
		this._super();
		
		this.selectIndex_ = 0;

		cc.BuilderReader.registerController("DailyDecomposeCheckView", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.DailyDecomposeCheckView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}

		common.swallowLayer(this, true);

		this.initView();
	},
	
	/**
	 * 初始化视图内容
	 */
	initView : function() {
		
	},
	
	/**
	 * 选择分解按钮被点击
	 */
	onCheckBtnTaped : function(sender) {
		var tag = sender.getTag();
		var checkBtn;
		
		for (var i = 1; i < 4; i++) {
			this["duihao" + i].visible = false;
		}
		this["duihao" + tag].visible = true;
		
		if (this.selectIndex_ != 0)
		{
			
			checkBtn = this["checkBtn" + this.selectIndex_];
			if (this.selectIndex_ == tag) {
				// 取消选择
				checkBtn.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn7_1.png"));
				checkBtn.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn7_0.png"));
				this.selectIndex_ = 0;
			} else {
				checkBtn.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn7_1.png"));
				checkBtn.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn7_0.png"));
				
				this.selectIndex_ = tag;
				
				checkBtn = this["checkBtn" + this.selectIndex_];
				checkBtn.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn7_0.png"));
				checkBtn.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn7_0.png"));
			}
		} else {
			this.selectIndex_ = tag;
			checkBtn = this["checkBtn" + this.selectIndex_];
			checkBtn.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn7_0.png"));
			checkBtn.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("btn7_0.png"));
		}
	},
	
	
	closeItemClick:function(){
		if (this.close) {
			this.close();
		}
		this.removeSelf();

	},
	
	confirmBtnAction:function(){
		if (this.confirm) {
			this.confirm();
		}
		if (this.selectIndex_ != 0) {
			DailyCraftsManModule.doOneKeyDecomposeAction(this.selectIndex_);
		} else {
			// 没有选择任何rank
			
		}
		
		this.removeSelf();
	},
	
	removeSelf:function(){
		this.removeFromParent(true);
	}
});