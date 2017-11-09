/**
 * 工坊
 */
var craftsmanLayer = DailyPageViewCell.extend({
	ctor : function(params){
		this._super(params);
		
		this.createListView(this.contentLayer, null, ccui.ScrollView.DIR_HORIZONTAL);
	},
	
	onActivate : function() {
		DailyCraftsManModule.fetchCraftsManData();
	},
	
	refreshView : function( viewData ) {
		if (viewData == null) {
			viewData = DailyCraftsManModule.getCraftsManData();
		}
		
		this.refreshMainView(viewData.main);
		this.refreshDecomposeView(viewData.deComposeData);
		this.refreshComposeView(viewData.composeData);
	},
	
	refreshMainView : function( viewData ) {
		
	},
	
	refreshDecomposeView : function( viewData ) {

		this.frame.setVisible(false);
		this.equip.setVisible(false);
		this.multiDecompose.setVisible(false);
		
		if (viewData.equip != null) {
			this.multiDecompose.setVisible(true);
			this.multiDecompose.setString(common.LocalizedString("daily_DC_willMultiDecompose", [viewData.amount]));
			
			this.rankBg.setVisible(true);
			this.rankBg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("rank_head_bg_{0}.png").format(viewData.equip.rank)));
			this.frame.setVisible(true);
			this.frame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(viewData.equip.rank)));
			
			var texture = cc.textureCache.addImage(common.getIconById(viewData.equip.cfg.icon));

			if (texture != null) {
				this.equip.setVisible(true);
				this["equip"].setTexture(texture);
			}
		}
	},
	
	refreshComposeView : function( viewData ) {
		if (viewData.material != null) {
			if (this.listView_ != null) {
				this.listView_.removeAllItems();
			}
			
			if (viewData.equip != null) {
				this.c_rank_bg.setVisible(true);
				this.c_rank_bg.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("rank_head_bg_{0}.png").format(viewData.equip.conf.rank)));
				this.c_frame.setVisible(true);
				this.c_frame.setSpriteFrame(cc.spriteFrameCache.getSpriteFrame(String("frame_{0}.png").format(viewData.equip.conf.rank)));

				var texture = cc.textureCache.addImage(common.getIconById(viewData.equip.conf.icon));

				if (texture != null) {
					this.c_equip.setVisible(true);
					this.c_equip.setTexture(texture);
					this.c_equip.setScale(0.33);
				}
			}
			
			for (var int = 0; int < viewData.material.length; int++) {
				var stuff =  viewData.material[int];
				var cell = new DailyComposeMaterialCell({
					data : stuff
				});
				this.listView_.pushBackCustomItem(cell);
			}
		}
	},
	
	/**
	 * 主页面按钮回调
	 */
	// 详情
	descBtnTaped : function( sender ) {
		var param = {
				info : DailyCraftsManModule.getCraftsManHelpDesc()
		};
		cc.director.getRunningScene().addChild(new CommonHelpView(param));
	},
	
	// 分解页面入口
	enterDecomposeViewBtnTaped : function( sender ) {
		DailyCraftsManModule.gotoView(1);
	},
	
	// 铸造页面入口
	enterComposeViewBtnTaped : function( sender ) {
		DailyCraftsManModule.gotoView(2);
	},
	
	// 合成页面入口
	enterNewcomposeViewBtnTaped : function( sender ) {
		
	},
	
	/**
	 * 铸造页面 按钮回调
	 */
	// 制造选择装备
	composeChooseBtnClick : function( sender ) {
		DailyCraftsManModule.showComposeEquipChooseView(this, this.refreshView);
	},
	onComposeFrameClicked : function( sender ) {
		DailyCraftsManModule.showComposeEquipChooseView(this, this.refreshView);
	},
	
	// 铸造中线装备icon点击回调
	composeFrameMenu : function(sender) {
		
	},
	
	// 开始制造
	beginComposeBtnClick : function( sender ) {
		DailyCraftsManModule.doComposeAction(this, this.refreshView);
	},

	// 返回主页
	backBtnClick : function( sender ) {
		DailyCraftsManModule.gotoView(0);
	},
	
	// 前往分解
	goDecomposeBtnClick : function( sender ) {
		DailyCraftsManModule.gotoView(1);
	},
	
	// 前往合成
	goNewcomposeBtnClick : function( sender ) {

	},

	
	goComposeBtnClick : function( sender ) {
		DailyCraftsManModule
	},

	/**
	 * 分解页面 按钮回调
	 */
	
	
	// 
	decomposeFrameMenu : function(sender) {
		
	},	
	
	// 分解装备选择
	decomposeChooseBtnClick : function(sender) {
		DailyCraftsManModule.showDailyDeComposeChooseEquipPopView(this, this.refreshView);
	},
	onDecomposeFrameClicked : function(sender) {
		DailyCraftsManModule.showDailyDeComposeChooseEquipPopView(this, this.refreshView);
	},

	// 一键分解白色装备
	decomposeAllWhiteBtnClick : function(sender) {
		DailyCraftsManModule.doOneKeyDecomposeAction(1);
	},

	// 一键分解绿色装备
	decomposeAllGreenBtnClick : function(sender) {
		DailyCraftsManModule.doOneKeyDecomposeAction(2);
	},
	
	// 一键分解      新添加
	decomposeAllBtnClick : function() {
		cc.director.getRunningScene().addChild(new DailyOneKeyDeComposeChooseView());
	},

	// 返回主页面
	backBtnClick : function(sender) {
		DailyCraftsManModule.gotoView(0);
	},

	// 开始分解
	beginDecomposeBtnClick : function(sender) {
		DailyCraftsManModule.doDecomposeAction(this, this.refreshView);
	},

	// 前往制造
	goComposeBtnClick : function(sender) {
		DailyCraftsManModule.gotoView(2);
	},

	// 前往合成
	goNewcomposeBtnClick : function(sender) {

	},
	
	onViewChanged : function(state) {
		
		this.NewcomposeLayer.setVisible(false);
		
		switch (state) {
		case 0:
			
			this.enterLayer.setVisible(true);
			this.decomposeLayer.setVisible(false);
			this.composeLayer.setVisible(false);
			
			break;
		case 1:
			
			this.enterLayer.setVisible(false);
			this.decomposeLayer.setVisible(true);
			this.composeLayer.setVisible(false);
			
			break;
		case 2:

			this.enterLayer.setVisible(false);
			this.decomposeLayer.setVisible(false);
			this.composeLayer.setVisible(true);
			
			break;
		default:
			break;
		}
	},
	
	onEnter:function(){
		this._super();
		addObserver(NOTI.DAILY_CREAFTS_MAN_CHANGE_VIEW, "onViewChanged", this);

		DailyCraftsManModule.gotoView(0);
	},
	onExit:function(){
		this._super();
		removeObserver(NOTI.DAILY_CREAFTS_MAN_CHANGE_VIEW, "onViewChanged", this);
	},
});