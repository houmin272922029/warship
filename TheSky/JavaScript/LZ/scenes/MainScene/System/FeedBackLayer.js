var FeedBackLayer = cc.Layer.extend({
	ctor:function(param) {
		this._super();
		cc.BuilderReader.registerController("FeedbackOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.Feedback_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.initLayer();
	},
	closeItemClick:function() {
		this.removeFromParent(true);
	},
	initLayer:function() {
		this.editBg = new cc.Scale9Sprite(ccbi_dir + "/ccbi/ccbResources/LevelMessageBg.png");
		editBox = new cc.EditBox(cc.size(this.editBoxBgs.getContentSize().width, this.editBoxBgs.getContentSize().height), this.editBg);
		editBox.setPlaceHolder(common.LocalizedString("请留下您的宝贵意见及建议"));
		editBox.setAnchorPoint(cc.p(0.5, 0.5));
		editBox.setPosition(cc.p(this.editBoxBgs.getContentSize().width / 2, this.editBoxBgs.getContentSize().height / 2));
		editBox.setFont("ccbResources/FZCuYuan-M03S.ttf", 25 * retina);
		editBox.setDelegate(this);
		this.editBoxBgs.addChild(editBox, 100 ,10);
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
		
	},
	commitFeedback:function(succ, fail) {
		var string = editBox.getString();
		if (getJsonLength(string) >= 500) {
			common.ShowText(common.LocalizedString("feedback.exceed"));
		} else {
			if (string == null || string == "") {
				common.ShowText(common.LocalizedString("feedback.tips"));
			} else {
				PlayerModule.dofeedBack(string, succ, fail);
			}
		}
	},
})