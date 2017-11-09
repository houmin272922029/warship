var EquipDetail = cc.Layer.extend({
	TYPE:{
		team:0, 		// 阵容 左 强化 右 更换 属性 全
		equips:1,		// 列表 左 强化 右 关闭 属性 全
		show:2,			// 展示 左 无 右 关闭 属性 全
		handbook:3,		// 图鉴 左 无 右 关闭 属性 配置
		shard:4,		// 装备碎片 左 无 右 关闭 属性 配置
	},
	ctor:function(equip, type, param){
		this._super();
		this.equip = equip;
		this.type = type;
		this.param = param;
		if (this.type === this.TYPE.handbook || this.type === this.TYPE.shard) {
			if (typeof equip === "string") {
				this.equip = EquipModule.getEquipConfigInfo(equip);
			}
		} else {
			if (typeof equip === "string") {
				this.equip = EquipModule.getEquip(equip);
			}
		}
		this.initLayer();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("EquipInfoOwner", {
		});
		cc.BuilderReader.registerController("EquipInfoCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.EquipDetail_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.refresh();
	},
	refresh:function(){
		this.equipInfoName.enableStroke(cc.color(32, 18, 9), 2);
		var equip = this.equip;
		var cfg = this.equip.cfg;
		//this.itemBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("itemInfoBg_2_" + equip.rank + ".png"));
		this.name.setString(cfg.name);
		this.icon.setTexture(common.getIconById(cfg.icon));
		if (this.type === this.TYPE.shard) {
			this.chipIcon.visible = true;
		}
		this.rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + equip.rank + "_icon.png"));
		if (this.type === this.TYPE.handbook || this.type === this.TYPE.shard) {
			this.levelBg.visible = false;
			this.level.visible = false;
		} else {
			this.level.setString(equip.level);
		}
		for (var k in equip.attr) {
			var v = equip.attr[k];
			this.attrIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this.attr.setString(v < 1 ? "+ " + Math.floor(v * 100) + "%" : "+ " + v);
		}
		// TODO 合成
		if (this.type === this.TYPE.team || this.type === this.TYPE.equips || this.type === this.TYPE.show) {
			
		}
		this.desp.setString(cfg.desp);
		this.price.setString(equip.price);
		this.leftText.enableStroke(cc.color(32, 18, 9), 2);
		this.rightText.enableStroke(cc.color(32, 18, 9), 2);
		switch (this.type) {
		case this.TYPE.show:
		case this.TYPE.handbook:
		case this.TYPE.shard:
			this.leftItem.visible = false;
			this.leftText.visible = false;
			break;
		case this.TYPE.team:
			this.rightText.setString(common.LocalizedString("更换装备"));
			break;
		default:
			break;
		}
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	leftItemClick:function(){
		if (this.type === this.TYPE.team || this.type === this.TYPE.equips) {
			var exit = NOTI.GOTO_EQUIPS;
			if (this.param && this.param.exit) {
				exit = this.param.exit;
			}
			postNotifcation(NOTI.GOTO_EQUIPUPDATE, {eid:this.equip.id, type:1, exit:exit});
			this.closeItemClick();
		}
	},
	rightItemClick:function(){
		if (this.type === this.TYPE.team) {
			var hid = this.param.hid;
			var pos = this.param.pos;
			var idx = FormModule.getIndexWithUid(hid);
			postNotifcation(NOTI.GOTO_EQUIP_CHANGE, {hid:hid, pos:pos, eid:this.equip.id, exit:function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : idx});
			}});
			this.closeItemClick();
		} else {
			this.closeItemClick();
		}
	}
	
});