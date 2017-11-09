var AllTitleCellLayer = cc.Node.extend({
	ctor:function(titleArray, idx){
		this._super();
		this.titleArray = titleArray;
		this.idx = idx;
		cc.BuilderReader.registerController("TitleTableCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.TitleBottomTableCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.initLayer();
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	initLayer:function(){
		for (var i = 0; i < 5; i++) {
			var cell = this.titleArray[i];
			if (cell) {
				if (cell.title.obtainFlag == 2) {
					if (cell.title.obtainTime == -1) {
						this["avatarBtn" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_duixing_chenghao.png"));
						this["avatarBtn" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_duixing_chenghao.png"));
						this["nameLabel" + (i + 1)].visible = false;
					}else {
						this["shadow" + (i + 1)].visible = true;
						this["nameLabel" + (i + 1)].setString(cell.cfg.name);
						var texture = EquipModule.getEquipIconByEquipId(cell.title.titleId);
						if (texture) {
							this["rankSprite" + (i + 1)].visible = true;
							this["rankSprite" + (i + 1)].setTexture(texture)
						}
					}
				}else {
					var texture = EquipModule.getEquipIconByEquipId(cell.title.titleId);
					if (texture) {
						this["rankSprite" + (i + 1)].visible = true;
						this["rankSprite" + (i + 1)].setTexture(texture)
					}
					this["avatarBtn" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + cell.cfg.colorRank + ".png"));
					this["avatarBtn" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + cell.cfg.colorRank +".png"));
					if (cell.cfg.expire == 24) {
						if ((Global.serverTime - cell.title.obtainTime) >= 24 * 3600) {
							this["shadow" + (i + 1)].visible = true;
							this["nameLabel" + (i + 1)].setString(cell.cfg.name);
							var texture = EquipModule.getEquipIconByEquipId(cell.title.titleId);
							if (texture) {
								this["rankSprite" + (i + 1)].visible = true;
								this["rankSprite" + (i + 1)].setTexture(texture)
							}
						}
					}
				}
			}else {
				this["nameLabel" + (i + 1)].visible = false;
				this["shadow" + (i + 1)].visible = false;
				this["avatarBtn" + (i + 1)].visible = false;
				this["rankSprite" + (i + 1)].visible = false;
			}
		}
	},
	bottomItemTaped:function(sender){
		var tag = sender.getTag();
		var cell = this.titleArray[tag];
		if (cell) {
			if (cell.title.obtainFlag == 2) {
				if (cell.title.obtainFlag == -1) {
					common.ShowText(common.LocalizedString("您的航海经历还不够丰富，多去冒险\n战斗，会有意外成就收获噢！"));
				} else {
					cc.director.getRunningScene().addChild(new TitleInfoLayer(cell.title.titleId, 1));
				}
			}else {
				cc.director.getRunningScene().addChild(new TitleInfoLayer(cell.title.titleId, 1));
			}
		}
	},
})