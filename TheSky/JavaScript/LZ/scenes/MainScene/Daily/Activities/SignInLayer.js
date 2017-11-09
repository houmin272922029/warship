var signInLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
		this.viewData_ = null;
		this.createListView(this["content"], null, ccui.ScrollView.DIR_VERTICAL);
		this.maskMenu.setSwallowTouches(true);
		this.listView_.setSwallowTouches(false);
	},
	
	onActivate : function() {
		ActivityModule.fetchSignInData();
	},
	
	onSelect : function(index) {
		var data = this.viewData_.list[index - 1];
		ActivityModule.showDailySiginPopView(data);
	},
	
	refreshView : function(viewData){
		if (viewData == null) {
			viewData = ActivityModule.getSignInData();
		}

		this.viewData_ =  viewData;
		// 处理lable显示
		this.despLabel0.setString(this.viewData_.getRewardCount);
		this.despLabel1.setString(this.viewData_.supplCount);
		this.despLabel0.enableStroke(cc.color(131, 88, 60), 2);
		this.despLabel1.enableStroke(cc.color(131, 88, 60), 2);
		this.desp0.enableStroke(cc.color(131, 88, 60), 2);
		this.desp1.enableStroke(cc.color(131, 88, 60), 2);
		this.desp2.enableStroke(cc.color(131, 88, 60), 2);
		// 列表显示
		var totalCount = viewData.list.length;
		var cellCount = totalCount % 4 == 0 ? totalCount / 4: (totalCount - totalCount % 4) / 4 + 1;

		if (this.listView_ != null){
			this.listView_.removeAllItems();
		}
		
		for (var int = 0; int < cellCount; int++) {
			var param = {}
			var items = new Array();
			for (var int2 = 0; int2 < 4; int2++) {
				var index = int * 4 + int2;
				items.push(viewData.list[index]);
			}
			param["items"] = items;
			param["index"] = int;
			param["target"] = this;
			param["callBack"] = this.onSelect;
			var cell = new DailySiginCell(param);
			this.listView_.pushBackCustomItem(cell);
		}
	},
});

/**
 * 签到页面的一条
 */
var DailySiginCell = ccui.Layout.extend({
	ctor : function(params) {
		this._super(params);
		
		this.target_ = params.target;
		this.callBack_ = params.callBack;

		this.index_ = params.index;
		this.cellData_ = params.items;

		this.size_ = params.size || cc.size(580, 143);
		this.setContentSize(this.size_);

		cc.BuilderReader.registerController("DailySignInCellOwner", {

		});
		this.node = cc.BuilderReader.load(ccbi_res.DailySignInCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}

		this["menu1"].setSwallowTouches(false);

		this.initCell();
	},

	initCell : function() {
		traceTable("日常cell===",this.cellData_)
		for (var int = 1; int <= this.cellData_.length; int++) {
			var item = this.cellData_[int - 1];
			if (item == null) {
				return;
			}
			var conf = item["conf"];
			var itemId = conf.rewardsID;
			var resDic = item.view; //userdatagetExchangeResource(itemId)
			
			this["item" + int].setVisible(true);
			this["item" + int].setTag(this.index_ * 4 + int);
			this["contentLayer" + int].setVisible(true);
			
			var rate = item["rate"];
			var doubledVipLevel = item["doubledVipLevel"];

			if (rate > 1) {
				this["SignInMarkSprite" + int].setVisible(true);
				this["Vips" + int].setString("Vip" + doubledVipLevel);
				this["Vip" + int].setString("Vip" + doubledVipLevel);
				this["Multiple" + int].setString("X" + rate);
			}
			
			// TODO addParticle
			var addParticle =  function() {
				
			}

			var state = item["state"];

			switch (state) {
			case 0:
				this["SignInHaveGetSprite" + int].setVisible(true);
				this["SignInHaveGet" + int].setVisible(true);
				this["bigSpriteBg" + int].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("signIn_buke.png"));
				break;
			case 1:
				this["bigSpriteBg" + int].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("signIn_keqian.png"));
				this["bg_light_" + int].setVisible(true);
			case 2:
				addParticle();
				this["bg_light_" + int].setVisible(true);
				this["bigSpriteBg" + int].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("signIn_keqian.png"));
				break;

			case 3:
				this["SignInHaveGetSprite" + int].setVisible(true);
				this["SignInHaveGet" + int].setVisible(true);
				this["bg_light_" + int].setVisible(true);
				this["bigSpriteBg" + int].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("signIn_keqian.png"));
				addParticle();
				break;
				
			default:
				this["bigSpriteBg" + int].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("signIn_buke.png"));
				break;
			}
			
			this["chip_icon" + int].setVisible(false);
			
			// 判断魂魄、影子单独处理
			if (common.havePrefix(itemId, "hero")) {
				var itemIcon = this["item" + int];
				itemIcon.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(resDic.rank)));
				itemIcon.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(resDic.rank)));
				this["soulIcon" + int].setVisible(true);
				this["littleSprite" + int].setVisible(true);
				this["littleSprite" + int].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(resDic.icon));
				this["bigSpriteRank" + int].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_"+ resDic.rank + ".png"));
			} else if (common.havePrefix(itemId, "shadow")) {
				var itemIcon = this["item" + int];
				itemIcon.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("s_frame.png"));
				itemIcon.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("s_frame.png"));
				itemIcon.setPosition(cc.p(itemIcon.getPositionX() + 5, itemIcon.getPositionY() - 5));
				
				if (resDic.icon != null) {
					// 播放影子动画
					var rankLayer = this["contentLayer" + int]
					olAni.playFrameAnimation("yingzi_" + resDic.icon + "_", rankLayer,
							cc.p(rankLayer.getContentSize().width / 2, rankLayer.getContentSize().height / 2), 1, 4,
							common.getColorByRank(resDic.rank));
				}
				thisthis["bigSpriteRank" + int].visible = false;
			} else {
				// 道具，装备，技能，货币
				var texture;
				if (common.havePrefix(itemId, "_shard")) {
					texture = cc.textureCache.addImage(String("ccbResources/icons/{0}.png").format(resDic.icon));
					this["chip_icon" + int].setVisible(true);
				} else {
					if (resDic.id == "diamond") {
						texture = cc.textureCache.addImage("tc/ccbi/ccbResources/icons/diamond.png");
					} else {
						texture = cc.textureCache.addImage(resDic.icon);
					}
					
				}
				
				if (texture != null) {
					this["bigSprite" + int].setVisible(true);
					this["bigSprite" + int].setTexture(texture);
				}
				
				if (!common.havePrefix(itemId, "shadow")) {
					var itemIcon = this["item" + int];
					itemIcon.setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(resDic.rank)));
					itemIcon.setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(resDic.rank)));
					this["bigSpriteRank" + int].setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_"+ resDic.rank + ".png"));
				}
			}
		}
		
		
	},

	onCardClicked : function(sender) {
		this.callBack_.call(this.target_, sender.getTag());
	},

});