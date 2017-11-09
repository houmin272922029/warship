var NewWorldSecondLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("NewWorldSecondViewOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.NewWorldSecondView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		var blooddatas = blooddata.datas;
		this.secondStarLabel.setString(this.secondStarLabel.getString() + blooddatas.firstBuffRecord);
		this.attrLabel.setString(this.attrLabel.getString() + blooddatas.firstBuff);
		this.attrLabel_s.setString(this.attrLabel_s.getString() + blooddatas.firstBuff);
	},
	attrItemClick:function(sender){
		var tag = sender.getTag();
		var attr;
		if (tag == 1) {
			attr = "atk";
		} else if (tag == 2){
			attr = "def";
		} else if (tag == 3){
			attr = "hp";
		} else if (tag == 4){
			attr = "mp";
		}
		BloodModule.doOnAddBuff(attr, this.addFirstBuffCallback);
	},
	addFirstBuffCallback:function(){
		postNotifcation(NOTI.BLOOD_REFRESH_STATE);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});