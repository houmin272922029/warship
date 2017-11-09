var skilldata = {
	skills:{},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (!data.skills) {
			return;
		}
		var skills = data.skills;
		for (var k in skills) {
			var skill = skills[k];
			this.skills[k] = skill;
		}
	},
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
	paySkill:function(sid){
		delete this.skills[sid];
	},
	gainSkill:function(sid, skill){
		this.skills[sid] = skill;
	}
}
skilldata.addDataObserver();