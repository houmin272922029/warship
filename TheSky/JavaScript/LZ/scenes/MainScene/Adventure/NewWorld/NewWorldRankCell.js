var NewWorldRankCell = cc.Node.extend({
	ctor:function(rankInfo, idx){
		this._super();
		cc.BuilderReader.registerController("newWorldRankCellOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.newWorldRankCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.rankInfo = rankInfo;
		this.rankLabel.setString(idx + 1);
		this.nameLabel.setString(rankInfo.name);
		this.stageLabel.setString(rankInfo.bestOutpostNum);
		if (this.rankInfo.succession == 0) {
			this.lainxuLabel.visible = false;
		} else {
			this.lainxuLabel.setString(common.LocalizedString("连续进榜%d天",rankInfo.succession));
		}
		this.levelLabel.setString(common.LocalizedString("LV：%d",rankInfo.level));
		this.starLabel.setString(common.LocalizedString("得星：%d",rankInfo.bestRecord));
		this.playerFormItem.setTag(idx + 1);
	},
	playerFormItemClick:function(){
		var id = this.rankInfo.id;
		//TODO获取阵容 传入玩家id
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	}
});