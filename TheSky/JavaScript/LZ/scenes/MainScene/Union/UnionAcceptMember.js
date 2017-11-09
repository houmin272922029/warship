var UnionAcceptMember = cc.Layer.extend({
	ctor:function(data){
		this._super();
		this.data = data;
		cc.BuilderReader.registerController("UnionAcceptLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionAcceptMember_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	inviteBtnClicked:function(){
		UnionModule.doProcessApplicants([this.data.id], true, function(dic){
			postNotifcation(NOTI.UNION_MANAGE_REFRESH);
			this.closeItemClick();
		}.bind(this));
	},
});