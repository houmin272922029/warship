var ArenaInfoCell = cc.Node.extend({
	ctor:function(player){
		this._super();
		cc.BuilderReader.registerController("ArenaInfoCellOwner", {});
		this.node = cc.BuilderReader.load(ccbi_res.ArenaInfoCell_ccbi, this);
		if (this.node != null) {
			this.addChild(this.node);
		}
		this.player = player;
		this.refresh();
	},
	refresh:function(){
		this.name.setString(this.player.name);
		this.scoreLabel.setString(common.LocalizedString("arena_rankScore",this.player.awardScore));
		this.level.setString(this.player.level);
		//this.playerScore_s.setString(common.LocalizedString("arena_score",PlayerModule.getPlayerArenaScore()));
		this.playerScore.setString(PlayerModule.getPlayerArenaScore());
		//this.infoLabel_s.setString(common.LocalizedString("保持此排名每10分钟获得积分%d",this.player.awardScore));
		this.infoLabel.setString(this.player.awardScore);
		var rank = this.player.rank;
		var grade = 1;
		var tempRank = rank;
		while (true) {
			if (Math.floor(tempRank / 10) == 0) {
				break;
			}
			grade += 1;
			if (grade == 5) {
				break;
			}
			tempRank = Math.floor(tempRank / 10);
		}
		trace(grade + " ------ ")
		this["rank" + grade].setString(rank);
		this["rank" + grade].visible = true;
	},
	onEnter:function(){
		this._super();
	},
	onEnter:function(){
		this._super();
	},
	getArenaScoreCallback:function(){
		postNotifcation(NOTI.REFRESH_ARENA_CALLBACK);
	},	
	refreshItemClick:function(){
		ArenaModule.doOnArenaScore(this.getArenaScoreCallback.bind(this))
	},
});