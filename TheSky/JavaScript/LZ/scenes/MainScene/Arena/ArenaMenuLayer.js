var ArenaMenuLayer = cc.Layer.extend({
	ctor:function(player){
		this._super();
		cc.BuilderReader.registerController("ArenaMenuOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.ArenaMenu_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.player = player;
		this.name.setString(this.player.name);
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	addFriendClicked:function(){
		//TODO 添加好友
	},
	leaveMsgClicked:function(){
		//TODO 留言
		cc.director.getRunningScene().addChild(new LeaveMessageLayer(this.player.name, this.player.id));
	},
	onEnter:function(){
		this._super();
	},
	onEnter:function(){
		this._super();
	},
});