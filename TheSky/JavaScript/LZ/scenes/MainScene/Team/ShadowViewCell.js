var ShadowViewCell = cc.Layer.extend({
	ctor:function(uid, page){
		this._super();
		this.uid = uid;
		this.page = page;
		if (uid) {
			this.hero = HeroModule.getHeroByUid(uid);
		}
		this.shadows = [];
		this.initLayer(uid);
	},
	initLayer:function(uid){
		cc.BuilderReader.registerController("shadowViewCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShadowViewCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		var size = this.node.getContentSize();
		this.setContentSize(size);
		this.menu.setSwallowTouches(false);
		
		if (uid) {
			var hero = this.hero;
			var attr = HeroModule.getHeroAttrsByHeroUId(uid);
			this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("hero_bg_" + hero.rank + ".png"));
			this.rankIcon.visible = true;
			this.rankIcon.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + hero.rank + "_icon.png"));
			if (hero["break"] && hero["break"] > 0) {
				this.breakLevel.visible = true;
				this.breakLevelFnt.setString(hero["break"]);
			}
			this.updateLabel("nameLabel", hero.name);
			this.updateLabel("levelLabel", "LV" + hero.level);
			this.updateLabel("priceLabel", hero.price);
			this.updateLabel("hpLabel", attr.hp);
			this.updateLabel("atkLabel", attr.atk);
			this.updateLabel("defLabel", attr.def);
			this.updateLabel("mpLabel", attr.mp);
			
			this.avatarSprite.setTexture(HeroModule.getHeroBust1ById(hero.heroId));
			this.avatarSprite.visible = true;
			
			this.progressBg.visible = true;
			this.progress = new cc.ProgressTimer(new cc.Sprite("#pro_blue.png"));
			this.progress.type = cc.ProgressTimer.TYPE_BAR;
			this.progress.midPoint = cc.p(0, 0);
			this.progress.barChangeRate = cc.p(1, 0);
			this.progressBg.getParent().addChild(this.progress);
			this.progress.setPosition(cc.p(this.progressBg.x, this.progressBg.y));
			this.progress.scale = retina;
			this.progress.percentage = hero.expNow / hero.expMax * 100;
			var shadows = hero.shadow || {};
			for (var i = 1; i <= 6; i++) {
				var item = this["shadowItem" + i];
				item.setTag(i);
				var shadowBg = this["shadowBg" + i];
				shadowBg.visible = true;
				if (ShadowModule.bOpen(hero.level, i)) {
					var sid = shadows[(i - 1) + ""];
					if (sid) {
						var shadow = ShadowModule.getShadowByUid(sid);
						var array = {pos:i-1,sid:sid};
						this.shadows.push(array);
						var cfg = ShadowModule.getShadowConfig(shadow.shadowId);
						olAni.playFrameAnimation("yingzi_" + cfg.icon + "_", shadowBg, 
								cc.p(shadowBg.getContentSize().width / 2, shadowBg.getContentSize().height / 2),
								1, 4, common.getColorByRank(shadow.rank));
						this.updateLabel("shadowName" + i, cfg.name);
						this.updateLabel("level" + i, shadow.level);
						var levelBg = this["levelBg" + i];
						levelBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("shadow_level_bg.png"));
						levelBg.visible = true;
					}
				} else {
					this["shadowItem" + i].setEnabled(false);
					var lock = new cc.Sprite("#shadowLock.png");
//					lock.setPosition(cc.p(shadowBg.x/2, shadowBg.y/2))
					shadowBg.addChild(lock);
				}
			}
			var attr = ShadowModule.getAttrsByHero(this.hero);
			var idx = 1
			for (var k in attr) {
				if (idx > 6) {
					break;
				}
				var v = attr[k];
				this.updateLabel("combo" + idx, k + " + " + v);
				idx++;
			}
			this.huobanItem.visible = true;
			this.huobanItem.setEnabled(true);
		} else {
			for (var i = 1; i <= 6; i++) {
				this["shadowItem" + i].visible = false;
			}
			this.bodyItem.setEnabled(false);
			this.huobanItem.visible = true;
			this.huobanItem.setEnabled(true);
		}
	},
	updateLabel:function(key, value){
		this[key].visible = true;
		this[key].setString(value);
	},
	huobanItemClick:function(){
		postNotifcation(NOTI.TEAM_CHANGE_TYPE, {type : 2});
	},
	bodyItemClick:function(){
		trace("bodyItemClick");
	},
	shadowItemClick:function(sender){
		var pos = sender.getTag() - 1;
		var shadow;
		for (var i = 0; i < this.shadows.length; i++) {
			if (this.shadows[i].pos == pos) {
				shadow = this.shadows[i].sid;
			}
		}
		if (shadow) {
			cc.director.getRunningScene().addChild(new ShadowDetail(ShadowModule.getOneShadowByUid(shadow), 0, {exit : function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : this.page});
			}.bind(this), hid:this.uid, pos:pos}));
		} else {
			postNotifcation(NOTI.GOTO_SHADOW_CHANGE, {hid:this.uid, pos:pos, exit:function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : this.page, type:1});
			}.bind(this)});
		}
	},
	heroItemClick:function(){
		trace("heroItemClick " + this.uid + " " +this.page);
		if (this.uid) {
			cc.director.getRunningScene().addChild(new HeroDetail(this.uid, 5, this.hero.rank, {exit:function(){
				postNotifcation(NOTI.GOTO_TEAM, {page : this.page});
			}.bind(this)}));
		} else {
			postNotifcation(NOTI.GOTO_ONFORM, {page:this.page, type:0});
		}
	}
});