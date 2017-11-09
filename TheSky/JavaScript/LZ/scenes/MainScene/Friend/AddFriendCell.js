var AddFriendCell = cc.Node.extend({
	ctor:function(dataInfo, idx){
		this._super();
		cc.BuilderReader.registerController("AddFriendViewCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.AddFriendViewCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.dataInfo = dataInfo;
		this.idx = idx;
		this.refresh();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	refresh:function(){
		this.levelLabel.setString(this.dataInfo.level);
		this.nameLabel.setString(this.dataInfo.name);
		
		this.isInvited.visible = false;
		this.addFriendBtn.visible = true;
		this.addTitle.visible = true;
		
	},
	inviteFriendCallBack:function(){
		postNotifcation(NOTI.REFRESH_ADDFRIEND_LAYER);
	},
	addFriendTaped:function(){
		
		traceTable(this.dataInfo)
		FriendModule.doOnInviteFriend(this.dataInfo.id, this.inviteFriendCallBack.bind(this));
	},
});