var NewsViewTableCell = cc.Layer.extend({
	ctor:function(idx, type, data){
		this._super();
		this.type = type || "system";
		this.index = idx;
		this.data = data;
		this.id = this.data.id;
		cc.BuilderReader.registerController("NewsCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.NewsViewTableCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.refersh();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	refersh:function() {
		var time = this.data.send_time;
		var timeStr;
		if ((Global.serverTime - time) < 7 * 24 * 3600) {
			timeStr = DateUtil.second2hms(Global.serverTime - time);
		} else {
			timeStr = "很久以前";
		}
		this.timeLabel.setString(timeStr);
		this.contentLabel.setString(decodeURI(this.data.content) || "");
		
		if (this.type == "award") {
			this.fightBtn.visible = true;
			this.fightSprite.visible = true;
			this.fightSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("lingjiang_0_text.png"));
		}else if (this.type == "message") {
			this.fightBtn.visible = true;
			this.replySprite.visible = true;
			this.replySprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("liuyan_text.png"));
		}else if (this.type == "system") {
			this.fightBtn.visible = true;
			this.lingQuLabel.visible = true;
			this.lingQuLabel.setString("查看信息");
		}
	},
	onConfirmTaped:function() {

	},
	awardSucc:function(){
		MailModule.deleteAwardMails(this.id);
		postNotifcation(NOTI.REFRESH_MAIL_LAYER);
	},
	onFightTaped:function() {
		if (this.type == "award") {
			MailModule.doOnGetMailAwards(this.id, this.awardSucc());
		} else if (this.type == "message") {
			var name = this.data.senderName || "";
			var uid = this.data.sender;
			var type = "mails";
			var levelMessageLayer = new LeaveMessageLayer(name, uid, type);
			cc.director.getRunningScene().addChild(levelMessageLayer);
		} else if (this.type == "system") {
			var text = this.data.content;
			var cb = new ConfirmBox({info:text, type:1, confirm:function() {
			}.bind(this), close:function(){
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		}
	}
});