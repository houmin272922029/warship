var TeamAllViewCell = cc.Layer.extend({
	ctor:function(){
		this._super();

		cc.BuilderReader.registerController("TeamAllViewCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.TeamAllViewCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}

		var size = this.node.getContentSize();
		this.setContentSize(size);
		
		var form = FormModule.getForm();
		var price = 0;
		for (var i = 1; i <= getJsonLength(form); i++) {
			var hid = form[(i - 1) + ""];
			if (hid === "") {
				continue;
			}
			var hero = HeroModule.getHeroByUid(hid);
			var hBg = this["hero" + i];
			var name = this["name" + i];
			var rank = this["rank" + i];
			var level = this["level" + i];
			hBg.visible = true;
			name.visible = true;
			name.setString(hero.name);
			rank.visible = true;
			rank.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_" + hero.rank + "_icon.png"));
			level.visible = true;
			level.setString("LV " + hero.level);
			price += hero.price;
		}
		this["allPrice"].setString(price);
		this.teamAllName.setString(common.LocalizedString("team_all_name"));
		this.teamAllName.enableStroke(cc.color(32, 18, 9), 2);

		this.fameLabel.setString(TitlesModule.getAllFame());
		
		var topData = TitlesModule.getDefalutTitle();
		for (var i = 0; i < topData.length; i++) {
			var topdata = topData[i];
			this["title_bg" + (i + 1)].visible = true;
			if (topdata.title.obtainFlag == 2) {
				if (topdata.cfg.expire == 24) {
					this["title" + (i + 1)].setString(topdata.cfg.name);
					this["title" + (i + 1)].visible = true;
					this["shadow" + (i + 1)].visible = true;
					var texture = EquipModule.getEquipIconByEquipId(topdata.title.titleId);
					if (texture) {
						this["titleSprite" + (i + 1)].visible = true;
						this["titleSprite" + (i + 1)].setTexture(texture);
					}
					this["frame" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + topdata.cfg.colorRank + ".png"));
					this["frame" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + topdata.cfg.colorRank +".png"));
					
				}else {
					this["frame" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_duixing_chenghao.png"));
					this["frame" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_duixing_chenghao.png"));
				}
			} else {
				var texture = EquipModule.getEquipIconByEquipId(topdata.title.titleId);
				if (texture) {
					this["titleSprite" + (i + 1)].visible = true;
					this["titleSprite" + (i + 1)].setTexture(texture);
				}
				this["title" + (i + 1)].setString(topdata.cfg.name);
				this["title" + (i + 1)].visible = true;
				this["frame" + (i + 1)].setNormalSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + topdata.cfg.colorRank + ".png"));
				this["frame" + (i + 1)].setSelectedSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_" + topdata.cfg.colorRank +".png"));
			}
		}
		
	},
	titleItemClick:function(sender){
		var tag = sender.getTag();
		var titlesArray = TitlesModule.getDefalutTitle();
		var finalArr = titlesArray[tag - 1];
		if (finalArr.title.obtainFlag == 2) {
			common.ShowText(common.LocalizedString("您的航海经历还不够丰富，多去冒险\n战斗，会有意外成就收获噢！"));
		} else {
			cc.director.getRunningScene().addChild(new TitleInfoLayer(finalArr.title.titleId, 0));
		}
	},
	allTitleItemClick:function(){
		
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
});