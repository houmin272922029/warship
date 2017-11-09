var UpdateShadowView = cc.Layer.extend({
	ctor:function(shadow,type){
		this._super();
		this.type = type || 0; //0:显示退出 1:显示放弃
		this.select = -1 ; // 表示选中的rank
		this.selectType = -1; //0:全选  1:全不选
		this.materialArray = []; 
		this.shadow = shadow;
		this.nowExp = this.shadow.expNow;
		cc.BuilderReader.registerController("ShadowUpdateLayerOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ShadowUpdateView_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		var cfg = this.shadow.cfg;
		var rankLayer = this.rankLayer;
		olAni.playFrameAnimation("yingzi_" + cfg.icon + "_", rankLayer,
				cc.p(rankLayer.getContentSize().width / 2, rankLayer.getContentSize().height / 2), 1, 4,
				common.getColorByRank(this.shadow.rank));
		this.levelIconTTF.setString(this.shadow.level);
		this.nameLabel.setString(cfg.name);
		this.shadowRankSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + this.shadow.rank + "_icon.png"));
		this.progressBg.visible = true;
		this.progress = new cc.ProgressTimer(new cc.Sprite("#shadow_pro_green.png"));
		this.progress.type = cc.ProgressTimer.TYPE_BAR;
		this.progress.midPoint = cc.p(0, 0);
		this.progress.barChangeRate = cc.p(1, 0);
		this.progressBg.addChild(this.progress);
		this.progress.setPosition(cc.p(this.progressBg.x-152, this.progressBg.y-16));
		this.tempShadowInfo = deepcopy(this.shadow);
		this.exitSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("text_tuichu.png"));
		this.createTableView();
		this.refresh();
	},
	initData:function(){
		this.initMaterials = ShadowModule.getCanUserShadowMaterialByUid(this.shadow.id);
	},
	refresh:function(){
		this.type = 0;
		this.materialArray = [];
		this.exitSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("text_tuichu.png"));
		this.tv.reloadData();
		this.nowLevel = this.shadow.level;
		this.tempLevel = this.tempShadowInfo.level;
		this.levelLabel.setString(this.nowLevel);
		var nextAttr = ShadowModule.getShadowAttrByLevelAndCid(this.nowLevel, this.shadow.shadowId)
		var cfg = this.shadow.cfg;
		if (cfg.level) {
			var frame = common.getDisplayFrame(cfg.property[0]);
			this.attSprite1.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(frame));
			this.attSprite2.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(frame));
			this.currentAttr1.setString(cfg.level[0]);
			this.nextAttr1.setString(nextAttr[0]);
			if (cfg.level[1]) {
				var frame = common.getDisplayFrame(cfg.property[1]);
				this.attSprite3.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(frame));
				this.attSprite4.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(frame));
				this.currentAttr2.setString(cfg.level[1]);
				this.nextAttr2.setString(nextAttr[1]);
				this.attSprite3.visible = true;
				this.attSprite4.visible = true;
				this.currentAttr2.visible = true;
				this.nextAttr2.visible = true;
			}
		}
		this.nowEXP = this.shadow.expNow;
		this.tempEXP = this.tempShadowInfo.expNow;
		var nextNeedEXP = ShadowModule.getNeedEXPToNextLevel(this.nowLevel, this.shadow.rank);
		this.progress.setPercentage(this.nowEXP / nextNeedEXP * 100);
		this.persentLabel.setString(this.nowEXP + "/" + nextNeedEXP);
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var tableViewBg = this.tableViewBg;
		tableViewBg.setContentSize(tableViewBg.getContentSize().width, tableViewBg.y - 232 * retina);
		var size = cc.size(cc.winSize.width, tableViewBg.getContentSize().height * 0.98);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:tableViewBg.y - tableViewBg.getContentSize().height + 2,
			anchorX:0,
			anchorY:0
		});
		this.tv.setDelegate(this);
		this.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell){
	},
	tableCellSizeForIndex:function (table, idx){
		return cc.size(cc.winSize.width, 155 * retina);
	},
	tableCellAtIndex:function(table, idx){
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var array = this.initMaterials[idx]
		var node = new UpdateShadowCell(this.initMaterials[idx]);
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		for (var i = 0; i < 5; i++) {
			if (array[i]) {
				if (array[i].rank == this.select && this.selectType == 0) {
					node.selectCell(i+1);
				}
				if (array[i].rank == this.select && this.selectType == 1) {
					node.unSelectCell(i+1);
				}
			}
		}
		node.scale = retina;
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.initMaterials.length;
	},
	chooseRankClick:function(sender){
		var allMaterial = ShadowModule.getCanUserShadowMaterialByUid(this.shadow.id, 1);
		var shadows = shadowdata.shadows;
		if (this.materialArray.length == 0) {
			this.select = sender.getTag() == 1 ? 1 : 2;
			this.selectType = this.selectType == 1 ? 0 : 1;
		}
		for (var i = 0; i < this.materialArray.length; i++) {
			for ( var k in shadowdata.shadows) {
				if (shadows[k].rank == 1 && shadows[k].id != this.materialArray[i]) {
					this.select = 1;
					this.selectType = 0;
				} else {
					this.select = 1;
					this.selectType = 1;
				}
				if (shadows[k].rank == 2 && shadows[k].id != this.materialArray[i]) {
					this.select = 2;
					this.selectType = 0;
					
				} else {
					this.select = 2;
					this.selectType = 1;
				}
			}
		}
		this.createTableView();
		this.tv.reloadData();
		this.refresh();
	},
	exitBtnAction:function(){
		if (this.type == 0) {
			postNotifcation(NOTI.GOTO_SHADOW, {type : 2});
		} else if (this.type == 1) {
			this.refresh();
		}
	},
	updateShadowAction:function(){
		ShadowModule.doOnShadowUpdate([this.shadow.id, this.materialArray], this.updateSucc.bind(this))
	},
	updateSucc:function(){
		this.tv.reloadData();
		this.type = 0;
		this.exitSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("text_tuichu.png"));
	},
	refreshProgress:function(dic){
		this.nowExp += dic.shadowExp;
		var array = ShadowModule.getShadowLevelAndExp(this.nowLevel, this.nowExp, this.shadow.rank);
		var level = array[0];
		var exp = array[1];
		var need = array[2];
		var material = {};
		if (dic.uid) {
			material = (dic.uid);
			if (dic.type == 0) {
				this.materialArray.push(material);
			} else {
				this.materialArray.pop(material);
			}
		}
		this.exitSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("fangqi_text.png"));
		this.type = 1;
		var nextAttr = ShadowModule.getShadowAttrByLevelAndCid(level, this.shadow.shadowId)
		var cfg = this.shadow.cfg;
		var nextAttr1 = cfg.level[0] + cfg.growth[0] * (level - 1);
		var nextNeedEXP = ShadowModule.getNeedEXPToNextLevel(level, this.shadow.rank);
		this.currentAttr1.setString(cfg.level[0] + cfg.growth[0] * (level - 1));
		this.nextAttr1.setString(cfg.level[0] + cfg.growth[0] * level);
		this.persentLabel.setString(exp + "/" + need);
		this.progress.setPercentage(parseInt(exp) / parseInt(need) * 100);
		if (cfg.level[1]) {
			this.currentAttr2.setString(cfg.level[1] + cfg.growth[1] * (level - 1));
			this.nextAttr2.setString(cfg.level[1] + cfg.growth[1] * level);
		}
		this.levelIconTTF.setString(level);
		this.levelLabel.setString("LV:" + level);
	
	},
	onEnter:function(){
		this._super();
		addObserver(NOTI.SHADOW_CHANGE_EXP, "refreshProgress", this);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.SHADOW_CHANGE_EXP, "refreshProgress", this);
	},
});