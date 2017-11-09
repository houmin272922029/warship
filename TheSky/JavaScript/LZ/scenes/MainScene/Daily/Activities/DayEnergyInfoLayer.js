var dayEnergyInfoLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
	},
	
	onActivate : function() {
		ActivityModule.getEatOiginalData([]);
	},
	
	/**
	 * @param data 可以为空，如果空，就重新取数据
	 */
	refreshView : function(viewData) {
		if (viewData == null) {
			viewData = ActivityModule.getEatViewData();
		}
		
		if (viewData == null) {
			return;
		}

		this["eatBtn1"].setVisible(false);
		this["eatBtn2"].setVisible(false);
		this["kaichiLabel1"].setVisible(false);
		this["kaichiLabel2"].setVisible(false);
		
		this.firstTimeLabel.setString(viewData.timeLabel1);
		this.secondTimeLabel.setString(viewData.timeLabel2);
		
		// 判断显示那个layer
		this["layer1"].setVisible(!viewData.isShowExtra);
		this["layer2"].setVisible(viewData.isShowExtra);
		this["menu1"].setVisible(!viewData.isShowExtra);
		this["menu2"].setVisible(viewData.isShowExtra);
		
		if (viewData.isShowExtra) {
			// 显示额外购买体力页
			for (var int = 1; int <= 2; int++) {
				this["str" + int].setString(common.LocalizedString("extra_str", viewData["str" + int]));
				this["gold" + int].setString(viewData["gold" + int]);
				var vipSp_ = viewData["vip" + int];
				this["vip" + int].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("ol_VIP_{0}.png".format(viewData["vip" + int]))));
			}
		} else {
			
			// 按钮不同状态的显示
			for (var int = 1; int <= 2; int++) {
				var status = viewData["status" + int];
				var label = this["eatLabel" + int];
				var str_ = "";
				if (status == 1) {
					// 在开饭时间
					this["eatBtn" + int].setVisible(true);
					this["kaichiLabel" + int].setVisible(true);
				} else if (status == 0) {
					// 还没开饭
					str_ = common.LocalizedString("还没开饭");
				} else if (status == 2) {
					// 时间过了
					str_ = common.LocalizedString("时间过了");
				}
				label.setString(str_);
			}
		}
	},
	
	/**
	 * 点击开吃
	 */
	goldEatClick : function(sender) {
		var tag = sender.getTag();
		ActivityModule.doEatAction(tag + 2);
	},

	onClickedEat1 : function(sender) {
		ActivityModule.doEatAction(ActivityModule.EatType.NormalEat1);
	},

	onClickedEat2 : function(sender) {
		ActivityModule.doEatAction(ActivityModule.EatType.NormalEat2);
	},
});