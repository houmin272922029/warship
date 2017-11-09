var CreateNameLayer = cc.Layer.extend({
	ctor:function(heroId){
		this._super();
		this.heroId = heroId;
		this.initLayer();
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.GET_SETTING, "getSetting", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.GET_SETTING, "getSetting", this);
	},
	initLayer:function(){
		cc.BuilderReader.registerController("CreateNameOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.CreateNameView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.longzhus = 1;
		traceTable("+-+-+", config.function_newplayer);
		this["longzhu_bg_1"].visible = true;
		this.refresh()
	},
	refresh:function(){
		var nameEditBg = this.nameEditBg;
		var editBg = cc.Sprite.createWithSpriteFrameName("guide_nameBg.png");
		this.editBox1 = new cc.EditBox(cc.size(this.chat_Bg1.getContentSize().width / 2, this.chat_Bg1.getContentSize().height / 2), editBg);
		this.editBox1.attr({
			x:this.chat_Bg1.x / 2,
			y:this.chat_Bg1.y / 2,
			anchorX:0.5,
			anchorY:0.5
		})
		this.editBox1.setFont(FONT_NAME, 30 * retina);
		this.editBox1.setAnchorPoint(cc.p(0.5, 0.5));
		nameEditBg.addChild(this.editBox1);
	},
	onRandomNameSucc:function(dic){
		if (dic.info.names) {
			this.editBox1.setString(dic.info.names);
		}
	},
	onRandomNameClicked:function(){
		trace("接口正在调试")
	},
	onOkClicked:function(){
		var name = this.editBox1.getString() || "";
		if (name == "" || name.length <= 0) {
			common.ShowText(common.LocalizedString("register_name_null"));
			return
		}
		this.getSetting();
		
	},
	onSelectFlag:function(sender){
		var tag = sender.getTag();
		if (this.longzhus == tag) {
			return;
		}else {
			this.longzhus = tag;
		}
		for (var i = 1; i < 8; i++) {
			this["longzhu_bg_" + i].visible = false;
		}
		this["longzhu_bg_" + tag].visible = true;
		this["longzhu"].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("flag_00" + tag + ".png"));
	},
	getSetting:function(){
		LoginModule.getSetting(function(dic){
			config.fromDic(dic.info);
			this.runAction(cc.sequence(
					cc.delayTime(0.5),
					cc.callFunc(function(){
						LoginModule.login(function(){
							cc.director.runScene(new MainScene());
						}, function(dic){
							if (dic.code === 1207){
								LoginModule.register([logindata.uid, logindata.token], this.editBox1.getString(), this.heroId, this.longzhus, function(dic){
								postNotifcation(NOTI.GET_SETTING);
								}.bind(this),function(dic){
									if (dic.code === 1209) {
										postNotifcation(NOTI.GET_SETTING);
									}
								})
							}
						});
					})
			));
		}.bind(this));
	},
})