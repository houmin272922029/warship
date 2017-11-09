var AdventureModule = {
		/**
		 * adventurePage 记录大冒险显示第几个页面 用于切换页面
		 */
		adventurePage : 0,
		/**
		 *	 获取用户大冒险列表信息
		 *   大冒险列表数组
		 */
		getUserAdventureList:function(){
			var adventureArray = [];
			var adventures = adventuredata.adventures;
			for (var k in adventures) {
				if (FunctionModule.bOpen("blood") && k.indexOf("bloodInfo") != -1) {
					adventureArray.push("blood");
				}
				if (FunctionModule.bOpen("boss") && k.indexOf("bossInfo") != -1) {
					adventureArray.push("boss");
				}
			}
			if (chapterdata.chapters) {
				if (getJsonLength(chapterdata.chapters) >= 8) {
					adventureArray.push("chapters");
				} else {
					for (var k in chapterdata.chapters) {
						adventureArray.push(k);
					}
				}
			}
			return adventureArray;
		},
		/**
		 * 大冒险网络接口
		 */
		/**
		 * 刷新所有大冒险数据
		 */
		doOnGetAdventureAllData:function(succ){
			dispatcher.doAction(ACTION.ADVENTURE_INFO,[], succ);
		},
		
		getPage:function(name){
			var list = this.getUserAdventureList();
			for (var i = 0; i < list.length; i++) {
				if (name === list[i]) {
					return i;
				}
			}
			return 0;
		},
}