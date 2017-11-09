var UnionRankCell = cc.Node.extend({
	ctor:function(idx, data, self){
		this._super();
		cc.BuilderReader.registerController("UnionRankTableCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionRankCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		
		if (data.id === self) {
			this.bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("union_cellBg_0.png"));
		}
		this.unionName.setString(data.name);
		this.unionOwnerName.setString(data.ceoName);
		this.unionLevel.setString(data.level);
		this.unionMemberNum.setString(data.membersCount + "/" + UnionModule.getUnionPlayerMax(data.level));
		this.unionRankNum.setString(idx);
	}
});