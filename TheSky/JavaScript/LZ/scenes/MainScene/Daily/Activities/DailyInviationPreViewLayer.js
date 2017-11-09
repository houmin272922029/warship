/**
 * 邀请奖励预览界面
 * 
 */
var DailyInviationPreViewLayer = DailyPopUpLayer.extend({
	ctor : function(params){
		this._super(params);

		this.viewData_ = params.viewData || null;
		
		this.initCCBLayer(ccbi_res.GetInvitePopUp_ccbi, "GetInviteRewardOwner", this, this);
		
		this.swallowLayer(this.infoBg);
		
		this.createListView(this.containLayer)


		for (var int = 0; int < this.viewData_.items.length; int++) {
			var item = new ItemDetialCell({
				cellData : this.viewData_.items[int]
			});
			
			this.listView_.pushBackCustomItem(item);
		}
	},

	closeItemClick : function() {
		this.closeView();
	},
	
	confirmBtnTaped : function() {
		this.closeView();
	}
});

/**
 * 英雄选择页面的一条
 */
var ItemDetialCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);
		
		this.cellData_ = params.cellData;
		
		this.size_ = params.size || cc.size(600,120);
		this.setContentSize(this.size_);
		
		cc.BuilderReader.registerController("GetSomeRewardCellOwner", {
			
		});
		this.node = cc.BuilderReader.load(ccbi_res.GetSomeBigRewardCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
				
		this.initCell();
	},
	
	initCell : function() {
		
		this.itemName.setString(this.cellData_.view.name);
		this.countLabel.setString(this.cellData_.amount);
	
		var texture = cc.textureCache.addImage(this.cellData_.view.icon);

		if (texture != null) {
			this["avatarSprite"].setVisible(true);
			this["avatarSprite"].setTexture(texture);
		}
		
		this["rankFrame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(this.cellData_.view.rank)));
	}
});