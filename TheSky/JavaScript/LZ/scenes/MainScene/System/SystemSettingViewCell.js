var SystemSettingViewCell = cc.Node.extend({
	ctor:function(idx){
		this._super();
		cc.BuilderReader.registerController("SystemSettingCellViewOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.SystemSettingViewCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
//		if (idx == 0 || idx == 1) {
//			this.sysBtn.visible = true;
//			this.btnLabel.visible = true;
//			if (idx == 0) {
//				this.sysLabel.setString(common.LocalizedString("音乐"));
//				this.btnLabel.setString(common.LocalizedString("已开启"));
////				this.setBtnImage(sysBtn, 0);
//			} else if (idx == 1){
//				this.sysLabel.setString(common.LocalizedString("点击音效"));
//				this.btnLabel.setString(common.LocalizedString("已关闭"));
//			} 
//		} else if (idx == 2) {
//			this.sysLabel.setString(common.LocalizedString("活动"));
//		} else if (idx == 3) {
//			this.sysLabel.setString(common.LocalizedString("帮助"));
//		} else if (idx == 4) {
//			this.sysLabel.setString(common.LocalizedString("反馈bug或建议"));
//		} else if (idx == 5) {
//			this.sysLabel.setString(common.LocalizedString("点击输入兑换礼品CD-KEY"));
//		} else if (idx == 6) {
//			this.sysLabel.setString(common.LocalizedString("联系客服"));
//		} else if (idx == 7) {
//			this.sysLabel.setString(common.LocalizedString("个人中心"));
//		} else if (idx == 8) {
//			this.sysLabel.setString(common.LocalizedString("登出"));
//		}
//		this.onSystemBtnTap();
		if (idx == 0) {
			this.sysLabel.setString(common.LocalizedString("登出"));
		}
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	setBtnImage:function(btn, type) {
		if (type == 0) {
			this.sysBtn.setNormalImage(new cc.Sprite("#btn4_0.png"));
			this.sysBtn.setSelectedImage(new cc.Sprite("#btn4_1.png"));
		} else {
			this.sysBtn.setNormalImage(new cc.Sprite("#btn2_0.png"));
			this.sysBtn.setSelectedImage(new cc.Sprite("#btn2_1.png"));
		}
	},
	onSystemBtnTap:function(idx) {
		if (idx == 0) {
			if (getUDBool(UDefKey.Setting_Music == "music")) {
				setUDBool(UDefKey.Setting_Music, "");
				this.btnLabel.setString(common.LocalizedString("已关闭"));
				this.setBtnImage(this.sysBtn, 1);
			} else {
				setUDBool(UDefKey.Setting_Music, "music");
				this.btnLabel.setString(common.LocalizedString("已开启"));
				this.setBtnImage(this.sysBtn, 0);
			}
		} else if (idx == 1) {
			if (getUDBool(UDefKey.Setting_Effect == "effect")) {
				setUDBool(UDefKey.Setting_Effect, "");
				this.btnLabel.setString(common.LocalizedString("已关闭"));
				this.setBtnImage(this.sysBtn, 1);
			} else {
				setUDBool(UDefKey.Setting_Effect, "effect");
				this.btnLabel.setString(common.LocalizedString("已开启"));
				this.setBtnImage(this.sysBtn, 0);
			}
		}
	},
});