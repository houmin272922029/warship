var FightBg1 = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("FightingBgOwner", {
		});
		cc.BuilderReader.registerController("fightingBg_1_AnimationOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.FightBg1_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		
		for (var i = 0; i < 3; i++) {
			var bird = new cc.Sprite("#fightingBg_1_birds.png");
			this.fightBg_sea.addChild(bird);
			bird.runAction(cc.sequence(
				cc.delayTime(i * 6),
				cc.callFunc(function(){
					bird.runAction(cc.repeatForever(cc.sequence(
							cc.callFunc(function(){
								bird.x = 230;
								bird.y = 570;
								bird.scale = 0.5;
								bird.opacity = 0;
							}),
							cc.spawn(
									cc.moveTo(15, 540, 749),
									cc.scaleTo(15, 1.2),
									cc.fadeTo(3, 128)
							)
					)))
				})
				
			));
		}
		var cloud = new cc.Sprite("#fightingBg_1_cloud.png");
		this.fightBg_sea.addChild(cloud);
		cloud.setAnchorPoint(1, 1);
		cloud.opacity = 155;
		cloud.runAction(cc.repeatForever(cc.sequence(
			cc.callFunc(function(){
				cloud.x = 0;
				cloud.y = 730;
			}),
			cc.moveBy(40, 1310, 0)
		)));
		
		this.manager = ccs.armatureDataManager;
		for (var i = 0; i < 2; i++) {
			var jsonPath = "bone/warBg/txdywdh/txdywdh.ExportJson";
			var img = "bone/warBg/txdywdh/txdywdh" +  i +".png";
			var plist = "bone/warBg/txdywdh/txdywdh" + i + ".plist";
			this.manager.addArmatureFileInfo(img, plist, jsonPath);
		}
		this.guidePuppet = new ccs.Armature("txdywdh");
		this.guidePuppet.getAnimation().play("Start",0 , true);
		this.guidePuppet.attr({
			x:0,
			y:cc.winSize.height,
			anchorX:0.066,
			anchorY:1
		});
		this.addChild(this.guidePuppet, -1);
	}
});