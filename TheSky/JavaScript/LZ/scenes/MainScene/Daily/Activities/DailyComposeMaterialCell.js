var DailyComposeMaterialCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);
		this.data_ = params.data || {};
		this.setContentSize(cc.size(120, 150));
		
		this.initCell();
	},
	
	initCell : function() {
		var rankBg = cc.Sprite.createWithSpriteFrameName(String("rank_head_bg_{0}.png").format(this.data_.conf.rank));
		rankBg.setPosition(cc.p(130 / 2, 160 / 2));
		this.addChild(rankBg, -100);
		
		var frame = cc.Sprite.createWithSpriteFrameName(String("frame_{0}.png").format(this.data_.conf.rank));
		frame.setPosition(cc.p(130 / 2, 160 / 2));
		this.addChild(frame, 2);

		var frameSize = frame.getContentSize();
		
		var texture = cc.textureCache.addImage(common.getIconById(this.data_.conf.icon));
		var icon = cc.Sprite.create(texture);
		icon.setScale(0.33);
		icon.setPosition(cc.p(frameSize.width / 2, frameSize.height / 2));
		frame.addChild(icon, 0);
		
		// 如果大于4，添加发光效果
		if (this.data_.conf.rank >= 4) {			
			olAni.addPartical({
				plist:"images/purpleEquip.plist", 
				node:icon,
				pos:cc.p(icon.getContentSize().width / 2, icon.getContentSize().height / 2),
				scale:2 / 0.35,
				isFollow:true
			});
		}
		
		var name = cc.Sprite.createWithSpriteFrameName(String("frame_level_{0}.png").format(this.data_.conf.rank));
		frame.addChild(name);
		name.setPosition(cc.p(frameSize.width / 2, frameSize.height / 2));
		
		// 材料数量
		var label = cc.LabelTTF.create(this.data_.amount, "ccbResources/FZCuYuan-M03S.ttf", 16);
		label.setColor(cc.color(221, 233, 73));
		frame.addChild(label);
		label.setPosition(cc.p(frameSize.width * 0.81, frameSize.height * 0.15));
		label.enableStroke(cc.color(32, 18, 9), 2);
		
		// 材料名字
		var name = cc.Sprite.createWithSpriteFrameName(String("rank_zhucai_{0}.png").format(this.data_.conf.rank));
		frame.addChild(name);
		name.setPosition(cc.p(frameSize.width / 2, -10));
	}
});