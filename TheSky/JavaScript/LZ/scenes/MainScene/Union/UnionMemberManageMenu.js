var UnionMemberManageMenu = cc.Layer.extend({
	ctor:function(data){
		this._super();
		this.data = data;

		cc.BuilderReader.registerController("unionMemberMenuOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.UnionMemberManageMenu_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		common.swallowLayer(this, true, this.infoBg, this.closeItemClick.bind(this));
		this.refresh();
	},
	closeItemClick:function(){
		this.removeFromParent(true);
	},
	refresh:function(){
		this.upPos.visible = true;
		this.downPos.visible = true;
		this.upLabel.visible = true;
		this.downLabel.visible = true;
		this.closeLabel.visible = true;
		this.fireLabel.visible = false;
		this.promotToPresidentBtn.visible = false;
		this.promotToPresidentLable.visible = false;
		
		this.name.setString(this.data.name);
		
		var self = UnionModule.getUnionData().leaguePlayer;
		var duty = this.data.duty;
		var selfDuty = self.duty;
		if (!UnionModule.haveAuthority([5]) || duty <= selfDuty + 1) {
			this.upPos.visible = false;
			this.upLabel.visible = false;
		}
		if (!UnionModule.haveAuthority([6]) || duty === 5 || duty <= selfDuty) {
			this.downPos.visible = false;
			this.downLabel.visible = false;
		}
		if (UnionModule.haveAuthority([14]) && selfDuty === 1 && duty === 2) {
			this.upPos.visible = false;
			this.upLabel.visible = false;
			this.promotToPresidentBtn.visible = true;
			this.promotToPresidentLable.visible = true;
		}
		if (UnionModule.haveAuthority([4]) && selfDuty < duty) {
			this.closeLabel.visible = false;
			this.fireLabel.visible = true;
		}
	},
	upPosClicked:function(){
		if (UnionModule.bFull(this.data.duty - 1)) {
			var duty = UnionModule.getUnionDuty(duty)
			common.showTipText(common.LocalizedString("联盟最多拥有%d个%s", [duty.numMax, duty.name]));
		} else {
			UnionModule.doChangeDuty(this.data.id, -1, function(dic){
				this.changeDuty(dic);
			}.bind(this));
		}
	},
	downPosClicked:function(){
		UnionModule.doChangeDuty(this.data.id, 1, function(dic){
			this.changeDuty(dic);
		}.bind(this))
	},
	changeDuty:function(dic){
		var members = dic.info.league.leagueInfo.members;
		for (var k in members) {
			var member = members[k];
			if (member.id === this.data.id) {
				this.data = member;
				break;
			}
		}
		this.refresh();
		postNotifcation(NOTI.UNION_MEMBER_REFRESH);
	},
	fireClick:function(){
		var self = UnionModule.getUnionData().leaguePlayer;
		var duty = this.data.duty;
		var selfDuty = self.duty;
		if (UnionModule.haveAuthority([4]) && selfDuty < duty) {
			var text = common.LocalizedString("确定开除此成员？");
			var cb = new ConfirmBox({info:text, confirm:function(){
				UnionModule.doFire(this.data.id, function(dic){
					postNotifcation(NOTI.UNION_MEMBER_REFRESH);
					this.closeItemClick();
				}.bind(this));
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		} else {
			this.closeItemClick();
		}
	},
	promotToPresidentClicked:function(){
		var text = common.LocalizedString("union_transferCDR");
		var cb = new ConfirmBox({info:text, confirm:function(){
			UnionModule.doAbdicate(this.data.id, function(dic){
				postNotifcation(NOTI.UNION_MEMBER_REFRESH);
				this.closeItemClick();
			}.bind(this));
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
});