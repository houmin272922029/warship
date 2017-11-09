var GuideNewLayer = cc.Layer.extend({
	GUIDESTEP : {
		firstGotoSail : 1, // 第一次进入起航
		firstStageFight : 2, // 第一关战斗
		firstFightResult : 3, // 第一关战斗结算
		gotoRogue : 4, // 进入罗格镇
		recruit :5, // 刷将
		recruitResult : 6, // 刷将结算页面
		firstGotoTeam : 7, // 第一次进入阵容
		onForm : 8, // 上阵
		selectHero : 9, // 选择上阵伙伴
		confirmHeroSelected : 10, // 确认上阵伙伴
		secondGotoSail : 11, // 第二次进入起航
		secondStageFight : 12, // 第二关战斗
		secondFightResult : 13, // 第二关战斗结算
		secondGotoTeam : 14, // 第二次进入阵容装备武器
		equipWeapon : 15, // 装备武器
		selectWeapon : 16, // 选择武器
		confirmWeaponSelected : 17, // 确认武器选择
//		gotoHome : 18, // 
//		gotoPackage : 20, //第三次去起航
//		guideEnd : 21, // 结束

		selectNeedUpdateEquip : 18, // 选择需要强化的武器
		selectUpdateEquip : 19, // 选择强化武器
		updateEquip : 20, // 强化武器
		gotoHome : 21, // 回到首页
		gotoPackage : 22, // 去背包
		selectNewGiftBag : 23,// 选择使用新手礼包 
		takeGiftBag : 24, // 收取礼包
		thirdGotoSail : 25, // 第三次去起航
		guideEnd : 26 // 结束
	},
	ctor:function(){
		this._super();
		this.initLayer();
	},
	onEnter:function(){
		this._super();
		this.refreshLayer(true);
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("GuideOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.GuideView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.guideStep = 1;
		for (var i = 1; i < 26; i++) {
			var button = new ccui.Button("guanghuan_0.png", "guanghuan_0.png", "", ccui.Widget.PLIST_TEXTURE);
			this["touch" + i].addChild(button);
			button.attr({
				x:this["touch" + i].getContentSize().width / 2,
				y:this["touch" + i].getContentSize().height / 2,
				anchorX:0.5,
				anchorY:0.5
			});
			button.addTouchEventListener(function(sender, type){
				if (type === ccui.Widget.TOUCH_ENDED) {
					this.guideStep ++;
					this.refreshLayer(true);
				}
			}, this);
			button.setSwallowTouches(false);
		}
	},
	refreshLayer:function(m_visible){
		if (this.guideStep > 1) {
			this["guide" + (this.guideStep - 1)].visible = !m_visible;
		}
		var layer = this["guide" + this.guideStep];
		layer.visible = m_visible;
		if (this.guideStep == 26) {
			common.swallowLayer(this, true, this.role, this.closeLayer.bind(this));
		}
		
//		if (this.guideStep == 1) {
//			postNotifcation(NOTI.GOTO_STAGE);
//		} else if (this.guideStep == 2) {
//			
//		}
	},
	closeLayer:function(){
		this.removeFromParent(true);
	},
})