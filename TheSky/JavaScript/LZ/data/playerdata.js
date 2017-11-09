var playerdata = {
	addDataObserver:function(){
		addObserver(NOTI.NOTI_DATA_UPDATE, "fromDic", this);
	},
	resetAllData:function() {
		playerdata.id = null;
	},
	fromDic:function(dic){
		if (!dic || !dic.info) {
			return;
		}
		var data = dic.info;
		if (data.player) {
			this.updateData(data.player);
		}
		if (data.playerInfo) {
			this.updateData(data.playerInfo);
		}
	},
	updateData:function(dic){
		if (dic.name !== undefined && dic.name !== null) {
			this.name = dic.name;
		}
		if (dic.flag !== undefined && dic.flag !== null) {
			this.flag = dic.flag;
		}
		if (dic.expAll !== undefined && dic.expAll !== null) {
			this.expAll = dic.expAll;
		}
		if (dic.expNow !== undefined && dic.expNow !== null) {
			this.expNow = dic.expNow;
		}
		if (dic.vipScore !== undefined && dic.vipScore !== null) {
			this.vipScore = dic.vipScore;
		}
		if (dic.diamond !== undefined && dic.diamond !== null) {
			this.gold = dic.diamond;
		}
		if (dic.gold !== undefined && dic.gold !== null) {
			this.berry = dic.gold;
		}
		if (dic.strength !== undefined && dic.strength !== null) {
			this.strength = dic.strength;
		}
		if (dic.cLoginDays !== undefined && dic.cLoginDay !== null) {
			this.cLoginDays = dic.cLoginDays;
		}
		if (dic.id !== undefined && dic.id !== null) {
			this.id = dic.id;
		}
		if (dic.energy !== undefined && dic.energy !== null) {
			this.energy = dic.energy;
		}
		if (dic.level !== undefined && dic.level !== null) {
			this.level = dic.level;
		}

		if (dic.hotBlood !== undefined && dic.hotBlood !== null) {
			this.hotBlood = dic.hotBlood;
		}
		if (dic.lastLoingTime !== undefined && dic.lastLoingTime !== null) {
			this.lastLoingTime = dic.lastLoingTime;
		}

		if (dic.arenaScore !== undefined && dic.arenaScore !== null) {
			this.arenaScore = dic.arenaScore;
		}
		if (dic.strength_time !== undefined && dic.strength_time !== null) {
			this.strength_time = dic.strength_time;
		}
		if (dic.energy_time !== undefined && dic.energy_time !== null) {
			this.energy_time = dic.energy_time;
		}

	},
	decrease:function(pay){
		if (pay.heroSouls) {
			for (var soulId in pay.heroSouls) {
				SoulModule.reduceSoul(soulId, pay.heroSouls[soulId]);
			}
		}
		if (pay.items) {
			for (var itemId in pay.items) {
				itemdata.payItem(itemId, pay.items[itemId]);
			}
		}
		if (pay.skills) {
			for (var sid in pay.skills) {
				skilldata.paySkill(sid);
			}
		}
		if (pay.equips) {
			for (var eid in pay.equips) {
				equipdata.payEquip(eid);
			}
		}
		if (pay.arenaScore) {
			this.arenaScore -= pay.arenaScore;
			this.arenaScore = Math.max(this.arenaScore, 0);
			postNotifcation(NOTI.REFRESH_ARENA_CALLBACK);
		}
		if (pay.gold) {
			this.berry -= pay.gold;
			this.berry = Math.max(this.berry, 0);
			postNotifcation(NOTI.BERRY_REFRESH);
		}
		if (pay.hotBlood) {
			this.hotBlood -=  pay.hotBlood;
			this.hotBlood = Math.max(this.hotBlood || 0);
		}
		if (pay.diamond) {
			this.gold -= pay.diamond;
			this.gold = Math.max(this.gold, 0);
			postNotifcation(NOTI.GOLD_REFRESH)
		}
		if (pay.strength) {
			this.strength -= pay.strength;
			this.strength = Math.max(this.strength, 0);
			postNotifcation(NOTI.ST_REFRESH);
		}
		if (pay.energy) {
			this.energy -= pay.energy;
			this.energy = Math.max(this.energy, 0);
			postNotifcation(NOTI.EN_REFRESH);
		}
		if (pay.frags) {
			for (var bookId in pay.frags) {
				chapterdata.payChapter(bookId);
			}
		}
	},
	increase:function(gain){
		if (gain.heros) {
			for (var heroId in gain.heros) {
				herodata.gainHero(heroId, gain.heros[heroId]);
			}
		}
		if (gain.heroSouls) {
			for (var soulId in gain.heroSouls) {
				souldata.gainSoul(soulId, gain.heroSouls[soulId]);
			}
		}
		if (gain.gold) {
			this.berry += gain.gold;
			postNotifcation(NOTI.BERRY_REFRESH);
		}
		if (gain.diamond) {
			this.gold += gain.diamond;
			postNotifcation(NOTI.GOLD_REFRESH);
		}
		if (gain.items) {
			var array = {}
			for (var k in gain.items) {
				itemdata.gainItem(k, gain.items[k]);
			}
		}
		if (gain.expAll) {
			PlayerModule.addExp(gain.expAll);
		}
		if (gain.heroExpAll) {
			FormModule.addExp(gain.heroExpAll);
		}
		if (gain.strength) {
			this.strength += gain.strength;
			postNotifcation(NOTI.ST_REFRESH);
		}
		if (gain.frags) {
			for (var k in gain.frags) {
				chapterdata.gainChapter(k, gain.frags[k]);
			}
		}
		if (gain.equips) {
			for (var eid in gain.equips) {
				equipdata.gainEquip(eid, gain.equips[eid]);
			}
		}
		if (gain.skills) {
			for (var sid in gain.skills) {
				skilldata.gainSkill(sid, gain.skills[sid]);
			}
		}
		if (gain.energy) {
			this.energy += gain.energy;
			postNotifcation(NOTI.EN_REFRESH);
		}
		if (gain.arenaScore) {
			this.arenaScore += gain.arenaScore;
			postNotifcation(NOTI.REFRESH_ARENA_INFO)
		}
	},
	popupGain:function(gain){
		var array = [];
		for (var k in gain) {
			if (k === "hotBlood") {
				common.showTipText(common.LocalizedString("gain.text.default", common.LocalizedString("gain.haki", gain[k])));
				continue;
			}
			if (k === "shadowCoin") {
				common.showTipText(common.LocalizedString("获得%s个影纹", gain[k]));
				continue;
			}
			if (k === "titles") {
				// TODO 获得称号 或者升级
				continue;
			}
			if (k === "sweetCount") {
				// 联盟糖果
				continue;
			}
			
			if (k === "strength") {
				common.showTipText(common.LocalizedString("获得%s点体力", gain[k]));
				continue;
			}

			if (k === "heroSouls") {
				for (var id in gain[k]) {
					var heroId = id.replace("herosoul", "hero");
					var dic = {id:heroId, amount:gain[k][id], type:k};
					array.push(dic);
				}
			} else if (k === "items" || k === "equipShard") {
				for (var id in gain[k]) {
					var dic = {id:id, amount:gain[k][id], type:k};
					array.push(dic);
				}
			} else if (k === "frags") {
				for (var sid in gain[k]) {
					var frag = gain[k][sid];
					for (var id in frag) {
						if (id === "times") {
							continue;
						}
						var dic = {id:id, amount:1, type:k};
						array.push(dic);
					}
				}
			} else if (k === "delayItems") {
				var temp = {};
				for (var bid in gain.delayItems) {
					var bag = gain.delayItems[bid];
					temp[bag.itemId] = temp[bag.itemId] || 0;
					temp[bag.itemId]++;
				}
				for (var id in temp) {
					var dic = {id:id, amount:temp[id], type:k};
					array.push(dic);
				}
			} else if (k === "books") {
				var temp = {};
				for (var sid in gain.books) {
					var skill = gain.books[sid];
					temp[skill.skillId] = temp[skill.skillId] || 0;
					temp[skill.skillId]++;
				}
				for (var id in temp) {
					var dic = {id:id, amount:temp[id], type:k};
					array.push(dic);
				}
			} else if (k === "shadows") {
				var temp = {};
				for (var sid in gain.shadows) {
					var shadow = gain.shadows[sid];
					temp[shadow.shadowId] = temp[shadow.shadowId] || 0;
					temp[shadow.shadowId]++;
				}
				for (var id in temp) {
					var dic = {id:id, amount:temp[id], type:k};
					array.push(dic);
				}
			} else if (k === "equips") {
				var temp = {};
				for (var eid in gain.equips) {
					var equip = gain.equips[eid];
					temp[equip.equipId] = temp[equip.equipId] || 0;
					temp[equip.equipId]++;
				}
				for (var id in temp) {
					var dic = {id:id, amount:temp[id], type:k};
					array.push(dic);
				}
			} else if (k === "gold" || k === "diamond") {
				if (gain[k] <= 0) {
					continue;
				}
				var key = k === "gold" ? "gold" : "diamond";
				array.push({id:key, amount:gain[k], type:key});
			} else if (k === "heros") {
				var temp = {};
				for (var hid in gain.heros) {
					var hero = gain.heros[hid];
					temp[hero.heroId] = temp[hero.heroId] || 0;
					temp[hero.heroId]++;
				}
				for (var id in temp) {
					var dic = {id:id, amount:temp[id], type:k};
					array.push(dic);
				}
			}
		}
		if (getJsonLength(array) > 0) {
			cc.director.getRunningScene().addChild(new RewardsLayer(array));
		}
	}
}

playerdata.addDataObserver()