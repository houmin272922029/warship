var bossRankCell = cc.Node.extend({
	ctor:function(playerData){
		this._super();
		cc.BuilderReader.registerController("BossRankCellOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.BossRankCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.playerData = playerData;
		this.refresh();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	refresh:function(){
		if (this.playerData.rank && getJsonLength(this.playerData.rank) != 0) {
			this.rankLabel.setString(this.playerData.rank);
		}
		this.levelLabel.setString(common.LocalizedString("LV：%d",this.playerData.level));
		this.damageLabel.setString(common.LocalizedString("伤害血量：%d",this.playerData.damageAll));
		if (this.playerData.id == PlayerModule.getName()) {
			this.playerFormText.visible = false;
			this.playerFormItem.visible = false;
		}
	},
	showFontLabel:function(){
		if (this.playerData.type == 0) {
			this.rankLabel.visible = false;
			this.fontlabel1.visible = true;
			this.fontlabel2.visible = true;
		}
	},
	playerFormItemClick:function(){
		//TODO 阵容展示
	},
});