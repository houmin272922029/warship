var ShadowDetail = cc.Layer.extend({
	TYPE:{
		team:0, 		// 阵容 左 升级 右 更换 
		shadows:1,		// 炼影 关闭
	},
	ctor:function(shadow, type, param){
		this._super();
		cc.BuilderReader.registerController("shadowPopupOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.shadowPopup_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.shadow = shadow;
		this.type = type;
		this.param = param;
		this.initLayer();
	},
	initLayer:function(){
		if (this.type === this.TYPE.team) {
			this.closeSprite.visible = false;
			this.closeBtn.visible = false;
		} else {
			this.upgrateShadow.visible = false;
			this.updateSprite.visible =false;
			this.changeBtn.visible = false;
			this.changeSprite.visible = false;
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.refresh();
	},
	refresh:function(){
		this.yingzixinxi.enableStroke(cc.color(32, 18, 9), 2);
		var shadow = this.shadow.shadow == null ? this.shadow : this.shadow.shadow;
		var cfg = this.shadow.cfg;
		olAni.playFrameAnimation("yingzi_" + cfg.icon + "_", this.shadowSpr,
				cc.p(this.shadowSpr.getContentSize().width / 2, this.shadowSpr.getContentSize().height / 2), 1, 4,
				common.getColorByRank(shadow.rank));
		this.name.setString(cfg.name);
		this.name.enableStroke(cc.color(32, 18, 9), 2);
		this.rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + shadow.rank + "_icon.png"));
		var attr = [];
		if (shadow.level) {
			this.level.setString(shadow.level);
			attr = ShadowModule.getShadowAttrByLevelAndCid(shadow.level, shadow.shadowId)
		} else {
			this.level.visible = false;
			this.lvSprite.visible = false;
			attr = ShadowModule.getShadowAttrByLevelAndCid(1, shadow.shadowId)
		}
//		var desp = "";
//		for (var i = 0; i < attr.length; i++) {
//			if (attr[i]) {
//				this["desp" + (i + 1)].visible = true;
//				var des = common.LocalizedString(cfg.property[i]);
//				this["desp" + (i + 1)].setString(des + " + " + attr[i]);
//			}
//		}
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	upgradeShadowClick:function(){
		if (this.type === this.TYPE.team) {
			var exit = NOTI.GOTO_SHADOW;
			if (this.param && this.param.exit) {
				exit = this.param.exit;
			}
			postNotifcation(NOTI.GOTO_SHADOW, {type:2, exit:exit});
			this.closeItemClick();
		}
	},
	changeShadowClick:function(){
		if (this.type === this.TYPE.team) {
			var hid = this.param.hid;
			var pos = this.param.pos;
			var idx = FormModule.getIndexWithUid(hid);
			postNotifcation(NOTI.GOTO_SHADOW_CHANGE, {hid:hid, pos:pos, sid:this.shadow.shadow.id, exit:function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : idx, type:1});
			}});
			this.closeItemClick();
		}
	},
});