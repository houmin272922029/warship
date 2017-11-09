var UpdateShadowCell = cc.Node.extend({
	ctor:function(shadows){
		this._super();
		this.exp = 0;
		this.shadows = shadows;
		cc.BuilderReader.registerController("TrainShadowCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.TrainShadowCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.menu.setSwallowTouches(false);
		for (var i = 1; i < 6; i++) {
			if (this.shadows[i-1]) {
				var cfg = this.shadows[i-1].cfg;
				var rankSprite = this["rankSprite" + i];
				olAni.playFrameAnimation("yingzi_" + cfg.icon + "_", rankSprite,
						cc.p(rankSprite.getContentSize().width / 2, rankSprite.getContentSize().height / 2), 1, 4,
						common.getColorByRank(this.shadows[i-1].rank));
				this["avatarBtn" + i].setTag(i);
				this["levelTTF" + i].setString(this.shadows[i-1].level);
				this["nameLabel" + i].setString(cfg.name);
			} else {
				this["avatar" + i].visible = false;
				this["avatarBtn" + i].visible = false;
				this["rankSprite" + i].visible = false;
				this["levelTTF" + i].visible = false;
				this["nameLabel" + i].visible = false;
			}
		}
	},
	shadowBtnAction:function(sender){
		var sprite = this["shadowLayer" + sender.getTag()]
		var shadow = this.shadows[sender.getTag() - 1]
		sprite.visible = sprite.visible ? false : true;
		if (sprite && sprite.visible) {
			var exp = ShadowModule.oneShadowCanGaveEXP(shadow.shadowId, shadow.level, shadow.rank) + shadow.expNow
			postNotifcation(NOTI.SHADOW_CHANGE_EXP, {shadowExp:exp, uid:shadow.id, type : 0});
		} else if(sprite) {
			var exp = -ShadowModule.oneShadowCanGaveEXP(shadow.shadowId, shadow.level, shadow.rank) - shadow.expNow
			postNotifcation(NOTI.SHADOW_CHANGE_EXP, {shadowExp:exp, uid:shadow.id, type : 1});
		}
		return sender;
	},
	selectCell:function(index){
		var sprite = this["shadowLayer" + (index)];
		sprite.visible = true;
		var shadow = this.shadows[index - 1];
		if (sprite && sprite.visible) {
			var exp = ShadowModule.oneShadowCanGaveEXP(shadow.shadowId, shadow.level, shadow.rank) + shadow.expNow
			postNotifcation(NOTI.SHADOW_CHANGE_EXP, {shadowExp:exp, uid:shadow.id, type : 0});
		}
	},
	unSelectCell:function(index){
		var sprite = this["shadowLayer" + (index)];
		sprite.visible = false;
		var shadow = this.shadows[index - 1];
		if (sprite && sprite.visible) {
			var exp = -ShadowModule.oneShadowCanGaveEXP(shadow.shadowId, shadow.level, shadow.rank) - shadow.expNow
			postNotifcation(NOTI.SHADOW_CHANGE_EXP, {shadowExp:exp, uid:shadow.id, type : 1});
		}
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	}
});