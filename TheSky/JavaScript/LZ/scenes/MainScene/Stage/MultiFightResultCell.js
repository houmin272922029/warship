var MultiFightResultCell = cc.Node.extend({
	ctor:function(dic, idx){
		this._super();
		cc.BuilderReader.registerController("SweepCellOwner", {
		});
		var node = cc.BuilderReader.load(ccbi_res.MultiFightResultCell_ccbi, this);
		if(node != null) {
			this.addChild(node);
		}
		this.setContentSize(node.getContentSize());
		
		this.titleLabel.setString(common.LocalizedString("☆第%d次☆", idx));
		this.name.setString(PlayerModule.getName());
		this.playerExp.setString(common.LocalizedString("船长经验+%d", dic.gain.expAll || 0));
		this.berryLabel.setString("+" + dic.gain.gold || 0);
		var info = "";
		for (var id in dic.heros) {
			var hero = HeroModule.getHeroByUid(id);
			info += (hero.name + "+" + dic.gain.heroExpAll);
			if (dic.heros[id].levelDiffer) {
				info += ("(" + common.LocalizedString("sail_levelup") + ")");
			}
			info += " ";
		}
		this.heroInfo.setString(info);
		var gain = dic.gain;
		info = "";
		for (var k in gain) {
			var v = gain[k];
			if (k === "heroes_soul") {
				for (var heroId in v) {
					var cfg = HeroModule.getHeroConfig(heroId);
					info += common.LocalizedString("gain_hero_soul", [v[heroId], cfg.name]);
					info += " ";
				}
			} else if (k === "items") {
				for (var itemId in v) {
					var cfg = ItemModule.getItemConfig(itemId);
					info += common.LocalizedString("gain_item", [v[itemId], cfg.name]);
					info += " ";
				}
			} else if (k === "books" || k === "equips" || k === "shadows" || k === "delayItems") {
				var t = [];
				for (var sid in v) {
					var dic = v[sid];
					var cfg;
					switch (k) {
					case "books":
						cfg = SkillModule.getSkillConfig(dic.skillId);
						break;
					case "equips":
						cfg = EquipModule.getEquipConfig(dic.equipId);
						break;
					case "shadows":
						cfg = ShadowModule.getShadowConfig(dic.shadowId);
						break;
					case "delayItems":
						cfg = ItemModule.getItemConfig(dic.itemId);
						break;
					default:
						break;
					}
					t[cfg.name] = t[cfg.name] || 0;
					t[cfg.name]++;
				}
				for (var name in t) {
					if (k === "books") {
						info += common.LocalizedString("gain_books", [t[name], name]);
					} else {
						info += common.LocalizedString("gain_item", [t[name], name]);
					}
					info += " ";
				}
			} else if (k === "frags") {
				var t = [];
				for (var sid in v) {
					var frag = v[sid];
					for (var id in frag) {
						if (id === "times") {
							continue;
						}
						var cfg = ItemModule.getItemConfig(id);
						traceTable("frag", cfg);
						t[cfg.name] = t[cfg.name] || 0;
						t[cfg.name]++;
					}
				}
				for (var name in t) {
					info += common.LocalizedString("gain_item", [t[name], name]);
					info += " ";
				}
			} else if (k === "equipShard") {
				for (var id in v) {
					var cfg = ShardModule.getShardConfig(id);
					info +=  common.LocalizedString("gain_item", [v[id], cfg.name]);
					info += " ";
				}
			} else if (k === "diamond") {
				info += common.LocalizedString("gain_gold", v);
				info += " ";
			}
		}
		this.awardLabel.setString(info);
		this.awardLabel.visible = true;
	}
});