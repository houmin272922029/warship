var RecruitLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		this.initLayer();
		
	},
	initLayer:function() {
		cc.BuilderReader.registerController("RecruitViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.RecruitView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		var contentHeight = this.recritBg.getContentSize().height * retina;
		this.recruitDes.enableStroke(cc.color(32, 18, 9), 2);

		this.refersh();
	},
	refersh:function() {
		var freechance1 = recruitdata.shopHero.tenPickOne.freeCount;
		var freechance2 = recruitdata.shopHero.bestPickOne.freeCount;
		var freechance3 = recruitdata.shopHero.wanPickOne.freeCount;
		var price = config.recruit_cost;
		if (freechance1 == 0 || freechance2 == 0 || freechance3 == 0) {
			
			for (var i = 1; i <= 3; i++) {
				this["priceLabel" + i].setString(price[i].cost);
			}
			var fTime1 = recruitdata.shopHero.tenPickOne.nextFreeTime ? recruitdata.shopHero.tenPickOne.nextFreeTime - Global.serverTime : 0;
			var fTime2 = recruitdata.shopHero.bestPickOne.nextFreeTime ? recruitdata.shopHero.bestPickOne.nextFreeTime - Global.serverTime : 0;
			var fTime3 = recruitdata.shopHero.wanPickOne.nextFreeTime?recruitdata.shopHero.wanPickOne.nextFreeTime - Global.serverTime:0;
			if (fTime1 <= 0) {
				this.freeRecruitTimesTips1.setString("今日" + freechance1 + "次免费机会");
			} else {
				this.recruitCDTimeLabel1.setString(DateUtil.second2hms(fTime1) + "后免费");
			}
			this.freeRecruitTimesTips1.visible = fTime1 <= 0;
			this.recruitCDTimeLabel1.visible = fTime1 > 0;
//			this.priceLabel1.visible = fTime1 > 0 || freechance1 === 0;
//			this.goldIcon1.visible = fTime1 > 0 || freechance1 === 0;

			if (fTime2 <= 0) {
				this.freeRecruitTimesTips2.setString("今日" + freechance2 + "次免费机会");
			} else {
				this.recruitCDTimeLabel2.setString(DateUtil.second2hms(fTime2) + "后免费");
			}
			this.freeRecruitTimesTips2.visible = fTime2 <= 0;
			this.recruitCDTimeLabel2.visible = fTime2 > 0;
//			this.priceLabel2.visible = fTime2 > 0 || freechance2 === 0;
//			this.goldIcon2.visible = fTime2 > 0 || freechance2 === 0;

			if (fTime3 <= 0) {
				this.freeRecruitTimesTips3.setString("今日" + freechance3 + "次免费机会");
			} else {
				this.recruitCDTimeLabel3.setString(DateUtil.second2hms(fTime3) + "后免费");
			}
			this.freeRecruitTimesTips3.visible = fTime3 <= 0;
			this.recruitCDTimeLabel3.visible = fTime3 > 0;
//			this.priceLabel3.visible = fTime3 > 0 || freechance3 === 0;
//			this.goldIcon3.visible = fTime3 > 0 || freechance3 === 0;

		} else {
			var fTime1 = recruitdata.shopHero.tenPickOne.nextFreeTime - Global.serverTime;
			var fTime2 = recruitdata.shopHero.bestPickOne.nextFreeTime - Global.serverTime;
			var fTime3 = recruitdata.shopHero.wanPickOne.nextFreeTime - Global.serverTime;
			if (fTime1 > 0) {
				this.recruitCDTimeLabel1.setString(DateUtil.second2hms(fTime1) + "后免费");
				this.freeRecruitTimesTips1.visible = false;
			} else {
				this.freeRecruitTimesTips1.setString("今日" + freechance1 + "次免费机会");
			}
			this.recruitCDTimeLabel1.visible = fTime1 > 0;
//			this.priceLabel1.visible = fTime1 > 0 || freechance1 === 0;
//			this.goldIcon1.visible = fTime1 > 0 || freechance1 === 0;
			if (fTime2 > 0) {
				this.recruitCDTimeLabel2.setString(DateUtil.second2hms(fTime2) + "后免费");
				this.freeRecruitTimesTips2.visible = false;
			} else {
				this.freeRecruitTimesTips2.setString("今日" + freechance2 + "次免费机会");
			}
			this.recruitCDTimeLabel2.visible = fTime2 > 0;
//			this.priceLabel2.visible = fTime2 > 0 || freechance2 === 0;
//			this.goldIcon2.visible = fTime2 > 0 || freechance2 === 0;
			if (fTime3 > 0) {
				this.recruitCDTimeLabel3.setString(DateUtil.second2hms(fTime3) + "后免费");
				this.freeRecruitTimesTips3.visible = false;
			} else {
				this.freeRecruitTimesTips3.setString("今日" + freechance3 + "次免费机会");
			}
			this.recruitCDTimeLabel3.visible = fTime3 > 0;
//			this.priceLabel3.visible = fTime3 > 0 || freechance3 === 0;
//			this.goldIcon3.visible = fTime3 > 0 || freechance3 === 0;
		}
		
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.RESURIT_HERO, "refersh", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.RESURIT_HERO, "refersh", this);
	},
	recruitAction:function(sender) {
		tag = sender.getTag();
		var cost = config.recruit_cost[tag - 100].cost;
		if (recruitdata.shopHero.tenPickOne.isFree == 1 || recruitdata.shopHero.bestPickOne.isFree == 1 || recruitdata.shopHero.wanPickOne.isFree == 1) {
			RecruitModule.doRecruit(tag - 100, "1", this.refersh.bind(this));
		} else {
			if  (tag == 101) {
				if (cost > PlayerModule.getGold()) {
					var text = common.LocalizedString("船长您的金币不足啦,请前往充值中心充值");
					var cb = new ConfirmBox({info:text, type:0, confirm:function(){
						var layer = new RechargeLayer();
						cc.director.getRunningScene().addChild(layer);
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				} else {
					RecruitModule.doRecruit(tag - 100, "1", this.refersh.bind(this));
				}
			} else if(tag == 102) {
				if (cost > PlayerModule.getGold()) {
					var text = common.LocalizedString("船长,重金才能招募到厉害的伙伴,但是你的金币数量不足了,快去充值招募心仪的伙伴吧！");
					var cb = new ConfirmBox({info:text, type:0, confirm:function(){
						var layer = new RechargeLayer();
						cc.director.getRunningScene().addChild(layer);
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				} else {
					var text = common.LocalizedString("船长,确定花费100个金币招募吗？");
					var cb = new ConfirmBox({info:text, type:0, confirm:function(){
						RecruitModule.doRecruit(tag - 100, "1", this.refersh.bind(this));
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				}
			} else if (tag == 103) {
				if (cost > PlayerModule.getGold()) {
					var text = common.LocalizedString("船长，重金才能招募到厉害的伙伴，但是你的金币数量不足了，快去充值招募心仪的伙伴吧！");
					var cb = new ConfirmBox({info:text, type:0, confirm:function(){
						var layer = new RechargeLayer();
						cc.director.getRunningScene().addChild(layer);
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				} else{
					var text = common.LocalizedString("船长,确定花费300个金币招募吗？");
					var cb = new ConfirmBox({info:text, type:0, confirm:function(){
						RecruitModule.doRecruit(tag - 100, "1", this.refersh.bind(this));
					}.bind(this)});
					cc.director.getRunningScene().addChild(cb);
				}
			}
		}
	},
	zhanBuInfoClick:function(){
		common.ShowText(common.LocalizedString("component_close"));
	},
	infoClick:function(sender) {
		var tag = sender.getTag();
		var text = common.LocalizedString("掉落详情")
		var cb = new RecruitHeroesView({info:text, type:tag, close:function(){}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
		
	},
});