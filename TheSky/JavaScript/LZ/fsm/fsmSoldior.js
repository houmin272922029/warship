var fsmSoldior = cc.Layer.extend({
	soldior:null,
	actor:null,
	oriPos:null,
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	ctor:function(soldior, pos){
		this._super();
		this.soldior = soldior;
		this.oriPos = pos;
		this.actor = new fsmBone(this, "Axe");
		this.actor.attr({
			x:pos.x,
			y:pos.y
		});
		var direction = this.soldior.side === "left" ? 1 : -1;
		this.actor.puppet.setScaleX(direction);
//		this.actor.flipX = direction;
		this.idle();
	},
	movementDone:function(){
		this.transition();
	},
	castFieldBuff:function(log, callback) {
		this.callback = callback;
		this.log = log;
		var self = this;
		this.actor.runAction(cc.sequence(
				cc.callFunc(function(){
					cc.log("【释放场地buff】" + self.soldior.name + "【" + log.sid + "】" + " cast buff " + log.skillName);
				}.bind(this)),
				cc.delayTime(0.5),
				cc.callFunc(function(){
					this.castFB();
					if (this.callback) {
						this.callback();
						this.callback = null;
					}
				}.bind(this))
		));
	},
	addFieldBuff:function(log, callback) {
		this.callback = callback;
		this.log = log;
		this.actor.runAction(cc.sequence(
				cc.callFunc(function(){
					for ( var k in log.param) {
						cc.log("【添加场地buff】" + this.soldior.name + "【" + log.sid + "】" + " got buff " + log.skillName + "[" + k + ":" + log.param[k] + "]");
					}
				}.bind(this)),
				cc.delayTime(1),
				cc.callFunc(function(){
					this.addFB();
					if (this.callback) {
						this.callback();
						this.callback = null;
					}
				}.bind(this))
		));
	},
	castBuff:function(log){
		this.log = log;
		for ( var k in log.param) {
			cc.log("【释放自身buff】" + this.soldior.name + "【" + log.sid + "】" + " cast buff " + log.skillName + "[" + k + ":" + log.param[k] + "]");
		}
	},
	attack:function(log, callback) {
		this.log = log;
		this.callback = callback;
		this.actor.runAction(cc.sequence(
				cc.delayTime(0.5),
				cc.callFunc(function(){
					if (this.callback) {
						this.callback();
						this.callback = null;
					}
				}.bind(this))
				));
		this.atk();
	},
	attacked:function(logs, callback) {
		this.logs = logs;
		this.callback = callback;
		cc.log(">>>>>>>>>>>>>>>>>>>>>>")
		for ( var k in logs) {
			cc.log(logs[k].action + " " + logs[k].sid);
		}
		cc.log("<<<<<<<<<<<<<<<<<<<<<<")
		var log = this.logs.shift();
		this.readAttacked(log);
	},
	readAttacked:function(log){
		switch (log.action) {
		case "attacked":
			cc.log("【被攻击】" + this.soldior.name + "【" + log.sid + "】" + " lost " + Math.abs(log.effect.hp) + " hp with " + log.attackType);
			this.defend();
			break;
		case "die":
			cc.log("【死亡】" + this.soldior.name + "【" + log.sid + "】" + "dead");
			this.dead();
			break;
		case "undead":
			cc.log("【不死】" + this.soldior.name + "【" + log.sid + "】" + "undead");
			this.idle();
			if (this.callback) {
				this.callback();
				this.callback = null;
			}
			break;
		default:
			break;
		}
	}
});

var bfsm = StateMachine.create({
	target: fsmSoldior.prototype,
	events: [
	         {name : "idle", from : "*", to : "stand"},
	         {name : "atk", from : "stand", to : "attack"},
	         {name : "defend", from : "stand", to : "damaged"},
	         {name : "dead", form : "damaged", to : "death"},
	         {name : "castFB", from : "stand", to : "castingFB"},
	         {name : "addFB", from : "stand", to : "addingFB"},
	         {name : "castB", from : "stand", to : "castingB"}
	         ]
});

fsmSoldior.prototype.onidle = function(event, from, to) {
//	cc.log("after event idle " + this.soldior.sid);
	this.actor.puppet.setOpacity(255);
	this.actor.puppet.visible = true;
}

fsmSoldior.prototype.onstand = function(event, from, to) {
//	cc.log("enter state stand");
	this.actor.puppet.getAnimation().play("Idle");
}

fsmSoldior.prototype.onleavestand = function(event, from, to) {
//	cc.log("leave state stand : " + event);
	if (event === "atk") {
		this.actor.puppet.getAnimation().play("atk", -1, 0);
		return StateMachine.ASYNC;
	} else if (event === "defend") {
		this.actor.puppet.getAnimation().play("Damaged", -1, 0);
		return StateMachine.ASYNC;
	} 
}

fsmSoldior.prototype.onbeforeatk = function(event, from, to) {
//	cc.log("before event atk 判断是否需要移动到敌人面前");
}

fsmSoldior.prototype.onatk = function(event, from, to) {
//	cc.log("after event atk 判断之前是否移动到敌人面前，是否回原始位置");
	this.idle();
	if (this.callback) {
		this.callback();
		this.callback = null;
	}
}

fsmSoldior.prototype.ondefend = function(event, from, to) {
//	cc.log("after event defend");
	if (this.logs.length > 0) {
		var log = this.logs.shift();
		this.readAttacked(log);
	} else {
		this.idle();
		if (this.callback) {
			this.callback();
			this.callback = null;
		}
	}
}

fsmSoldior.prototype.onleavedamaged = function(event, from, to) {
//	cc.log("leave state damaged");
	if (event === "dead") {
		this.actor.puppet.getAnimation().play("Death", -1, 0);
		return StateMachine.ASYNC;
	}
}

fsmSoldior.prototype.ondeath = function(event, from, to) {
//	cc.log("enter state death");
	this.actor.puppet.runAction(cc.sequence(
			cc.callFunc(function(){
				if (this.callback) {
					this.callback();
					this.callback = null;
				}
			}.bind(this)),
			cc.fadeOut(1),
			cc.callFunc(function(){
				this.actor.puppet.visible = false;
			}.bind(this))
	));
}

fsmSoldior.prototype.oncastingFB = function(event, from, to) {
	this.idle();
}

fsmSoldior.prototype.onaddingFB = function(event, from, to) {
	this.idle();
}

fsmSoldior.prototype.oncastingB = function(event, from, to) {
	this.idle();
}