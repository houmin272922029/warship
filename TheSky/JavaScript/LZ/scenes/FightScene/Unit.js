var Unit = cc.Class.extend({
	info:null, // 数据
	oriPos:null, // 初始站位
	localZOrder:0, // 初始z
	actor:null, // 骨骼动画
	engine:null, // 引擎
	STATE:{
		ALIVE:0,
		DEAD:1,
	},
	ctor:function(info, engine){
		this.info = info;
		this.engine = engine;
		var resId = info.resId;
		var cfg = HeroModule.getHeroBoneRes(resId);
		this.actor = new Actor(this, cfg.name, cfg.amount);
		this.actor.scale = 0.8;
		var direction = this.info.side === "left" ? 1 : -1;
		this.actor.puppet.setScaleX(direction);
		this.state = this.STATE.ALIVE;
		this.idle();
	},
	movementDone:function(name){
//		trace("movementDone " + name)
		this.transition();
	},
	onTarget:function(){
		var isCallback = true;
		this.actor.runAction(cc.speed(cc.sequence(
				cc.callFunc(function() {
					SoundUtil.playEffect("audio/" + this.atk_mp3 + ".mp3");
				}.bind(this))
		), this.engine.aniSpeed));

		if (this.atkLogs.skill && this.atkLogs.skill.id) {
			var skillId = this.atkLogs.skill.id;
			var resTypeGoCfg = SkillModule.getSkillBoneTypeGoRes(skillId);
			var resCfg = SkillModule.getSkillBoneTypeOnRes(skillId);
			var cfg = SkillModule.getSkillConfig(skillId);
			var typego = cfg.typego;
			var typeon = cfg.typeon;
			traceTable("this.targetPos++++++", this.targetPos)
			
			if (typego) {
				this.actor.runAction(cc.speed(cc.sequence(
						cc.callFunc(function(){
							this.manager = ccs.armatureDataManager;
							for (var i = 0; i < resTypeGoCfg.amount; i++) {
								var jsonPath = "bone/skill/" + resTypeGoCfg.name + "/" + resTypeGoCfg.name + ".ExportJson";
								var img = "bone/skill/" + resTypeGoCfg.name + "/" + resTypeGoCfg.name +  i +".png";
								var plist = "bone/skill/" + resTypeGoCfg.name + "/" + resTypeGoCfg.name + i + ".plist";
								this.manager.addArmatureFileInfo(img, plist, jsonPath);
							}

							this.skillTypeGoPuppet = new ccs.Armature(resTypeGoCfg.name);
							this.skillTypeGoPuppet.getAnimation().play("Loop", 0, true);
							this.skillTypeGoPuppet.getAnimation().setSpeedScale(cfg.speed1);

							if (typego.typego == 1) { //地方单位为坐标的单体特效
								this.skillTypeGoPuppet.attr({
									x:this.targetPos.x < cc.winSize.width / 2 ? this.targetPos.x + cc.winSize.width * typego.offsetX : this.targetPos.x - cc.winSize.width * typego.offsetX,
									y:this.targetPos.y ,
									anchorX:0.5,
									anchorY:0.5
								});
								var offsetX = this.info.side === "left" ? cc.winSize.width * typego.offsetX : -cc.winSize.width * typego.offsetX;
								var offsetY = cc.winSize.height * typego.offsetY;
								this.skillTypeGoPuppet.runAction(cc.moveBy(2,  offsetX, offsetY));
							}else if (typego.typego == 2) {	//敌方单位为坐标的群体
								this.skillTypeGoPuppet.attr({
									x:this.oriPos.x + cc.winSize.width * typego.offsetX,
									y:this.oriPos.y + cc.winSize.height * typego.offsetY,
									anchorX:0.5,
									anchorY:0.5
								});
								var offset = this.info.side === "left" ? cc.winSize.width * typego.offsetX : -cc.winSize.width * typego.offsetY;
								var targetMidPointX = this.targetPos.x < cc.winSize.width / 2 ? cc.winSize.width / 5 * 3.5 - cc.winSize.width * typego.offsetX : cc.winSize.width / 5 * 1.5 - cc.winSize.width * typego.offsetX;
								var targetMidPointY = (cc.winSize.height + 390 * retina) / 2 + cc.winSize.height * typego.offsetY;
								this.skillTypeGoPuppet.runAction(cc.moveBy(2, this.targetMidPointX.x - this.oriPos.x + offset, this.targetMidPointY.y - this.oriPos.y));
							} else if (typego.typego == 3) { //战场地图中心为原点
								this.skillTypeGoPuppet.attr({
									x:this.targetPos.x < cc.winSize.width / 2 ? cc.winSize.width / 5 * 1.5 - cc.winSize.width * typego.offsetX : cc.winSize.width / 5 * 3.5 - cc.winSize.width * typego.offsetX,
									y:(cc.winSize.height + 390 * retina) / 2 + cc.winSize.width * cc.winSize.height * typego.offsetY,
									anchorX:0.5,
									anchorY:0.5
								});
								var offset = this.info.side === "left" ? cc.winSize.width * typego.offsetX : -cc.winSize.width * typego.offsetY;
								var targetMidPointX = this.targetPos.x < cc.winSize.width / 2 ? cc.winSize.width / 5 * 3.5 - cc.winSize.width * typego.offsetX : cc.winSize.width / 5 * 1.5 - cc.winSize.width * typego.offsetX;
								var targetMidPointY = (cc.winSize.height + 390 * retina) / 2 + cc.winSize.height * typego.offsetY;
								this.skillTypeGoPuppet.runAction(cc.moveBy(2, this.targetMidPointX.x - this.oriPos.x + offset, this.targetMidPointY.y - this.oriPos.y));
							} else if (typego.typego == 4) { //己方单位坐标的技能特效
								this.skillTypeGoPuppet.attr({
									x:this.targetPos.x < cc.winSize.width / 2 ? cc.winSize.width / 5 * 3.5 - cc.winSize.width * typego.offsetX : cc.winSize.width / 5 * 1.5 - cc.winSize.width * typego.offsetX,
											y:(cc.winSize.height + 390 * retina) / 2 + cc.winSize.height * typego.offsetY,
											anchorX:0.5,
											anchorY:0.5
								});
							} else {
								this.skillTypeGoPuppet.setPosition(this.targetPos.x, this.targetPos.y);
							}
							this.skillTypeGoPuppet.getAnimation().setMovementEventCallFunc(function(target, type, movementName){
								if (type > 0) {
									this.skillTypeGoPuppet.removeFromParent(true);
								}
							}.bind(this), this.skillTypeGoPuppet);
							this.engine.scene.addChild(this.skillTypeGoPuppet, 10);
						}.bind(this))
				), this.engine.aniSpeed));
			}
			if (typeon) {
				this.actor.runAction(cc.speed(cc.sequence(
						cc.callFunc(function(){
							this.manager = ccs.armatureDataManager;
							for (var i = 0; i < resCfg.amount; i++) {
								var jsonPath = "bone/skill/" + resCfg.name + "/" + resCfg.name + ".ExportJson";
								var img = "bone/skill/" + resCfg.name + "/" + resCfg.name +  i +".png";
								var plist = "bone/skill/" + resCfg.name + "/" + resCfg.name + i + ".plist";
								this.manager.addArmatureFileInfo(img, plist, jsonPath);
							}
							var judgeX = this.targetPos.x < cc.winSize.width / 2 ? - 1 : 1;
							this.skillPuppet = new ccs.Armature(resCfg.name);
							this.skillPuppet.getAnimation().play("Loop", 0, false);
							this.skillPuppet.getAnimation().setSpeedScale(cfg.speed2);

							if (typeon.typeon == 1) { //地方单位为坐标的单体特效
								this.skillPuppet.attr({
									x:this.targetPos.x + cc.winSize.width * typeon.offsetX * judgeX,
									y:this.targetPos.y + cc.winSize.height * typeon.offsetY,
									anchorX:0.5,
									anchorY:0.5
								});
							}else if (typeon.typeon == 2) {	//敌方单位为坐标的群体
								this.skillPuppet.attr({
									x:this.targetPos.x + cc.winSize.width * typeon.offsetX* judgeX,
									y:(cc.winSize.height + 390 * retina) / 2 + cc.winSize.height * typeon.offsetY,
									anchorX:0.5,
									anchorY:0.5
								});
							} else if (typeon.typeon == 3) { //战场地图中心为原点
								this.skillPuppet.attr({
									x:this.targetPos.x < cc.winSize.width / 2 ? cc.winSize.width / 5 * 1.5 - cc.winSize.width * typeon.offsetX* judgeX : cc.winSize.width / 5 * 3.5 - cc.winSize.width * typeon.offsetX* judgeX,
									y:(cc.winSize.height + 390 * retina) / 2 + cc.winSize.height * typeon.offsetY,
									anchorX:0.5,
									anchorY:0.5
								});
							} else if (typeon.typeon == 4) { //己方单位坐标的技能特效
								this.skillPuppet.attr({
									x:this.targetPos.x < cc.winSize.width / 2 ? cc.winSize.width / 5 * 3.5 - cc.winSize.width * typeon.offsetX* judgeX : cc.winSize.width / 5 * 1.5 - cc.winSize.width * typeon.offsetX* judgeX,
									y:(cc.winSize.height + 390 * retina) / 2 + cc.winSize.height * typeon.offsetY,
									anchorX:0.5,
									anchorY:0.5
								});
							} else {
								this.skillPuppet.setPosition(this.targetPos.x, this.targetPos.y);
							}
							this.skillPuppet.getAnimation().setMovementEventCallFunc(function(target, type, movementName){
								if (type > 0) {
									this.skillPuppet.removeFromParent(true);
								}
							}.bind(this), this.skillPuppet);
							this.skillPuppet.setScaleX(this.targetPos.x < cc.winSize.width / 2 ? -1 : 1)
							this.skillPuppet.getAnimation().setFrameEventCallFunc(function(target, event, originFrameIndex, currentFrameIndex){
								if (event === "ontarget" && isCallback && this.onTargetCallback) {
									isCallback = false;
									this.onTargetCallback();
									this.onTargetCallback = null;
								}
							}.bind(this), this.skillPuppet);
							this.engine.scene.addChild(this.skillPuppet, 10);
						}.bind(this))
				), this.engine.aniSpeed));
				return;
			}
		}
		if (this.onTargetCallback) {
			if (isCallback) {
				this.onTargetCallback();
				this.onTargetCallback = null;
			}
		}
	},
	setOriPos:function(pos){
		this.oriPos = pos;
	},
	setLocalZOrder:function(z){
		this.localZOrder = z;
	},
	refreshInfo:function(info){
		this.info = info;
	},
	/**
	 * 释放场地buff
	 * 
	 * @param log
	 * @param callback
	 */
	castFieldBuff:function(log, callback){
		this.log = log;
		var self = this;
		this.actor.runAction(cc.speed(cc.sequence(
			cc.callFunc(function(){
				trace("【释放场地buff】" + self.info.name + "【" + log.sid + "】" + " cast buff " + log.skillName);
			}.bind(this)),
			cc.callFunc(function(){
				if (callback) {
					callback();
				}
			})
		), this.engine.aniSpeed));
	},
	/**
	 * 添加buff效果
	 * 
	 * @param log
	 * @param callback
	 */
	addDebuff:function(log, callback){
		var param = log.param;
		var side = this.info.side;
		var buffSide = side === "left" ? -1 : 1;
		cc.spriteFrameCache.addSpriteFrames("images/buffText.plist");
		var chars = [];
		for (var k in param) {
			chars = k.split('');
		}
		olAni.addPartical({
			plist:"images/buff.plist", 
			node:this.actor,
			pos:cc.p(0, 0),
			scaleX:buffSide,
			scaleY:1
		});
		var buff = new cc.Sprite("#debuffIcon.png");
		this.actor.addChild(buff);
		buff.setAnchorPoint(0, 0.5);
		buff.runAction(cc.speed(cc.sequence(
				cc.repeat(cc.sequence(
				cc.moveBy(0.25, 0, 15),
				cc.moveBy(0.25, 0, -15)
			), 3),
			cc.fadeOut(0.25)
		), this.engine.aniSpeed));
		var startPosX = -30;
		var tSpArray = []
		for (var i in chars) {
			var char = chars[i];
			var text = new cc.Sprite("#debuff_" + char + ".png");
			tSpArray.push(text);
			this.actor.addChild(text);
			text.attr({
				x:startPosX,
				y:60,
				anchorX:0,
				anchorY:0.5
			});
			startPosX += text.getContentSize().width * 0.7;
			text.runAction(cc.speed(cc.sequence(
				cc.repeat(cc.sequence(
						cc.moveBy(0.25, 0, 15),
						cc.moveBy(0.25, 0, -15)
				), 3),
				cc.fadeOut(0.25)
			), this.engine.aniSpeed));
		}
		buff.setPosition(startPosX, 60);
		this.actor.runAction(cc.speed(cc.sequence(
			cc.delayTime(1.75),
			cc.callFunc(function(){
				for (var k in log.param) {
					trace("【添加debuff】" + this.info.name + "【" + this.info.sid + "】" + " got debuff " + log.skillName + "[" + k + ":" + log.param[k] + "]");
				}
				buff.removeFromParent(true);
				for (var i in tSpArray) {
					tSpArray[i].removeFromParent(true);
				}
			}.bind(this)),
			cc.delayTime(0.25),
			cc.callFunc(function(){
				if (callback) {
					callback();
				}
			})
		), this.engine.aniSpeed));
	},
	/**
	 * 释放buff
	 * 
	 * @param log
	 * @param callback
	 */
	addBuff:function(log, callback){
		var param = log.param;
		olAni.addPartical({
			plist:"images/buff.plist", 
			node:this.actor,
			pos:cc.p(0, 0),
			scaleX:this.info.side === "left" ? 1 : -1,
			scaleY:1
		});
		cc.spriteFrameCache.addSpriteFrames("images/buffText.plist");
		var chars = [];
		for (var k in param) {
			chars = k.split('');
		}
		var startPosX = -30;
		var buff = new cc.Sprite("#buffIcon.png");
		this.actor.addChild(buff);
		buff.setAnchorPoint(0, 0.5);
		buff.runAction(cc.speed(cc.sequence(
				cc.repeat(cc.sequence(
						cc.moveBy(0.25, 0, 15),
						cc.moveBy(0.25, 0, -15)
				), 3),
				cc.fadeOut(0.25)
		), this.engine.aniSpeed));
		var tSpArray = []
		for (var i in chars) {
			var char = chars[i];
			var text = new cc.Sprite("#buff_" + char + ".png");
			tSpArray.push(text);
			this.actor.addChild(text);
			text.attr({
				x:startPosX,
				y:60,
				anchorX:0,
				anchorY:0.5
			});
			startPosX += text.getContentSize().width * 0.7;
			text.runAction(cc.speed(cc.sequence(
					cc.repeat(cc.sequence(
							cc.moveBy(0.25, 0, 15),
							cc.moveBy(0.25, 0, -15)
					), 3),
					cc.fadeOut(0.25)
			), this.engine.aniSpeed));
		}
		buff.setPosition(startPosX, 60);
		this.actor.runAction(cc.speed(cc.sequence(
			cc.delayTime(1.75),
			cc.callFunc(function(){
				for (var k in log.param) {
					trace("【添加buff】" + this.info.name + "【" + this.info.sid + "】" + " got buff " + log.skillName + "[" + k + ":" + log.param[k] + "]");
				}
				buff.removeFromParent(true);
				for (var i in tSpArray) {
					tSpArray[i].removeFromParent(true);
				}
			}.bind(this)),
			cc.delayTime(0.25),
			cc.callFunc(function(){
				if (callback) {
					callback();
				}
			}.bind(this))
		), this.engine.aniSpeed));
	},
	/**
	 * 攻击
	 * 
	 * @param target 防御者
	 * @param callback 攻击动作命中的回调
	 */
	attack:function(target, callback, logs) {
		this.atkLogs = logs;
		this.targetPos = target.oriPos;
		this.onTargetCallback = callback;
		var id = this.info.resId;
		var cfg = HeroModule.getHeroConfig(id) || {};
		this.atk_mp3 = cfg.atk_mp3
		var range = cfg.range || 0;
		this.actor.setLocalZOrder(9);
		
		if (this.atkLogs.skill && this.atkLogs.skill.id) {
			range = SkillModule.getSkillConfig(this.atkLogs.skill.id).range || 0;
		}
		if (range === 0) {
			// 需要冲上去
			var offset = this.info.side === "left" ? -55 : 55;
			this.actor.runAction(cc.speed(cc.sequence(
				cc.moveBy(0.1, target.oriPos.x - this.oriPos.x + offset, target.oriPos.y - this.oriPos.y),
				cc.callFunc(function(){
					this.engine.scene.headAction(this, "attack");
					this.atk();
				}.bind(this))
			), this.engine.aniSpeed));
		} else {
			this.engine.scene.headAction(this, "attack");
			this.atk();
		}
	},
	/**
	 * 被攻击
	 * 
	 * @param caster 攻击方
	 * @param logs
	 * @param callback
	 */
	attacked:function(caster, logs, callback){
		traceTable(caster.info.sid, logs);
		this.caster = caster;
		this.logs = logs;
		this.callback = callback;
		var log = this.logs.shift();
		this.readAttacked(log);
	},
	readAttacked:function(log){
		var action = log.action;
		trace("attacked action = " + action);
		switch (action) {
		case "attacked":
			this.damaged(log);
			break;
		case "die":
			this.dead();
			break;
		case "undead":
			this.undead(log);
			break;
		case "rebound":
			this.rebound(log);
			break;
		default:
			break;
		}
	},
	rebound:function(log){
		cc.spriteFrameCache.addSpriteFrames("images/buffText.plist");
		var rebound = new cc.Sprite("#rebound_001.png");
		var actor = this.actor;
		actor.addChild(rebound);
		rebound.setAnchorPoint(0.3, 0.5);
		rebound.setPosition(0, actor.getContentSize().height / 2);
		var animFrames = [];
		var frame;
		for (var i = 1; i <= 6; i++) {
			frame = cc.spriteFrameCache.getSpriteFrame("rebound_00" + i + ".png");
			animFrames.push(frame);
		}
		var ani = new cc.Animation(animFrames, 0.1);
		rebound.runAction(cc.speed(cc.sequence(
			cc.animate(ani),
			cc.callFunc(function(){
				rebound.removeFromParent(true);
			}.bind(this))
		), this.engine.aniSpeed));
		
		if (this.logs.length > 0) {
			var log = this.logs.shift();
			this.readAttacked(log);
		} else {
			if (this.callback) {
				this.callback(this);
				this.callback = null;
			}
		}
	},
	undead:function(log){
		this.info.hp = 1;
		this.engine.scene.headDamageAni(this);
		cc.spriteFrameCache.addSpriteFrames("images/buffText.plist");
		var revive = new cc.Sprite("#revive_001.png");
		var actor = this.actor;
		actor.addChild(revive, 10);
		revive.setAnchorPoint(0.5, 0);
		revive.setPosition(0, 0);
		var animFrames = [];
		var frame;
		for (var i = 1; i <= 8; i++) {
			frame = cc.spriteFrameCache.getSpriteFrame("revive_00" + i + ".png");
			animFrames.push(frame);
		}
		var ani = new cc.Animation(animFrames, 0.1);
		revive.runAction(cc.speed(cc.sequence(
			cc.animate(ani),
			cc.callFunc(function(){
				revive.removeFromParent(true);
				if (this.logs.length > 0) {
					var log = this.logs.shift();
					this.readAttacked(log);
				} else {
					this.idle();
					if (this.callback) {
						this.callback(this);
						this.callback = null;
					}
				}
			}.bind(this))
		), this.engine.aniSpeed));
	},
	damaged:function(log) {
		var type = log.attackType;
		if (type === "cri" || type === "hit") {
			var dmg = log.effect.hp;
			this.info.hp = Math.max(0, this.info.hp + dmg);
			this.engine.scene.headAction(this, "defend");
			this.engine.scene.headDamageAni(this);
			var effect;
			if (this.caster.info.sid !== this.info.sid) {
				// 不是攻击被反弹伤害
				this.defend();
			} else {
				this.actor.runAction(cc.speed(cc.sequence(
					cc.delayTime(0.5),
					cc.callFunc(function(){
						if (this.logs.length > 0) {
							var log = this.logs.shift();
							this.readAttacked(log);
						} else {
							if (this.callback) {
								this.callback(this);
								this.callback = null;
							}
						}
					}.bind(this))
				), this.engine.aniSpeed));
			}
			if (effect) {
				// TODO 攻击特效
			}
			if (type === "cri") {
				this.showText("attacked_cri", 1.5);
			}
			this.showDamage(dmg, type, 1);
			var self = this;
			function addDefBuff(){
				self.addBuff({param:{res:0.1}, skillName:"见闻"});
			}
			if (log.def_up) {
				// 纸绘
				this.addBuff({param:{def:0.1},skillName:"纸绘"}, function(){
					if (log.damage_dec) {
						// 见闻
						addDefBuff();
					}
				});
			} else if (log.damage_dec) {
				addDefBuff();
			}
		} else if (type === "dod" || type === "parry") {
			if (type === "dod") {
				type = "dodge";
			}
			this.showText("attacked_" + type, 1);
			if (this.logs.length > 0) {
				var log = this.logs.shift();
				this.readAttacked(log);
			} else {
				if (this.callback) {
					this.callback(this);
					this.callback = null;
				}
			}
		} 
		
	},
	showText:function(fileName, scaleSize){
		var pic = new cc.Sprite("#" + fileName + ".png");
		var actor = this.actor;
		actor.getParent().addChild(pic, 10);
		pic.setAnchorPoint(0.5, 0);
		var side = this.info.side === "left" ? 1 : -1;
		pic.setPosition(fileName === "attacked_cri" ? actor.x + 55 * side : actor.x, 
				actor.y + actor.getContentSize().height * 0.7);
		pic.scale = 0.01;
		pic.runAction(cc.speed(cc.sequence(
			cc.scaleBy(0.1, 75 * scaleSize),
			cc.scaleBy(0.1, 0.8),
			cc.delayTime(0.25),
			cc.fadeOut(0.25),
			cc.callFunc(function(){
				pic.removeFromParent(true);
			})
		), this.engine.aniSpeed));
	},
	showDamage:function(damage, type, scaleSize){
		if (type === "dodge" || type === "parry") {
			return;
		}
		var actor = this.actor;
		cc.spriteFrameCache.addSpriteFrames("images/fightingNumber.plist");
		var chars = String(damage).split('');
		var pics = [];
		var startPosX = actor.x - 55 * scaleSize;
		for (var i in chars) {
			var char = chars[i];
			var pic = new cc.Sprite("#" + type + "_" + char + ".png");
			actor.getParent().addChild(pic, 9);
			pic.setAnchorPoint(0, 0.5);
			pic.setPosition(startPosX, actor.y + actor.getContentSize().height * 0.6);
			startPosX += pic.getContentSize().width / 2 * scaleSize;
			pic.scale = 0.01;
			pics.push(pic);
		}
		for (var i in pics) {
			var pic = pics[i];
			pic.runAction(cc.speed(cc.sequence(
				cc.delayTime(0.1),
				cc.scaleBy(0.1, 75 * scaleSize),
				cc.scaleBy(0.1, 0.8),
				cc.delayTime(0.25),
				cc.fadeOut(0.25)
			), this.engine.aniSpeed));
		}
		actor.runAction(cc.speed(cc.sequence(
			cc.delayTime(1.5),
			cc.callFunc(function(){
				for (var i in pics) {
					var pic = pics[i];
					pic.removeFromParent(true);
				}
			})
		), this.engine.aniSpeed));
	}
});

StateMachine.create({
	target: Unit.prototype,
	events: [
	         {name : "idle", from : "*", to : "stand"},
	         {name : "atk", from : "stand", to : "attack"},
	         {name : "defend", from : "stand", to : "damaged"},
	         {name : "dead", form : "*", to : "death"},
	         {name : "castFB", from : "stand", to : "castingFB"},
	         {name : "addFB", from : "stand", to : "addingFB"},
	         {name : "castB", from : "stand", to : "castingB"}
	         ]
});

Unit.prototype.onidle = function(event, from, to) {
//	trace("after event idle " + this.soldior.sid);
	this.actor.puppet.setOpacity(255);
	this.actor.puppet.visible = true;
}

Unit.prototype.onstand = function(event, from, to) {
//	trace("enter state stand");
	this.actor.puppet.getAnimation().play("Idle");
}

Unit.prototype.onleavestand = function(event, from, to) {
//	trace("leave state stand : " + event);
	if (event === "atk") {
		this.actor.puppet.getAnimation().play("atk", -1, 0);
		return StateMachine.ASYNC;
	} else if (event === "defend") {
		this.actor.puppet.getAnimation().play("Damaged", -1, 0);
		return StateMachine.ASYNC;
	} 
}

Unit.prototype.onbeforeatk = function(event, from, to) {
//	trace("before event atk 判断是否需要移动到敌人面前");
}

Unit.prototype.onatk = function(event, from, to) {
//	trace("after event atk 判断之前是否移动到敌人面前，是否回原始位置");
	var id = this.info.resId;
	var cfg = HeroModule.getHeroConfig(id) || {};
	var range = cfg.range || 0;
	
	if (this.atkLogs.skill && this.atkLogs.skill.id) {
		range = SkillModule.getSkillConfig(this.atkLogs.skill.id).range || 0;
	}
	
	if (range === 0) {
		// 需要冲上去
		this.actor.runAction(cc.speed(cc.sequence(
				cc.moveTo(0.1, this.oriPos),
				cc.callFunc(function(){
					this.actor.setLocalZOrder(this.localZOrder);
					this.idle();
				}.bind(this))
		), this.engine.aniSpeed));
	} else {
		this.idle();
		this.actor.setLocalZOrder(this.localZOrder);
	}
//	if (this.onTargetCallback) {
	//	this.onTargetCallback();
	//	this.onTargetCallback = null;
//	}
}

Unit.prototype.ondefend = function(event, from, to) {
//	trace("after event defend");
	if (this.logs.length > 0) {
		var log = this.logs.shift();
		this.readAttacked(log);
	} else {
		this.actor.runAction(cc.speed(cc.sequence(
			cc.delayTime(0.5),
			cc.callFunc(function(){
				if (this.callback) {
					this.callback(this);
					this.callback = null;
				}
			}.bind(this))
		), this.engine.aniSpeed));
		if (!this.caster || this.caster.info.sid !== this.info.sid) {
			this.idle();
		}
	}
}

Unit.prototype.onleavedamaged = function(event, from, to) {
//	trace("leave state damaged");
	if (event === "dead") {
		this.actor.puppet.getAnimation().play("Death", -1, 0);
		return StateMachine.ASYNC;
	}
}

Unit.prototype.ondeath = function(event, from, to) {
//	trace("enter state death");
	this.actor.puppet.runAction(cc.speed(cc.sequence(
			cc.fadeOut(1),
			cc.callFunc(function(){
				this.engine.scene.showDie(this);
				this.actor.puppet.visible = false;
				this.state = this.STATE.DEAD;
				if (this.callback) {
					this.callback(this);
					this.callback = null;
				}
			}.bind(this))
	), this.engine.aniSpeed));
}