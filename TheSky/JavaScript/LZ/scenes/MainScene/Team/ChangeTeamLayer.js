var ChangeTeamLayer = cc.Layer.extend({
	selected:0,
	ctor:function(){
		this._super();
		this.form = deepcopy(FormModule.getForm());
		this.initLayer();
		common.swallowLayer(this, true);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("ChangeTeamViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ChangeTeamView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.refresh();
	},
	refresh:function(){
		for (var i = 1; i <= 8; i++) {
			this["hero" + i].visible = false;
			this["changePos" + i].visible = false;
			this["changeHero" + i].visible = false;
			this["frame" + i].visible = false;
			this["name" + i].visible = false;
			this["rank" + i].visible = false;
			this["level" + i].visible = false;
			this["cpt" + i].visible = false;
			this["cht" + i].visible = false;
			this["head" + i].visible = false;
		}
		for (var i = 1; i <= getJsonLength(this.form); i++) {
			var hid = this.form[(i - 1) + ""];
			var hero = HeroModule.getHeroByUid(hid);
			var h = this["hero" + i];
			h.visible = true;
			var cp = this["changePos" + i];
			var ch = this["changeHero" + i];
			var cpt = this["cpt" + i];
			var cht = this["cht" + i];
			if (this.selected == i) {
				h.setNormalImage(new cc.Sprite("#cellBg_1.png"));
				h.setSelectedImage(new cc.Sprite("#cellBg_1.png"));
				ch.visible = true;
				cht.visible = true;
			} else {
				if (this.selected != 0) {
					cp.visible = true;
					cpt.visible = true;
				}
				h.setNormalImage(new cc.Sprite("#cellBg_0.png"));
				h.setSelectedImage(new cc.Sprite("#cellBg_0.png"));
			}
			this["rankBg" + i].visible = true;
			this["rankBg" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + hero.rank + ".png"));
			this["frame" + i].visible = true;
			this["frame" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + hero.rank + ".png"));
			this["name" + i].visible = true;
			this["name" + i].setString(hero.name);
			this["rank" + i].visible = true;
			this["rank" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + hero.rank + "_icon.png"));
			this["level" + i].visible = true;
			this["level" + i].setString("LV " + hero.level);
			this["head" + i].visible = true;
			this["head" + i].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(HeroModule.getHeroHeadById(hero.heroId)));
		}
	},
	heroItemClick:function(sender){
		var tag = sender.getTag();
		this.selected = this.selected == tag ? 0 : tag;
		this.refresh();
	},
	changePosItemClick:function(sender){
		var tag = sender.getTag();
		this.form[(tag - 1) + ""] = [this.form[(this.selected - 1) + ""], this.form[(this.selected - 1) + ""] = this.form[(tag - 1) + ""]][0];
		this.selected = 0;
		this.refresh();
	},
	changeHeroItemClick:function(sender){
		var tag = sender.getTag();
//		trace("changeHero " + tag);
		postNotifcation(NOTI.GOTO_ONFORM, {page:tag - 1, type:0});
		this.removeFromParent(true);
	},
	cancelClick:function(){
		this.removeFromParent(true);
	},
	confirmClick:function(){
		FormModule.doChangeTeam(this.form, function(){
			postNotifcation(NOTI.FORM_CHANGE_SUCC);
			this.removeFromParent(true);
		}.bind(this));
	}
	
});