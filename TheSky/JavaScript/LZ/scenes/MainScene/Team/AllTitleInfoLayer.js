var AllTitleInfoLayer = cc.Layer.extend({
	ctor:function(){
		this._super();
		cc.BuilderReader.registerController("AllTitleInfoOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.AllTitleInfoView_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		
		this.initLayer();
	},
	onEnter:function(){
		this._super();
		this.createTableView();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		var topData = TitlesModule.getTopAllTitleInfo();
		for (var i = 0; i < 10; i++) {
			if (topData.length < i + 1) {
				this["frame" + (i + 1)].visible = false;
				this["avatarSprite" + (i + 1)].visible = false;
				this["titleLabel" + (i + 1)].visible = false;
				this["shadowLayer" + (i + 1)].visible = false;
			}else {
				if (topData[i].title.obtainFlag == 2) {
					if (topData[i].cfg.expire == 24) {
						this["shadowLayer" + (i + 1)].visible = true;
						this["titleLabel" + (i + 1)].setString(topData[i].cfg.name);
						var texture = EquipModule.getEquipIconByEquipId(topData[i].title.titleId);
						if (texture) {
							this["avatarSprite" + (i + 1)].setTexture(texture);
							this["avatarSprite" + (i + 1)].visible = true;
						}
					}else {
						this["titleLabel" + (i + 1)].visible = false;
						this["frame" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_duixing_chenghao.png"));
						this["frame" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_duixing_chenghao.png"));
					}
				} else {
					var texture = EquipModule.getEquipIconByEquipId(topData[i].title.titleId);
					if (texture) {
						this["avatarSprite" + (i + 1)].setTexture(texture);
						this["avatarSprite" + (i + 1)].visible = true;
					}
					this["frame" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + topData[i].cfg.colorRank + ".png"));
					this["frame" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + topData[i].cfg.colorRank +".png"));
					this["titleLabel" + (i + 1)].setString(topData[i].cfg.name);
				}
			}
		}
	},
	closeClick:function(){
		this.removeFromParent(true);
	},
	initData:function(){
		this.bottomData = TitlesModule.getBottomAllTitleInfo();
	},
	createTableView:function(){
		this.initData();
		if (this.tv) {
			this.tv.removeFromParent(true);
		}
		var size = this.bottomLayer.getContentSize();
		this.tv = new cc.TableView(this, size);
		this.tv.setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
		this.tv.setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN);
		this.tv.attr({
			x:this.bottomLayer.x,
			y:this.bottomLayer.y,
			anchorX:0.5,
			anchorY:1
		});
		this.tv.setDelegate(this);
		this.bottomLayer.addChild(this.tv);
	},
	scrollViewDisScroll:function(view){
	},
	scrollViewDidZoom:function(view){
	},
	tableCellTouched:function (table, cell) {
	},
	tableCellSizeForIndex:function (table, idx) {
		return cc.size(580, 150);
	},
	tableCellAtIndex:function (table, idx) {
		var cell = table.dequeueCell();
		if (!cell) {
			cell = new cc.TableViewCell();
		} else {
			cell.removeAllChildren(true);
		}
		var node = new AllTitleCellLayer(this.bottomData[idx],idx);
		node.attr({
			x:0,
			y:0,
			anchorX:0,
			anchorY:0
		});
		
		cell.addChild(node);
		return cell;
	},
	numberOfCellsInTableView:function (table) {
		return this.bottomData.length;
	},
})