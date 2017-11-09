var HakiViewCell = cc.Layer.extend({
	ctor:function(uid, page){
		this._super();
		this.page = page;
		if(uid) {
			this.hero = HeroModule.getHeroByUid(uid);
			this.uid = uid;
		}
		this.initLayer(uid);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},

	initLayer:function(uid){
		cc.BuilderReader.registerController("TeamHakiViewCellOwner", {
		});
		cc.BuilderReader.registerController("HakiSkillCellOwner", {
		});
		cc.BuilderReader.registerController("HakiDetailCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.TeamHakiViewCell_ccbi, this);
		if(this.node != null){
			this.addChild(this.node);
		}
		var size = this.node.getContentSize();
		this.setContentSize(size);
		this.menu.setSwallowTouches(false);
		this.lockLayer.visible = false;
		if (uid) {
			var level = HeroModule.getHeroByUid(uid).level;
			var openLevel = HeroModule.hakiOpenLv();
			if (level < openLevel)
			{
				this.lockLayer.visible  = true;
			}
		}
		this.refersh(uid);
	},
	refersh:function(uid, amount){
		if (uid) {
			var hero = this.hero;
			var attrHaki = HeroModule.getHeroAttrsAndAddByHero(hero)[0];
			if (attrHaki) {
				this.hpLabel.setString(attrHaki.hp);
				this.atkLabel.setString(attrHaki.atk);
				this.defLabel.setString(attrHaki.def);
				this.mpLabel.setString(attrHaki.mp);
				this.criLabel.setString(attrHaki.cri);
				this.dodLabel.setString(attrHaki.dod);
				this.parryLabel.setString(attrHaki.parry);
				this.resiLabel.setString(attrHaki.resi);
				this.hitLabel.setString(attrHaki.hit);
				this.cntLabel.setString(attrHaki.cnt);	
				var aggress = HeroModule.getAggressByUid(uid);
				if (aggress) {
					var agressIdx = aggress.kind + "_" + aggress.layer + "_" + aggress.base;
					var agrdata = config.aggress_data["data_" + agressIdx];
					this.costLabel1.setString(agrdata.conmuse);
					this.costLabel2.setString(agrdata.conmuse);
					var showInfo = "";
					for (var k in agrdata) {
						if(k !== "conmuse" && agrdata[k] !== 0) {
							showInfo = common.LocalizedString(k) + "+" + agrdata[k];
						}
					}
					this.attr1.setString(showInfo);
					this.attr2.setString(showInfo);
				}
				for (i = 1; i <= 8; i++) {
					var value = true;
					if (aggress.kind > i) {
						value = false;
					}
					this["hakiLock" + i].visible = value;
				}
				this.avatarSprite.setTexture(HeroModule.getHeroBust1ById(hero.heroId));
				this.avatarSprite.visible = true;
				var blood = PlayerModule.getHotBlood();
				this.hakiBloodLabel.setString(blood);
			}
		}
	},
	teamItemClick:function() {
		postNotifcation(NOTI.TEAM_CHANGE_TYPE, {type : 0});
	},
	hakiTrainItemClick:function() {
		var aggress = HeroModule.getAggressByUid(this.uid);
		var agPre = HeroModule.getAggressByUid(this.uid).pre;
		if (agPre === 0 ) {
			//TODO
			if (aggress.kind > 8) {
				//弹框ERR_8001
			}
			//对话框
			var layer = new StageTalkView();
			cc.director.getRunningScene().addChild(layer);
		} else if(agPre === 1) {
			HeroModule.doTrain(this.uid, this.trainSucc.bind(this));
		} 
//		HeroModule.doFight(this.uid, this.trainSucc.bind(this));
	},
	trainSucc:function(rtnData) {
		var agressdata = rtnData.info.heros[this.uid].aggress;
		var agressIdx = agressdata.kind + "_" + agressdata.layer + "_" + (agressdata.base + 1);
		var agrdata = config.aggress_data["data_" + agressIdx];
		var attrHaki = HeroModule.getHeroByUid(this.uid).attrFix;
		for (var k in agrdata) {
			if (agrdata[k] > 0 && k !== "conmuse") {
				attrHaki[k] = attrHaki[k] + agrdata[k];
			}
		}
		this.refersh(this.uid);
	},
	statusItemClick:function() {
		var agressdata = HeroModule.getHeroByUid(this.uid).aggress;
		var layer = new HakiSkillDetailLayer(this.uid, agressdata.kind);
		cc.director.getRunningScene().addChild(layer);
	},
	ballItemClick:function() {
		var agressdata = HeroModule.getHeroByUid(this.uid).aggress;
		var layer = new HakiSkillDetailLayer(this.uid, agressdata.kind);
		cc.director.getRunningScene().addChild(layer);
	},
	collectItem:function() {
		//TODO
	},
	SkillClick:function(sender) {
		var tag = sender.getTag();
		var agr = HeroModule.getHeroByUid(this.uid).aggress;
		if (agr.kind > tag) {
			var layer = new HakiSkillDetailLayer(this.uid, tag);
			cc.director.getRunningScene().addChild(layer);
		} else {
			return;
		}
		
	},
})