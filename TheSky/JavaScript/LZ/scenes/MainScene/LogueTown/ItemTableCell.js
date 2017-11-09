var ItemTableCell = cc.Node.extend({
	ctor:function(item, idx){
		this._super();
		this.item = item;
		cc.BuilderReader.registerController("ItemTableCellOwner", {
		});
		this.node = cc.BuilderReader.load(ccbi_res.ItemTableCell_ccbi, this);
		if(this.node != null) {
			this.addChild(this.node);
		}
		this.countLabel.setString(item.xianshi);
		this.nameLabel.setString(item.name);
		this.despLabel.setString(item.desp);
		this.countLabel.setString(ItemModule.getItemCount(item.id));
		this.rankFrame.setNormalImage(cc.Sprite("#frame_" + item.rank + ".png"));
		this.rankFrame.setSelectedImage(cc.Sprite("#frame_" + item.rank + ".png"));
		this.countSprite.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("frame_level_" + item.rank + ".png"));
		this.rank_bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame("rank_head_bg_" + item.rank + ".png"));
		this.avatarSprite.visible = true;
		this.avatarSprite.setTexture(common.getIconById(item.icon));
		this.priceLabel.setString(item.price);
		if (item.rank === 4) {
			olAni.addPartical({
				plist:"images/purpleEquip.plist", 
				node:this.avatarSprite,
				pos:cc.p(this.avatarSprite.getContentSize().width / 2, this.avatarSprite.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		} else if (item.rank === 5) {
			olAni.addPartical({
				plist:"images/goldEquip.plist", 
				node:this.avatarSprite,
				pos:cc.p(this.avatarSprite.getContentSize().width / 2, this.avatarSprite.getContentSize().height / 2),
				scale:2 / 0.35 / retina,
				isFollow:true
			});
		}
	},
	onAvatarTaped:function(item) {
		var item = this.item;
		var cb = new ItemDetailInfoView({info:item.id, type:0, close:function(){
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	buyBtnTaped:function(item) {
		var item = this.item;
		var cb = new ShopBuySomePopUp({info:item, type:0, close:function(){
		}.bind(this)});
		cc.director.getRunningScene().addChild(cb);
	},
	onEnter:function(){
		this._super();
	},
	onExit:function(){
		this._super();
	},
	
});