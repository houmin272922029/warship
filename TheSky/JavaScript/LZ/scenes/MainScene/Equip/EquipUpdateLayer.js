var EquipUpdateLayer = cc.Layer.extend({
	refineStage:0,
	stuffSelect:{},
	/**
	 * 装备改造界面
	 * 
	 * @param eid 装备id
	 * @param type 改造类型
	 * @param exit 退出后的方法 @require
	 */
	ctor:function(eid, type, exit){
		this._super();
		this.eid = eid;
		this.type = type || 1;
		this.exit = exit;
		cc.BuilderReader.registerController("EquipUpdateLayerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.EquipUpdateLayer_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		
	},
	onEnter:function(){
		this._super();
		SoundUtil.playMusic("audio/equipUpdate" + ".mp3", true);
		var self = this;
		this.initData();
		this.changeType(this.type);
	},
	onExit:function(){
		this._super();
	},
	initData:function(){
		this.equip = EquipModule.getEquip(this.eid);
		this.stuffs = ItemModule.getRefineStuffs(this.equip.equipId);
		this.stuffSelect = {};
		this.tab1.enableStroke(cc.color(32, 18, 9), 2);
		this.tab2.enableStroke(cc.color(32, 18, 9), 2);
		this.tab3.enableStroke(cc.color(32, 18, 9), 2);
		if (this.equip.rank < 3) {
			this.btn2.visible = false;
			this.btn3.visible = false;
			this.tab2.visible = false;
			this.tab3.visible = false;
		}
	},
	changeType:function(type){
		if (type === 3) {
			common.showTipText(common.LocalizedString("close_func"));
			return;
		}
		this["btn" + this.type].setNormalImage(new cc.Sprite("#btn_fenye_0.png"));
		this["btn" + this.type].setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		this["layer" + this.type].visible = false;
		this["menu" + this.type].visible = false;
		if (this.type === 3) {
			this.menuStuff.visible = false;
		}
		this.type = type;
		this["btn" + this.type].setNormalImage(new cc.Sprite("#btn_fenye_1.png"));
		this["btn" + this.type].setSelectedImage(new cc.Sprite("#btn_fenye_1.png"));
		this["layer" + this.type].visible = true;
		this["menu" + this.type].visible = true;
		if (this.type === 3) {
			this.menuStuff.visible = true;
		}
		switch (this.type) {
		case 1:
			this.refreshUpdate();
			break;
		case 2:
			this.refreshRefine();
			break;
		case 3:
			this.refreshCombine();
			break;
		default:
			break;
		}
	},
	tabClick:function(sender){
		var tag = sender.getTag();
		if (tag === this.type) {
			return;
		}
		if (tag === 2 && !FunctionModule.bOpen("equip_refine")) {
			common.showTipText(common.LocalizedString("船长等级超过18级才可精炼装备"));
			return;
		}
		this.changeType(tag);
	},
	/**
	 * 刷新强化界面
	 */
	refreshUpdate:function(){
		var equip = this.equip;
		var cfg = equip.cfg;
		this["1avatarFrame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + equip.rank + ".png"));
		this["1equipIcon"].visible = true;
		this["1equipIcon"].setTexture(common.getIconById(equip.equipId));
		this["1levelSprite"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + equip.rank + ".png"));
		this["1levelLabel"].setString(equip.level);
		this["1namelabel"].setString(cfg.name);
		this["1nowLevel"].setString(equip.level);
		this["1nextLevel"].setString((Number(equip.level) + 1));
		var grow = cfg.updateEffect;
		var refineGrow = (equip.stage * cfg.refine).toPrecision(2);
		this["1growBaseAttr"].setString(grow);
		this["1growTopAttr"].setString("+" + refineGrow);
		this["1growTopAttr"].visible = refineGrow > 0;
		var nextAttr = EquipModule.getEquipAttr(equip.equipId, equip.level + 1, equip.stage);
		for (var k in equip.attr) {
			this["1nowAttrIcon"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this["1nextAttrIcon"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this["1growAttrIcon"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this["1attrSprite"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this["1nowAttrLabel"].setString(equip.attr[k]);
			this["1nextAttrLabel"].setString(nextAttr[k]);
			var init = cfg.initial[k];
			this["1initAttrLabel"].setString(init);
		}
		this["1needLabel"].setString(Math.floor(EquipModule.getUpdateEquipCostCoe(equip.level) * cfg.updateSilver));
	},
	/**
	 * 刷新精炼界面
	 */
	refreshRefine:function(){
		if (!this.progress) {
			this.progress
			this.progress = new cc.ProgressTimer(new cc.Sprite("#refine_pro_green.png"));
			this.progress.type = cc.ProgressTimer.TYPE_BAR;
			this.progress.midPoint = cc.p(0, 0);
			this.progress.barChangeRate = cc.p(1, 0);
			this["2progressBg"].getParent().addChild(this.progress);
			this.progress.setPosition(cc.p(this["2progressBg"].x, this["2progressBg"].y));
			this.progress.percentage = 0;
		}
		this["2progressBg"].visible = true;
		this["2percentLabel"].setLocalZOrder(1);
		this["2percentLabel1"].setLocalZOrder(1);
		var equip = this.equip;
		var cfg = equip.cfg;
		this["2avatarFrame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + equip.rank + ".png"));
		this["2equipIcon"].setTexture(common.getIconById(equip.equipId));
		this["2levelSprite"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + equip.rank + ".png"));
		this["2levelLabel"].setString(equip.level);
		this.refreshStageProgress();
		this.addMaterialTable();
		this.tv.reloadData();
	},
	selectStuff:function(id){
		this.stuffSelect[id] = this.stuffSelect[id] || 0;
		this.stuffSelect[id]++;
		this.refreshStageProgress();
	},
	refreshStageProgress:function(){
		this.refineStage = this.equip.stage;
		var equip = this.equip;
		var cfg = equip.cfg;
		var refinelv = cfg.refinelv;
		var exp = equip.expNow || 0;
		var stuffExp = 0;
		for (var k in this.stuffSelect) {
			var count = this.stuffSelect[k];
			var item = ItemModule.getItemConfig(k);
			stuffExp += item.params * count;
		}
		exp += stuffExp;
		var max;
		while (true) {
			max = refinelv[Math.min(this.refineStage + 1, getJsonLength(refinelv)) + ""];
			if (exp < max) {
				break;
			}
			exp -= max;
			this.refineStage++;
		}
		this["2percentLabel1"].setString(exp);
		this["2percentLabel"].setString("/" + max);
		this["2percentLabel1"].enableStroke(cc.color(204, 0, 255), 2);
		this["2percentLabel"].enableStroke(cc.color(204, 0, 255), 2);
		this.progress.percentage = exp / max * 100;

		this["2expectShadowLabel"].setString(this.refineStage);
		this["2expectShadowLabel"].enableStroke(cc.color(0,129,106), 2);
		var grow = cfg.updateEffect;
		var refineGrow = (this.refineStage * cfg.refine).toPrecision(2);
		this["2growBaseAttr"].setString(grow);
		this["2growBaseAttr2"].setString(grow);
		this["2growTopAttr"].setString(refineGrow);
		this["2growTopAttr"].visible = refineGrow > 0;
		refineGrow = (this.refineStage * cfg.refine).toPrecision(2);
		this["2growTopAttr2"].setString("+" + refineGrow);
		this["2growTopAttr2"].visible = refineGrow > 0;
		var newAttr = EquipModule.getEquipAttr(equip.equipId, equip.level, this.refineStage);
		for (var k in equip.attr) {
			this["2nowAttrIcon"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this["2nextAttrIcon"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(common.getDisplayFrame(k)));
			this["2nowAttrLabel"].setString(equip.attr[k]);
			this["2preAttrLabel"].setString(newAttr[k]);
		}
		
		this["2stageLabel1"].setString(common.LocalizedString("%s阶", equip.stage));
		this["2stageLabel2"].setString(common.LocalizedString("%s阶", this.refineStage));
		this["2tipsLabel"].enableStroke(cc.color(172,75,9), 2);

		this["updateStage"].visible = this.refineStage > equip.stage;
	},
	addMaterialTable:function(){
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var layer = this["2materialLayer"];
		var size = cc.size(layer.getContentSize().width, layer.getContentSize().height);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL);
		this.tv.setBounceable(true);
		this.tv.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		})
		this.tv.setDelegate(this);
		layer.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(105, 105);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var item = this.stuffs[idx];
		var used = this.stuffSelect[item.id] || 0;
		var node = new RefineStuffCell(this.stuffs[idx], used, this.selectStuff.bind(this));
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.stuffs.length;
	},
	refreshCombine:function(){
		
		var equip = this.equip;
		var cfg = equip.cfg;
		this.combineDes.enableStroke(cc.color(32, 18, 9), 2);
		this["3avatarFrame"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + equip.rank + ".png"));
		this["3equipIcon"].setTexture(common.getIconById(cfg.icon));
		this["3levelSprite"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + equip.rank + ".png"));
		this["3levelbgLabel"].setString(equip.level);
		this["3levelLabel"].setString(equip.level);
		//this["progressBg"]
		
	},
	/**
	 * 退出
	 */
	exitClick:function(){
		if (typeof this.exit === "string") {
			postNotifcation(this.exit);
		} else {
			this.exit.apply();
		}
	},
	/**
	 * 强化
	 */
	updateClick:function(){
		var pLevel = PlayerModule.getLevel();
		if (this.equip.level >= pLevel * 3) {
			common.showTipText(common.LocalizedString("ERR_1601"));
			return;
		}
		var equip = this.equip;
		var cfg = equip.cfg;
		var level = equip.level
		var cost = Math.floor(EquipModule.getUpdateEquipCostCoe(level) * cfg.updateSilver);
		if (cost > PlayerModule.getBerry()) {
			common.showTipText(common.LocalizedString("ERR_1102"));
			return;
		}
		EquipModule.doUpdate(this.eid, function(dic){
			traceTable("update succ", dic);
			this.initData();
			var nextLevel = this.equip.level;
			this.updateEffect(nextLevel - level);
			this.refreshUpdate();
		}.bind(this), function(dic){
			traceTable("update fail", dic);
		}.bind(this))
	},
	updateEffect:function(level){
		var avatar = this["1avatarFrame"];
		var size = avatar.getContentSize();
		olAni.addPartical({
			plist:"images/eff_refineEquip_1.plist", 
			node:avatar,
			pos:cc.p(size.width / 2, size.height / 2),
			scale:2,
		});
		olAni.addPartical({
			plist:"images/eff_refineEquip_2.plist", 
			node:avatar,
			pos:cc.p(size.width / 2, size.height / 2),
			scale:4,
		});
		var cache = cc.spriteFrameCache;
		cache.addSpriteFrames(common.formatLResPath("fontPic.plist"));
		cache.addSpriteFrames("images/fightingNumber.plist");
		
		function textAction(sender){
			var remove = function(){
				sender.removeFromParent(true);
			}
			sender.runAction(cc.sequence(
				cc.scaleBy(0.1, 100),
				cc.scaleBy(0.1, 0.8),
				cc.delayTime(0.25),
				cc.fadeOut(0.1),
				cc.callFunc(remove)
			));
		}
		
		var pic1 = new cc.Sprite("#hit_+.png");
		var pic2 = new cc.Sprite("#hit_" + level + ".png");
		avatar.addChild(pic1);
		avatar.addChild(pic2);
		pic1.scale = 0.01;
		pic2.scale = 0.01;
		if (level >= 2) {
			var cri = new cc.Sprite("#equip_cri.png");
			avatar.addChild(cri);
			cri.attr({x:size.width / 2 - 40, y:size.height / 2});
			pic1.attr({x:size.width / 2 + 30, y:size.height / 2});
			pic2.attr({x:size.width / 2 + 60, y:size.height / 2});
			cri.scale = 0.01
			pic1.setColor(cc.color(255, 0, 0));
			pic2.setColor(cc.color(255, 0, 0));
			cri.setColor(cc.color(255, 0, 0));
			textAction(cri);
			textAction(pic1);
			textAction(pic2);
		} else {
			pic1.attr({x:size.width / 2 - 15, y:size.height / 2});
			pic2.attr({x:size.width / 2 + 15, y:size.height / 2});
			textAction(pic1);
			textAction(pic2);
		}
	},
	/**
	 * 精炼
	 */
	refineClick:function(){
		if (getJsonLength(this.stuffSelect) === 0) {
			common.showTipText(common.LocalizedString("请点选精炼材料"));
			return;
		}
		EquipModule.doRefine(this.eid, this.stuffSelect, function(dic){
			traceTable("refine succ", dic);
			this.refineEffect();
			var stage = this.equip.stage;
			this.initData();
			this.refreshRefine();
			var newStage = this.equip.stage;
			if (newStage > stage) {
				var result = new EquipRefineResult(this.eid, stage);
				cc.director.getRunningScene().addChild(result);
			}
		}.bind(this), function(dic){
			traceTable("refine fail", dic);
		});
	},
	refineEffect:function(){
		var avatar = this["2avatarFrame"];
		var size = avatar.getContentSize();
		olAni.addPartical({
			plist:"images/eff_refineEquip_1.plist", 
			node:avatar,
			pos:cc.p(size.width / 2, size.height / 2),
			scale:0.6 / retina,
		});
		olAni.addPartical({
			plist:"images/eff_refineEquip_2.plist", 
			node:avatar,
			pos:cc.p(size.width / 2, size.height / 2),
			scale:1.2 / retina,
		});
	}
	
});