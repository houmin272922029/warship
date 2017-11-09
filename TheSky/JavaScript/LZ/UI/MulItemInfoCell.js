var QuestCell = cc.Node.extend({
	ctor:function(itemData){
		this._super();
		cc.BuilderReader.registerController("MultiItemCellOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.MultiItemCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.itemData = itemData;
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		
	},
});