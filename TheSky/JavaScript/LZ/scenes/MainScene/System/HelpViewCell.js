var HelpViewCell = cc.Node.extend({
	ctor:function(idx) {
		this._super();
		this.index = idx;
		cc.BuilderReader.registerController("HelpCellViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.HelpCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
		this.initData();
	},
	initData:function() {
		var helpdata = HelpModule.getHelpInfo();
		var cellData = helpdata["" + (this.index)];
		if (cellData) {
			this.title.setString(cellData.id);
			this.context.setString(cellData.content);
			if (cellData.icon && cellData.icon != "") {
				this.icon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(cellData.icon));
			}
		}
	},
})