var ActionLoading = cc.Layer.extend({
	ctor:function(){
		this._super();
		var box = new cc.Scale9Sprite("images/grayBg.png");
		box.setContentSize(290, 200);
		box.attr({
			x:cc.winSize.width / 2,
			y:cc.winSize.height / 2,
			anchorX:0.5,
			anchorY:0.5,
			scale:retina
		});
		this.addChild(box);
		cc.spriteFrameCache.addSpriteFrames(common.formatLResPath("olRes/ol_loading.plist"));
		var avatar = new cc.Sprite("#load_icon_1.png");
		avatar.setPosition(box.getContentSize().width / 2, 100);
		box.addChild(avatar);
		
		var animFrames = [];
		var frame;
		for (var i = 1; i <= 12; i++) {
			frame = cc.spriteFrameCache.getSpriteFrame("load_icon_" + i + ".png");
			animFrames.push(frame);
		}
		var ani = new cc.Animation(animFrames, 0.1);
		avatar.runAction(cc.animate(ani).repeatForever());
	
//		var btmLabel = new cc.LabelTTF("", FONT_NAME, 20, cc.size(box.getContentSize().width * 0.98, 90), 
//				cc.TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_CENTER);
//		btmLabel.attr({
//			x:box.getContentSize().width / 2,
//			y:45,
//			anchorX:0.5,
//			anchorY:0.5
//		});
//		
		common.swallowLayer(this, true);
	},
	
});