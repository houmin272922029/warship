var ItemDetailInfoView = cc.Layer.extend ({
	TYPE:{
		wareHouse:0,    //仓库  左 无 右 开启 属性 配置
		vip:1,          //vip特权 左 无 右 无 属性 配置
		loguetown:2,	//商城 左 无 右 关闭 属性 配置
		itembuy:3,      //道具购买 左 购买 右 关闭 属性 配置
	},
	ctor:function( param){
		this._super();
		this.itemId = param.info;
		this.type = param.param;
		this.close = param.close;
		if (this.type === this.TYPE.wareHouse || this.vip === this.TYPE.vip || this.loguetown === this.TYPE.loguetown) {
			if (typeof item === "string") {
				this.item = ItemModule.getItemConfig(itemId);
			}
		}
		cc.BuilderReader.registerController("ItemDetailInfoOwner", {
		})
		this.node = cc.BuilderReader.load(ccbi_res.ItemDetailInfoView_ccbi , this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
		this.refersh();
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	refersh:function(){
		this.closeBtn.visible = false;
		this.closeText.visible = false;
		this.useBtn.visible = false;
		this.useText.visible = false;
		var name = "";
		var res = common.getResource(this.itemId);
		if(res.iconType === 0) {
			var config = ItemModule.getItemConfig(this.itemId);
			if (!config) {
				config = EquipModule.getEquipConfig(this.itemId);
				name = config.name;
				this.despLabel.setString(EquipModule.getEquipConfig(this.itemId).desp);
			} else {
				name = ItemModule.getItemName(this.itemId);
				var rankSp = ItemModule.getItemRank(this.itemId);
				this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + rankSp + "_icon.png"));
				this.despLabel.setString(ItemModule.getItemDes(this.itemId));
			}
			this["itemIcon"].setTexture(res.icon);
		} else {
			name = HeroModule.getHeroConfigById(this.itemId).name;
			this["itemIcon"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(this.itemId)));
			var rankSp = HeroModule.getHeroConfigById(this.itemId).rank;
			this.rankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + rankSp + "_icon.png"));
			this.despLabel.setString(HeroModule.getHeroConfigById(this.itemId).desp);
			var cfg = ItemModule.getItemConfig(this.itemId)
			this.itemBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("itemInfoBg_2_" + cfg.rank + ".png"));
			this.nameLabel.setString(cfg.name);
			this.itemIcon.setTexture(common.getIconById(cfg.icon));
			this.rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + cfg.rank + "_icon.png"));
			this.despLabel.setString(cfg.desp);
			//this.countLabel.setString(cfg.price);
			switch (this.type) {
			case this.TYPE.itembuy:
				this.closeText.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("goumai_title.png"));
				break;
			}
		}
		
	},
	leftBtnAction:function() {
		if (this.type === this.TYPE.itembuy) {
			postNotifcation(NOTI.GOTO_SHOPBUYSOMEPOPUP, {info:this.item.id, type:0, exit:exit});
		}
		this.closeItemClick();
	},
	useAction:function() {
		this.removeFromParent(true);
		var item = this.item;
		var cb = new RewardsLayer({info:this.item, type:0, close:function(){
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	
})




