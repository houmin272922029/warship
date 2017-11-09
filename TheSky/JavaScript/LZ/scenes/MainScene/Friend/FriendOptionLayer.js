var FriendOptionLayer = cc.Layer.extend({
	ctor:function(type, heroInfo){
		this._super();
		this.type = type;
		this.heroInfo = heroInfo;
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("FriendOptionLayerOwner",{
		});
		this.node = cc.BuilderReader.load(ccbi_res.FriendOptionLayer_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.titleLabel.setString(this.heroInfo.name);
		if (this.type == "enemy") {
			if (this.heroInfo.type && this.heroInfo.type == 0) {
				this.title2.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("juedou_text.png"));
			} else {
				this.title2.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("fanji_text.png"));
			}
			this.title3.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("guanzhu_text.png"));
		} else if (this.type == "attention") {
			this.title2.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("quxiaoguanzhu_text.png"));
			this.title3.visible = false;
			this.btn3.visible = false;
		}
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	actionTap1:function(){
		cc.director.getRunningScene().addChild(new LeaveMessageLayer(this.heroInfo.name, this.heroInfo.id));
	},
	cancelFollowFriendCallBack:function(){
		common.ShowText(common.LocalizedString("fri_attent_cancel"));
		postNotifcation(NOTI.FRFRESH_FRIEND_LAYER);
		this.removeFromParent(true);
	},
	actionTap2:function(){
		if (this.type == "friends") {
			//TODO 获取阵容
			trace("获取阵容");
		} else if (this.type == "enemy") {
			if (this.heroInfo.type == 0) {
				//比武
				postNotifcation(NOTI.GOTO_ARENA, {page : "fight"});
			} else if (this.heroInfo.type == 1){
				//残页
				if (getJsonLength(chapterdata.chapters) > 0) {
					postNotifcation(NOTI.GOTO_ADVENTURE, {page:AdventureModule.adventurePage});
					postNotifcation(NOTI.MOVETO_PAGE, {page : AdventureModule.getUserAdventureList().length - 1});
				}
			}
		} else if (this.type == "attention") {
			//取消关注
			FriendModule.doOnUnAttentionFriend(this.heroInfo.id, this.cancelFollowFriendCallBack.bind(this));
		}
		this.removeFromParent(true);
	},
	deleteFriendCallBack:function(){
		common.ShowText(common.LocalizedString("fri_del_succ"));
		postNotifcation(NOTI.FRFRESH_FRIEND_LAYER);
		this.removeFromParent(true);
	},
	followFriendCallBack:function(){
		common.ShowText(common.LocalizedString("fri_attent_succ"));
		postNotifcation(NOTI.FRFRESH_FRIEND_LAYER);
	},
	actionTap3:function(){
		if (this.type == "friends") {
			//删除好友
			FriendModule.doOnDeleteFriend(this.heroInfo.id, this.deleteFriendCallBack.bind(this));
		} else if (this.type == "enemy") {
			//关注
			FriendModule.doOnAttentionFriend(this.heroInfo.id, this.followFriendCallBack.bind(this));
		}
	},
});