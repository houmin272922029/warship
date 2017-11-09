var invitationLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);

		this.initLayer();
	},
	
	onActivate : function() {
		ActivityModule.fetchInviteData();
	},
	
	/**
	 * 初始化一些静态的显示
	 */
	initLayer : function() {
		this.editBox_ = null;
	},
	
	/**
	 * 当邀请页面数据发生改变，刷新页面
	 * @param viewData
	 */
	refreshView : function(viewData) {
		if (viewData == null) {
			viewData = ActivityModule.getInvitationData();
		}
		this.viewData_ = viewData;
				
		this.selfCode.setString(viewData.selfCode);
		this.invitedNum.setString(viewData.acceptCount);
		
		var isInvited = viewData.isInvited;
		this.acceptInviteLabel.setVisible(!isInvited);
		this.eidtBoxPos.setVisible(!isInvited);
		this.receiveInviteBtn.setVisible(!isInvited);
		this.receiveInviteLabel.setVisible(!isInvited);
		
		if (!isInvited) {
			
			this.editBox_ = new cc.EditBox(this.eidtBoxPos.getContentSize(), new cc.Scale9Sprite("#chat_bg.png"), new cc.Scale9Sprite("#chat_bg.png"));
			this.editBox_.setPosition(cc.p(0, 0));
			this.editBox_.setAnchorPoint(0, 0);
			this.editBox_.setFont(common.formatLResPath("FZCuYuan-M03S.ttf"), 24 * retina);
			
			this.eidtBoxPos.addChild(this.editBox_);
			this.editBox_.setVisible(true);
			
		} else {
			
			if (this.editBox_ != null) {
				this.editBox_.setVisible(false);
			}
			
		}	
		
		// 奖励显示
		for (var int = 0; int < 4; int++) {
			this["boxBtn" + (int + 1)].setTag(int + 1);
			if (viewData.rewardList[int] != null) {
				
				var oneItem = viewData.rewardList[int];
				this["inviteNumTip" + (int + 1)].setString(oneItem.count);
				
				if (oneItem.lackCount != 0) {
					this["jincha_" + (int + 1)].setVisible(true);
					this["num_" + (int + 1)].setVisible(true);
					this["num_" + (int + 1)].enableStroke(cc.color(255, 255, 255), 2);
					this["num_" + (int + 1)].setString(oneItem.lackCount);
				} else {
					this["jincha_" + (int + 1)].setVisible(false);
					this["num_" + (int + 1)].setVisible(false);
				}
				
			} else {
				
				this["boxBtn" + (int + 1)].setVisible(false);
				this["inviteNumTip" + (int + 1)].setVisible(false);
				this["lingqu_" + (int + 1)].setVisible(false);
				this["jincha_" + (int + 1)].setVisible(false);
				this["jincha_bg" + (int + 1)].setVisible(false);
				
			}
		}
	},
	
	/**
	 * 复制自己的邀请码
	 * 
	 * @function copyToPasteBoard 拷贝字符串到剪贴板的方法
	 * @param string str 希望拷贝的字符串
	 * @return 是否拷贝成功
	 */
	copyInviteCode : function() {
		var selfCode = this.viewData_.selfCode;
		cc.Application.getInstance().copyToPasteBoard(selfCode);
		common.ShowText(common.LocalizedString("daily_copy_success"))
	},
	
	/**
	 * 接受他人邀请
	 * receiveInvite
	 */
	receiveInvite : function() {
		var code = this.editBox_.string;
		if (code.length > 0) {
			ActivityModule.acceptInvitation(code);
		} else {
			common.ShowText(common.LocalizedString("daily_invite_inviteNumIsEmpty"));
		}
	},
	
	onBoxClicked : function(sender) {
		var tag = sender.getTag();
		if (this.viewData_ == null || this.viewData_.rewardList == null) {
			return;
		}
		var viewData = this.viewData_.rewardList[tag - 1];
		if (viewData != null) {
			ActivityModule.showInvitionReswardView(viewData);
		}
	}
	
});