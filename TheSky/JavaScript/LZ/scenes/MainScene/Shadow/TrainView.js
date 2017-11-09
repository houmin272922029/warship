var TrainView = cc.Layer.extend({
	ctor:function(){
		this._super();
		this.initLayer();
		this.updataTrainViewUI();
	},
	initLayer:function(){
		cc.BuilderReader.registerController("TrainShadowContentOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.TrainShadowContentView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.status = shadowdata.shadowData.statusNow;
		var height = cc.winSize.height - this.topLayer.getContentSize().height - this.bottomContentLayer.getContentSize().height * retina - mainBottomTabBarHeight * retina - 10;
		this.tableContentSprite.setContentSize(this.tableContentSprite.getContentSize().width, height / retina * 0.98);
		this.tableContentSprite.setPosition(cc.p(cc.winSize.width / 2, cc.winSize.height - this.topLayer.getContentSize().height - 10));
		this.bottomContentLayer.setPosition(cc.p(this.bottomContentLayer.x, 112 * retina));
		this.stateArray = [];
		for (var i = 1; i < 10; i++) {
			var array = {};
			var luffy = this["luffy" + i];
			array.pos = cc.p(luffy.getPosition().x, luffy.getPosition().y);
			array.scale = luffy.getScale();
			this.stateArray.push(array);
		}
		this.initLuffyPos();
		this._refresh_JianJue_PinMing_TwoBtn();
	},
	
	updataTrainViewUI:function(){
		this.initLuffyPos();
		this._refresh_JianJue_PinMing_TwoBtn();
		this.refreshTimeLabel();
//		this.createTableView();
//		this.tv.reloadData();
	},
	/**
	 * 刷新时间显示
	 */
	refreshTimeLabel:function(){
		var duration = ShadowModule.getTimeDurationNextFreeTime();
		if (duration > 0) {
			this.timeLablel.setString(DateUtil.second2dhms(duration));
			this.timeLablel.visible = true;
		}
	},
	/**
	 * 刷新文字显示
	 * @param pos
	 */
	refreshGoldAndBerryLabels:function(pos){
		var needBerryCfg = ShadowModule.getTrainShadowNeedBerry(pos);
		var needBerry = 0;
		if (needBerryCfg) {
			needBerry = needBerryCfg.silver;
		}
		this.berryLabel.setString(needBerry);
		this.goldLabel.setString("200");
	},
	normalTheBtn:function(sender){
		sender.setNormalImage(new cc.Sprite("#btn_16_0.png"));
		sender.setSelectedImage(new cc.Sprite("#btn_16_1.png"));
	},
	blackTheBtn:function(sender){
		sender.setNormalImage(new cc.Sprite("#btn_16_0.png"));
		sender.setSelectedImage(new cc.Sprite("#btn_16_1.png"));
	},
	/**
	 * 刷新坚决和拼命两个按钮
	 */
	_refresh_JianJue_PinMing_TwoBtn:function(){
		var center = ShadowModule.getCenterIndex();
		if (center == 4 ){
			this.blackTheBtn( this.trainByHeartBtn);
		} else if( center == 5) { 
			this.blackTheBtn( this.trainByHeartBtn);
			this.blackTheBtn( this.trainAtFullSplitBtn);
		} else {
			this.normalTheBtn( this.trainByHeartBtn);
			this.normalTheBtn( this.trainAtFullSplitBtn);
		}
	},
	showQuality:function(center){
		var SHADOW_QUALITY_COUNT = [2,3,4,3,4];
		var SHADOW_QUALITY = [[1,2], [1,2,3], [1,2,3,4], [2,3,4], [3,4,5,0]];
		var qualityCount = SHADOW_QUALITY_COUNT[center - 1];
		var shadowQuality = SHADOW_QUALITY[center - 1];
		this.qualityBg.removeAllChildren(true);
		for (var i = 0; i < qualityCount; i++) {
			var quality;
			if (shadowQuality[i] > 0) {
				quality = cc.Sprite.createWithSpriteFrameName("rank_" + shadowQuality[i] + "_icon.png");
				quality.setScale(0.8);
			} else {
				quality = cc.Sprite.createWithSpriteFrameName("shadow.png");
				quality.setScale(1);
			}
			quality.setPosition(cc.p(this.qualityBg.getContentSize().width / 2, this.qualityBg.getContentSize().height / (qualityCount + 1) * (i + 1)));
			this.qualityBg.addChild(quality);
		}
	},
	/**
	 * 刷新路飞的位置
	 */
	initLuffyPos:function(){
		var center = ShadowModule.getCenterIndex();
		this.refreshGoldAndBerryLabels(center);
		this.luffyPosArray = [];
		for (var i = 0; i < 5; i++) {
			this.luffyPosArray[i] = i + 5 - center;
			var nowPos = this.stateArray[this.luffyPosArray[i]].pos;
			var scale = this.stateArray[this.luffyPosArray[i]].scale;
			this["aniLuffySprite" + (i+1)].setPosition(nowPos);
			this["aniLuffySprite" + (i+1)].setScale(scale);
			var value = 5 - Math.abs(i + 1 - center);
			this["aniLuffySprite" + (i+1)].getParent().reorderChild(this["aniLuffySprite" + (i + 1)],value);
		}
		this.luffyDespWord.getParent().reorderChild(this.luffyDespWord,6);
		this.luffyDespWord.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("ol_lianying_text_" + center + ".png"));
		this.showQuality(center)
	},
	setCustomzorder:function(sender, value){
		sender.getParent().reorderChild(sender, value);
	},
	setAnimation:function(){
		this.isAnimation = false;
	},
	/**
	 * 生成一个动作序列 
	 * @param nowPos 当前位置
	 * @param desPos 偏移后的位置
	 * @param duration 偏移时间
	 * @param sender   偏移目标
	 * @returns        序列动作
	 */
	generateActionSequence:function(nowPos, offset, duration, sender){
		var array = [];
		var flageNum = offset < 0 ? -1 : 1;
		var time = duration / (offset) * flageNum;
		var absOffSet = Math.abs(offset);
		for (var j = 0; j < absOffSet; j++) {
			var value = 4 - Math.abs(nowPos + offset - 4);
			var desState = this.stateArray[nowPos + offset];
			var spawn = cc.Spawn.create(cc.MoveTo.create(time, desState.pos), cc.scaleTo(time, desState.scale));
			array.push(spawn);
			array.push(cc.CallFunc.create(this.setCustomzorder(sender, value)))
		}
		array.push(cc.CallFunc.create(this.setAnimation));
		return cc.Sequence.create(array);
	},
	setFontAction:function(spriteIndex){
		this.luffyDespWord.getParent().reorderChild(this.luffyDespWord,6);
		this.luffyDespWord.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("ol_lianying_text_" + spriteIndex + ".png"));
	},
	/**
	 * @param 要居中显示的路飞位置索引  
	 * @param 动画的时间间隔
	 */
	animationAction:function(spriteIndex, duration){
		this.isAnimation = true;
		this.refreshGoldAndBerryLabels(spriteIndex);
		var offset = 5 - this.luffyPosArray[spriteIndex];
		if (offset == 0) {
			this.isAnimation = false;
			return;
		}
		for (var i = 0; i < 5; i++) {
			var nowPos = this.luffyPosArray[i];
			this["aniLuffySprite" + (i + 1)].runAction(this.generateActionSequence( nowPos, offset, duration, this["aniLuffySprite" + (i + 1)]));
			this.luffyPosArray[i] = nowPos + offset;
		}
		this.runAction(cc.Sequence.create(cc.delayTime(duration), cc.CallFunc.create(this.setFontAction(spriteIndex))));
		this.showQuality(spriteIndex)
	},
	initData:function(){
		this.shadows = ShadowModule.getTrainViewData();
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var size = cc.size(cc.winSize.width, this.tableContentSprite.getContentSize().height * retina);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:cc.winSize.height - this.topLayer.getContentSize().height - this.tableContentSprite.getContentSize().height * retina - 10,
			anchorX:0,
			anchorY:0
		});
		this.tv.setBounceable(true);
		this.tv.setDelegate(this);
		this.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function(table, cell) {
	},
	tableCellSizeForIndex:function(table, idx){
		return cc.size(cc.winSize.width, 155 * retina);
	},
	tableCellAtIndex:function(table, idx){
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new TrainShadowCell(this.shadows[idx]);
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0,
			scale:retina
		});
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function(table){
		return this.shadows.length;
	},
	/**
	 * 坚决
	 */
	trainByHeartAction:function(){
		if (this.isAnimation) {
			return;
		}
		if (playerdata.gold < 200) {
			common.showTipText(common.LocalizedString("ERR_1101"));
//			var info = common.LocalizedString("qingjiao_goldEnough");
//			var cb = new ConfirmBox({info:info, type:0, confirm:function(){
//				//TODO 跳转商店
//			}.bind(this)});
//			cc.director.getRunningScene().addChild(cb);
			return;
		}
		if (ShadowModule.getCenterIndex() == 5) {
			common.showTipText(common.LocalizedString("shadow_hadReachedTheHighest"));
			return;
		} else if (ShadowModule.getCenterIndex() == 4) {
			common.showTipText(common.LocalizedString("shadow_hadReachedTheJianJue"));
			return;
		} else {
			var info = common.LocalizedString("sureCostGold?" ,200);
			var cb = new ConfirmBox({info:info, type:0, confirm:function(){
				ShadowModule.doOnShadowChangeStatus([4], this.trainShadowByHeartCallBack.bind(this))
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		}
	},
	trainShadowByHeartCallBack:function(){
		this._haveJianJue = true;
		this._refresh_JianJue_PinMing_TwoBtn();
		this.animationAction(ShadowModule.getCenterIndex(), 0.3);
		this.tv.reloadData();
	},
	trainShadowCallBack:function(){
		this.tv.reloadData();
		this._haveJianJue = false;
		this._refresh_JianJue_PinMing_TwoBtn();
		this.animationAction(ShadowModule.getCenterIndex(), 0.3);
		this.tv.reloadData();
	},
	/**
	 * 炼影一次
	 */
	trainShadowAction:function(){
		this.status = shadowdata.shadowData.statusNow;
		if (this.status == 4 || this.status == 5) {
			ShadowModule.doOnShadowExerciseWithStatus(this.status, 1, this.trainShadowCallBack.bind(this));
		}
		ShadowModule.doOnShadowExercise([1], this.trainShadowCallBack.bind(this));
	},
	/**
	 * 练影十次
	 */
	trainShadowTenTimesAction:function(){
		if (this.isAnimation) {
			return;
		}
		ShadowModule.doOnShadowExercise([10], this.trainShadowCallBack);
	},
	/**
	 * 拼命
	 */
	trainAtFullSplitAction:function(){
		if (this.isAnimation) {
			return;
		}
		if (playerdata.gold < 500) {
			common.showTipText(common.LocalizedString("ERR_1101"));
//			var info = common.LocalizedString("qingjiao_goldEnough");
//			var cb = new ConfirmBox({info:info, type:0, confirm:function(){
//				//TODO 跳转商店
//			}.bind(this)});
			return;
		}
		if (ShadowModule.getCenterIndex() == 5) {
			common.showTipText(common.LocalizedString("shadow_hadReachedTheHighest"));
			return;
		}
		if (ShadowModule.getCenterIndex() == 4) {
			if (this._haveJianJue) {
				var info = common.LocalizedString("shadow_surePingMingWithJianJue?");
				var cb = new ConfirmBox({info:info, type:0, confirm:function(){
					ShadowModule.doOnShadowChangeStatus([5], this.trainShadowAtFullSplitCallBack.bind(this))
				}.bind(this)});
				return;
			}
		}
		if (ShadowModule.getCenterIndex() != 5) {
			var info = common.LocalizedString("sureCostGold?", 500);
			var cb = new ConfirmBox({info:info, confirm:function(){
				ShadowModule.doOnShadowChangeStatus([5], this.trainShadowAtFullSplitCallBack.bind(this))
			}.bind(this)});
			cc.director.getRunningScene().addChild(cb);
		}
	},
	trainShadowAtFullSplitCallBack:function(){
		this._refresh_JianJue_PinMing_TwoBtn();
		this.animationAction(ShadowModule.getCenterIndex(), 0.5);
		this.tv.reloadData();
	},
	/**
	 * 炼其他
	 */
	trainShadowTrainOtherTimes:function(){
		var TrainShadowOtherTimesLayer ;//TODO 创建炼其他页面
		cc.director.getRunningScene().addChild(new TrainShadowOther());
	},
	onEnter:function(){
		this._super();
		this.isAnimation = false;
		addObserver(NOTI.TRINGSHADOW_CD_TIME, "refreshTimeLabel", this);
		addObserver(NOTI.updataTrainViewUI, "refreshTimeLabel", this);
		this.updataTrainViewUI();
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.TRINGSHADOW_CD_TIME, "refreshTimeLabel", this);
		removeObserver(NOTI.updataTrainViewUI, "refreshTimeLabel", this);
	},
});