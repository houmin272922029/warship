var chapterdata = {
		chapters:{},
		fragEnemies:{},
		fromDic:function(dic){
			if (!dic || !dic.info) {
				return;
			}
			var data = dic.info;
			if (data.frags) {
				var frags = data.frags;
				for (var k in frags) {
					var frag = frags[k];
					this.chapters[k] = frag;
				}
			}
			if (data.fragsInfo) {
				var fragsEnemies = data.fragsInfo.fragEnemies;
				for (var k in fragsEnemies) {
					var enemies = fragsEnemies[k];
					this.fragEnemies[k] = enemies;
				}
			}
		},
		addDataObserver:function(){
			addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
		},
		payChapter:function(frags){
			for (var k in this.chapters[frags]) {
				this.chapters[frags][k] -= 1;
			}
		},
		gainChapter:function(frags, gain){
			if (!this.chapters[frags]) {
				this.chapters[frags] = gain;
			} else {
				for (var k in gain) {
					this.chapters[frags][k] = this.chapters[frags][k] || 0;
					this.chapters[frags][k] += gain[k];
				}
			}
		},
}

chapterdata.addDataObserver();