var SkillBreakSelect = cc.Layer.extend({
	/**
	 * 
	 * @param skill
	 * @param dogfood {sid:true, sid:true}
	 * @param exit
	 */
	ctor:function(skill, dogfood, exit){
		this._super();
		this.skill = skill;
		this.dogfood = dogfood;
		this.exit = exit;
		
		cc.BuilderReader.registerController("BreakSkillSelectLayerOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.SkillBreakSelect_ccbi, this);
		if (node) {
			this.addChild(node);
		}
		
	},
	onEnter:function(){
		this._super();
		this.skills = SkillModule.getSkillWithoutSid(this.skill.id);
		this.checkDogfood();
		this.createTableView();
	},
	onExit:function(){
		this._super();
	},
	checkDogfood:function(){
		this.updateBtnState(true);
	},
	updateBtnState:function(flag){
		this.quitBtn.visible = !flag;
		this.giveupLabel.visible = !flag;
		this.confirmBtn.visible = flag;
		this.confirLabel.visible = flag;
		this.exitBtn.visible = !flag;
		this.exitLable.visible = !flag;
	},
	createTableView:function(){
		if (this.tv) {
			var offset = this.tv.getContentOffset();
			this.tv.reloadData();
			this.tv.setContentOffset(offset, false);	
			return;
		}
		var topLayer = this.EQTopLayer;
		var size = cc.size(cc.winSize.width, (cc.winSize.height - topLayer.getContentSize().height 
				- mainBottomTabBarHeight * retina) * 0.99);
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:0,
			y:mainBottomTabBarHeight * retina,
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
	tableCellTouched:function (table, cell) {
		var node = cell.getChildByTag(100);
		var idx = cell.getIdx();
		if (idx === 0) {
			return;
		}
		var skill = this.skills[idx - 1];
		if (this.dogfood[skill.id]) {
			this.dogfood[skill.id] = false;
			node.unSelectCell();
			this.checkDogfood();
			return;
		}
		var count = 0;
		for (var k in this.dogfood) {
			if (this.dogfood[k]) {
				count++;
			}
		}
		if (count >= 5) {
			common.showTipText(common.LocalizedString("最多选5个奥义"));
		} else {
			if (skill.rank >= 3) {
				var info = common.LocalizedString("船长，你选择了A级以上的奥义做突破材料，这不是太可惜了吗，您舍得吗？");
				var cb = new ConfirmBox({info:info, confirm:function(){
					this.dogfood[skill.id] = true;
					node.selectCell();
					this.checkDogfood();
				}.bind(this)});
				cc.director.getRunningScene().addChild(cb);
			} else {
				this.dogfood[skill.id] = true;
				node.selectCell();
				this.checkDogfood();
			}
		}
	},
	tableCellSizeForIndex:function (table, idx) {
		if (idx === 0) {
			return cc.size(cc.winSize.width, 45 * retina);
		}
		return cc.size(cc.winSize.width, 125 * retina);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node;
		if (idx === 0) {
			cc.BuilderReader.registerController("TitleTipsLayerOwner", {
			});
			node = cc.BuilderReader.load(ccbi_res.TitleTipsLayer_ccbi, this);
			this.tipsLabel.setString(common.LocalizedString("数量越多（最多5个）或选择同种奥义，成功的概率越大。"));
		} else {
			var skill = this.skills[idx - 1];
			node = new SkillSelectCell(skill);
			if (this.dogfood[skill.id]) {
				node.selectCell();
			} else {
				node.unSelectCell();
			}
		}
		node.attr({
			x:cc.winSize.width / 2,
			y:0,
			anchorX:0.5,
			anchorY:0,
			scale:retina
		});
		cell.addChild(node, 0, 100);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.skills.length + 1;
	},
	confirmBtnClicked:function(){
		var dogfood = [];
		for (var k in this.dogfood) {
			if (this.dogfood[k]) {
				var skill = SkillModule.getSkillInfo(k);
				dogfood.push(skill);
			}
		}
		postNotifcation(NOTI.GOTO_SKILL_BREAK, {skill:this.skill, dogfood:dogfood, exit:this.exit});
	}
});