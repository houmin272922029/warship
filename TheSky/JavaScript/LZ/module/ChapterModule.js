var ChapterModule = {
		/**
		 * 获得残页种类、通过残页id(例chapter_000409_01)获取技能id(例book_000409)
		 * @ param bookId
		 */
		getChapterPro:function(bookId){
			var cfg = SkillModule.getSkillConfig(bookId);
			var chapterNum = cfg.chapternum;
			var chapterPre = bookId.replace("book", "chapter");
			var count = 0;
			for (var i = 1; i <= chapterNum; i++) {
				var fixI = common.fix(i, 2);
				var chapterId = chapterPre + "_" + fixI;
				if (chapterdata.chapters[bookId][chapterId] && chapterdata.chapters[bookId][chapterId] > 0) {
					count += 1;
				}
			}
			return count;
		},
		/**
		 * 获取残页flag是否可以合成
		 * @param bookId
		 */
		skillCanCombine:function(bookId){
			var cfg = SkillModule.getSkillConfig(bookId);
			var chapterNum = cfg.chapternum;
			var chapterPre = bookId.replace("book", "chapter");
			var flag = true;
			for (var i = 1; i < chapterNum + 1; i++) {
				var fixI = common.fix(i, 2);
				var chapterId = chapterPre + "_" + fixI;
				if (!chapterdata.chapters[bookId][chapterPre + "_" + fixI] || chapterdata.chapters[bookId][chapterPre + "_" + fixI] < 0) {
					flag = false;
					break;
				}
			}
			return flag;
		},
		/**
		 * 获得残页种数量
		 * @param chapterId
		 */
		getChapterCount:function(chapterId){
			if (getJsonLength(chapterdata.chapters) == 0) {
				return 0;
			}
			var bookId = chapterId.substr(0, 14).replace("chapter", "book");
			if (!chapterdata.chapters[bookId] || !chapterdata.chapters[bookId][chapterId]) {
				return 0;
			}
			return chapterdata.chapters[bookId][chapterId];
		},
		/**
		 * 减少残章剩余合成次数
		 * @param bookId
		 */
		reduceCombineTime:function(bookId){
			if (!chapterdata.chapters[bookId]) {
				return;
			}
			var kind = 0;
			for (var k in chapterdata.chapters) {
				if (k == "times") {
				} else {
					if (chapterdata.chapters[k] && chapterdata.chapters[k] > 0) {
						kind += 1;
					}
				}
			}
			if (kind > 0) {
				return;
			}
			chapterdata.chapters[bookId].times = chapterdata.chapters[bookId].times - 1;
			if (chapterdata.chapters[bookId].times <= 0) {
				chapterdata.chapters[bookId] = null;
			}
		},
		/**
		 * 获取所有的残页
		 */
		getAllChapters:function(){
			var retArray = [];
			for (var bookId in chapterdata.chapters) {
				var dic = {bookId:bookId,chapters:chapterdata.chapters[bookId]};
				retArray.push(dic);
			}
			var count = Math.floor(retArray.length / 4);
			if (count == 0) {
				return[retArray];
			} else {
				var chapters = [];
				count = retArray.length % 4 === 0 ? count : count + 1;
				for (var i = 0; i < count; i++) {
					var row = [];
					for (var j = 0; j < 4; j++) {
						var s = retArray[4 * i + j];
						if (s) {
							row.push(s);
						}
					}
					chapters.push(row);
				}
				return chapters;
			}
		},
		/**
		 * 网络接口
		 */
		/**
		 * 取某技能的可打残章及敌人信息
		 * @param skillId 技能ID
		 */
		doOnGetFragEnemies:function(skillId, succ){
			dispatcher.doAction(ACTION.FRAG_GET_FRAGENEMIES, [skillId], succ);
		},
		/**
		 * 根据技能id获得玩家的残章数据，用于前端刷新
		 * @param bookId 残页ID
		 */
		doOnGetBookFrags:function(chapterId, succ){
			dispatcher.doAction(ACTION.FRAG_GET_BOOKFRAGS, [chapterId], succ);
		},
		/**
		 * 拼合残章
		 * @param skillId 技能ID
		 */
		doOnFragCombine:function(skillId, succ, fail){
			dispatcher.doAction(ACTION.FRAG_COMBINEFRAGS, [skillId], succ, fail);
		},
		/**
		 * 发起残章战斗
		 * @param enemyId 敌人ID，索引 0,1,2
		 * @param fragId  抢夺残页Id
		 */
		doOnGetFragBattle:function(enemyId, fragId, succ, fail){
			dispatcher.doAction(ACTION.FRAG_FRAG_BATTLE, [enemyId, fragId], succ, fail);
		},
};