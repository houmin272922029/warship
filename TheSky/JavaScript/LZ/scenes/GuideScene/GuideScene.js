var GuideScene = cc.Scene.extend({
	ctor:function(){
		this._super();
	},
	onEnter:function(){
		this._super();
		var layer = new GuideLayer();
		this.addChild(layer);
	},
	onExit:function(){
		this._super();
	}
});


var GuideLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		this.initLayer();
		this.step = 0;
	},
	onEnter:function(){
		this._super();
//		if (this.step === 1) {
//			this.showVideo2();
//		} else {
//			this.showVideo1();
//		}
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		this.node = cc.BuilderReader.load(ccbi_res.OLGuideView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.showSelectRole();
	},
	showSelectRole:function(){
		this.clearContentLayer();
		var contentLayer = this["contentLayer"];
		var layer = new SelectRoleLayer();
//		var layer = new GuideNewLayer();
		contentLayer.addChild(layer);
	},
	showVideo1:function(){
		// 第一个动画20秒
		SoundUtil.playMusic("audio/guide_1.mp3", false);
		this.des.runAction(
				cc.sequence(
						cc.callFunc(function() {
								this["bg_1"].runAction(cc.sequence(
										cc.fadeOut(0.001),
										cc.delayTime(7),
										cc.fadeIn(2)
								));
							}.bind(this)),
							cc.callFunc(function() {
								this["des"].runAction(cc.sequence(
										cc.fadeOut(0.001),
										cc.delayTime(8),
										cc.fadeIn(1.5),
										cc.moveTo(4, cc.p(this.des.x, cc.winSize.height)),
										cc.fadeOut(2)
								));
							}.bind(this)),
							cc.callFunc(function() {
								this["wukong"].runAction(cc.sequence(
										cc.fadeOut(0.001),
										cc.moveTo(1, cc.p(cc.winSize.width / 2, cc.winSize.height / 2)),
										cc.delayTime(1),
										cc.fadeIn(2),
										cc.fadeOut(1),
										cc.moveTo(1, cc.p(cc.winSize.width * 0.262, cc.winSize.height * 0.742)),
										cc.delayTime(10),
										cc.fadeIn(1)
								));
							}.bind(this)),
							cc.callFunc(function() {
								this["boss"].runAction(cc.sequence(
										cc.fadeOut(0.001),
										cc.moveTo(1, cc.p(cc.winSize.width / 2, cc.winSize.height / 2)),
										cc.delayTime(4),
										cc.fadeIn(2),
										cc.fadeOut(1),
										cc.moveTo(1, cc.p(cc.winSize.width * 0.645, cc.winSize.height * 0.296)),
										cc.delayTime(7),
										cc.fadeIn(1)
								));
							}.bind(this)),
							
							cc.callFunc(function() {
								this.manager = ccs.armatureDataManager;
								for (var i = 0; i < 2; i++) {
									var jsonPath = "bone/guide/vs/vs.ExportJson";
									var img = "bone/guide/vs/vs" +  i +".png";
									var plist = "bone/guide/vs/vs" + i + ".plist";
									this.manager.addArmatureFileInfo(img, plist, jsonPath);
								}
								this.guidePuppet = new ccs.Armature("vs");
								var animation = this.guidePuppet.getAnimation();
								this.guidePuppet.runAction(cc.sequence(
										cc.fadeOut(0.001),
										cc.delayTime(17),
										cc.fadeIn(0.01),
										cc.callFunc(function() {
											animation.play("Loop", 0, true);
										})
								));
								this.guidePuppet.getAnimation().setSpeedScale(1);
								this.guidePuppet.attr({
									x:cc.winSize.width / 2,
									y:cc.winSize.height / 2,
									anchorX:0.5,
									anchorY:0.5
								});
								this.guidePuppet.getAnimation().setMovementEventCallFunc(function(target, type, movementName){
									if (type > 0) {
										this.guidePuppet.removeFromParent(true);
									}
								}.bind(this), this.guidePuppet);
								this.guidePuppet.getAnimation().setFrameEventCallFunc(function(target, event, originFrameIndex, currentFrameIndex){
									if (event === "ontarget") {
										var newGuideLog = guideLog;
										var music = "audio/guide_1.mp3";
										var dic = {log:newGuideLog, bg:1, music:music, left:"悟空", extra:{from:"guide"}};
										this.step = 1;
										cc.director.pushScene(new FightScene(dic));
									}
								}.bind(this), this.guidePuppet);
								this.layer_1.addChild(this.guidePuppet, 10);
							}.bind(this))
					)
		);
	},
	
	showVideo2:function(){
		// 第二个动画10秒
		this.layer_2.visible = true;
		this.layer_3.visible = true;
		this["bg_2"].runAction(
				cc.sequence(
					cc.CallFunc(function(){
						SoundUtil.playMusic("audio/guide_2.mp3", false);
					}.bind(this)),
					cc.CallFunc(function(){
						this.guanghuan.runAction(cc.sequence(
								cc.delayTime(7),
								cc.callFunc(function(){
									SoundUtil.playMusic("audio/guide_3.mp3", false);
								})
						));
					}.bind(this)),
					cc.CallFunc(function(){
						this.guanghuan.runAction(cc.sequence(
							cc.fadeOut(0.01),
							cc.fadeIn(1),
							cc.scaleTo(3,1,1),
							cc.fadeOut(1)
						));
					}.bind(this)),
					cc.CallFunc(function(){
						this.bg_2.runAction(cc.sequence(
								cc.delayTime(4),
								cc.fadeOut(1)
						));
					}.bind(this)),
					cc.CallFunc(function(){
						this.baiban.runAction(cc.sequence(
								cc.fadeOut(0.01),
								cc.delayTime(19),
								cc.fadeIn(1)
						));
					}.bind(this)),
					cc.CallFunc(function(){
						this.longzhu_1.runAction(cc.sequence(
								cc.delayTime(5),
								cc.fadeTo(0.1, 20),
								cc.fadeTo(0.9, 255),
								cc.fadeTo(1, 20),
								cc.fadeTo(2, 255),
								cc.fadeTo(1, 20),
								cc.fadeTo(2, 255),
								cc.moveBy(7.5, 0, -this.shenlong.getContentSize().height * 0.57)
						));
					}.bind(this)),
					cc.CallFunc(function(){
						this.longzhu_0.runAction(cc.sequence(
								cc.delayTime(12),
								cc.moveBy(7.5, 0, -this.shenlong.getContentSize().height * 0.57)
						));
					}.bind(this)),
					cc.CallFunc(function(){
						this.shenlong.runAction(cc.sequence(
								cc.fadeOut(0.01),
								cc.delayTime(11),
								cc.fadeIn(1),
								cc.moveBy(7, 0, -this.shenlong.getContentSize().height * 0.57)
						));
					}.bind(this)),
					cc.CallFunc(function(){
						this.buma.runAction(cc.sequence(
								cc.delayTime(12),
								cc.moveBy(7.5, 0, -this.shenlong.getContentSize().height * 0.57)
						));
					}.bind(this)),
					cc.CallFunc(function(){
						this.buma.runAction(cc.sequence(
								cc.delayTime(20),
								cc.callFunc(function(){
									cc.director.popScene();
								})
						));
					}.bind(this))
				)
		);
	},
	clearContentLayer:function(){
		this["contentLayer"].removeAllChildren(true);
	},
});

cc.BuilderReader.registerController("OLGuideOwner", {
});