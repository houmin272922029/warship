var SelectRoleLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("SelectRoleOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.SelectRoleView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		};
		this.heroIds = ["hero_000401","hero_000406","hero_000419"];
		this.heroDesp = ["robin_desp_text.png","sanji_desp_text.png","zoro_desp_text.png"];
		this.heroNames = ["robin_text.png","sanji_text.png","zoro_text.png"];
		this.confirmItem.setLocalZOrder(10);
		this.addRoleInfos();
		this.refresh()
		this.current;
		for (var i = 0; i < 3; i++) {
			var blackLayerBg = cc.LayerColor.create(cc.color(0, 0, 0, 150), this["roleBtn" + (i+1)].getContentSize().width, this["roleBtn" + (i+1)].getContentSize().height);
			this["roleBtn" +  (i+1)].addChild(blackLayerBg, 16 ,10);
			blackLayerBg.visible = false;
		}
		
		
		
//		traceTable("config--", array)
	},
	addRoleInfos:function(){
		for (var i = 1; i < 4; i++) {
			var item = this["roleBtn" + i];
			var despRes = this.heroDesp[i - 1];
			var despSprite = new cc.Sprite("#" + despRes);
			item.addChild(despSprite, 5);
			despSprite.attr({
				x:item.getContentSize().width / 2,
				y:item.getContentSize().height * 0.75,
				anchorX:0.5,
				anchorY:0.5
			});
			this.heroDesp[i - 1] = despSprite;

			var nameRes = this.heroNames[i - 1];
			var nameSprite  = new cc.Sprite("#" + nameRes);
			item.addChild(nameSprite, 5);
			nameSprite.attr({
				x:item.getContentSize().width / 2,
				y:item.getContentSize().height * 0.22,
				anchorX:0.5,
				anchorY:0.5
			});
			this.heroNames[i - 1] = nameSprite;
		}
	},
	refresh:function(){

	},
	roleClick:function(sender){
		var tag = sender.getTag();
		if (tag == this.current) {
			return;
		} else {
			this.current = tag;
		}
		
		
		this.manager = ccs.armatureDataManager;
		for (var i = 0; i < 1; i++) {
			var jsonPath = "bone/guide/Tiny_CHEER/Tiny.ExportJson";
			var img = "bone/guide/Tiny_CHEER/Tiny" +  i +".png";
			var plist = "bone/guide/Tiny_CHEER/Tiny" + i + ".plist";
			this.manager.addArmatureFileInfo(img, plist, jsonPath);
		}
		this.guidePuppet = new ccs.Armature("Tiny");
		var animation = this.guidePuppet.getAnimation();
		animation.play("Cheer", -1, 0);
		this.guidePuppet.attr({
			x:cc.winSize.width / 2,
			y:cc.winSize.height / 2,
			anchorX:0.5,
			anchorY:0.5
		});
		this.guidePuppet.getAnimation().setMovementEventCallFunc(function(target, type, movementName){
			if (type > 0) {
				this.guidePuppet.removeFromParent(true);
			}
		}.bind(this), this.guidePuppet);
		this.guidePuppet.getAnimation().setFrameEventCallFunc(function(target, event, originFrameIndex, currentFrameIndex){
			if (event === "ontarget") {
			}
		}.bind(this), this.guidePuppet);
		this.guidePuppet.setScale(5);
		this["role_" +  this.current].addChild(this.guidePuppet, 100);
		
		
		
		for (var i = 0; i < 3; i++) {
			this["roleBtn" +  (i+1)].getChildByTag(10).visible = false;
			this["roleBtn" +  (i+1)].setEnabled(false);
			this.heroDesp[i].attr({
				x:this["roleBtn" +  (i+1)].getContentSize().width / 2,
				y:this["roleBtn" +  (i+1)].getContentSize().height * 0.75,
				anchorX:0.5,
				anchorY:0.5
			});
			this.heroNames[i].attr({
				x:this["roleBtn" +  (i+1)].getContentSize().width / 2,
				y:this["roleBtn" +  (i+1)].getContentSize().height * 0.22,
				anchorX:0.5,
				anchorY:0.5
			});
		}
		var item = this["roleBtn" +  this.current];
		var despText = this.heroDesp[this.current - 1];
		var nameLabel = this.heroNames[this.current - 1];
		if (item) {
			item.setLocalZOrder(1);
		}
		if (despText) {
			despText.runAction(cc.moveBy(0.3, cc.p(0, 50)));
		}
		if (nameLabel) {
			nameLabel.runAction(cc.moveBy(0.3, cc.p(0, -50)));
		}
		this.despText1.runAction(cc.sequence(
				cc.delayTime(0.3),
				cc.callFunc(function(){
					for (var i = 0; i < 3; i++) {
						if ((i + 1) != this.current) {
							this["roleBtn" +  (i+1)].getChildByTag(10).visible = true;
							this["roleBtn" +  (i+1)].setEnabled(true);
						}
					}
				}.bind(this))
		));
		
	},
	confirmClick:function(){
		var heroId = this.heroIds[this.current -1];
		if (heroId) {
			var layer = new CreateNameLayer(heroId);
			cc.director.getRunningScene().addChild(layer);
		}
	},
})