var LaLaViewCell = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("LalaViewCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.LaLaViewCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}

		var size = this.node.getContentSize();
		this.setContentSize(size);
		this.refresh();
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.LALA_REFRESH, "refresh", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.LALA_REFRESH, "refresh", this);
	},
	refresh:function(){
		for (var i = 1; i <= 7; i++) {
			var lala = this["lala" + i];
			var head = this["head" + i];
			var headBg = this["headBg" + i];
			var lalaLabel = this["lalaLable" + i];
			var lalaIcon = this["lalaIcon" + i];
			var lalaMenu = this["lalaMenu" + i];
			lalaMenu.opacity = 0;
			var state = FormModule.formSevenState(i);
			lalaIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("lala" + i + "_" + (state != 3 ? 0 : 1) + ".png"));
			if (state == 0) {

			} else if (state == 1) {
				lala.setNormalImage(new cc.Sprite("#lalaView.png"));
				lala.setSelectedImage(new cc.Sprite("#lalaView.png"));
			} else if (state == 2) {
				lala.setNormalImage(new cc.Sprite("#frame_1.png"));
				lala.setSelectedImage(new cc.Sprite("#frame_1.png"));
				headBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_1.png"));
				headBg.visible = true;
				lalaLabel.visible = true;
			} else {
				var hid = FormModule.getFormSevenByIndex(i);
				var hero = HeroModule.getHeroByUid(hid);
				lala.setNormalImage(new cc.Sprite("#frame_" + hero.rank + ".png"));
				lala.setSelectedImage(new cc.Sprite("#frame_" + hero.rank + ".png"));
				head.visible = true;
				head.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(hero.heroId)));
				headBg.visible = true;
				headBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + hero.rank + ".png"));
			}
			var sevenLv = FormModule.getFormSevenLv(i);
			lalaLabel.setString("Lv." + (sevenLv === 5 ? "Max" : sevenLv));
			lalaLabel.setColor(cc.color(255, 120, 0));
			lalaLabel.visible = state > 1;

			var lalaLSprite = this["lalaLSprite" + i];
			lalaLSprite.visible = state > 1 && sevenLv < FormModule.getFormSevenUpgradeMax(i);
			if (sevenLv === 5) {
				lalaLSprite.visible = false;
			}
		}
		var attr = FormModule.getSevenFormAttr();
		var atk = attr.atk || 0;
		this.lala_atk_label.setString( atk);
		var def = attr.def || 0;
		this.lala_def_label.setString( def);
		var hp = attr.atk || 0;
		this.lala_hp_label.setString( hp);
		var mp = attr.mp || 0;
		this.lala_mp_label.setString( mp);
	},
	lalaItemClick:function(sender){
		var tag = sender.getTag();
		var state = FormModule.formSevenState(tag);
		if (state === 0) {
			common.showTipText(common.LocalizedString("lala_lock_tip", FormModule.getNextFormSevenMax()))
		} else if (state === 1) {
			if (!FormModule.formSevenCanOpen(tag)) {
				common.showTipText(common.LocalizedString("lala_open_last"));
				return;
			}
			// 需要道具弹框
			var name = ItemModule.getItemName("item_014");
			var info = common.LocalizedString("lala_useItem_open", name);
			var cb = new ConfirmBox({info:info, confirm:function(){
				var level = FormModule.getFormSevenLv(tag);
				var need = FormModule.formSevenCost(tag, level);
				if (ItemModule.getItemCount("item_014") > need) {
					FormModule.doOpenFormSeven(tag - 1, this.refresh.bind(this));
				} else {
					var info = common.LocalizedString("lala_item_need", [name, name]);
					var cb = new ConfirmBox({info:info, confirm:function(){
						postNotifcation(NOTI.GOTO_DAILY, {page : DailyName.KissMermaid});
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				}
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		} else if (state === 2) {
			postNotifcation(NOTI.GOTO_ONFORM, {page:tag - 1, type:1});
		} else {
			trace("show hero detail");
		}
	},
	lalaIconClick:function(sender){
		var tag = sender.getTag();
		var state = FormModule.formSevenState(tag);
		if (state > 1) {
			// 升级
			var layer = new LaLaUpdateLayer(tag);
			cc.director.getRunningScene().addChild(layer);
		} else {
			// 弹框
			var cfg = FormModule.getFSNameConfig(tag);
			var info = common.LocalizedString("lalaIcon_tips", [cfg.name, common.LocalizedString(cfg.attr), common.LocalizedString(cfg.attr)]);
			var cb = new ConfirmBox({info:info, type:1});
			cc.director.getRunningScene().addChild(cb);
		}
	}
});