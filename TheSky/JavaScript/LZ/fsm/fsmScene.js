var fsmLayer = cc.Layer.extend({
	layout:{},
	soldiors:{left:[],right:[]},
	sCount:{left:0,right:0},
	cursor:0,
	pos:{
		left:[
		      cc.p(cc.winSize.width / 5 * 2, cc.winSize.height / 3 * (6 / 5)),
		      cc.p(cc.winSize.width / 5 * 2, cc.winSize.height / 3 * (7 / 5)),
		      cc.p(cc.winSize.width / 5 * 2, cc.winSize.height / 3 * (8 / 5)),
		      cc.p(cc.winSize.width / 5 * 2, cc.winSize.height / 3 * (9 / 5)),
		      cc.p(cc.winSize.width / 5, cc.winSize.height / 3 * (6 / 5)),
		      cc.p(cc.winSize.width / 5, cc.winSize.height / 3 * (7 / 5)),
		      cc.p(cc.winSize.width / 5, cc.winSize.height / 3 * (8 / 5)),
		      cc.p(cc.winSize.width / 5, cc.winSize.height / 3 * (9 / 5)),
		      ],
		right:[
		     cc.p(cc.winSize.width / 5 * 3, cc.winSize.height / 3 * (6 / 5)),
		     cc.p(cc.winSize.width / 5 * 3, cc.winSize.height / 3 * (7 / 5)),
		     cc.p(cc.winSize.width / 5 * 3, cc.winSize.height / 3 * (8 / 5)),
		     cc.p(cc.winSize.width / 5 * 3, cc.winSize.height / 3 * (9 / 5)),
		     cc.p(cc.winSize.width / 5 * 4, cc.winSize.height / 3 * (6 / 5)),
		     cc.p(cc.winSize.width / 5 * 4, cc.winSize.height / 3 * (7 / 5)),
		     cc.p(cc.winSize.width / 5 * 4, cc.winSize.height / 3 * (8 / 5)),
		     cc.p(cc.winSize.width / 5 * 4, cc.winSize.height / 3 * (9 / 5)),
		     ],
	},
	ctor:function(){
		this._super();
		this.initLayer();
	},
	onEnter:function(){
		this._super();
//		this.analyseJson();
		this.init();
	},
	onExit:function(){
		this._super();
	},
	analyseJson:function(){
		var log = js_result[this.cursor];
		this.cursor++;
		if (!log) {
			this.transition();
			return;
		}
		var action = log.action
		cc.log("action = " + action)
		switch (action) {
		case "layout":
			this.setSoldiers(log.result);
			break;
		case "fieldBuff": 
			this.fieldBuff(log.result);
			break;
		case "buff":
			this.buff(log.result);
			break;
		case "attack":
			this.attack(log.result);
			break;
		default:
			this.transition();
			break;
		}
		
//		this.runAction(cc.sequence(
//				cc.callFunc(function(){
//					var log = js_result[this.cursor];
//					var action = log.action;
//					cc.log("action = " + action);
//					this.cursor++;
//				}.bind(this)),
//				cc.delayTime(1),
//				cc.callFunc(function(){
//					cc.log("read done");
//					this.transition();
//				}.bind(this))
//		));
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
		function countdown(){
			semaphore--;
			if (semaphore === 0) {
				map = {};
				this.transition();
			}
		}

		var self = this;
		
		var array = [];
		if (attacker.skill) {
			array.push(cc.callFunc(function(){
				var soldior = self.layout[attacker.sid].soldior;
				cc.log("【使用技能】" + soldior.name + "【" + attacker.sid + "】" + " use skill " + attacker.skill.id);
			}));
			array.push(cc.delayTime(1));
		} else {
			array.push(cc.callFunc(function(){
				var soldior = self.layout[attacker.sid].soldior;
				cc.log("【普通攻击】" + soldior.name + "【" + attacker.sid + "】");
			}));
		}
		function attacked(){
			for (var k in map) {
				var log = map[k];
				self.layout[k].attacked(log, countdown.bind(self));
			}
		}
		array.push(cc.callFunc(function(){
			self.layout[attacker.sid].attack(attacker, attacked.bind(self));
		}));
		this.runAction(cc.sequence(array));
	},
	buff:function(logs){
		var index = 0;
		this.runAction(cc.sequence(
				cc.callFunc(function(){
					for (var k in logs) {
						var buffer = logs[k];
						this.layout[buffer.sid].castBuff(buffer);
					}
				}.bind(this)),
				cc.delayTime(1),
				cc.callFunc(function(){
					this.transition();
				}.bind(this))
				));
	},
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
		this.layout[caster.sid].castFieldBuff(caster, buffSoldior.bind(this));
		function buffSoldior(){
			for (var i = 1; i < len; i++) {
				var buffer = logs[i];
				this.layout[buffer.sid].addFieldBuff(buffer, countdown.bind(this));
			}
		}
	},
	setSoldiers:function(logs){
		this.soldiors = {left:[],right:[]};
		for (var k in logs) {
			var log = logs[k];
			var array = [];
			var pos = this.pos[log.side][this.soldiors[log.side].length];
			var soldior = new fsmSoldior(log, pos);
			this.layout[log.sid] = soldior;
			this.soldiors[log.side].push(soldior);
			this.sCount[log.side]++;
			this.addChild(soldior.actor, 8 - log.x);
		}
		this.transition();
	},
	initLayer:function(){
//		var av = new fsmBone("Axe");
//		this.addChild(av);
//		av.attr({
//			x:cc.winSize.width / 2,
//			y:cc.winSize.height / 2
//		});
//		var axe = new fsmBone("Axe");
//		this.addChild(axe);
//		axe.attr({
//			x:cc.winSize.width / 4,
//			y:cc.winSize.height / 2,
//		})
//		
//		// add a "close" icon to exit the progress. it's an autorelease object
//		var atk = new cc.MenuItemLabel(
//				new cc.LabelTTF("攻击", "Arial", 20),
//				function(){
//					av.atk();
//				}
//				);
//		atk.attr({
//			x: cc.winSize.width / 2,
//			y: 50
//		});
//		var idle = new cc.MenuItemLabel(
//				new cc.LabelTTF("站着", "Arial", 20),
//				function(){
//					av.idle();
//				}
//				);
//		idle.attr({
//			x: cc.winSize.width / 2,
//			y: 150,
//		})
//		var defend = new cc.MenuItemLabel(
//				new cc.LabelTTF("挨打", "Arial", 20),
//				function(){
//					av.defend();
//				}
//				);
//		defend.attr({
//			x:cc.winSize.width / 2,
//			y:250
//		});
//		var menu = new cc.Menu(atk, idle, defend);
//		menu.x = 0;
//		menu.y = 0;
//		this.addChild(menu, 1);
	}
});


fsmLayer.prototype.onbeforeinit = function(event, from, to) {
//	cc.log("layer before event init");
}

fsmLayer.prototype.oninit = function(event, from, to) {
//	cc.log("layer after event init");
	this.next();
}

fsmLayer.prototype.onidle = function(event, from, to) {
//	cc.log("layer enter state idle");
}

fsmLayer.prototype.onleaveidle = function(event, from, to) {
//	cc.log("layer leave state idle");
}

fsmLayer.prototype.onbeforenext = function(event, from, to) {
//	cc.log("layer before event next");
}

fsmLayer.prototype.onnext = function(event, from ,to) {
//	cc.log("layer after event next");
}

fsmLayer.prototype.onreading = function(event, from, to) {
//	cc.log("layer enter state reading");
	this.done();
	fsmLayer.prototype.analyseJson.call(this);
//	this.analyseJson().bind(this);
}

fsmLayer.prototype.onleavereading = function(event, from, to) {
//	cc.log("layer leave state reading");
	return StateMachine.ASYNC;
}

fsmLayer.prototype.onbeforedone = function(event, from, to) {
//	cc.log("layer before event done");
}

fsmLayer.prototype.ondone = function(event, from, to) {
//	cc.log("layer after event done");
	if (this.cursor >= getJsonLength(js_result)) {
		cc.log("log is over");
	} else {
		this.next();
	}
}

var flFSM = StateMachine.create({
	target: fsmLayer.prototype,
	events: [
	         {name : "init", from : "*", to : "idle"},
	         {name : "next", from : "idle", to : "reading"},
	         {name : "done", from : "reading", to : "idle"}
	         ]
});

var fsmScene = cc.Scene.extend({
	ctor:function(){
		this._super();
	},
	onEnter:function(){
		this._super();
		var layer = new fsmLayer();
		this.addChild(layer);
	},
	onExit:function(){
		this._super();
	},
});