--[[
    活动command
    -- qy.tank.command.ActivitiesCommand:getInfo
]]

local ActivitiesCommand = qy.class("ActivitiesCommand", qy.tank.command.BaseCommand)

-- 显示某一运营活动
function ActivitiesCommand:showActivity(name,extendData)
	local aType = qy.tank.view.type.ModuleType	


	local function __callFunc()
		if extendData and  extendData.callBack1 then
			extendData.callBack1()
		end
	end
	if name == aType.POT then  -- 大锅饭
		local service = qy.tank.service.PotService
	    service:main(nil,function()
	        __callFunc()
	        local controller = qy.tank.controller.PotController.new()
	        self:startController(controller)
	    end)
	elseif name ==aType.VIP_AWARD then --vip award
				__callFunc()
         		qy.tank.command.VipCommand:showAwardDialog()
    elseif name == aType.INVADE then
		 --伞兵入侵
		local service = qy.tank.service.InvadeService
        		service:main(nil , function(data)
        			__callFunc()
            		qy.tank.view.invade.InvadeDialog.new():show(true)
            		qy.GuideManager:nextTiggerGuide()
        		end)
	elseif name == aType.CLASSIC_BATTLE then
		--经典战役
		local service = qy.tank.service.ClassicBattleService
		service:getlist(function()
			__callFunc()
	        local controller = qy.tank.controller.ClassicBattleController.new()
	          	self:startController(controller)
	          	qy.GuideManager:nextTiggerGuide()
	        end)
	elseif name == aType.INSPECTION then
		--每日检阅
		local service = qy.tank.service.InspectionService
        service:getList(nil , function(data)
        	__callFunc()
            qy.tank.view.inspection.InspectionDialog.new():show(true)
            qy.GuideManager:nextTiggerGuide()
        end)
	elseif name == aType.ARENA then
		--竞技场
		local service = qy.tank.service.ArenaService
       	service:getList(function()
       		__callFunc()
           	local controller = qy.tank.controller.ArenaController.new()
           	self:startController(controller)
           	qy.GuideManager:nextTiggerGuide()
        end)
	elseif name == aType.FIGHT_JAPAN then
		--抗日远征
		local service = qy.tank.service.FightJapanService
       	service:getList(nil,function(data)
       		__callFunc()
        	--qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
            local controller = qy.tank.controller.FightJapanController.new()
            self:startController(controller)
            qy.GuideManager:nextTiggerGuide()
        end)
     elseif name == aType.SER_WAR then
     		-- 巅峰对决
     	if qy.language == "cn" then
	     	local service = qy.tank.service.ServiceWarService
	            service:getList(function(data)
	     	 	__callFunc()
	     	 	qy.tank.module.Helper:register("servicewar")
	     	 	qy.tank.module.Helper:start("servicewar", self)
	     	  end)
        end
  	elseif name == aType.BOSS then
  		-- 世界boss
  		local service = qy.tank.service.WorldBossService
       	service:getList(function(data)
       		__callFunc()
        	qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
	        qy.tank.module.Helper:register("worldboss")
			qy.tank.module.Helper:start("worldboss", self)
            -- qy.GuideManager:nextTiggerGuide()
        end)
	elseif name == aType.GOLD_BUNKER then
        qy.tank.module.Helper:start(name)
    elseif name == aType.CARRAY then  -- 军团押运
    	local service = qy.tank.service.CarrayService
    	service:init(function()
    		qy.tank.module.Helper:register("carray")
        	qy.tank.module.Helper:start("carray", self)
    	end)
    elseif name == aType.FAME then
		--威震欧亚
		local service = qy.tank.service.FameService
        service:getList(nil , function(data)
        	-- __callFunc()
        	qy.tank.module.Helper:register("fame")
            qy.tank.module.Helper:start("fame", nil,function( )
            	qy.tank.view.fame.FameDialog.new():show(true)
            end)
        end)
	elseif name == aType.TORCH_OPERATION then
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
	    qy.tank.module.Helper:register("torch")
		qy.tank.module.Helper:start("torch", qy.App.runningScene.controllerStack:currentView())
	elseif name == aType.LIMIT_TIME_SALE then
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
		qy.tank.module.Helper:register("rush_purchase")
		qy.tank.module.Helper:start("rush_purchase", qy.App.runningScene.controllerStack:currentView())
	elseif name == aType.SUPER_LIMIT_TIME_SALE then
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
		qy.tank.module.Helper:register("newrush_purchase")
		qy.tank.module.Helper:start("newrush_purchase", qy.App.runningScene.controllerStack:currentView())
		--双十一
	elseif name == aType.DOUBLE_ELEVEN then
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
		qy.tank.module.Helper:register("double_eleven")
		qy.tank.module.Helper:start("double_eleven", qy.App.runningScene.controllerStack:currentView())
		--战狼
	elseif name == aType.FIGHT_THE_WOLF then
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
		qy.tank.module.Helper:register("fight_the_wolf")
		qy.tank.module.Helper:start("fight_the_wolf", qy.App.runningScene.controllerStack:currentView())
	elseif name == aType.LIMIT_SECKILL then
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
		qy.tank.module.Helper:register("time_limit_spike")
		qy.tank.module.Helper:start("time_limit_spike", qy.App.runningScene.controllerStack:currentView())
	--你选我送
	elseif name == aType.YOU_CHOOSE_I_SEND then
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
		qy.tank.module.Helper:register("you_choose_me")
		qy.tank.module.Helper:start("you_choose_me", qy.App.runningScene.controllerStack:currentView())
	--圣诞大作战
	elseif name == aType.CHRISTMAS_WAR then
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
		qy.tank.module.Helper:register("christmas_battle")
		qy.tank.module.Helper:start("christmas_battle", qy.App.runningScene.controllerStack:currentView())
	--军团充值
	elseif name == aType.LEGION_RECHARGE then 
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
		qy.tank.module.Helper:register("legion_recharge")
		qy.tank.module.Helper:start("legion_recharge", qy.App.runningScene.controllerStack:currentView())
	--战地设宴
	elseif name == aType.BATTLE_FORGE_BANQUET then 
		__callFunc()
		qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
		qy.tank.module.Helper:register("field_banquet")
		qy.tank.module.Helper:start("field_banquet", qy.App.runningScene.controllerStack:currentView())
	


	elseif name == aType.LEGION_BOSS then
  		-- 军团boss
  		local service = qy.tank.service.LegionBossService
        service:get(function(data)
            qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
            qy.tank.module.Helper:register("legion_boss")
            qy.tank.module.Helper:start("legion_boss", self)
            -- qy.GuideManager:nextTiggerGuide()
        end)
    elseif name == aType.LEGION_SKILL then
  		-- 军团技能
  		local service = qy.tank.service.LegionService
  		service:getSkillMain(function()
        	qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS, true)
        	qy.tank.module.Helper:register("legion_skill")
        	qy.tank.module.Helper:start("legion_skill", qy.App.runningScene.controllerStack:currentView())
    	end)

    elseif name == aType.SOUL_ROAD then --
    	local service = qy.tank.service.SoulRoadService
    	service:get(function(data)
    		qy.tank.module.Helper:register("soul_road")
        	qy.tank.module.Helper:start("soul_road", self)
    	end)
    elseif name == aType.SIGNLE_HERO then --
    	local service = qy.tank.service.SingleHeroService
    	service:get(function(data)
    		qy.tank.module.Helper:register("singlehero")
        	qy.tank.module.Helper:start("singlehero", self)
    	end)
	elseif name == aType.SOLDIERS_WAR then --
    	local service = qy.tank.service.SoldiersWarService
    	service:get(function(data)
    		qy.tank.module.Helper:register("soldiers_war")
        	qy.tank.module.Helper:start("soldiers_war", self)
    	end)
    elseif aType.SER_CAMP == name then
        --阵营战
        local model = qy.tank.model.ServerFactionModel
        if model.isfaction == 0 then
            qy.tank.service.ServerFactionService:getInto(function()
            	__callFunc()
                qy.tank.module.Helper:register("service_faction_war")
                qy.tank.module.Helper:start("service_faction_war",self)
            end)
        else
            qy.tank.service.ServerFactionService:mainCamp(function()
            	__callFunc()
                qy.tank.module.Helper:register("service_faction_war")
                qy.tank.module.Helper:start("service_faction_war",self)
            end)
        end
	elseif name == aType.INTER_SERVICE_ARENA then --
		if qy.tank.model.UserInfoModel.userInfoEntity.level >= 60 then
	    	local service = qy.tank.service.InterServiceArenaService
	    	service:get(function(data)
	    		__callFunc()
	    		qy.tank.module.Helper:register("inter_service_arena")
	        	qy.tank.module.Helper:start("inter_service_arena", self)
	    	end)
	    else
	    	qy.hint:show("60级开启跨服军神榜")
    	end  
	elseif name == aType.INTER_SERVICE_ESCORT then --		
		if qy.tank.model.UserInfoModel.userInfoEntity.level >= 60 then
	    	local service = qy.tank.service.InterServiceEscortService
	    	service:get(function(data)
	    		__callFunc()
	    		qy.tank.module.Helper:register("inter_service_escort")
	        	qy.tank.module.Helper:start("inter_service_escort", self)
	    	end)    	
	    else
	    	qy.hint:show("60级开启跨服押运")
    	end  
	elseif name == aType.STRONG_BATTLE or name == aType.GREATEST_RACE then
    	-- 最强之战
        qy.tank.service.GreatestRaceService:get(true,function()
        	__callFunc()
            qy.tank.module.Helper:register("greatest_race")
            qy.tank.module.Helper:start("greatest_race",nil,function()
                self:startController(qy.tank.controller.GreatestRaceController.new(extendData))
                qy.tank.model.RedDotModel:changeCrossSerRedRod()
            end)
        end)
	elseif name == aType.OFFER_A_REWARD then --
    	local service = qy.tank.service.OfferARewardService
    	service:get(function(data)
    		qy.tank.module.Helper:register("offer_a_reward")
        	qy.tank.module.Helper:start("offer_a_reward", self)
    	end)
    elseif name == aType.EXERCISE then --
    	local service = qy.tank.service.ServerExerciseService
    	local open_level = qy.tank.model.RoleUpgradeModel:getOpenLevelByModule(name)
    	local intro = qy.tank.model.RoleUpgradeModel:getOpenintroByModule(name)
        print("ssssss",open_level)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
        	__callFunc()
	    	service:getMainList(function(data)
	    		qy.tank.module.Helper:register("server_exercise")
	        	qy.tank.module.Helper:start("server_exercise", self)
	    	end)
	    else
	    	qy.hint:show(open_level.."级开启"..intro)
    	end
    elseif name == aType.ENDLESS_WAR then --
    	local service = qy.tank.service.EndlessWarService
    	local open_level = qy.tank.model.RoleUpgradeModel:getOpenLevelByModule(name)
    	local intro = qy.tank.model.RoleUpgradeModel:getOpenintroByModule(name)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
        	__callFunc()
	    	service:get(function(data)
	    		qy.tank.module.Helper:register("endless_war")
	        	qy.tank.module.Helper:start("endless_war", self)
	    	end)
	    else
	    	qy.hint:show(open_level.."级开启"..intro)
    	end
	elseif name == aType.WAR_PICTURE then --
    	local service = qy.tank.service.WarPictureService
    	service:get(function(data)
    		qy.tank.module.Helper:register("war_picture")
        	qy.tank.module.Helper:start("war_picture", qy.App.runningScene.controllerStack:currentView())
    	end)
	elseif name == aType.GROUP_BATTLES then --
    	local service = qy.tank.service.GroupBattlesService
    	service:get(function(data)
    		qy.tank.module.Helper:register("group_battles")
        	qy.tank.module.Helper:start("group_battles", qy.App.runningScene.controllerStack:currentView())
        	__callFunc()
    	end)
    elseif name == aType.ACTIVITY_2048 then
        --2048
        __callFunc()
		local service = qy.tank.service.Activity2048Service
		service:get(function(data)
		   	qy.tank.module.Helper:register("activity_2048")
		    qy.tank.module.Helper:start("activity_2048", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.LUCKY_TRUNTABLE then
        --幸运转盘
	   	qy.tank.module.Helper:register("lucky_turntable")
	    qy.tank.module.Helper:start("lucky_turntable", qy.App.runningScene.controllerStack:currentView())
	elseif name == aType.ANNIVER_PAY then
        --周年庆充值
        __callFunc()
		local service = qy.tank.service.AnniverPayService
		service:get(function(data)
		   	qy.tank.module.Helper:register("anniver_pay")
		    qy.tank.module.Helper:start("anniver_pay", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.SERIES_RECHARGE then
        --连充惊喜
        __callFunc()
		local service = qy.tank.service.SeriesRechargeService
		service:get(function(data)
		   	qy.tank.module.Helper:register("series_recharge")
		    qy.tank.module.Helper:start("series_recharge", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.BOIL_DUMPLING then
        --煮元宵
        __callFunc()
		local service = qy.tank.service.BoilDumplingService
		service:get(function(data)
		   	qy.tank.module.Helper:register("boil_dumpling")
		    qy.tank.module.Helper:start("boil_dumpling", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.COMBAT_CASTING then
        --战备铸造
        __callFunc()
		local service = qy.tank.service.CombatCastingService
		service:get(function(data)
		   	qy.tank.module.Helper:register("combat_casting")
		    qy.tank.module.Helper:start("combat_casting", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.DAILY_PUNCH then
        --累充
        __callFunc()
		local service = qy.tank.service.DailyPunchService
		service:get(function(data)
		   	qy.tank.module.Helper:register("daily_punch")
		    qy.tank.module.Helper:start("daily_punch", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.DAILY_CONSUMPTION then
        --累消
        __callFunc()
		local service = qy.tank.service.DailyConsumptionService
		service:get(function(data)
		   	qy.tank.module.Helper:register("daily_consumption")
		    qy.tank.module.Helper:start("daily_consumption", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.LEAP_FUND then
        --飞跃基金
        __callFunc()
		local service = qy.tank.service.LeapFundService
		service:get(function(data)
		   	qy.tank.module.Helper:register("leap_fund")
		    qy.tank.module.Helper:start("leap_fund", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.BATTLE_FIELD_STORE then
        --战地储备
        __callFunc()
		local service = qy.tank.service.BattleFieldStoreService
		service:get(function(data)
		   	qy.tank.module.Helper:register("battlefield_store")
		    qy.tank.module.Helper:start("battlefield_store", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.BATTLE_FIELD_SUPPLY then
        --战地补给
        __callFunc()
		local service = qy.tank.service.BattleFieldSupplyService
		service:get(function(data)
		   	qy.tank.module.Helper:register("battlefield_supply")
		    qy.tank.module.Helper:start("battlefield_supply", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.LOGIN_FUND then
        --登录基金
        __callFunc()
		local service = qy.tank.service.LoginFundService
		service:get(function(data)
		   	qy.tank.module.Helper:register("login_fund")
		    qy.tank.module.Helper:start("login_fund", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.RECHARGE_DUTY then
        --端午充值返利
        __callFunc()
		local service = qy.tank.service.RechargeDutyService
		service:get(function(data)
		   	qy.tank.module.Helper:register("recharge_duty")
		    qy.tank.module.Helper:start("recharge_duty", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.INTRUDER_TIME then
        --入侵者
        __callFunc()
		local service = qy.tank.service.IntruderTimeService
		service:get(function(data)
		   	qy.tank.module.Helper:register("intruder_time")
		    qy.tank.module.Helper:start("intruder_time", qy.App.runningScene.controllerStack:currentView())
		end)
	

		
	elseif name == aType.YURI_ENGINEER then
        --尤里的工程师
        __callFunc()
		local service = qy.tank.service.YuriEngineerService
		service:get(function(data)
		   	qy.tank.module.Helper:register("yuri_engineer")
		    qy.tank.module.Helper:start("yuri_engineer", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.INTERSERVICE_LEGIONBATTLE then--跨服军团战
		__callFunc()
		local service = qy.tank.service.ServiceLegionWarService
		service:init(function(data)
		   	qy.tank.module.Helper:register("service_legion_war")
		    qy.tank.module.Helper:start("service_legion_war", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.ALL_SERVERS_GROUP_BATTLES then--跨服多人副本
		__callFunc()
		local service = qy.tank.service.AllServersGroupBattlesService
		service:get(function(data)
		   	qy.tank.module.Helper:register("all_servers_group_battles")
		    qy.tank.module.Helper:start("all_servers_group_battles", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.GOD_WORSHIP then
		if qy.tank.model.UserInfoModel.userInfoEntity.level >= 30 then
	    	--战神膜拜
			local service = qy.tank.service.GodWorshipService
			service:get(function(data)
			    qy.tank.module.Helper:register("god_worship")
			    qy.tank.module.Helper:start("god_worship", qy.App.runningScene.controllerStack:currentView())
			end)
	    else
	    	qy.hint:show("30级开启战神膜拜")
    	end
    elseif name == aType.ZONGZI_FIGHT then
    	__callFunc()
    	local service = qy.tank.service.TasteWarService
		service:main(function()
	    	qy.tank.module.Helper:register("taste_war")
	        qy.tank.module.Helper:start("taste_war", qy.App.runningScene.controllerStack:currentView())
		end)
	elseif name == aType.TANK_918 then -- 鼠式增援
		__callFunc()
    	local service = qy.tank.service.Tank918Service
		service:get(function()
	    	qy.tank.module.Helper:register("limit_reinforce")
	    	qy.tank.module.Helper:start("limit_reinforce", qy.App.runningScene.controllerStack:currentView())  
    	end)
    elseif name == aType.TIGER_MACHINE then -- 老虎机
		__callFunc()
    	local service = qy.tank.service.LuckyDrawService
		service:init(function()
	    	qy.tank.module.Helper:register("lucky_draw")
	    	qy.tank.module.Helper:start("lucky_draw", qy.App.runningScene.controllerStack:currentView())  
    	end)  	
	else
		local service = qy.tank.service.OperatingActivitiesService  --l老运营活动
		service:getInfo(name, function(data)
			__callFunc()
			if name == aType.LOGIN_GIFT then --七天登陆礼包
				qy.tank.view.operatingActivities.loginGift.LoginGiftDialog.new():show(true)
	        			qy.GuideManager:next(91)
			elseif name == aType.HEROIC_RACING then  -- 英勇竞速
				qy.tank.view.operatingActivities.heroicRacing.HeroicRacingDialog.new():show(true)
			elseif name == aType.GUNNER_TRAIN then  -- 炮手训练
				qy.tank.view.operatingActivities.gunnerTrain.GunnerTrainDialog.new():show(true)
				qy.GuideManager:nextTiggerGuide()
			elseif name == aType.VISIT_GENERAL then  -- 拜访名将
				qy.tank.view.operatingActivities.visitGeneral.VisitGeneralDialog.new():show(true)
			elseif name == aType.HEADQUATER_SUPPORT then  -- 总部支援
				qy.tank.view.operatingActivities.headquartersSupport.HeadquartersSupportDialog.new():show(true)
			elseif name == aType.OPEN_SERVER_GIFT_BAG then
				-- 开服礼包
				qy.tank.view.operatingActivities.openServerGift.ServerGiftDialog.new():show(true)
			elseif name == aType.ARNY_ASSAULT then
				-- 战争动员
				qy.tank.view.operatingActivities.armyAssault.ArmyAssaultDialog.new():show(true)
			elseif name == aType.FIRST_PAY then
				--首充
				qy.tank.view.operatingActivities.firstPay.FirstPayDialog.new(extendData):show(true)
			elseif name == aType.TOTAL_PAY then
				--累充返利第一版
				qy.tank.view.operatingActivities.totalPay.TotalPayDialog.new():show(true)
			elseif name == aType.PAY_REBATE then
				--累充返利第二版
				qy.tank.view.operatingActivities.pay_rebate.PayRebateDialog.new():show(true)
			elseif name == aType.PAY_REBATE_VIP then
				--累充返利第三版
                qy.tank.module.Helper:register("pay_rebate_vip")
        		qy.tank.module.Helper:start("pay_rebate_vip", qy.App.runningScene.controllerStack:currentView())
			elseif name == aType.PAY_EVERYDAY then
        		--每日充值
		        local service = qy.tank.service.PayEveryDayService
		    	service:get(function(data)
		    		qy.tank.module.Helper:register("pay_everyday")
		        	qy.tank.module.Helper:start("pay_everyday", qy.App.runningScene.controllerStack:currentView())
		    	end)
			elseif name == aType.KELUBO_TREASURY then
        		--克虏伯
		        local service = qy.tank.service.KeluboTreasuryService
		    	service:get(function(data)
		    		qy.tank.module.Helper:register("kelubo_treasury")
		        	qy.tank.module.Helper:start("kelubo_treasury", qy.App.runningScene.controllerStack:currentView())
		    	end)
			elseif name == aType.JUNENGPINHE then
        		--聚能拼合
		        local service = qy.tank.service.JuNengPinHeService
		    	service:get(function(data)
		    		qy.tank.module.Helper:register("junengpinhe")
		        	qy.tank.module.Helper:start("junengpinhe", qy.App.runningScene.controllerStack:currentView())
		    	end)
			elseif name == aType.FANFANLE then
        		--翻翻乐
		        local service = qy.tank.service.FanFanLeService
		    	service:get(function(data)
		    		qy.tank.module.Helper:register("fanfanle")
		        	qy.tank.module.Helper:start("fanfanle", qy.App.runningScene.controllerStack:currentView())
		    	end)
			elseif name == aType.MONTH_CARD then
				--月卡
				if qy.product == "sina" then
					qy.tank.view.monthCard.AppstoreMonthCard.new():show(true)
				else
					qy.tank.view.monthCard.MainDialog.new():show(true)
				end
			elseif name == aType.UP_FUND then
				qy.tank.view.operatingActivities.growthFund.MainDialog.new():show(true)
			elseif name == aType.PUB then
				qy.tank.module.Helper:register("pubs")
        		qy.tank.module.Helper:start("pubs", qy.App.runningScene.controllerStack:currentView())
        	elseif name == aType.HAPPY_NATIONAL then
				qy.tank.module.Helper:register("happy_nationalday")
        		qy.tank.module.Helper:start("happy_nationalday", qy.App.runningScene.controllerStack:currentView())
			elseif name == aType.MARKET then
				--黑市
				qy.tank.module.Helper:register("market")
        		qy.tank.module.Helper:start("market", qy.App.runningScene.controllerStack:currentView())
        	elseif name == aType.BONUS then  -- 充值红利
		    	qy.tank.module.Helper:register("bonus")
		        qy.tank.module.Helper:start("bonus", qy.App.runningScene.controllerStack:currentView())
            --季卡，年卡
            elseif name == aType.YEAR_CARD then  
		    	qy.tank.module.Helper:register("year_card")
		        qy.tank.module.Helper:start("year_card", qy.App.runningScene.controllerStack:currentView())
		    --签到好礼
            elseif name == aType.DAY_MARK then  
		    	qy.tank.module.Helper:register("sign_in_gifts")
		        qy.tank.module.Helper:start("sign_in_gifts", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.IRON_MINE then  -- 挖矿
		    	qy.tank.module.Helper:register("iron_mine")
		        qy.tank.module.Helper:start("iron_mine", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.LUCKY_CAT then  -- 挖矿
		    	qy.tank.module.Helper:register("lucky_cat")
		        qy.tank.module.Helper:start("lucky_cat", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.NEWYEAR_SUPPLY then  -- 春节特供
		    	qy.tank.module.Helper:register("newyear_supply")
		        qy.tank.module.Helper:start("newyear_supply", qy.App.runningScene.controllerStack:currentView())
			elseif name == aType.ASSEMBLY then
				--集结号
				qy.tank.module.Helper:register("assembly")
                qy.tank.module.Helper:start("assembly",nil,function()
                    qy.tank.view.operatingActivities.assembly.AssemblyDialog.new():show(true)
                end)
			elseif name == aType.SPR_GIT then
				--猴年吉祥
				qy.tank.module.Helper:register("spring_gift")
                qy.tank.module.Helper:start("spring_gift",nil,function()
                    qy.tank.view.operatingActivities.spring_gift.SpringGDialog.new():show(true)
                end)
            elseif name == aType.HEAD_TREASURE then
				--元首的宝藏
				qy.tank.module.Helper:register("head_treasure")
                qy.tank.module.Helper:start("head_treasure", qy.App.runningScene.controllerStack:currentView())
            elseif name == aType.LOGIN_COMBAT then
				--登录作战
				qy.tank.module.Helper:register("login_total")
                qy.tank.module.Helper:start("login_total", qy.App.runningScene.controllerStack:currentView())
            elseif name == aType.RECHARGE_DOYEN then
    			qy.tank.module.Helper:register("recharge_doyen")
        		qy.tank.module.Helper:start("recharge_doyen", qy.App.runningScene.controllerStack:currentView())
        	elseif name == aType.RECHARGE_SECTION then
    			qy.tank.module.Helper:register("recharge_section")
        		qy.tank.module.Helper:start("recharge_section", qy.App.runningScene.controllerStack:currentView())
        	elseif name == aType.RECHARGE_KING then
    			qy.tank.module.Helper:register("recharge_king")
        		qy.tank.module.Helper:start("recharge_king", qy.App.runningScene.controllerStack:currentView())
        	elseif name == aType.EARTH_SOUL then -- 大地英魂
				qy.tank.module.Helper:register("earth_soul")
    			qy.tank.module.Helper:start("earth_soul", qy.App.runningScene.controllerStack:currentView())
    		elseif name == aType.ALL_RECHARGE then --全服福利
				qy.tank.module.Helper:register("allrecharge")
		    	qy.tank.module.Helper:start("allrecharge", qy.App.runningScene.controllerStack:currentView())
			elseif name == aType.SEARCH_TREASURE then -- 探宝日记
               	qy.tank.module.Helper:register("searchTreasure")
               	qy.tank.module.Helper:start("searchTreasure", qy.App.runningScene.controllerStack:currentView())
            elseif name == aType.QUIZ then -- 知识竞赛
               	qy.tank.module.Helper:register("quiz")
               	qy.tank.module.Helper:start("quiz", nil,function()
               		local controller = qy.tank.controller.QuizController.new()
            		self:startController(controller)
               	end)
            elseif name == aType.ACHIEVE_SHARE then -- 分享有礼
               	qy.tank.module.Helper:register("share")
               	qy.tank.module.Helper:start("share",nil,function()
               		qy.tank.view.operatingActivities.achieve_share.AchieveShareDialog.new():show(true)
               	end)
            elseif name == aType.DISCOUNT_SALE then -- 折扣贩售
               	qy.tank.module.Helper:register("discount_sale")
               	qy.tank.module.Helper:start("discount_sale",nil,function()
               		qy.tank.view.operatingActivities.discount_sale.DiscountSaleDialog.new():show(true)
               	end)
            elseif name == aType.OUTSTANDING then -- 精英招募
               	qy.tank.module.Helper:register("outstanding")
		    	qy.tank.module.Helper:start("outstanding", qy.App.runningScene.controllerStack:currentView())
			elseif name == aType.SINGLE_RECHARGE then
				--单笔充值(白虎来袭)
				qy.tank.module.Helper:register("single_recharge")
                qy.tank.module.Helper:start("single_recharge",nil,function()
                    qy.tank.view.operatingActivities.single_recharge.SingleRechargeDialog.new():show(true)
                end)
            elseif name == aType.GROUPPURCHASE then -- 超值购物
            	qy.tank.module.Helper:register("grouppurchase")
		    	qy.tank.module.Helper:start("grouppurchase", qy.App.runningScene.controllerStack:currentView())
            elseif name == aType.MATCH_FIGHT_POWER then -- 战力竞赛
            	qy.tank.module.Helper:register("match_fight_power")
		    	qy.tank.module.Helper:start("match_fight_power", qy.App.runningScene.controllerStack:currentView())
			elseif name == aType.WAR_AID then
				--战地援助
				qy.tank.module.Helper:register("war_aid")
                qy.tank.module.Helper:start("war_aid",nil,function()
                    qy.tank.view.operatingActivities.war_aid.WarAidDialog.new():show(true)
                end)
			elseif name == aType.MILITARY_SUPPLY then
				-- 军资整备
				qy.tank.module.Helper:register("military_supply")
				qy.tank.module.Helper:start("military_supply",nil,function()
					qy.tank.view.operatingActivities.military_supply.MilitaryDialog.new():show(true)
				end)
		    elseif name == aType.BEAT_ENEMY then
				--暴打敌营
		        local service = qy.tank.service.BeatEnemyService
		    	service:get(function(data)
		    		qy.tank.module.Helper:register("beat_enemy")
		        	qy.tank.module.Helper:start("beat_enemy", qy.App.runningScene.controllerStack:currentView())
		    	end)
		    elseif name == aType.SIGN then
				--签到系统
		        local service = qy.tank.service.SignService 
		    	service:get(function(data)
		    		qy.tank.module.Helper:register("sign")
		        	qy.tank.module.Helper:start("sign", qy.App.runningScene.controllerStack:currentView())
		    	end)
		    elseif name == aType.DIAMOND_REBATE then
		    	 	qy.tank.module.Helper:register("diamond_rebate")
		        	qy.tank.module.Helper:start("diamond_rebate", qy.App.runningScene.controllerStack:currentView())
			elseif name == aType.OLYMPIC then
				-- 军奥会
		    	qy.tank.module.Helper:register("olympic")
		    	qy.tank.module.Helper:start("olympic",self)
		    elseif name == aType.LUCKY_INDIANA then
		    	--幸运夺宝
		     	qy.tank.module.Helper:register("lucky_indiana")
		        qy.tank.module.Helper:start("lucky_indiana", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.SEVEN_DAYS_HAPPY then
		    	qy.tank.module.Helper:register("christmas_sevendays")
		        qy.tank.module.Helper:start("christmas_sevendays", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.ANNUAL_BONUS then
		    	qy.tank.module.Helper:register("annual_bonus")
		        qy.tank.module.Helper:start("annual_bonus", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.RECRUIT_SUPPLY then
		    	qy.tank.module.Helper:register("recruit_supply")
		        qy.tank.module.Helper:start("recruit_supply", qy.App.runningScene.controllerStack:currentView())
		     --每日福利
		     elseif name == aType.DAILY_WELFARE then
		    	qy.tank.module.Helper:register("daily_snap_up")
		        qy.tank.module.Helper:start("daily_snap_up", qy.App.runningScene.controllerStack:currentView())   
		    elseif name == aType.RED_PACKET then
		    	qy.tank.module.Helper:register("newyear_redpacket")
		        qy.tank.module.Helper:start("newyear_redpacket", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.NATASHA_DOUBLE then
		    	qy.tank.module.Helper:register("natasha_blessing")
		        qy.tank.module.Helper:start("natasha_blessing", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.NATASHA_DROP then
		    	qy.tank.module.Helper:register("Natasha_gift")
		        qy.tank.module.Helper:start("Natasha_gift", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.MAY_PLEASURE then
		    	qy.tank.module.Helper:register("happy_fiveday")
		        qy.tank.module.Helper:start("happy_fiveday", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.MERGE_CARNIVAL then
		    	qy.tank.module.Helper:register("merge_carnival")
		        qy.tank.module.Helper:start("merge_carnival", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.COLLECT_DUMPLINGS then
		    	qy.tank.module.Helper:register("collect_dumplings")
		        qy.tank.module.Helper:start("collect_dumplings", qy.App.runningScene.controllerStack:currentView())
		    elseif name == aType.FIRE_REBATE then

		    	qy.tank.module.Helper:register("fire_rebate")
		        qy.tank.module.Helper:start("fire_rebate", qy.App.runningScene.controllerStack:currentView())
        	elseif name == aType.LEGIONGENERALTIONMODEL then

          		qy.tank.module.Helper:register("legion_generaltion")
          		qy.tank.module.Helper:start("legion_generaltion", qy.App.runningScene.controllerStack:currentView())

		    elseif name == aType.CROSSFIRE then
		    	local service = qy.tank.service.BreakFireService 
		    	service:get(function(data)
		    		qy.tank.module.Helper:register("break_fireline")
		        	qy.tank.module.Helper:start("break_fireline", qy.App.runningScene.controllerStack:currentView())
		    	end)
			end
		end)
	end
end

function ActivitiesCommand:refresh(tType , activityData)
	local actData  = activityData

	if tonumber(tType) == 1 then
		qy.tank.model.BattleRoomModel:initList(actData)
	elseif tonumber(tType) == 2 then
		qy.tank.model.OperatingActivitiesModel:initList(actData)
	elseif tonumber(tType) == 3 then
		qy.tank.model.ActivityIconsModel:initList(actData)
		qy.tank.model.OperatingActivitiesModel:initList(actData)
	elseif tonumber(tType) == 4 then
		qy.tank.model.OperatingActivitiesModel:initList(actData)
	end
	qy.Event.dispatch(qy.Event.ACTIVITY_REFRESH)
end

--[[
	更新活动数据
	type 活动大类型：  1 作战室   2 运营活动  3 主界面  4跨服竞技
]]
function ActivitiesCommand:getList( type , callBack)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getList",
        ["p"] = {type = type}
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
    	local actData = {}
    	actData.activity_list = {}
    	actData.activity_list[""..type] = response.data.activity_list
    	actData.activity_list.type = type
    	actData.activity_list_status = response.data.activity_list_status
        self:refresh(type , actData)
        if callBack~=nil then
	        callBack(response.data)
	    end
    end)
end



return ActivitiesCommand
