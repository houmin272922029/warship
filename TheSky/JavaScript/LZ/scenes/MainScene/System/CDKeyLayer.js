var CDKeyLayer = cc.Layer.extend({
	ctor:function(param) {
		this._super();

		cc.BuilderReader.registerController("CdkeyOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.Cdkey_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.edixBg = cc.Sprite.createWithSpriteFrameName("chat_bg.png");
		var editBox = new cc.EditBox(cc.size(this.edixBg.getContentSize().width /2, this.edixBg.getContentSize().height/2), this.edixBg);
		editBox.setPlaceHolder(common.LocalizedString("点此输入CD-KEY"));
		editBox.setAnchorPoint(cc.p(0.5, 0.5));
		editBox.setPosition(cc.p(this.edixBg.getPositionX() *2 - 20, this.edixBg.getPositionY()*2 + 270));
		editBox.setFont("ccbResources/FZCuYuan-M03S.ttf", 30 * retina);
		this.infoBg.addChild(editBox);
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
		this.closeItemClick();
	},
	closeItemClick:function() {
		this.removeFromParent(true);
	},
	commitCdkey:function() {
		var editBox = new cc.EditBox(cc.size(this.edixBg.getContentSize().width, this.edixBg.getContentSize().height), this.edixBg);
		var string = editBox.getText();
		if (getJsonLength(string) <= 0) {
			common.ShowText(common.LocalizedString("Cdkey.empty"));
		} else {
			//TODO发送网络请求
		}
	}
})