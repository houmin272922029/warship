var UnionMemberManageCell = cc.Node.extend({
	ctor:function(data){
		this._super();
		this.data = data;
		cc.BuilderReader.registerController("unionMemberCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionMemberManageCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		this.name.setString(data.name);
		this.identity.setString(UnionModule.getUnionDuty(data.duty).name);
		this.level.setString(data.level);
		this.rank.setString(data.arenaRank);
		this.contribute.setString(data.contribution);
	},
	onCellBgClicked:function(){
		if (this.data.id === PlayerModule.getPlayerId()) {
			cc.director.getRunningScene().addChild(new UnionQuit());
		} else {
			cc.director.getRunningScene().addChild(new UnionMemberManageMenu(this.data));
		}
	}
});