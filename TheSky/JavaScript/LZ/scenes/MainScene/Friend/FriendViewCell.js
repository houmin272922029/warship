var FriendViewCell = cc.Node.extend({
	ctor:function(type, dataInfo){
		this._super();
		this.type = type;
		this.dataInfo = dataInfo;
		cc.BuilderReader.registerController("FriendTableCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.FriendViewCell_ccbi, this);
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
		this.levelLabel.setString(common.LocalizedString("Lv:%s", this.dataInfo.level));
		this.nameLabel.setString(this.dataInfo.name);
		if (this.type == "friends") {
			this.rightBtn.visible = true;
			this.rightBtn.setNormalImage(new cc.Sprite("#btn_12_0.png"));
			this.rightBtn.setSelectedImage(new cc.Sprite("#btn_12_1.png"));
			this.rightTitle.visible = true;
			this.rightTitle.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("liuyan_text.png"));
		} else if (this.type == "enemy") {
			this.rightBtn.visible = true;
			this.rightTitle.visible = true;
			this.enemyFromLable.visible = true;
			this.rightBtn.setNormalImage(new cc.Sprite("#btn_12_0.png"));
			this.rightBtn.setSelectedImage(new cc.Sprite("#btn_12_1.png"));
			if (this.dataInfo.from == 0) {
				//比武
				this.rightTitle.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("juedou_text.png"));
				this.enemyFromLable.setString(common.LocalizedString("决斗仇敌"));
			} else {
				//残页
				this.rightTitle.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("fanji_text.png"));
				this.enemyFromLable.setString(common.LocalizedString("日常仇敌"));
			}
		} else if (this.type == "attention") {
			this.rightBtn.visible = false;
			this.rightTitle.visible = false;
		}
	},
	rightBtnAction:function() {
		if (this.type == "friends") {
			var layer = new LeaveMessageLayer(this.dataInfo.name, this.dataInfo.id);
			cc.director.getRunningScene().addChild(layer);
		} else if (this.type == "enemy") {
			if (this.dataInfo.type == 0) {
				//比武
				postNotifcation(NOTI.GOTO_ARENA, {page : "fight"});
			} else if (this.dataInfo.type == 1){
				//残页
				if (getJsonLength(chapterdata.chapters) > 0) {
					postNotifcation(NOTI.GOTO_ADVENTURE, {page:AdventureModule.adventurePage});
					postNotifcation(NOTI.MOVETO_PAGE, {page : AdventureModule.getUserAdventureList().length - 1});
				}
			}
		}
	},
	onBgTaped:function(){
		cc.director.getRunningScene().addChild(new FriendOptionLayer(this.type, this.dataInfo), 199, 199);
	},
});