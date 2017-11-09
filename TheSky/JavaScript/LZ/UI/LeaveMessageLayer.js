var LeaveMessageLayer = cc.Layer.extend({
	ctor:function(name, uid, type){
		this._super();
		cc.BuilderReader.registerController("LeaveMessageOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.LeaveMessage_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}

		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.name = name;
		this.uid = uid;
		this.type = type || "mails";
		this.editBox;
		this.refresh();
	},
	refresh:function(){
		if (this.name) {
			this.titleLabel.setString(common.LocalizedString("给%s留言",this.name));
		} else {
			this.titleLabel.setString("");
		}
		var editBoxBgs = this.editBoxBgs;
		var editBg = new cc.Scale9Sprite(ccbi_dir + "/ccbi/ccbResources/LevelMessageBg.png");
		this.editBox = new cc.EditBox(cc.size(editBoxBgs.getContentSize().width, editBoxBgs.getContentSize().height), editBg);
		this.editBox.setPlaceHolder(common.LocalizedString("点我输入留言内容"));
		this.editBox.setAnchorPoint(cc.p(0.5, 0.5));
		this.editBox.setPosition(cc.p(editBoxBgs.getContentSize().width / 2,  editBoxBgs.getContentSize().height / 2));
		this.editBox.setFont(ccbi_dir + "/ccbi/ccbResources/FZCuYuan-M03S.ttf", 25*retina);
		editBoxBgs.addChild(this.editBox, 100, 10);
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	onExit:function(){
		this._super();
	},
	onCancelTap:function() {
		this.removeFromParent(true);
	},
	onEnter:function(){
		this._super();
	},
	onSendSucc:function(){
		if (this.type == "mails") {
			this.removeFromParent(true);
		}
	},
	onSendTap:function(){
		FriendModule.doOnLevelMessage(this.uid, encodeURI(this.editBox.getString()), this.onSendSucc());
	},
});