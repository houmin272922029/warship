var UnionShopCell = cc.Node.extend({
	ctor:function(data){
		this._super();
		var shop = UnionModule.getUnionData().leagueInfo.shop;
		this.data = data;
		this.item = UnionModule.getShopItem(data.itemKey);
		cc.BuilderReader.registerController("UnionShopTableViewCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionShopCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		this.menu.setSwallowTouches(false);
		var count = data.buyLogs[PlayerModule.getPlayerId()] || 0;
		if (!UnionModule.bShopItemBought(data.itemKey, count)) {
			this.buyBtn.setNormalImage(new cc.Sprite("#btn2_2.png"));
			this.buyBtn.setSelectedImage(new cc.Sprite("#btn2_2.png"));
		}
		var cfg = this.item.cfg;
		this.updateLabel("nameLabel", cfg.name);
		this.updateLabel("countLabel", this.item.count);
		this.updateLabel("costLabel", this.item.cost);
		this.updateLabel("buyCount", this.item.max - count);
		var type = this.item.type;
		var cache = cc.spriteFrameCache;
		if (type === "shadow") {
			cache.addSpriteFrames(common.formatLResPath("shadow.plist"));
			olAni.playFrameAnimation("yingzi_" + cfg.icon + "_", this.shadowContent, 
					cc.p(this.shadowContent.getContentSize().width / 2, this.shadowContent.getContentSize().height / 2),
					1, 4, ShadowModule.getColorByRank(cfg.rank));
		} else if (type === "soul") {
			this.smallAvatarSprite.setSpriteFrame(HeroModule.getHeroHeadById(this.item.id));
			this.smallAvatarSprite.visible = true;
		} else {
			this.bigAvatarSprite.setTexture(common.getIconById(cfg.icon));
			this.bigAvatarSprite.visible = true;
			if (type === "shard") {
				this.chipIcon.visible = true;
			}
		}
		this.rankSprite.setSpriteFrame(cache.getSpriteFrame("rank_" + cfg.rank + "_icon.png"));
		if (type === "shadow") {
			this.avatarBtn.setNormalImage(new cc.Sprite("#s_frame.png"));
			this.avatarBtn.setSelectedImage(new cc.Sprite("#s_frame.png"));
			this.avatarBtn.x += 3;
			this.avatarBtn.y -= 5;
		} else {
			this.avatarBtn.setNormalImage(new cc.Sprite("#frame_" + cfg.rank + ".png"));
			this.avatarBtn.setSelectedImage(new cc.Sprite("#frame_" + cfg.rank + ".png"));
		}
		var need = UnionModule.getBuyStuffNeedShopLevel(this.item.level);
		if (shop.level >= need) {
			this.condition2Label.visible = false;
		} else {
			this.updateLabel("condition2Label", common.LocalizedString("shopNeedLv_string", need));
			this.buyBtn.setNormalImage(new cc.Sprite("#btn2_2.png"));
			this.buyBtn.setSelectedImage(new cc.Sprite("#btn2_2.png"));
		}
	},
	updateLabel:function(key, string){
		this[key].visible = true;
		this[key].setString(string);
	},
	onBuyBtnTaped:function(){
		var count = this.data.buyLogs[PlayerModule.getPlayerId()] || 0;
		if (!UnionModule.bShopItemBought(this.data.itemKey, count)) {
			common.showTipText(common.LocalizedString("超过最大购买次数"));
			return;
		}
		var shop = UnionModule.getUnionData().leagueInfo.shop;
		var need = UnionModule.getBuyStuffNeedShopLevel(this.item.level);
		if (shop.level < need) {
			common.showTipText(common.LocalizedString("需要商城达到%s级才可以购买", need));
			return;
		}
		UnionModule.doCandyShopBuy(this.item.level, function(dic){
			postNotifcation(NOTI.UNION_SHOP_REFRESH);
		});
	},
	onAvatarTaped:function(){
		var type = this.item.type;
		if (type === "soul") {
			cc.director.getRunningScene().addChild(new HeroDetail(this.item.id, 4, this.item.cfg.rank));
		} else if (type === "shadow") {
			
		} else if (type === "shard") {
			cc.director.getRunningScene().addChild(new EquipDetail(this.item.cfg.equip, 3));
		} else if (type === "book") {
			cc.director.getRunningScene().addChild(new SkillDetail(this.item.id, 2));
		}
	}
});