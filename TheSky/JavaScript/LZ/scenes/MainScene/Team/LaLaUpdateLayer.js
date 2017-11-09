var LaLaUpdateLayer = cc.Layer.extend({
	ctor:function(idx){
		this._super();
		this.idx = idx;

		cc.BuilderReader.registerController("LaLaViewUpdataOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.LaLaUpdateLayer_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true);
		this.refresh();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	refresh:function(){
		var nameCfg = FormModule.getFSNameConfig(this.idx);
		var upCfg = FormModule.getFSUpgradeConfig(this.idx);
		var level = FormModule.getFormSevenLv(this.idx); // 当前等级
		if (level === getJsonLength(upCfg) - 1) {
			// 最大等级
			this.PercentBefore.visible = false;
			this.PercentAfter.visible = false;
			this.LvBefore.visible = false;
			this.LvAfter.visible = false;
			this.cardNeed.visible = false;
			this.cardOwn.visible = false;
			this.cardUpNeed.visible = false;
			this.cardUpSpend.visible = false;
			this.arrow1.visible = false;
			this.arrow2.visible = false;
			this.Icon1.visible = false;

			this.LvMax.visible = true;
			this.percentMax.visible = true;
			this.percentMax.setString("+" + (parseInt(upCfg[level] * 100)) + "%");
			this.Icon2.visible = true;
			var icon = nameCfg.attr === "mp" ? "int" : nameCfg.attr;
			this.Icon2.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(icon + "_icon.png"));
			this.TopLvUp.visible = true;
			
			this.SureBtn.visible = false;
			this.LvUpSprite.visible = false;
		} else {
			this.PercentBefore.setString("+" + (parseInt(upCfg[level] * 100)) + "%");
			this.PercentAfter.setString("+" + (parseInt(upCfg[level + 1] * 100)) + "%");
			this.LvBefore.setString("Lv." + level);
			var next = level + 1;
			this.LvAfter.setString("Lv." + (next == getJsonLength(upCfg) - 1 ? "Max" : next));
			var cost = FormModule.formSevenCost(this.idx, next);
			this.cardNeed.setString(cost);
			this.cardOwn.setString(ItemModule.getItemCount("item_014"));
			var icon = nameCfg.attr === "mp" ? "int" : nameCfg.attr;
			this.Icon1.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(icon + "_icon.png"));
			this.Icon2.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(icon + "_icon.png"));
		}
		
		if (level === FormModule.getFormSevenUpgradeMax(this.idx)) {
			this.SureBtn.setNormalImage(new cc.Sprite("#btn2_2.png"));
			this.SureBtn.setSelectedImage(new cc.Sprite("#btn2_2.png"));
		}
		this.SubstrateName.setString(nameCfg.name);
		this.LightIconSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("lala"+ this.idx + "_1.png"));
		
		this.LvName.setString("Lv." + level);
	},
	UpdateClicked:function(){
		var level = FormModule.getFormSevenLv(this.idx);
		if (level === FormModule.getFormSevenUpgradeMax(this.idx)) {
			var info = common.LocalizedString("LaLa.levelnotenough");
			var cb = new ConfirmBox({info:info, type:1});
			cc.director.getRunningScene().addChild(cb);
			return;
		}
		if (ItemModule.getItemCount("item_014") < FormModule.formSevenCost(this.idx, level + 1)) {
			var name = ItemModule.getItemName("item_014");
			var info = common.LocalizedString("lala_item_need", [name, name]);
			var cb = new ConfirmBox({info:info, confirm:function(){
				trace("goto daily");
				this.closeItemClick();
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
			return;
		}
		FormModule.doUpgradeFormSeven(this.idx - 1, function(dic){
			var upResult = dic.info.upResult;
			if (upResult && upResult == 1) {
				postNotifcation(NOTI.LALA_REFRESH);
				common.showTipText("升级成功！");
			} else {
				common.showTipText("升级失败！");
			}
			this.refresh();
		}.bind(this));
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	}
});