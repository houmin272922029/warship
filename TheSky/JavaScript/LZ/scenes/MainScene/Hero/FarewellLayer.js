var FarewellLayer = cc.Layer.extend({
	/**
	 * 
	 * @param desHeroUid 加经验的英雄
	 * @param srcHero 被送吧的英雄
	 * @param uiType 0没有选择离队伙伴 1选择了离队伙伴，预览界面 2送别后的结果
	 * @param exitcb 退出页面的通知
	 */
	ctor:function(desHeroUid, srcHeroUid, uiType, exitNoti){
		this._super();
		this.desHeroUid = desHeroUid;
		this.srcHeroUid = srcHeroUid;
		this.uiType = uiType || 0;
		this.exitNoti = exitNoti || NOTI.GOTO_HEROES;
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("FarewellLayerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.FarewellView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		if (ItemModule.getItemCount("item_009") > 0 || ItemModule.getItemCount("item_008") == 0) {
			this.SMPType = 1;
		} else {
			this.SMPType = 0;
		}
		this.updateFWUI();
	},
	updateFWUI:function(){
		
		var desHero = HeroModule.getHeroByUid(this.desHeroUid);
		var srcHero = HeroModule.getHeroByUid(this.srcHeroUid);
		
		if (desHero) {
			if (!this.pedestalLeft.getChildByTag(123)) {
				var cfg = HeroModule.getHeroBoneRes(desHero.heroId);
				var node = common.createBone(cfg.name, cfg.amount);
				this.pedestalLeft.addChild(node, 0, 123);
				node.puppet.getAnimation().play("Idle");
				node.scale = 0.7;
				var size = this.pedestalLeft.getContentSize();
				node.attr({
					x:size.width / 2,
					y:size.height / 3 * 2,
					anchorX:0.5,
					anchorY:0
				})
			}
		}
		
		if (srcHero) {
			if (!this.pedestalRight.getChildByTag(123)) {
				var cfg = HeroModule.getHeroBoneRes(srcHero.heroId);
				var node = common.createBone(cfg.name, cfg.amount);
				this.pedestalRight.addChild(node, 0, 123);
				node.puppet.getAnimation().play("Idle");
				node.scale = 0.7;
				var size = this.pedestalRight.getContentSize();
				node.attr({
					x:size.width / 2,
					y:size.height / 3 * 2,
					anchorX:0.5,
					anchorY:0
				})
			}
		} else {
			if (this.pedestalRight.getChildByTag(123)) {
				this.pedestalRight.removeChildByTag(123, true);
			}
		}
		

		this.noSelTip.visible = this.uiType === 0;
		this.noSelTip1.visible = this.uiType !== 1;
		this.noSelTip2.visible = this.uiType !== 1;
		this.srcName.visible = this.uiType === 1;
		this.srcLV.visible = this.uiType === 1;
		this.srcLevel.visible = this.uiType === 1;
		this.previewFrame.visible = this.uiType === 1;
		this.breakFiger.visible = this.uiType !== 1;
		this.reslutLayer.visible = this.uiType === 2;
		
		if (this.uiType === 0) {
		} else if (this.uiType === 1) {
			this.srcName.setString(srcHero.name);
			this.srcLevel.setString(srcHero.level);
			this.preSrcNameLabel.setString(common.LocalizedString("%s贡献:", srcHero.name));
			this.preDesLevelLabel.setString(common.LocalizedString("%s等级:", desHero.name));
			var addExp = this.SMPType === 0 ? Math.floor(srcHero.expAll * 0.8) : srcHero.expAll
			this.preSrcExp.setString(addExp);
			this.preDesLevelOri.setString(desHero.level);
			this.preDesLevelResult.setString(HeroModule.getHeroLevel(desHero.exp, desHero.expAll + addExp));
			this.needItem = HeroModule.getFarewellItemForHeroUId(this.srcHeroUid);
			this.preGetPYDCount.setString(this.needItem);
			this.bloodItem = HeroModule.getFarewellBlood(HeroModule.getHakiTrainTotalCost(srcHero.aggress), this.SMPType);
			this.preGetBloodCount.setString(this.bloodItem);
			var itemId = this.SMPType === 0 ? "item_008" : "item_009";
			this.preSMPName.setString(ItemModule.getItemName(itemId));
			var cfg = ItemModule.getItemConfig(itemId);
			this.smpBtn.setNormalImage(new cc.Sprite("#frame_" + cfg.rank + ".png"));
			this.ItemBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_"+ cfg.rank + ".png"));
			if (cfg.icon) {
				this.smpIcon.setTexture(common.formatLResPath("icons/" + cfg.icon + ".png"));
			}
		} else if (this.uiType === 2) {
			this.oriLevel.setString(this.desOriHeroInfo.level);
			this.oriHp.setString(this.desOriHeroInfo.hp);
			this.oriDef.setString(this.desOriHeroInfo.def);
			this.oriAtk.setString(this.desOriHeroInfo.atk);
			this.oriInt.setString(this.desOriHeroInfo.mp);
			this.oriPoint.setString(this.desOriHeroInfo.point);
			this.oriBreak.setString(this.desOriHeroInfo.oriBreak);
			var attr = HeroModule.getHeroBasicAttrsByUid(this.desHeroUid);
			this.reslutLevel.setString(desHero.level);
			this.reslutHp.setString(attr.hp);
			this.reslutDef.setString(attr.def);
			this.reslutAtk.setString(attr.atk);
			this.reslutInt.setString(attr.mp);
			this.resultPoint.setString(desHero.point)
			this.resultBreak.setString(desHero["break"])
			this.gainLBQCount.setString(this.needItem);
			this.gainBloodCount.setString(this.bloodItem);
		}
		this.desName.setString(desHero.name);
		this.desLevel.setString(desHero.level);
		
	},
	onBackClicked:function(){
		if (typeof this.exitNoti === "string") {
			postNotifcation(this.exitNoti);
		} else {
			this.exitNoti.apply();
		}
	},
	onFareWellClicked:function(){
		if (this.uiType === 0) {
			this.onClickedPedesta();
			common.showTipText(common.LocalizedString("玩家还未选择角色"));
		} else if (this.uiType === 1) {
			if ((this.SMPType === 0 && ItemModule.getItemCount("item_008") === 0) && (this.SMPType === 1 && ItemModule.getItemCount("item_009") === 0)) {
				common.showTipText(common.LocalizedString("您的生命牌不足,请选择购买"));
				//TODO 弹出购买生命牌窗口
			}
			this.desOriHeroInfo = HeroModule.getHeroBasicAttrsByUid(this.desHeroUid)
			var desHero = HeroModule.getHeroByUid(this.desHeroUid);
			this.desOriHeroInfo.level = desHero.level;
			this.desOriHeroInfo.point = desHero.point;
			this.desOriHeroInfo.oriBreak = desHero["break"];
			
			HeroModule.doFarewell(this.desHeroUid, this.srcHeroUid, this.SMPType + 1, function(dic){
				this.uiType = 2;
				this.srcHeroUid = null;
				this.updateFWUI();
				HeroModule.getHeroAttrsByHeroUId(uid);
			}.bind(this), function(dic){
				traceTable("fail", dic);
			});
		}
	},
	onClickedPedesta:function(){

	},
	onClickedSMP:function(){
		var layer = new SelectSMPLayer(this.selectItem.bind(this));
		cc.director.getRunningScene().addChild(layer);
	},
	onClickedPedestal:function(){
		postNotifcation(NOTI.GOTO_FAREWELLSELHERO, {uid : this.desHeroUid});
	},
	selectItem:function(type){
		this.SMPType = type;
		this.updateFWUI();
	}
});