var HakiDetailLayer = cc.Layer.extend({
	ctor:function(uid, tag){
		this._super();
		this.uid = uid;
		this.tag = tag;
		cc.BuilderReader.registerController("HakiDetailOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.HakiDetailView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
	 common.swallowLayer(this, true, this.infoBg, function(){
			this.closeItemClick();
		}.bind(this));
	 this.refersh(uid, tag);
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
	refersh:function(uid, tag){
		var cfg = config.aggress_skill;
		var cfgTrain = config.aggress_roundattr;
		var aggress = HeroModule.getHeroByUid(uid).aggress;
		var kind = tag;
		var skilldetail = cfg["aggskill_00000" + kind];
		this["nameLabel"].setString(skilldetail.name);
		this["despLabel"].setString(skilldetail.words);
		this.menu = new cc.Menu();
		this.menu.anchorX = 0.5;
		this.menu.anchorY = 1;
		this.menu.x = 0;
		this.menu.y = 0;
		this["skill" + this.tag].addChild(this.menu);
		for (i = 1; i <= 8; i++) {
			var trainAttr = cfgTrain["roundattr_" + aggress.kind + "_" + i];
			this["stepLabel" + i].setString(trainAttr.said);
			if ((i < aggress.layer) || (i == aggress.layer && aggress.base == 30)) {
				this["stepLabel" + i].setColor(cc.color(0, 255, 0));
			} else {
				this["stepLabel" + i].setColor(cc.color(140, 140, 140));
			}
			if (i === this.tag) {
				this["skill" + i].visible = true;
			} else {
				this["skill" + i].visible = false;
			}
		}
		this.traincomplete.setString("完全突破取得的训练效果");
		if (aggress.kind != kind) {
			this.step.setString("第8重");
		} else {
			this.step.setString("第" + aggress.layer + "重");
		}
		for ( j = 1; j <= 30; j++) {
			this.createMenuItem(j);
		}
	},
	createMenuItem:function(i) {
		var cfg = config.aggress_skill;
		var aggress = HeroModule.getHeroByUid(this.uid).aggress;
		
		var cache = cc.spriteFrameCache;
		cache.addSpriteFrames(common.formatLResPath("haki_1.plist"));
		var sp1 = new cc.Sprite("#haki_line_0.png");
		var sp2 = new cc.Sprite("#haki_ball_bg.png");
		var color = 1;
		if (aggress.kind === this.tag) {
			if (aggress.base > i) {
				color = 2;
			} else {
				color = 3;
			}
		} else {
			color = 1;
		}
		var sp3 = new cc.Sprite("#blood_" + aggress.kind +"_" + color + ".png"); 
		var item = new cc.MenuItemSprite(sp3, sp3, sp3, function(uid){
			var layer = (this.tag === aggress.kind) ? aggress.layer : 8;
//			trace(layer)
			var agressIdx = this.tag + "_" + layer + "_" + i;
			var agrdata = config.aggress_data["data_" + agressIdx];
			var showInfo = "";
			for (var k in agrdata) {
				if(k !== "conmuse" && agrdata[k] !== 0) {
					showInfo = common.LocalizedString(k) + "+" + agrdata[k];
				}
			}
			if (this["detailLabel" + i]) {
				this["detailLabel" + i].setString(showInfo);
			}else{
				this["detailLabel" + i] = new cc.LabelTTF(showInfo, "Atlas", 14);
				this["detailLabel" + i].x = item.x;
				this["detailLabel" + i].y = item.y + item.width - 18;
				this["detailLabel" + i].setColor(cc.color(0, 255, 0));
				this["skill" + this.tag].addChild(this["detailLabel" + i]);
			}
			for ( m = 1; m <= 30; m++) {
				if (m != i && this["detailLabel" + m])  {
					this["detailLabel" + m].visible = false;
					
				} else if(this["detailLabel" + m]) {
					this["detailLabel" + m].visible = true;
				}
			}
		}.bind(this));
		item.setScale(0.5);
		
		item.x = this["ball_" + this.tag + "_" + i].x;
		item.y = this["ball_" + this.tag + "_" + i].y;
		
		this.menu.addChild(item,-1);
	},
	menuItemCallBack:function() {
		
	},
});