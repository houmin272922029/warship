var UnionMemberCell = cc.Node.extend({
	ctor:function(data){
		this._super();
		cc.BuilderReader.registerController("UnionRankMemberInfoCellViewOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionMemberCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		if (data.vipLevel > 0) {
			this.memberName.setString(data.name + "(V" + data.vipLevel + ")");
		} else {
			this.memberName.setString(data.name);
		}
		this.level.setString("LV:" + data.level);
		this.arenaRank.setString(data.arenaRank);
		this.duty.setString(UnionModule.getUnionDuty(data.duty).name);
	}
});