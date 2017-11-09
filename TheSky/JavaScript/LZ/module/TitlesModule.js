var TitlesModule = {
		/**
		 * 获取称号数据
		 */
		getTitleData:function(){
			return titledata.titles;
		},
		/**
		 * 获取称号data配置
		 */
		getTitleConfig:function(titleId){
			var cfg = config.title_data
			return cfg[titleId] || null;
		},
		/**
		 * 获取称号updateConfition数据
		 */
		getTitleUpdateConfition:function(){
			return config.title_000103_updateCondition;
		},
		/**
		 * 获得总气势值
		 */
		getAllFame:function(){
			var fame = 0;
			var famePer = 0;
			var titles = this.getTitleData();
			for (var k in titles) {
				if (titles[k].level > 0) {
					var cfg = this.getTitleConfig(k);
					if (cfg.baseValue < 1) {
						if (cfg.targetID) {
							for (var key in cfg.targetID) {
								var id = cfg.tatgetID[k];
								var data = titles[id];
								if (data) {
									var targetCfg = this.getTitleConfig(id);
									var targetFame = targetCfg.baseValue + targetCfg.updateValue * (data.level - 1);
									fame = fame + Math.floor(targetFame * (cfg.baseValue + cfg.updateValue * (titles[k].level - 1)));
								}
							}
						}else {
							
						}
					} else {
						fame = fame + cfg.baseValue + cfg.updateValue * (titles[k].level - 1);
					}
				}
			}
			fame = fame + cfg.baseValue + cfg.updateValue * (titles[k].level - 1);
			return fame;
		},
		/**
		 * 获得称号页面默认显示称号
		 */
		getDefalutTitle:function(){
			var outDic = [];
			var cfg = config.title_data;
			for (var k in cfg) {
				if (cfg[k].outer != 0) {
					outDic.push(k);
				}
			}
			var titles = titledata.titles; 
			var retArray = [];
			for (var i = 0; i < outDic.length; i++) {
				var tempArray = {};
				var titleCfg = this.getTitleConfig(outDic[i]);
				var titleContent = deepcopy(titles[outDic[i]]);
				tempArray["cfg"] = titleCfg;
				tempArray["title"] = titleContent;
				retArray.push(tempArray);
			}
			retArray.sort(function(a,b){
				return a.cfg.outer > b.cfg.outer ? -1 : 1;
			});
			return retArray;
		},
		/**
		 * 根据titleid得到一条title信息
		 */	
		getOneTitleByTitleId:function(titleId){
			var tempArray = [];
			var titles = titledata.titles;
			var titleCfg = this.getTitleConfig(titleId);
			var titleContent = deepcopy(titles[titleId]);
			tempArray["cfg"] = titleCfg;
			tempArray["title"] = titleContent;
			return tempArray;
		},
		/**
		 * 得到全部称号页面上部所有称号
		 */
		getTopAllTitleInfo:function(){
			var innerTop = [];
			var cfg = config.title_data;
			var titles = this.getTitleData();
			for (var k in cfg) {
				var tempArray = {};
				if (cfg[k].inner == 0) {
					tempArray["title"] = deepcopy(titles[k]);
					tempArray["cfg"] = cfg[k];
					innerTop.push(tempArray);
				}
			}
			innerTop.sort(function(a,b){
				return a.cfg.sort < b.cfg.sort ? -1 : 1;
			});
			return innerTop;
		},
		/**
		 * 得到所有底部信息
		 */
		getBottomAllTitleInfo:function(){
			var innerBottom = [];
			var cfg = config.title_data;
			var titles = this.getTitleData();
			for (var k in cfg) {
				var temp = {};
				if (cfg[k].inner == 1) {
					temp["title"] = deepcopy(titles[k]);
					temp["cfg"] = cfg[k];
					innerBottom.push(temp);
				}
			}
			innerBottom.sort(function(a, b){
				return a.cfg.sort > b.cfg.sort ? -1 : 1;
			})
			
			
			var count = Math.floor(innerBottom.length / 5);
			if (count == 0) {
				return [equip];
			} else {
				var eq = [];
				count = innerBottom.length % 5 === 0 ? count : count + 1;
				for (var j = 0; j < count; j++) {
					var row = [];
					for (var i = 0; i < 5; i++) {
						var s = innerBottom[5 * j + i];
						if (s) {
							row.push(s);
						}
					}
					eq.push(row);
				}
				return eq;
			}
		},
		/**
		 * 网络接口
		 * 
		 */
		/**
		 *  获得所有称号
		 */
		doOnGetAllTitle:function(succ, fail){
			dispatcher.doAction(ACTION.FROM_GETALLTITLES, [], succ, fail);
		},
}