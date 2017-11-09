var FightLayer = cc.Layer.extend({
	heads:{left:[], right:[]},
	ctor:function(params){
		this._super();
		this.params = params;
		this.log = params.log;
		this.engine = new FightEngine(this);
	},
	onEnter:function(){
		this._super();
		this.initLayer(this.params.bg || 1);
		this.engine.start(this.log, this.params.music);
		addObserver(NOTI.FIGHT_VEDIO, "playVedio", this);
	},
	onExit:function(){
		this._super();
		this.removeAllChildren(true);
		this.stopAllActions();
		removeObserver(NOTI.FIGHT_VEDIO, "playVedio", this);
	},
	playVedio:function(){
		this.bVedio = true;
		this.sailorsLayer.removeAllChildren(true);
		this.engine.start(this.log, this.params.music);
	},
	initLayer:function(bg){
		cc.BuilderReader.registerController("FightingLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.FightLayer_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		
		for (var i = 1; i < 6; i++) {
			this["teamName_left_" + i].setString(this.params.left || "");
			this["teamName_right_" + i].setString(this.params.right || "");
		}
		this.heads = {left:[], right:[]};
		for (var i = 1; i <= 8; i++) {
			var left = new HeroHead("left", this.engine);
			left.visible = false;
			this.heads.left.push(left);
			this["head_left_" + i].addChild(left);
			var right = new HeroHead("right", this.engine);
			right.visible = false;
			this.heads.right.push(right);
			this["head_right_" + i].addChild(right);
		}
		var bgLayer;
		switch (bg) {
		case 1:
			bgLayer = new FightBg1();
			break;
		default:
			trace("来个人帮我填坑，其他战斗背景还没写");
			bgLayer = new FightBg1();
			break;
		}
		this.fightingBgLayer.addChild(bgLayer);
		
		// 人物位置最下面一行的位置Y值，取背景图高度的1.05倍
		var yOfBottomLine = this.bgForHeads.getContentSize().height * 1.05 * retina;
		// 参考点坐标是屏幕宽度中间值和最下面一行人物位置的Y值
		var referencePoint = cc.p(cc.winSize.width / 2, yOfBottomLine);
		// 中间两个海贼团之间的间隙，共0.06
		this.battleFieldCrack = 0.06 / 2;
		// 左右两边的位置参考点
		this.referencePoint_left = cc.p(cc.winSize.width * (0.5 - this.battleFieldCrack), yOfBottomLine);
		this.referencePoint_right = cc.p(cc.winSize.width * (0.5 + this.battleFieldCrack), yOfBottomLine);
		// 站位面积的高度：屏幕高度 - 背景图高度的40% - 站位参考点的纵坐标
		this.battleFieldHeight = cc.winSize.height - 730 * 0.4 * retina - yOfBottomLine;
		// 根据人物数量配置的位置，结构为：横坐标相对位置，纵坐标相对位置，z轴
		this.arrangement = [
		    [{x:0.38, y:0.5, z:1}],
		    [{x:0.28, y:0.71, z:1}, {x:0.56, y:0.3, z:2}],
		    [{x:0.5, y:0.8, z:1}, {x:0.65, y:0.21, z:3}, {x:0.27, y:0.51, z:2}],
		    [{x:0.22, y:0.4, z:3}, {x:0.8, y:0.56, z:2}, {x:0.37, y:0.82, z:1}, {x:0.61, y:0.16, z:4}],
		    [{x:0.16, y:0.53, z:3}, {x:0.8, y:0.32, z:4}, {x:0.68, y:0.7, z:2}, {x:0.46, y:0.1, z:5},{x:0.37, y:0.86, z:1}],
		    [{x:0.13, y:0.74, z:2}, {x:0.61, y:0.17, z:6}, {x:0.23, y:0.26, z:5}, {x:0.62, y:0.85, z:1}, {x:0.41, y:0.5, z:4}, {x:0.85, y:0.53, z:3}],
		    [{x:0.24, y:0.23, z:6}, {x:0.76, y:0.75, z:2}, {x:0.82, y:0.29, z:5}, {x:0.54, y:0.49, z:4}, {x:0.18, y:0.71, z:3}, {x:0.45, y:0.86, z:1}, {x:0.51, y:0.15, z:7}],
		    [{x:0.08, y:0.5, z:5}, {x:0.34, y:0.68, z:2}, {x:0.42, y:0.28, z:7}, {x:0.69, y:0.91, z:1},{x:0.66, y:0.12, z:8}, {x:0.89, y:0.65, z:3}, {x:0.93, y:0.33, z:6}, {x:0.59, y:0.51, z:4}]
		];
		
	},
	
	setUnit:function(unit){
		var info = unit.info;
		var index = parseInt(info.sid.split(".")[1]) - 1;;
		var head = this.heads[info.side][index];
		head.visible = true;
		head.initHead(info);
		this.sailorsLayer.addChild(unit.actor);
	},
	/**
	 * 刷新单位
	 * 
	 * @param unit
	 */
	refreshUnits:function(){
		for (var i = 0; i < 8; i++) {
			this.heads.left[i].visible = false;
			this.heads.right[i].visible = false;
		}
		var units = this.engine.layout;
		var side = ["left", "right"];
		for (var i in side) {
			var k = side[i];
			for (var idx in units[k]) {
				var unit = units[k][idx];
				var info = unit.info;
				var head = this.heads[k][idx];
				head.visible = true;
				head.initHead(info);
				head.refreshHp(info.hp, info.baseHp);
			}
		}
	},
	/**
	 * 血条动画
	 * 
	 * @param unit
	 */
	headDamageAni:function(unit){
		var info = unit.info;
		var head = this.heads[info.side][info.x - 1];
		head.hpAni(info.hp, info.baseHp);
	},
	showDie:function(unit){
		var info = unit.info;
		var head = this.heads[info.side][info.x - 1];
		head.showDie();
	},
	/**
	 * 出站人数设置
	 * 
	 * @param left {Object}
	 * @param right {Object}
	 */
	setMembersCount:function(left, right){
		var lNow = left.now;
		var lMax = left.max;
		var rNow = right.now;
		var rMax = right.max;
		for (var i = 1; i < 6; i++) {
			this["rolesNumber_1_" + i].setString(lNow + "/" + lMax);
			this["rolesNumber_1_" + i].setLocalZOrder(2);
			this["rolesNumber_2_" + i].setString(rNow + "/" + rMax);
			this["rolesNumber_2_" + i].setLocalZOrder(2);
		}
		
		if (!this.leftBloodProgress) {
			this.leftBloodProgress = new cc.ProgressTimer(new cc.Sprite("#pro_yellow.png"));
			this.leftBloodProgress.type = cc.ProgressTimer.TYPE_BAR;
			this.leftBloodProgress.midPoint = cc.p(0, 0);
			this.leftBloodProgress.barChangeRate = cc.p(1, 0);
			this.bloodBarOnTitle_left.getParent().addChild(this.leftBloodProgress);
			this.leftBloodProgress.attr({
				x:this.bloodBarOnTitle_left.x,
				y:this.bloodBarOnTitle_left.y,
				anchorX:1,
				anchorY:0.5
			})
		}
		this.leftBloodProgress.percentage = lNow / lMax * 100;
		
		if (!this.rightBloodProgress) {
			this.rightBloodProgress = new cc.ProgressTimer(new cc.Sprite("#pro_yellow.png"));
			this.rightBloodProgress.type = cc.ProgressTimer.TYPE_BAR;
			this.rightBloodProgress.midPoint = cc.p(0, 0);
			this.rightBloodProgress.barChangeRate = cc.p(1, 0);
			this.bloodBarOnTitle_right.getParent().addChild(this.rightBloodProgress);
			this.rightBloodProgress.attr({
				x:this.bloodBarOnTitle_right.x,
				y:this.bloodBarOnTitle_right.y,
				anchorX:1,
				anchorY:0.5
			})
		}
		this.rightBloodProgress.percentage = rNow / rMax * 100;
	},
	/**
	 * 头像动画
	 * 
	 * @param unit
	 * @param action
	 */
	headAction:function(unit, action){
		var x = unit.info.x;
		var side = unit.info.side;
		var head = this.heads[side][x - 1];
		switch (action) {
		case "attack":
			head.attack();
			break;
		case "defend":
			head.defend();
			break;
		default:
			break;
		}
	},
});

var FightScene = cc.Scene.extend({
	/**
	 * 创建战场
	 * 
	 * @params params {Object}
	 */
	ctor:function(params){
		this.params = params || {};
		this._super();
	},
	onEnter:function(){
		this._super();
		var layer = new FightLayer(this.params);
		this.addChild(layer);
	},
	onExit:function(){
		this._super();
	}
});


