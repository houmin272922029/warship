var TitleInfoLayer = cc.Layer.extend({
	// 0:点击全部称号只消失 1：添加全部称号层
	ctor:function( titleId, uiType){
		this._super();
		this.titleId = titleId;
		this.Type = uiType || 1;
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("TitleInfoOwner", {
		});
		cc.BuilderReader.registerController("TitleInfoCellOwner", {
		});
		node = cc.BuilderReader.load(ccbi_res.TitleInfoView_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.refresh();
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	allTitleTaped:function(){
		cc.director.getRunningScene().addChild(new AllTitleInfoLayer());
//		if (this.Type == 0) {
//			cc.director.getRunningScene().addChild(new AllTitleInfoLayer());
//		}else if (this.Type == 1) {
//			this.removeFromParent(true);
//		}
	},
	refresh:function(){
		var dic = TitlesModule.getOneTitleByTitleId(this.titleId);
		if (dic == null) {
			return;
		}
		this.nameLabel.setString(dic.cfg.name);
		if (dic.title.obtainFlag == 2) {
			if (dic.title.obtainTime == -1) {
				this.ownerState.setString(common.LocalizedString("title_notget"));
			}else {
				this.ownerState.setString(common.LocalizedString("title_passtime"));
			}
		}else {
			this.ownerState.setString(common.LocalizedString("title_alreadyget"));
		}
		if (dic.title.level > 0) {
			this.level.setString(common.LocalizedString("titleInfo_levelTitle",dic.title.level));
			this.levelBG.vivisble = true;
			this.level.vivisble = true;
		}else {
			this.level.vivisble = false;
			this.levelBG.vivisble = false;
		}
		if (dic.cfg.baseValue < 1) {
			if (dic.titlelevel == 0) {
				this.attr.setString(dic.cfg.baseValue * 100 + "%");
			}else {
				this.attr.setString(((dic.cfg.baseValue + (dic.title.level - 1) * dic.cfg.updateValue)* 100) + "%");
			}	
		}else {
			if (dic.title.level == 0) {
				this.attr.setString(dic.cfg.baseValue);
			}else {
				this.attr.setString(dic.cfg.baseValue + (dic.title.level - 1) * dic.cfg.updateValue);
			}
		}
		var texture = EquipModule.getEquipIconByEquipId(dic.title.titleId);
		if (texture) {
			this.haoxiangni.visible = true;
			this.haoxiangni.setTexture(texture);
		}
		if (dic.cfg.ifUpdate == 1) {
			if (dic.title.level <= dic.cfg.levelmax) {
				this.label1.visible = true;
				this.label1.setString(common.LocalizedString("title_timeline"));
				this.label2.visible = true;
				if (dic.cfg.expire == 24) {
					this.label2.setString(DateUtil.format(dic.title.obtainTime));
				}else {
					this.label2.setString(common.LocalizedString("title_longtime"));
				}
				this.label3.visible = true;
				this.label3.setString(common.LocalizedString("title_updateCondition"));
				this.label4.visible = true;
				this.label4.setString(dic.title.desc);
				this.attrSprite.visible = false;
				this.label5.visible = true;
				this.label5.setString(common.LocalizedString("title_updateqi"));
				this.label6.visible = true;
				if (dic.cfg.baseValue < 1) {
					this.label6.setString("+" + ((dic.cfg.baseValue + (dic.title.level - 1) * dic.cfg.updateValue)* 100) + "%");
				}else {
					this.label6.setString("+" + dic.cfg.baseValue + (dic.title.level - 1) * dic.cfg.updateValue);
				}
				if (dic.cfg.illus) {
					this.label7.visible = true;
					this.label8.visible = true;
					this.label7.setString(common.LocalizedString("title_insturction"));
					this.label8.setString(dic.cfg.illus);
				}else {
					this.label7.visible = false;
					this.label8.visible = false;
				}
			}
		}else if (dic.cfg.ifUpdate == 2) {
			this.label1.visible = true;
			this.label1.setString(common.LocalizedString("title_getTime"));
			this.label2.visible = true;
			if (dic.cfg.expire == 24) {
				this.label2.setString(DateUtil.format(dic.title.obtainTime));
			}else {
				this.label2.setString(common.LocalizedString("title_longtime"));
			}
			this.label3.visible = true;
			this.label3.setString(common.LocalizedString("title_updateCondition2"));
			this.label4.visible = true;
			this.label4.setString(dic.cfg.desc);
			if (dic.cfg.illus) {
				this.label7.visible = true;
				this.label8.visible = true;
				this.label7.setString(common.LocalizedString("title_insturction"));
				this.label8.setString(dic.cfg.illus);
			}else {
				this.label7.visible = false;
				this.label8.visible = false;
			}
		}
	},
})
		
