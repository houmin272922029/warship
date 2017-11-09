var UnionBuild = cc.Layer.extend({
	selected:0,
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("UnionUpgrateLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionBuild_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		var height = cc.winSize.height - this.BSTopLayer.getContentSize().height - mainBottomTabBarHeight * retina - this.bottomLayer.getContentSize().height * retina;
		this.bottomLayer.y = mainBottomTabBarHeight * retina;
		var size = this.avatarsContentLayer.getContentSize();
		this.avatarsContentLayer.setContentSize(cc.size(size.width, height / retina));
		this.avatarsContentLayer.y = mainBottomTabBarHeight * retina + this.bottomLayer.getContentSize().height * retina;
		size = this.avatarsContentLayer.getContentSize();
		this.data = UnionModule.getBuildingInfo(); 
		var index = 0;
		for (var i in this.data) {
			var x = Math.floor(i % 4) + 1;
			var y = 3 - Math.floor(i / 4);
			var posY = (y - 1) * 2 + 1;
			var posX = (x - 1) * 2 + 1;
			var avatar = this["avatar" + (Number(i) + 1)];
			var item = this["topBtn" + (Number(i) + 1)];
			item.setNormalImage(new cc.Sprite("#frame_1.png"));
			item.setSelectedImage(new cc.Sprite("#frame_1.png"));
			item.x = size.width * posX / 8;
			item.y = size.height * posY / 6;
			avatar.x = size.width * posX / 8;
			avatar.y = size.height * posY / 6;
			avatar.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(this.data[i].cfg.icon + ".png"));
		}
		this.previewIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_1.png"));
		this.upgrateBtn.visible = UnionModule.haveAuthority([10]);
		this.upgrateSprite.visible = UnionModule.haveAuthority([10]);
		this.candyBtn.visible = UnionModule.haveAuthority([12]);
		this.candySprite.visible = UnionModule.haveAuthority([12]);
		this.refresh();
	},
	refresh:function(){
		var data = this.data[this.selected];
		var frame = this.topMenu.getChildByTag(this.selected + 1);
		this.selFrame.setPosition(frame.getPosition());
		this.nameLabel.setString(data.cfg.name);
		if (data.id === "leagueshop") {
			this.despLable.setString(data.cfg.introduce.format(data.level));
		} else if (data.id === "leaguedepot") {
			var attr = UnionModule.getDepotAttrAddByLevel(data.level);
			this.despLable.setString(data.cfg.introduce.format([data.level, attr[0], attr[1], attr[2]]));
		} else {
			var attr = UnionModule.getAttrAddByLevel(data.level, data.id);
			this.despLable.setString(data.cfg.introduce.format([data.level, Math.floor(attr[0] * 100), Math.floor(attr[1] * 100)]));
		}
		this.bottomIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(data.cfg.icon + ".png"));
		if (data.cfg.icon.indexOf("huo") === 0) {
			this.textIcon.visible = true;
			this.textIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("huo_text.png"));
		} else if (data.cfg.icon.indexOf("lei") === 0) {
			this.textIcon.visible = true;
			this.textIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("lei_text.png"));
		} else if (data.cfg.icon.indexOf("di") === 0) {
			this.textIcon.visible = true;
			this.textIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("di_text.png"));
		} else if (data.cfg.icon.indexOf("shui") === 0) {
			this.textIcon.visible = true;
			this.textIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("shui_text.png"));
		} else if (data.cfg.icon.indexOf("feng") === 0) {
			this.textIcon.visible = true;
			this.textIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("feng_text.png"));
		} else {
			this.textIcon.visible = false;
		}
		this.levelLabel.setString(common.LocalizedString("union_currentLevel", data.level));
		this.needLabel.setString(data.cost);
	},
	onExitTaped:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:0});
	},
	onBuildingHelpTaped:function(){
		
	},
	oneOptionTaped:function(sender){
		var tag = sender.getTag();
		this.selected = tag - 1;
		this.refresh();
	},
	onUpgrateTaped:function(){
		var union = UnionModule.getUnionData();
		var data = this.data[this.selected];
		if (data.id === "leagueshop") {
			if (!UnionModule.bShopCanUpgrade()) {
				common.showTipText(common.LocalizedString("union_shopLimit"));
				return;
			}
		} else {
			if (data.level >= union.leagueInfo.level) {
				common.showTipText(common.LocalizedString("union_shopLimit"));
				return;
			}
		}
		if (data.cost > union.leagueInfo.depot.sweetCount) {
			var text = common.LocalizedString("union_candyNotEngouth")
			var cb = new ConfirmBox({info:text, confirm:function(){
				this.onContributeTaped();
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		} else {
			UnionModule.doUpgradeBuilding(data.id, function(dic){
				this.data = UnionModule.getBuildingInfo(); 
				this.refresh();
				var frame = this.topMenu.getChildByTag(this.selected + 1);
				olAni.addPartical({
					plist:"images/eff_unionUpgrateFire.plist", 
					node:this.avatarsContentLayer,
					pos:frame.getPosition(),
					duration:1,
					scale:0.75 / retina,
				});
			}.bind(this));
		}
	},
	onContributeTaped:function(){
		cc.director.getRunningScene().addChild(new UnionContribution());
	},
	onDistributeTaped:function(){
		postNotifcation(NOTI.UNION_CHANGESTATE, {state:6});
	},
});