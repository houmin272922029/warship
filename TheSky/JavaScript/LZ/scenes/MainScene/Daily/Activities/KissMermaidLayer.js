var kissMermaidLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
		
		this.aniLayerContainer = {};
	},
	
	onActivate : function() {
		ActivityModule.fetchKissMermaidData([]);
	},
	
	refreshView : function(viewData){
		if (viewData == null) {
			viewData = ActivityModule.getKissMermaidData();
		}
		
		this["kissCount"].setString(common.LocalizedString("已亲吻%d/%d次", [viewData.successionDays, viewData.days]));
		if (this.partical_ != null) {
			this.partical_.removeFromParent(true)
		}
		if (viewData.successionDays == viewData.days) {
			this["mouthBtn"].setEnable(false);
		} else {
			if (viewData.isKissToday == 1) {
				// 今天已经亲吻过
				this["mouthBtn"].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("merman_liwu.png"));
				this["mouthBtn"].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("merman_liwu.png"));
			} else {
				// 添加粒子效果
				var contentSize = this["mouthBtn"].getContentSize();
				this.partical_ = olAni.addPartical({
					plist :    "images/eff_onMouth.plist", 
					node :     this["mouthBtn"],
					pos :      cc.p(contentSize.width / 2, contentSize.height / 2),
					scaleX :   1,
					scaleY :   1,
					duration : 5,
				});
			}
		}
	},
	
	onKissClicked : function (){
		ActivityModule.kissMermaidAction(this, function(dic) {
			cc.BuilderReader.registerController("MermanAnimation_LayerOwner", {

			});
			var aniLayer = cc.BuilderReader.load(ccbi_res.DialyMermanAnimationView_ccbi, this.aniLayerContainer);
			if(aniLayer != null) {
				this.addChild(aniLayer);
			}
		});
	},
});