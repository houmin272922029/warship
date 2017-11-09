var SchedulerModule = {
		tSecond1 : 0,
		tSecond3 : 0,
		tSecond10 : 0,
		tSecond40 : 0,
		tSecond600 : 0,
		tSecond1800 : 0,
		startTimer:function(){
			var node = new cc.Node();
			cc.director.getRunningScene().addChild(node);
			this.scehTimer = node.schedule(this.timers.bind(this), 1, cc.REPEAT_FOREVER, 0);
		},
		endTimer:function(){
			if (this.scehTimer) {
				cc.Director._getInstance().unscheduleScriptEntry(this.scehTimer);
			}
		},
		timers:function(dt){
			if (!dt) {
				dt = 0;
			}
			/**
			 * 每秒 方法
			 */
			this.tSecond1 = this.tSecond1 + dt;
			if (this.tSecond1 > 1){
				this.tSecond1 = this.tSecond1 - 1;
				this.timer_1s();
			}
			/**
			 * 40秒 计时器
			 */
			this.tSecond40 += dt;
			if (this.tSecond40 > 40) {
				this.tSecond40 = this.tSecond40 - 40;
				this.time_40s();
			}
			/**
			 * 10秒 计时器
			 */
			this.tSecond10 += dt;
			if (this.tSecond10 > 10) {
				this.tSecond10 = this.tSecond10 - 10;
				this.time_10s();
			}
		},
		time_tick:function(tickTime){
			Global.serverTime = Global.serverTime + tickTime;
			if (playerdata.strength < PlayerModule.getStrengthMax() && Global.serverTime - playerdata.strength_time >= config.energy_Recovtime["1"].str_time) {
				var count = Math.floor((Global.serverTime - playerdata.strength_time) / config.energy_Recovtime["1"].str_time);
				playerdata.strength = playerdata.strength + count;
				if (playerdata.strength >= PlayerModule.getStrengthMax()) {
					playerdata.strength = PlayerModule.getStrengthMax();
					playerdata.strength_time = Global.serverTime;
				} else {
					playerdata.strength_time = playerdata.strength_time + config.energy_Recovtime["1"].str_time * count;
				}
			}
			if (playerdata.energy && playerdata.energy < PlayerModule.getEnergyMax() && Global.serverTime - playerdata.energy_time >= config.energy_Recovtime["1"].ene_time) {
				var count = Math.floor((Global.serverTime - playerdata.energy_time) / config.energy_Recovtime["1"].ene_time);
				playerdata.energy = playerdata.energy + count;
				if (playerdata.energy >= PlayerModule.getEnergyMax()) {
					playerdata.energy >= PlayerModule.getEnergyMax();
					playerdata.energy_time = Global.serverTime;
				} else {
					playerdata.energy_time = playerdata.energy_time + config.energy_Recovtime["1"].ene_time * count;
				}
			}
		},
		timer_1s:function(){
			this.time_tick(1);
			postNotifcation(NOTI.STRENGTH);
			postNotifcation(NOTI.TRINGSHADOW_CD_TIME);
			postNotifcation(NOTI.BOSS_TIME_REFRESH);//boss首页时间刷新
			postNotifcation(NOTI.BOSS_RESURRECT);  //boss挑战结束时间控制
			postNotifcation(NOTI.BOSS_CHALLENGE); //挑战结果页面计时
			postNotifcation(NOTI.DO_LOADING); //刷新更新页面进度条
			postNotifcation(NOTI.ACIVITY_TIME_UPDATE);  // 活动时间更新
			postNotifcation(NOTI.RESURIT_HERO); //招募英雄时间刷新
			postNotifcation(NOTI.GUIDE_REFRESH_TIME); //新手计时
		},
		time_40s:function(){
			postNotifcation(NOTI.REFRESH_ARENA_INFO);
		},
		time_10s:function() {
			postNotifcation(NOTI.REFRESH_ALLCHATDATA); //聊天数据刷新
		},
}