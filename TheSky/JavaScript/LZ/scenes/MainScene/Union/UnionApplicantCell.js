var UnionApplicantCell = cc.Node.extend({
	ctor:function(data){
		this._super();
		this.data = data;
		cc.BuilderReader.registerController("UnionApplicantCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionApplicantCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		this.captainNameLabel.setString(data.name);
		this.levelRankLabel.setString(data.level);
		this.DuelRankLabel.setString(data.arenaRank);
		this.menu.setSwallowTouches(false);
	},
	applicantCellClicked:function(){
		cc.director.getRunningScene().addChild(new UnionAcceptMember(this.data));
	},
});