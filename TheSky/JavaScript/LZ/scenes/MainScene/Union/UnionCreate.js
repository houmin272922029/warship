var UnionCreate = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("UnionCreateLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionCreate_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeTipFun.bind(this));

		this.UnionCreateInfoTTF.setString(UnionModule.getCreateTip());
		this.createLeaguePayTTF.setString(UnionModule.getCreateCost());
		this.ed = new cc.EditBox(this.UnionCreateNameLayer.getContentSize(), new cc.Scale9Sprite("#chat_bg.png"), new cc.Scale9Sprite("#chat_bg.png"));
		this.ed.setPlaceHolder(common.LocalizedString("union_printUnionName"));
		this.ed.setPosition(this.UnionCreateNameLayer.getPosition());
		this.ed.setAnchorPoint(0.5, 0.5);
		this.ed.setFont(common.formatLResPath("FZCuYuan-M03S.ttf"), 30 * retina);
		this.UnionCreateNameLayer.getParent().addChild(this.ed);
		
	},
	closeTipFun:function(){
		this.removeFromParent(true);
	},
	createUnionFun:function(){
		var name = this.ed.string;
		if (name.length === 0) {
			common.showTipText(common.LocalizedString("union_empty"));
			return;
		}
		UnionModule.doCreate(name, function(dic){
			traceTable("create union succ", dic);
			postNotifcation(NOTI.UNION_CHANGESTATE, {state:0});
			this.closeTipFun();
		}.bind(this), function(dic){
			traceTable("create union fail", dic);
		})
	},
});