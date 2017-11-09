var CusserviceCell = cc.Node.extend({
	ctor:function(idx) {
		this._super();
		this.index = idx;
		cc.BuilderReader.registerController("CusserviceCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.CusserviceCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
		this.initData();
	},
	initData:function() {
		var servicedata = CusserviceModule.getServiceInfo();
		var cellData = servicedata["" + (this.index)];
		if (cellData) {
			this.title.setString(cellData.id);
			this.context.setString(cellData.content1);
		}
	},
})