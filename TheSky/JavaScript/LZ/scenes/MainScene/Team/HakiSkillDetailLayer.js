var HakiSkillDetailLayer = cc.Layer.extend ({
	ctor:function(uid, tag){
		this._super();
		this.uid = uid;
		this.tag = tag;
		cc.BuilderReader.registerController("HakiSkillOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.HakiSkillView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
			this.closeItemClick1();
		}.bind(this));
		this.refresh(uid);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	closeItemClick:function() {
		this.removeFromParent(true);
	},
	closeItemClick1:function() {
		this.removeFromParent(true);
	},
	detailItemClick:function(sender) {
		var tag = sender.getTag();
		var layer = new HakiDetailLayer(this.uid, this.tag);
		cc.director.getRunningScene().addChild(layer);
		this.closeItemClick1();
	},
	refresh:function(uid) {
		var cfg = config.aggress_skill;
		var aggress = HeroModule.getHeroByUid(uid).aggress;
		var kind = aggress.kind;
		if (this.tag < aggress.kind) {
			kind = this.tag;
		}
		var agressIdx = aggress.kind + "_" + aggress.layer + "_" + aggress.base;
		var skilldetail = cfg["aggskill_00000" + kind];
		this["nameLabel"].setString(skilldetail.name);
		this["despLabel"].setString(skilldetail.words);

//		this["icon"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("aggskill_00000" + kind + ".png"));
	},
 });


