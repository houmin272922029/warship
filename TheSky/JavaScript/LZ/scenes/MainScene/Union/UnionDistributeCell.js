var UnionDistributeCell = cc.Node.extend({
	ctor:function(data){
		this._super();

		cc.BuilderReader.registerController("UnionDistributeCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionDistributeCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		this.name.setString(data.name);
		this.identity.setString(UnionModule.getUnionDuty(data.duty).name);
		this.level.setString(data.level);
		this.contribute.setString(data.sweetCount);
		this.menu.setSwallowTouches(false);
		this.unSelectCell();
	},
	selectCell:function(){
		this.cellBg.setNormalImage(new cc.Sprite("#union_cellBg_0.png"));
		this.cellBg.setSelectedImage(new cc.Sprite("#union_cellBg_0.png"));
	},
	unSelectCell:function(){
		this.cellBg.setNormalImage(new cc.Sprite("#union_cellBg_1.png"));
		this.cellBg.setSelectedImage(new cc.Sprite("#union_cellBg_1.png"));
	},
});