var HeroHead = cc.Node.extend({
	ctor:function(side, engine){
		this._super();
		this.engine = engine;
		this.side = side;
		cc.BuilderReader.registerController("head_owner", {
		});
		var node = cc.BuilderReader.load(ccbi_dir + "/ccbi/ccbResources/head_" + side + ".ccbi", this);
		if (node) {
			this.addChild(node);
		}
	},
	initHead:function(info){
		this.heroHead.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(info.resId)));
		for (var i = 1; i <= 5; i++) {
			this["levelLabel_" + i].setString("LV " + info.level);
			this["hpLabel_" + i].setString("?????");
			this["nameLabel_" + i].setString(info.name);
		}
		var rank = info.rank;
		var color;
		switch (rank) {
		case 1:
			color = "grey";
			break;
		case 2:
			color = "green";
			break;
		case 3:
			color = "blue";
			break;
		case 4:
			color = "purple";
			break;
		default:
			color = "purple";
			break;
		}
		this.headBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("headBg_" + color + ".png"));
		this.deadIcon1.visible = false;
		this.deadIcon2.visible = false;
	},
	refreshHp:function(now, max){
		for (var i = 1; i <= 5; i++) {
			this["hpLabel_" + i].setString(now + "/" + max);
		}
		this.bloodBar.scaleX = now / max;
	},
	attack:function(){
		var side = this.side;
		function resetSweep(sender){
			sender.x = side === "left" ? 0 : 171;
		}
		this.sweepArrow.runAction(cc.speed(cc.spawn(
				cc.sequence(
					cc.callFunc(resetSweep, this.sweepArrow),
					cc.delayTime(0.3),
					cc.moveBy(4 / 15, side === "left" ? 171 : 0, 0),
					cc.callFunc(resetSweep, this.sweepArrow)
				),
				cc.sequence(
					cc.delayTime(0.3),
					cc.fadeIn(1 / 30),
					cc.delayTime(1 / 5),
					cc.fadeOut(1 / 30)
				)
		), this.engine.aniSpeed));
		this.highLight.scale = 0;
		this.highLight.opacity = 0;
		this.highLight.runAction(cc.speed(cc.spawn(
			cc.sequence(
				cc.scaleTo(1 / 6, 1.1),
				cc.scaleTo(2 / 15, 1),
				cc.delayTime(17 / 30),
				cc.scaleTo(1 / 15, 1.1),
				cc.scaleTo(1 / 15, 1)
			),
			cc.sequence(
				cc.fadeIn(1 / 6),
				cc.delayTime(23 / 30),
				cc.fadeOut(1 / 15)
			)
		), this.engine.aniSpeed));
	},
	defend:function(){
		this.heroHead.runAction(cc.speed(cc.spawn(
			cc.sequence(
				cc.delayTime(10 / 30),
				cc.moveTo(1 / 15, -1, 55),
				cc.moveTo(1 / 15, 2, 42),
				cc.moveTo(1 / 15, -1, 54),
				cc.moveTo(1 / 15, -1, 43),
				cc.moveTo(1 / 15, 0, 45)
			),
			cc.sequence(
				cc.delayTime(10 / 30),
				cc.rotateTo(1 / 15, 5),
				cc.rotateTo(1 / 15, -5),
				cc.rotateTo(1 / 15, 5),
				cc.rotateTo(1 / 15, -4),
				cc.rotateTo(1 / 15, 0)
			)
		), this.engine.aniSpeed));
		
		this.headFrame.runAction(cc.speed(cc.spawn(
			cc.sequence(
				cc.delayTime(10 / 30),
				cc.moveTo(1 / 15, 84, 59),
				cc.moveTo(1 / 15, 87, 59),
				cc.moveTo(1 / 15, 84, 58),
				cc.moveTo(1 / 15, 87, 58),
				cc.moveTo(1 / 15, 86, 55)
			),
			cc.sequence(
				cc.delayTime(10 / 30),
				cc.rotateTo(1 / 15, 5),
				cc.rotateTo(1 / 15, -5),
				cc.rotateTo(1 / 15, 5),
				cc.rotateTo(1 / 15, -4),
				cc.rotateTo(1 / 15, 0)
			)
		), this.engine.aniSpeed));
		
		this.highLight.scale = 0;
		this.highLight.opacity = 0;
		this.highLight.runAction(cc.speed(cc.spawn(
			cc.sequence(
				cc.scaleTo(1 / 6, 1.1),
				cc.scaleTo(2 / 15, 1),
				cc.delayTime(17 / 30),
				cc.scaleTo(1 / 15, 1.1),
				cc.scaleTo(1 / 15, 1)
			),
			cc.sequence(
				cc.fadeIn(1 / 6),
				cc.delayTime(23 / 30),
				cc.fadeOut(1 / 15)
			)
		), this.engine.aniSpeed));
	},
	hpAni:function(now, max){
		this.bloodBar.stopAllActions();
		this.bloodBar.runAction(cc.speed(cc.sequence(
			cc.delayTime(0.5),
			cc.scaleTo(0.5, now / max, 1),
			cc.callFunc(function(){
				this.refreshHp(now, max);
			}.bind(this))
		), this.engine.aniSpeed));
	},
	showDie:function(){
		this.headBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("headBg_grey.png"));
		this.deadIcon1.visible = true;
		this.deadIcon2.visible = true;
	}
});