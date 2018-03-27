--[[
	模块工具类
	Author: H.X.Sun
	Date: 2015-08-17
	--qy.tank.utils.ModuleUtil

]]

local ModuleUtil = {}

local ModuleType = qy.tank.view.type.ModuleType

function ModuleUtil.viewRedirectByViewId(_id, callBack)
	local viewType, redirectType = ModuleUtil.getModuleTypeById(_id)
	if viewType == "" then
		qy.hint:show(qy.TextUtil:substitute(70022))
		return
	end
	callBack()
	local extendData = {}
	if redirectType == 1 then
		if ModuleType.MAIL == viewType then
			extendData.defaultIdx = 4
			qy.tank.command.MainCommand:viewRedirectByModuleType(viewType, extendData)
		else
			qy.tank.command.MainCommand:viewRedirectByModuleType(viewType)
		end
	elseif redirectType == 2 then
		qy.tank.command.ActivitiesCommand:showActivity(viewType)
	end
end


function ModuleUtil.getViewIdByType(_type)
	if _type == ModuleType.GARAGE then
		--车库
		return 2
	-- elseif _type == 3 then
	-- 	--战车列表
	-- 	return ""
	elseif _type == ModuleType.EQUIP then
		--装备界面
		return 4
	elseif _type == ModuleType.EMBATTLE then
		--布阵
		return 5
	elseif _type == ModuleType.TRAINING then
		--训练场
		return 6
	-- elseif _type == 7 then
	-- 	--批量突飞
	-- 	return ""
	elseif _type == ModuleType.EXTRACTION_CARD then
		--军资基地
		return 8
	elseif _type == ModuleType.STORAGE then
		--仓库
		return 9
	elseif _type == ModuleType.MAIL then
		--邮箱
		return 10
	elseif _type == ModuleType.TANK_SHOP then
		--坦克工厂
		return 11
	elseif _type == ModuleType.SHOP then
 		--坦克商店
        		return 12
	elseif _type == ModuleType.PROP_SHOP then
		--军火商店
        		return 13
	elseif _type == ModuleType.TASK then
		--日常任务
		return 14
	elseif _type == ModuleType.SET then
		--设置
		return 15
	-- elseif _type == ModuleType.SET then
	-- 	--玩家资料
	-- 	return 16
	elseif _type == ModuleType.VIP then
		--vip特权
		return 17
	elseif _type == ModuleType.TECHNOLOGY then
		--科技实验室
		return 18
	-- elseif _type == 19 then
	-- 	--钢铁洪流
	-- 	return ""
	-- elseif _type == 20 then
	-- 	--铁甲雄心
	-- 	return ""
	-- elseif _type == 21 then
	-- 	--如何获得科技书
	-- 	return ""
	elseif _type == ModuleType.CLASSIC_BATTLE then
		--经典战役
		return 22
	-- elseif _type == 23 then
	-- 	--远征商店
	-- 	return ""
	-- elseif _type == 24 then
	-- 	--打不过怎么办
	-- 	return ""
	elseif _type == ModuleType.SUPPLY then
		--补给
		return 25
	elseif _type == ModuleType.FIGHT_JAPAN then
		--抗日远征
		return 26
	-- elseif _type == 27 then
	-- 	--帮助界面
	-- 	return ""
	elseif _type == ModuleType.INVADE then
		--伞兵入侵
		return 28
	-- elseif _type == 29 then
	-- 	--世界BOSS
	-- 	return ""
	elseif _type == ModuleType.INSPECTION then
		--每日检阅
		return 30
	elseif _type == ModuleType.ARENA then
		--竞技场
		return 31
	elseif _type == ModuleType.MINE_MAIN_VIEW then
		--矿场
		return 32
	elseif _type == ModuleType.MINE_MAIN_VIEW then
		--普通矿区
		return 33
	elseif _type == ModuleType.MINE_MAIN_VIEW then
		--稀有矿区
		return 34
	elseif _type == 35 then
		--成就
		return 35
	elseif _type == ModuleType.CHAPTER then
		--关卡
		return 36
	elseif _type == 37 then
		--月卡
		return 37
	elseif _type == ModuleType.POT then
		--大锅饭
		return 38
	elseif _type == ModuleType.HEORIC_RACING then
		--英勇竞速
		return 39
	elseif _type == ModuleType.GUNNER_TRAIN then
		--炮手训练
		return 40
	elseif _type == ModuleType.VISIT_GENERAL then
		--拜访名将
		return 41
	elseif _type == ModuleType.HEADQUATER_SUPPORT then
		--总部支援
		return 42
	elseif _type == ModuleType.ACHIEVEMENT then
		--绑定账号
		return 43
	end
end

--[[--
--通过界面ID获取界面的type
--@return 界面type，跳转type(1:普通模块，2：活动模块)
--]]
function ModuleUtil.getModuleTypeById(viewId)
	if viewId == 1 then
		--主界面
		return "", 1
	elseif viewId == 2 then
		--车库
		return ModuleType.GARAGE,1
	elseif viewId == 3 then
		--战车列表
		return "",1
	elseif viewId == 4 then
		--装备界面
		return ModuleType.EQUIP,1
	elseif viewId == 5 then
		--布阵
		return ModuleType.EMBATTLE,1
	elseif viewId == 6 then
		--训练场
		return ModuleType.TRAINING,1
	elseif viewId == 7 then
		--批量突飞
		return "",1
	elseif viewId == 8 then
		--军资基地
		return ModuleType.EXTRACTION_CARD,1
	elseif viewId == 9 then
		--仓库
		return ModuleType.STORAGE,1
	elseif viewId == 10 then
		--邮箱
		return ModuleType.MAIL,1
	elseif viewId == 11 then
		--坦克工厂
		return ModuleType.TANK_SHOP,1
	elseif viewId == 12 then
 		--坦克商店
        		return ModuleType.SHOP,1
	elseif viewId == 13 then
		--军火商店
        		return ModuleType.PROP_SHOP,1
	elseif viewId == 14 then
		--日常任务
		return ModuleType.TASK,1
	elseif viewId == 15 then
		--设置
		return ModuleType.SET,1
	elseif viewId == 16 then
		--玩家资料
		return "",1
	elseif viewId == 17 then
		--vip特权
		return ModuleType.VIP,2
	elseif viewId == 18 then
		--科技实验室
		return ModuleType.TECHNOLOGY,1
	elseif viewId == 19 then
		--钢铁洪流
		return "",1
	elseif viewId == 20 then
		--铁甲雄心
		return "",1
	elseif viewId == 21 then
		--如何获得科技书
		return "",1
	elseif viewId == 22 then
		--经典战役
		return ModuleType.CLASSIC_BATTLE,2
	elseif viewId == 23 then
		--远征商店
		return ModuleType.F_J_EX_SHOP,1
	elseif viewId == 24 then
		--打不过怎么办
		return "",1
	elseif viewId == 25 then
		--补给
		return ModuleType.SUPPLY,1
	elseif viewId == 26 then
		--抗日远征
		return ModuleType.FIGHT_JAPAN,2
	elseif viewId == 27 then
		--帮助界面
		return "",1
	elseif viewId == 28 then
		--伞兵入侵
		return ModuleType.INVADE,2
	elseif viewId == 29 then
		--世界BOSS
		return "",1
	elseif viewId == 30 then
		--每日检阅
		return ModuleType.INSPECTION,2
	elseif viewId == 31 then
		--竞技场
		return ModuleType.ARENA,2
	elseif viewId == 32 then
		--矿场
		return ModuleType.MINE_MAIN_VIEW,1
	elseif viewId == 33 then
		--普通矿区
		return ModuleType.MINE_MAIN_VIEW,1
	elseif viewId == 34 then
		--稀有矿区
		return ModuleType.MINE_MAIN_VIEW,1
	elseif viewId == 35 then
		--成就
		return ModuleType.ACHIEVEMENT,1
	elseif viewId == 36 then
		--关卡
		return ModuleType.CHAPTER,1
	elseif viewId == 37 then
		--月卡
		return ModuleType.MONTH_CARD,2
	elseif viewId == 38 then
		--大锅饭
		return ModuleType.POT,2
	elseif viewId == 39 then
		--英勇竞速
		return ModuleType.HEORIC_RACING,2
	elseif viewId == 40 then
		--炮手训练
		return ModuleType.GUNNER_TRAIN,2
	elseif viewId == 41 then
		--拜访名将
		return ModuleType.VISIT_GENERAL,2
	elseif viewId == 42 then
		--总部支援
		return ModuleType.HEADQUATER_SUPPORT,2
	elseif viewId == 43 then
		-- 图鉴成就
		return ModuleType.ACHIEVEMENT, 1
	elseif viewId == 44 then
		--分解功能
		return ModuleType.RESOLVE, 1
	elseif viewId == 45 then
		--七天登陆
		return ModuleType.LOGIN_GIFT, 2
	elseif viewId == 46 then
		--开服礼包
		return ModuleType.OPEN_SERVER_GIFT_BAG, 2
	elseif viewId == 47 then
		--战争动员
		return ModuleType.ARNY_ASSAULT, 2
	elseif viewId == 48 then
		--累充返利
		return ModuleType.TOTAL_PAY, 2
	elseif viewId == 49 then
		--充值红利
		return ModuleType.BONUS, 2
	elseif viewId == 50 then
		--主线副本
		return ModuleType.CHAPTER, 1
	elseif viewId == 51 then
		--军团基地
		return ModuleType.LEGION, 1
	elseif viewId == 52 then
		--军团押运
		return ModuleType.CARRAY, 2
	elseif viewId == 53 then
		--黑市
		return ModuleType.MARKET, 2
	elseif viewId == 54 then
		--世界boss
		return ModuleType.BOSS, 2
	elseif viewId == 55 then
		--黄金地堡
		return ModuleType.GOLD_BUNKER, 2
	elseif viewId == 56 then
		--军魂
		return ModuleType.SOUL, 1
	elseif viewId == 57 then
		--军魂之路
		return ModuleType.SOUL_ROAD, 2
	elseif viewId == 58 then
		-- 合金
		return ModuleType.ALLOY, 1
	elseif viewId == 59 then
		--孤胆英雄
		return ModuleType.SIGNLE_HERO, 2
	elseif viewId == 60 then
		--将士之战
		return ModuleType.SOLDIERS_WAR, 2
	elseif viewId == 61 then
		--战争图卷
		return ModuleType.WAR_PICTURE, 2
	elseif viewId == 62 then
		--战争图卷
		return ModuleType.BEAT_ENEMY, 2
	elseif viewId == 63 then
		--签到系统
		return ModuleType.SIGN, 2
	elseif viewId == 64 then
		--多人副本
		return ModuleType.GROUP_BATTLES, 2
	elseif viewId == 65 then
		--军功悬赏
		return ModuleType.OFFER_A_REWARD, 2
	elseif viewId == 66 then
		--军功悬赏ƒ
		return ModuleType.INTER_SERVICE_ARENA, 2
	elseif viewId == 67 then
		--充值
		return ModuleType.RECHARGE, 1
	elseif viewId == 68 then
		--乘员
		return ModuleType.PASSENGER, 1
	elseif viewId == 70 then
		--阵营站
		return ModuleType.SER_CAMP, 2
	elseif viewId == 69 then
		--无尽战斗
		return ModuleType.ENDLESS_WAR, 2
	end
end

return ModuleUtil
