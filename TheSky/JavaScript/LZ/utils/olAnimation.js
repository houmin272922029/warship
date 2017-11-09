var olAni = {
	addPartical:function(params){
		var plist = params.plist;
		var node = params.node;
		var pos = params.pos || cc.p(0, 0);
		var duration = params.duration;
		var z = params.z || 0;
		var tag = params.tag || 0;
		var color = params.color;
		var scale;
		var scaleX = params.scaleX;
		var scaleY = params.scaleY;
		var isFollow = params.isFollow;
		if (!scaleX && !scaleY) {
			scale = params.scale || 1;
		}
		var action = params.action;
		var startColor = params.startColor;
		var endColor = params.endColor;
		if (!plist) {
			return null;
		}
		var ps = new cc.ParticleSystem(plist);
		if (node) {
			node.addChild(ps, z, tag);
		}
		ps.setPosition(pos);
		if (duration) {
			ps.setDuration(duration);
		}
		if (scaleX && scaleY) {
			ps.setScaleX(scaleX * cc.winSize.width / 480);
			ps.setScaleY(scaleY * cc.winSize.width / 480);
		} else {
			ps.setScale(scale * cc.winSize.width / 480);
		}
		if (color) {
			ps.setColor(color);
		}
		if (startColor) {
			ps.setStartColor(startColor);
		}
		if (endColor) {
			ps.setEndColor(endColor);
		}
		if (isFollow) {
			ps.setPositionType(cc.ParticleSystem.TYPE_GROUPED);
		}
		if (action) {
			ps.runAction(action);
		}
		return ps;
	},
	addFrameParticle:function(params){
		var plist = params.plist;
		var node = params.node;
		var pos = params.pos;
		var width = params.width;
		var height = params.height;
		var color = params.color;
		var duration = params.duration;
		var z = params.z || 0;
		if (!plist) {
			return null;
		}
		var top = new cc.ParticleSystem(plist);
		top.setPosVar(cc.p(width / 2 / retina, 0));
		top.setPosition(cc.p(pos.x, pos.y + height / 2));
		top.setScale(retina);
		if (color) {
			top.setColor(color);
		}
		if (duration) {
			top.setDuration(duration);
		}
		
		var bottom = new cc.ParticleSystem(plist);
		bottom.setPosVar(cc.p(width / 2 / retina, 0));
		bottom.setPosition(cc.p(pos.x, pos.y - height / 2));
		bottom.setScale(retina);
		if (color) {
			bottom.setColor(color);
		}
		if (duration) {
			bottom.setDuration(duration);
		}
		
		var left = new cc.ParticleSystem(plist);
		left.setPosVar(cc.p(0, height / 2 / retina));
		left.setPosition(cc.p(pos.x - width / 2, pos.y));
		left.setScale(retina);
		if (color) {
			left.setColor(color);
		}
		if (duration) {
			left.setDuration(duration);
		}
		
		var right = new cc.ParticleSystem(plist);
		right.setPosVar(cc.p(0, height / 2 / retina));
		right.setPosition(cc.p(pos.x + width / 2, pos.y));
		right.setScale(retina);
		if (color) {
			right.setColor(color);
		}
		if (duration) {
			right.setDuration(duration);
		}
		
		if (node) {
			node.addChild(top, z);
			node.addChild(bottom, z);
			node.addChild(left, z);
			node.addChild(right, z);
		}
		return [top, bottom, left, right];
	},
	/**
	 * 帧动画 圈住的粒子效果
	 * 
	 * @param prefix 	 序列帧图片前缀
	 * @param node   	 所在的节点
	 * @param pos		 位置
	 * @param startIndex 开始帧
	 * @param endIndex	 结束帧
	 * @param color		 自定义的颜色
	 */
	playFrameAnimation:function(prefix, node, pos, startIndex, endIndex, color){
		var sp = new cc.Sprite("#" + prefix + startIndex + ".png");
		if (color) {
			sp.setColor(color);
		}
		var animFrames = [];
		var frame;
		for (var i = startIndex; i <= endIndex; i++) {
			frame = cc.spriteFrameCache.getSpriteFrame(prefix + i + ".png");
			animFrames.push(frame);
		}
		var ani = new cc.Animation(animFrames, 0.13);
		sp.runAction(cc.animate(ani).repeatForever());
		if (node) {
			node.addChild(sp);
			sp.setPosition( pos );
		}
		return sp;
	}
}