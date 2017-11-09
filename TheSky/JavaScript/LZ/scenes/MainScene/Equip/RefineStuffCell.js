var RefineStuffCell = cc.Node.extend({
	used:0,
	ctor:function(item, used, func){
		this._super();
		this.item = item;
		this.used = used;
		this.func = func;

		cc.BuilderReader.registerController("EquipRefineMaterialCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.RefineStuffCell_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		this.materialCountLabel.setString(item.count - this.used);
		this.frame.setNormalImage(new cc.Sprite("#frame_" + item.rank + ".png"));
		this.frame.setSelectedImage(new cc.Sprite("#frame_" + item.rank + ".png"));
		this.equipIcon.setTexture(common.getIconById(item.icon));
		this.equipIcon.visible = true;
		this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + item.rank + ".png"));
		this.frame5.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + item.rank + ".png"));
//		this.levelLabel.setString(item.sort);
		this.colorLayer.visible = item.count == this.used;
		this.frame.setEnabled(false);
	},
	onEnter:function(){
		this._super();
		var icon = this.equipIcon;
		this.listener = common.registerTouchedEvent(icon, this.touchedCallback.bind(this), 
				this.beganCallback.bind(this), this.endCallback.bind(this));
	},
	onExit:function(){
		this._super();
		if (this.listener) {
			cc.eventManager.removeListener(this.listener);
			this.listener = null;
		}
		this.unschedule(this.startSelect);
		this.unschedule(this.selectItem);
	},
	selectItem:function(){
		var item = this.item;
		if (item.count === this.used) {
			this.unschedule(this.startSelect);
			this.unschedule(this.selectItem);
			common.showTipText(common.LocalizedString("您的仓库里没有此材料，去起航\n闯关可以有机会获得喔！"));
			return;
		}
		this.used++;
		this.materialCountLabel.setString(item.count - this.used);
		this.func(this.item.id);
		if (item.count === this.used) {
			this.colorLayer.visible = true;
		}
	},
	touchedCallback:function(){
		this.selectItem();
	},
	startSelect:function(){
		this.schedule(this.selectItem, 0.1);
	},
	beganCallback:function(){
		this.schedule(this.startSelect, 1, 1);
	},
	endCallback:function(){
		this.unschedule(this.startSelect);
		this.unschedule(this.selectItem);
	}

});