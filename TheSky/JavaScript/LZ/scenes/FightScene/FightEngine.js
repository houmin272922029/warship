var FightEngine = function(scene){
	this.scene = scene;
	this.units = {};
	this.layout = {left:[],right:[]};
	this.sCount = {left:0, right:0};
	this.sMax = {left:0, right:0};
	this.cursor = 0;
	this.aniSpeed = 1;
}

FightEngine.prototype = {
	analyseLog:function(){
		var log = this.log[this.cursor];
		this.cursor++;
		if (!log) {
			this.transition();
			return;
		}
		var action = log.action
		trace("action = " + action);
		var result = log.result;
		switch (action) {
		case "layout":
			this.setUnits(result);
			break;
		case "fieldBuff": 
			this.fieldBuff(result);
			break;
		case "buff":
			this.buff(result);
			break;
		case "fame":
			this.fame(result);
			break;
		case "init":
			this.refreshUnit(result);
			break;
		case "round":
			this.round(result);
//			this.transition();
			break;
		case "attack":
			this.attack(result);
//			this.transition();
			break;
		case "finish":
			this.finish(result);
			break;
		case "combo":
			this.combo(result);
//			this.transition();
			break;
		case "force":
			this.aniSpeed = 1;
			this.force(result);
			break;
		default:
			this.transition();
		break;
		}
//		this.transition();
	},
	force:function(log){
		var leftHp = log.leftHp;
		var leftMp = log.leftMp;
		var rightHp = log.rightHp;
		var rightMp = log.rightMp;
		var left = leftHp + leftMp;
		var right = rightHp + rightMp;
		var lDuration = left < right ? 6 : (6 / right * left);
		var rDuration = right < left ? 6 : (6 / left * right);
		var lmpDuration = leftMp / left * lDuration;
		var lhpDuration = leftHp / left * lDuration;
		var rmpDuration = rightMp / right * rDuration;
		var rhpDuration = rightHp / right * rDuration;
		var owner = {};
		var self = this;
		var units = [];
		cc.BuilderReader.registerController("decisiveBattleOwner", {
			"startToFadeIn":function(){
				var i_left = 1;
				var c_left = 1;
				var i_right = 1;
				var c_right = 1;
				for (var i in self.layout.left) {
					var u = self.layout.left[i];
					var info = u.info;
					var resId = info.resId;
					var cfg = HeroModule.getHeroBoneRes(resId);
					var actor = new Actor(this, cfg.name, cfg.amount);
					var unit = {};
					unit.ori = u;
					unit.actor = actor;
					unit.side = "left";
					unit.pos = u.oriPos;
					owner.rolesLayer.addChild(actor, u.localZOrder);
					actor.setAnchorPoint(0.5, 0.5);
					units.push(unit);
					var dstPosX = cc.winSize.width * 0.4 - cc.winSize.width * 0.05 * (c_left - 1);
					var dstPoxY = cc.winSize.height * 0.5 + ((c_left + 1) * 0.5 - i_left) * 25;
					i_left++;
					if (i_left > c_left) {
						i_left = 1;
						c_left++;
					}
					actor.scale = 0.5 * retina;
					actor.setPosition(u.oriPos);
					actor.opacity = 0;
					var array = [];
					array.push(cc.moveTo(0.4, dstPosX, dstPoxY));
					for (var j = 0; j < 5; j++) {
						var d = 10 - Math.random() * 20;
						array.push(cc.jumpBy(0.6, d * retina, 0, 5 * retina, 6));
						array.push(cc.jumpBy(0.6, -d * retina, 0, 5 * retina, 6));
					}
					actor.runAction(cc.sequence(array));
				}
				for (var i in self.layout.right) {
					var u = self.layout.right[i];
					var info = u.info;
					var resId = info.resId;
					var cfg = HeroModule.getHeroBoneRes(resId);
					var actor = new Actor(this, cfg.name, cfg.amount);
					var unit = {};
					unit.ori = u;
					unit.actor = actor;
					unit.side = "right";
					owner.rolesLayer.addChild(actor, u.localZOrder);
					actor.setAnchorPoint(0.5, 0.5);
					units.push(unit);
					var dstPosX = cc.winSize.width * 0.6 + cc.winSize.width * 0.05 * (c_right - 1);
					var dstPoxY = cc.winSize.height * 0.5 + ((c_right + 1) * 0.5 - i_right) * 25;
					i_right++;
					if (i_right > c_right) {
						i_right = 1;
						c_right++;
					}
					actor.scaleX = -0.5 * retina;
					actor.scaleY = retina * 0.5;
					actor.setPosition(u.oriPos);
					actor.opacity = 0;
					var array = [];
					array.push(cc.moveTo(0.4, dstPosX, dstPoxY));
					for (var j = 0; j < 5; j++) {
						var d = 10 - Math.random() * 20;
						array.push(cc.jumpBy(0.6, d * retina, 0, 5 * retina, 6));
						array.push(cc.jumpBy(0.6, -d * retina, 0, 5 * retina, 6));
					}
					actor.runAction(cc.sequence(array));
				}
				self.scene.runAction(cc.sequence(
					cc.delayTime(0.4),
					cc.callFunc(function(){
						for (var i in units) {
							var actor = units[i].actor;
							actor.puppet.getAnimation().play("atk");
						}
					})
				));
			},
			"tbLinesShow":function(){
				olAni.addPartical({
					plist:"images/eff_page_504.plist", 
					node:owner.rolesLayer,
					pos:cc.p(0, cc.winSize.height * 0.65),
					scaleX: 0.75,
					scaleY: 0.15,
					duration: 10,
				});
				olAni.addPartical({
					plist:"images/eff_page_504.plist", 
					node:owner.rolesLayer,
					pos:cc.p(cc.winSize.width, cc.winSize.height * 0.3),
					scaleX: -0.75,
					scaleY: 0.15,
					duration: 10,
				});
				olAni.addPartical({
					plist:"images/eff_decisiveBattle_4.plist", 
					node:owner.blackLayer,
					pos:cc.p(0, cc.winSize.height * 0.72),
					scale: 1,
					duration: 5,
				});
				olAni.addPartical({
					plist:"images/eff_decisiveBattle_4.plist", 
					node:owner.blackLayer,
					pos:cc.p(cc.winSize.width, cc.winSize.height * 0.37),
					scaleX: -1,
					scaleY: 1,
					duration: 5,
				});
			},
			"startFire":function(){
				olAni.addPartical({
					plist:"images/eff_decisiveBattle_2.plist", 
					node:owner.rolesLayer,
					pos:cc.p(cc.winSize.width / 2, cc.winSize.height * 0.48),
					scale: 1,
					duration: 5,
				});
				olAni.addPartical({
					plist:"images/eff_decisiveBattle_5.plist", 
					node:owner.rolesLayer,
					pos:cc.p(cc.winSize.width / 2, cc.winSize.height * 0.48),
					scale: 1,
					duration: 5,
				});
			},
			"startForcing":function(){
				var spiritBar_left = owner.sBar_left;
				var spiritBar_right = owner.sBar_right;
				var innerPowerBar_left = owner.innerPowerBar_left;
				var innerPowerBar_right = owner.innerPowerBar_right;
				var label_left = owner.label_left;
				var label_right = owner.label_right;
				var blackLayer = owner.blackLayer;
				var brightBoundary = owner.brightBoundary;
				olAni.addPartical({
					plist:"images/eff_decisiveBattle_1.plist", 
					node:blackLayer,
					pos:cc.p(innerPowerBar_left.x, innerPowerBar_left.y),
					scale: 1,
					duration: lmpDuration,
					action:cc.moveBy(lmpDuration, 252 * retina * 0.75, 0),
					tag:501
				});
				olAni.addPartical({
					plist:"images/eff_decisiveBattle_1.plist", 
					node:blackLayer,
					pos:cc.p(innerPowerBar_right.x, innerPowerBar_right.y),
					scale: 1,
					duration: rmpDuration,
					action:cc.moveBy(rmpDuration, -252 * retina * 0.75, 0),
					tag:502
				});
				innerPowerBar_left.runAction(cc.sequence(
					cc.moveBy(lmpDuration, 252 * retina * 0.75, 0),
					cc.callFunc(function(){
						for (var i in units) {
							var unit = units[i];
							if (unit.side === "left") {
								unit.actor.color = cc.color(255, 0, 0);
							}
						}
						label_left.setString(common.LocalizedString("fight_force_bone"));
						olAni.addPartical({
							plist:"images/eff_decisiveBattle_1.plist", 
							node:blackLayer,
							pos:cc.p(spiritBar_left.x, spiritBar_left.y),
							scale: 1,
							duration: lhpDuration,
							action:cc.moveBy(lhpDuration, 252 * retina * 0.75, 0),
							tag:503
						});
						var array = [];
						array.push(cc.moveBy(lhpDuration, 252 * retina * 0.75, 0));
						if (left < right) {
							array.push(cc.callFunc(function(){
								innerPowerBar_right.stopAllActions();
								spiritBar_right.stopAllActions();
								olAni.addPartical({
									plist:"images/eff_force_blood.plist", 
									node:blackLayer,
									pos:cc.p(brightBoundary.x - 50 * retina, brightBoundary.y),
									scaleX: -0.75,
									scaleY: 0.75,
									duration: 1.5,
									tag:503
								});
								var rightPar_1 = blackLayer.getChildByTag(502);
								if (rightPar_1) {
									rightPar_1.stopAllActions();
									rightPar_1.removeFromParent(true);
								}
								var rightPar_2 = blackLayer.getChildByTag(504);
								if (rightPar_2) {
									rightPar_2.stopAllActions();
									rightPar_2.removeFromParent(true);
								}
								var rightPar_3 = blackLayer.getChildByTag(505);
								if (rightPar_3) {
									rightPar_3.stopAllActions();
									rightPar_3.removeFromParent(true);
								}
								for (var i in units) {
									var unit = units[i];
									var actor = unit.actor;
									if (unit.side === "left") {
										actor.stopAllActions();
										actor.puppet.getAnimation().play("Damaged", -1, 0);
										var jump = [];
										jump.push(cc.jumpBy(2, cc.winSize.width * -0.3 * (1 + 0.02 * i), 75 * retina * (1 - 0.1 * i), 100 * retina * (1 - 0.1 * i), 1));
										jump.push(cc.jumpBy(1, -30 * retina, 0, 40 * retina, 1));
										jump.push(cc.jumpBy(0.5, -15 * retina, 0, 15 * retina, 1));
										actor.runAction(cc.spawn(
												cc.sequence(jump),
											cc.rotateBy(2, -50)
										));
										var ori = unit.ori;
										ori.dead();
									} else {
										actor.puppet.getAnimation().play("Idle");
									}
								}
							}));
							array.push(cc.delayTime(2.5));
							array.push(cc.callFunc(function(){
								self.forceNode.stopAllActions();
								self.transition();
							}));
						}
						spiritBar_left.runAction(cc.sequence(array));
					})
				));
				
				innerPowerBar_right.runAction(cc.sequence(
						cc.moveBy(rmpDuration, -252 * retina * 0.75, 0),
						cc.callFunc(function(){
							for (var i in units) {
								var unit = units[i];
								if (unit.side === "right") {
									unit.actor.color = cc.color(255, 0, 0);
								}
							}
							label_right.setString(common.LocalizedString("fight_force_bone"));
							olAni.addPartical({
								plist:"images/eff_decisiveBattle_1.plist", 
								node:blackLayer,
								pos:cc.p(spiritBar_right.x, spiritBar_right.y),
								scale: 1,
								duration: rhpDuration,
								action:cc.moveBy(rhpDuration, -252 * retina * 0.75, 0),
								tag:504
							});
							var array = [];
							array.push(cc.moveBy(rhpDuration, -252 * retina * 0.75, 0));
							if (left > right) {
								array.push(cc.callFunc(function(){
									innerPowerBar_left.stopAllActions();
									spiritBar_left.stopAllActions();
									olAni.addPartical({
										plist:"images/eff_force_blood.plist", 
										node:blackLayer,
										pos:cc.p(brightBoundary.x + 50 * retina, brightBoundary.y),
										scaleX: 0.75,
										scaleY: 0.75,
										duration: 1.5,
										tag:503
									});
									var leftPar_1 = blackLayer.getChildByTag(501);
									if (leftPar_1) {
										leftPar_1.stopAllActions();
										leftPar_1.removeFromParent(true);
									}
									var leftPar_2 = blackLayer.getChildByTag(503);
									if (leftPar_2) {
										leftPar_2.stopAllActions();
										leftPar_2.removeFromParent(true);
									}
									var leftPar_3 = blackLayer.getChildByTag(505);
									if (leftPar_3) {
										leftPar_3.stopAllActions();
										leftPar_3.removeFromParent(true);
									}
									for (var i in units) {
										var unit = units[i];
										var actor = unit.actor;
										if (unit.side === "right") {
											actor.stopAllActions();
											actor.puppet.getAnimation().play("Damaged", -1, 0);
											var jump = [];
											jump.push(cc.jumpBy(2, cc.winSize.width * 0.3 * (1 + 0.02 * i), 75 * retina * (1 - 0.1 * i), 100 * retina * (1 + 0.1 * i), 1));
											jump.push(cc.jumpBy(1, 30 * retina, 0, 40 * retina, 1));
											jump.push(cc.jumpBy(0.5, 15 * retina, 0, 15 * retina, 1));
											actor.runAction(cc.spawn(
													cc.sequence(jump),
													cc.rotateBy(2, 50)
											));
											var ori = unit.ori;
											ori.dead();
										} else {
											actor.puppet.getAnimation().play("Idle");
										}
									}
								}));
								array.push(cc.delayTime(2.5));
								array.push(cc.callFunc(function(){
									self.forceNode.stopAllActions();
									self.transition();
								}));
							}
							spiritBar_right.runAction(cc.sequence(array));
						})
				));
				
			}
		});
		this.forceNode = cc.BuilderReader.load(ccbi_res.FightForce_ccbi, owner);
		this.scene.fightEffectLayer.addChild(this.forceNode);
		this.forceNode.setPosition(0, 0);
		owner.blackLayer.setPosition(cc.winSize.width / 2, (cc.winSize.height - 500 * retina) / 2 + 412 * retina);
	},
	combo:function(logs){
		var unit = this.units[logs[0].sid];
		unit.addBuff({param:{"2hit":1}, skillName:"岚脚"}, function(){
			this.transition();
		}.bind(this));
	},
	finish:function(logs){

		var extra = this.scene.params.extra;
		if (extra.from === "guide") {
			cc.director.popScene();
			return;
		}
		var result = logs[0];
		var self = this;
		var owner = {};
		var node;
		if (result === "win") {
			cc.BuilderReader.registerController("congratulationsOwner", {
				"animationFinished":function(){
					self.transition();
					self.BattleEnd(result);
					node.removeFromParent(true);
				}
			});
			node = cc.BuilderReader.load(ccbi_res.FightWin_ccbi, owner);
			this.scene.addChild(node);
			node.attr({
				x:cc.winSize.width / 2,
				y:(cc.winSize.height + this.scene.bgForHeads.getContentSize().height * retina - 100 * retina) / 2,
				anchorX:0.5,
				anchorY:0.5,
				scale:retina
			});
		} else if (result === "lose") {
			cc.BuilderReader.registerController("gameoverOwner", {
				"gameoverFinished":function(){
					self.transition();
					self.BattleEnd(result);
					node.removeFromParent(true);
				}
			});
			node = cc.BuilderReader.load(ccbi_res.FightLose_ccbi, owner);
			this.scene.addChild(node);
		}
		function removeResultNode(){
		}
		if (this.forceNode) {
			this.forceNode.removeFromParent(true);
		}
	},
	BattleEnd:function(result){
		// 战斗结束，跳转逻辑
		trace("end");
		var extra = this.scene.params.extra;
		this.scene.addChild(new FightResult(extra, result, this.battleRound, this.scene.bVedio));
	},
	start:function(log, music){
		this.log = log;
		SoundUtil.playMusic("audio/" + music + ".mp3", true);
		this.units = {};
		this.layout = {left:[],right:[]};
		this.sCount = {left:0, right:0};
		this.sMax = {left:0, right:0};
		this.cursor = 0;
		this.init();
	},
	round:function(logs){
		var round = logs[0];
		this.battleRound = round;
		if (round === 3) {
			this.transition();
		} else {
			var self = this;
			var node;
			cc.BuilderReader.registerController("roundFightOwner", {
				"roundShowFinished":function(){
					self.transition();
					node.removeFromParent(true);
				}
			});
			node = cc.BuilderReader.load(ccbi_res.FightRound_ccbi, this);
			this.scene.addChild(node);
			this.roundColor_1.setTexture(common.formatLResPath("roundFight/roundColor_" + round + ".png"));
			this.roundColor_2.setTexture(common.formatLResPath("roundFight/roundColor_" + round + ".png"));
			this.roundColor_2.setBlendFunc(gl.ONE, gl.ONE);
			this.roundNum.setTexture(common.formatLResPath("roundFight/roundNum_" + round + ".png"));
			this.roundNum.setBlendFunc(gl.ONE, gl.ONE);
			node.setAnchorPoint(0.5, 0.5);
			node.setPosition(cc.winSize.width / 2, (cc.winSize.height + 
					this.scene.bgForHeads.getContentSize().height * retina - 100 * retina) / 2);
		}
	},
	/**
	 * 刷新unit
	 * 
	 * @param logs
	 */
	refreshUnit:function(logs){
		this.sCount = {left:0, right:0};
		this.layout = {left:[],right:[]};
		for (var k in logs) {
			var log = logs[k];
			log.hp = log.attr.hp;
			var unit = this.units[log.sid];
			unit.refreshInfo(log);
			this.layout[log.side].push(unit);
			this.sCount[log.side]++;
		}
		this.scene.refreshUnits();
		this.scene.setMembersCount({now:this.sCount.left, max:this.sMax.left}, 
				{now:this.sCount.right, max:this.sMax.right});
		this.refreshArrangement();
		this.refreshUnitsPosition();
		var self = this;
		this.scene.runAction(cc.speed(cc.sequence(
			cc.delayTime(0.5),
			cc.callFunc(function(){
				self.transition();
			})
		), this.aniSpeed));
	},
	/**
	 * 初始化unit
	 * 
	 * @param logs
	 */
	setUnits:function(logs){
		for (var k in logs) {
			var log = logs[k];
			var array = [];
			var unit = new Unit(log, this);
			this.units[log.sid] = unit;
			this.layout[log.side].push(unit);
			this.sCount[log.side]++;
			this.sMax[log.side]++;
			this.scene.setUnit(unit);
		}
		this.scene.setMembersCount({now:this.sCount.left, max:this.sMax.left}, 
			{now:this.sCount.right, max:this.sMax.right});
		this.refreshArrangement();
		this.refreshUnitsPosition(true);
		this.unitsMoveIn();
	},
	refreshArrangement:function(){
		var leftArrangement = this.scene.arrangement[this.sCount.left - 1];
		var rightArrangement = this.scene.arrangement[this.sCount.right - 1];
		this.arrangement = {left:leftArrangement, right:rightArrangement};
	},
	unitsMoveIn:function(){
		var semaphore = getJsonLength(this.units);
		function countdown(){
			semaphore--;
			if (semaphore === 0) {
				this.transition();
			}
		}
		for (var k in this.units) {
			var unit = this.units[k];
			var side = unit.info.side === "left" ? 1 : -1;
			unit.actor.runAction(cc.speed(cc.sequence(
				cc.delayTime(0.75 - side * 0.25),
				cc.moveTo(Math.random() * 3 * 0.075, unit.oriPos),
				cc.callFunc(countdown.bind(this))
			), this.aniSpeed));
		}
		
	},
	refreshUnitsPosition:function(bLayout){
		var left = this.layout.left;
		var right = this.layout.right;
		var scene = this.scene;
		var index = 0;
		var offset = cc.winSize.width * 0.6;
		for (var i in left) {
			var unit = left[i];
			if (unit.state === unit.STATE.DEAD) {
				continue;
			}
			var arrange = this.arrangement.left[index];
			var x = scene.referencePoint_left.x - arrange.x * cc.winSize.width * (0.43 - scene.battleFieldCrack) / retina;
			var y = scene.referencePoint_left.y + arrange.y * scene.battleFieldHeight / retina;
			var z = arrange.z;
			unit.setOriPos(cc.p(x, y));
			unit.setLocalZOrder(z);
			if (!bLayout) {
				unit.actor.runAction(cc.speed(cc.moveTo(0.25, x, y), this.aniSpeed));
			} else {
				unit.actor.setPosition(x - offset, y);
			}
			unit.actor.setLocalZOrder(z);
			index++;
		}
		index = 0;
		for (var i in right) {
			var unit = right[i];
			if (unit.state === unit.STATE.DEAD) {
				continue;
			}
			var arrange = this.arrangement.right[index];
			var x = scene.referencePoint_right.x + arrange.x * cc.winSize.width * (0.43 - scene.battleFieldCrack) / retina;
			var y = scene.referencePoint_right.y + arrange.y * scene.battleFieldHeight / retina;
			var z = arrange.z;
			unit.setOriPos(cc.p(x, y));
			unit.setLocalZOrder(z);
			if (!bLayout) {
				unit.actor.runAction(cc.speed(cc.moveTo(0.25, x, y), this.aniSpeed));
			} else {
				unit.actor.setPosition(x + offset, y);
			}
			unit.actor.setLocalZOrder(z);
			index++;
		}
	},
	/**
	 * 场地buff
	 * 
	 * @param logs
	 */
	fieldBuff:function(logs){
		var caster = logs[0];
		var len = getJsonLength(logs);
		var semaphore = len - 1;
		function countdown(){
			semaphore--;
			if (semaphore === 0) {
				this.transition();
			}
		}
		this.units[caster.sid].castFieldBuff(caster, buffSoldior.bind(this));
		function buffSoldior(){
			for (var i = 1; i < len; i++) {
				var buffer = logs[i];
				this.units[buffer.sid].addDebuff(buffer, countdown.bind(this));
			}
		}
	},
	/**
	 * 单体buff
	 * 
	 * @param logs
	 */
	buff:function(logs){
		var semaphore = getJsonLength(logs);
		function countdown(){
			semaphore--;
			if (semaphore === 0) {
				this.transition();
			}
		}
		for (var k in logs) {
			var buffer = logs[k];
			this.units[buffer.sid].addBuff(buffer, countdown.bind(this));
		}
	},
	fame:function(logs){
		var scene = this.scene;
		var log = logs[0];
		cc.spriteFrameCache.addSpriteFrames("images/fightingNumber.plist");
		var pics = [];
		var leftFame = new cc.Sprite("#vigour.png");
		scene.fightEffectLayer.addChild(leftFame);
		leftFame.attr({
			anchorX:0,
			anchorY:0.5,
			x:cc.winSize.width * 0.1,
			y:cc.winSize.height - 730 * 0.3 * retina,
			scale:retina,
			opacity:0
		});
		pics.push(leftFame);
		var left = String(log.left).split('');
		var startPosX1 = cc.winSize.width * 0.1 + leftFame.getContentSize().width * retina;
		for (var i in left) {
			var n = left[i];
			var number = new cc.Sprite("#vigour_" + n + ".png");
			scene.fightEffectLayer.addChild(number);
			number.attr({
				anchorX:0,
				anchorY:0.5,
				x:startPosX1,
				y:cc.winSize.height - 730 * 0.3 * retina,
				scale:retina,
				opacity:0,
			});
			pics.push(number);
			startPosX1 += number.getContentSize().width * retina * 0.8;
		}
		var startPosX2 = cc.winSize.width * 0.9;
		var right;
		if (log.right === -1) {
			right = ["unknown", "unknown", "unknown"];
		} else {
			right = String(log.right).split('');
		}
		for (var i = right.length - 1; i >= 0; i--) {
			var n = right[i];
			var number = new cc.Sprite("#vigour_" + n + ".png");
			scene.fightEffectLayer.addChild(number);
			number.attr({
				anchorX:1,
				anchorY:0.5,
				x:startPosX2,
				y:cc.winSize.height - 730 * 0.3 * retina,
				scale:retina,
				opacity:0,
			});
			pics.push(number);
			startPosX2 -= number.getContentSize().width * retina * 0.8;
		}

		var rightFame = new cc.Sprite("#vigour.png");
		scene.fightEffectLayer.addChild(rightFame);
		rightFame.attr({
			anchorX:1,
			anchorY:0.5,
			x:startPosX2,
			y:cc.winSize.height - 730 * 0.3 * retina,
			scale:retina,
			opacity:0
		});
		pics.push(rightFame);
		
		for (var i in pics) {
			var pic = pics[i];
			pic.runAction(cc.speed(cc.spawn(
				cc.fadeIn(0.25),
				cc.sequence(
					cc.delayTime(0.5),
					cc.spawn(
						cc.moveBy(0.5, 0, 100 * retina),
						cc.fadeOut(0.5)
					)
				)
			), this.aniSpeed));
		}
		// 先手
		var first = new cc.Sprite("#headStartIcon.png");
		var unit = this.layout[log.first][0];
		scene.fightEffectLayer.addChild(first);
		first.attr({
			x:cc.winSize.width / 2 + 100 * (log.first === "left" ? -1 : 1),
			y:cc.winSize.height - 730 * 0.7 * retina,
			scale:5,
			opacity:0
		});
		first.runAction(cc.speed(cc.spawn(
			cc.sequence(
				cc.delayTime(0.5),
				cc.fadeOut(0.25),
				cc.callFunc(function(){
					first.removeFromParent(true);
				})
			),
			cc.spawn(cc.scaleBy(0.25, 0.2), cc.fadeIn(0.25)).easing(cc.easeIn(5))
		), this.aniSpeed));
		
		scene.runAction(cc.speed(cc.sequence(
			cc.delayTime(1.75),
			cc.callFunc(function(){
				for (var i in pics) {
					var pic = pics[i];
					pic.removeFromParent(true);
				}
				this.transition();
			}.bind(this))
		), this.aniSpeed));
	},
	attack:function(logs){
		var attacker = logs[0];
		var map = {};
		for (var i = 1; i < getJsonLength(logs); i++) {
			var log = logs[i];
			map[log.sid] = map[log.sid] || [];
			map[log.sid].push(log);
		}

		var semaphore = getJsonLength(map);
		function countdown(unit){
			semaphore--;
			trace("countdown " + unit.info.sid + ":" + semaphore);
			unit.caster = null;
			if (semaphore === 0) {
				map = {};
				this.scene.runAction(cc.speed(cc.sequence(
					cc.delayTime(0.5),
					cc.callFunc(function() {
						this.transition();
					}.bind(this))
				), this.aniSpeed));
			}
		}
		var self = this;
		var unit = self.units[attacker.sid];
		function attacked(){
			for (var k in map) {
				var log = map[k];
				self.units[k].attacked(unit, log, countdown.bind(self));
			}
		}
		function startAttack(){
			var target;
			if (getJsonLength(map) === 1) {
				for (var k in map) {
					target = self.units[k];
					break;
				}
			} else {
				for (var k in map) {
					target = self.units[k];
					if (target.info.x === unit.info.x) {
						break;
					}
				}
			}
			unit.attack(target, attacked, attacker);
		}
		
		var scene = this.scene;
		if (attacker.skill) {
			trace("【使用技能】" + unit.info.name + "【" + attacker.sid + "】" + " use skill " + attacker.skill.id);
			
			var skill = attacker.skill;
			var id = skill.id;
			var cfg = SkillModule.getSkillConfig(id);
			
			traceTable("skill cfg", cfg);
			var skillName = cfg.name;
			var imageName = id.replace("book", "skillname");
			if (cfg.rank <= 2) {
				var bg = new cc.Sprite("images/EnemySkillNameBg.png");
				bg.setPosition(cc.winSize.width / 2, (cc.winSize.height - 150 * retina - cc.winSize.height / 2 * (1 - retina) / retina));
				scene.sailorsLayer.addChild(bg, 8);
				bg.scaleY = 0.1;
				bg.setAnchorPoint(0.5, 0.5);
				olAni.addPartical({
					plist:"images/enemySkillnamebg.plist", 
					node:bg,
					pos:cc.p(bg.getContentSize().width / 2, bg.getContentSize().height / 2),
					scale: 1 / retina,
					duration: 1,
				});
				var label = new cc.Sprite("images/" + imageName + ".png");
				label.scale = 0.7;
				bg.addChild(label);
				label.setPosition(bg.getContentSize().width / 2, bg.getContentSize().height / 2);
				label.setAnchorPoint(0.5, 0.5);
				bg.runAction(cc.speed(cc.sequence(
					cc.scaleBy(0.25, 1, 10),
					cc.delayTime(1),
					cc.callFunc(function(){
						bg.runAction(cc.fadeOut(0.25));
						label.runAction(cc.fadeOut(0.25));
					}),
					cc.delayTime(0.25),
					cc.callFunc(function(){
						startAttack();
						bg.removeFromParent(true);
					}.bind(this))
				), this.aniSpeed));
			} else {
				var mask = new cc.LayerColor(cc.color(0, 0, 0, 155), cc.winSize.width / retina, cc.winSize.height / retina - 311);
				scene.sailorsLayer.addChild(mask, 8);
				mask.setPosition(cc.winSize.width / 2 / retina * (retina - 1), (412 * retina - cc.winSize.height / 2 * (1 - retina)) / retina);
				mask.scaleX = unit.info.side === "left" ? -1 : 1;

				olAni.addPartical({
					plist:"images/eff_page_504.plist", 
					node:mask,
					pos:cc.p(0, mask.getContentSize().height / 2),
					scale: 1 / retina,
					duration: 5,
				});
				// 半身像
				var bust = new cc.Sprite(HeroModule.getHeroBust1ById(unit.info.id));
				var music = HeroModule.getHeroConfig(unit.info.id).maxAtkRoar_mp3 || "voice002";
				SoundUtil.playEffect("audio/" + music + ".mp3");
				
				mask.addChild(bust);
				bust.setAnchorPoint(0.5, 0);
				var h = 65;
				bust.setPosition(mask.getContentSize().width + bust.getContentSize().width, h);
				bust.runAction(cc.speed(cc.sequence(
					cc.moveTo(0.25, mask.getContentSize().width - bust.getContentSize().width * 0.4, h),
					cc.moveTo(1, mask.getContentSize().width - bust.getContentSize().width * 0.5, h),
					cc.moveTo(0.25, -bust.getContentSize().width * 0.5, h)
				), this.aniSpeed));
				// 三角
				var st = new cc.Sprite("images/skillTriangle.png");
				mask.addChild(st);
				st.attr({
					x:0,
					y:st.getContentSize().height / 2,
					anchorX:0,
					anchorY:0.5,
					scaleX:1,
					scaleY:0.1,
				});
				var label = new cc.Sprite("images/" + imageName + ".png");
				st.addChild(label);
				label.setAnchorPoint(1, 0.5);
				label.scale = 1.25;
				label.setPosition(0, st.getContentSize().height * 0.55);
				label.runAction(cc.speed(cc.moveTo(0.25, st.getContentSize().width * 0.4, 
						st.getContentSize().height * 0.46), this.aniSpeed));
				if (unit.info.side === "left") {
					label.setFlippedX(true);
				}
				st.setCascadeOpacityEnabled(true);
				st.runAction(cc.speed(cc.sequence(
					cc.scaleBy(0.25, 1, 10),
					cc.delayTime(1),
					cc.fadeOut(0.25)
				), this.aniSpeed));
				mask.runAction(cc.speed(cc.sequence(
					cc.delayTime(1.5),
					cc.fadeOut(0.5),
					cc.callFunc(function(){
						startAttack();
						mask.removeFromParent(true);
					}.bind(this))
				), this.aniSpeed));
			}
		} else {
			trace("【普通攻击】" + unit.info.name + "【" + attacker.sid + "】");
			startAttack();
		}
	},
}

FightEngine.prototype.oninit = function(event, from, to) {
	this.next();
}

FightEngine.prototype.onreading = function(event, from, to) {
	this.done();
	FightEngine.prototype.analyseLog.call(this);
}


FightEngine.prototype.onleavereading = function(event, from, to) {
	return StateMachine.ASYNC;
}

FightEngine.prototype.ondone = function(event, from, to) {
	if (this.cursor >= getJsonLength(this.log)) {
		trace("log is over");
	} else {
		this.next();
	}
}

StateMachine.create({
	target: FightEngine.prototype,
	events: [
	         {name : "init", from : "*", to : "idle"},
	         {name : "next", from : "idle", to : "reading"},
	         {name : "done", from : "reading", to : "idle"}
	         ]
});