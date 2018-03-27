--[[
--运营活动 model
--Author: H.X.Sun
--Date: 2015-06-24
--]]

local OperatingActivitiesModel = qy.class("OperatingActivitiesModel", qy.tank.model.BaseModel)
    -- login_gift = require("data/seven_login_award"),
    -- heroic_racing = require("data/heroic_racing"),
    -- gunner_train = require("data/gunner_train"),
    -- visit_general = require("data/visit_general"),
local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil
local _ColorMapUtil = qy.tank.utils.ColorMapUtil
local _ModuleType = qy.tank.view.type.ModuleType
local _StorageModel = qy.tank.model.StorageModel
local _AwardUtils = qy.tank.utils.AwardUtils

--[[--
--获取活动列表
--]]
function OperatingActivitiesModel:initList(totalData)
	local ModuleType = qy.tank.view.type.ModuleType
	self.activityList = {}
	self.listIndex = {}
	self.listData = {}
	self.configList = {}
	self.fundList = {} -- 成长基金

	if totalData.activity_list["2"] then
		self.listIndex = totalData.activity_list["2"]

		if qy.product ~= "sina" and qy.product ~= "develop" and qy.product ~= "local" then
			-- 不是新浪渠道，屏蔽分享
			local shardIndex = 0
			for i = 1, #self.listIndex do
				if self.listIndex[i] == "achieve_share" then
					shardIndex = i
				end
			end
			if shardIndex > 0 then
				table.remove(self.listIndex,shardIndex)
			end
		end


	end

		
	if totalData.activity_list_status then
		if self.activityRedDotStatus == nil then 
			self.activityRedDotStatus = {} 
		end

		self.activityRedDotStatus[tostring(totalData.activity_list.type)] = {}

		for k,v in pairs(totalData.activity_list_status) do
			self.activityRedDotStatus[tostring(totalData.activity_list.type)][k] = v
		end
	end
		

	if totalData.activity_list["3"] then
		self.mainViewList = {}

		for i, v in pairs(totalData.activity_list["3"]) do
			if i ~= "first_pay" and v ~= "first_pay" then
				--真特么恶心
				if type(i) == "string" then
					table.insert(self.mainViewList , i)
				elseif type(v) == "string" then
 					table.insert(self.mainViewList , v)
 				end
 			end
		end
	end


	if totalData.activity_list["4"] then
		self.serviceList = totalData.activity_list["4"]
	end

	if self.mainViewList and self.mainViewList.heroic_racing then
		self.hacingUptime = self.mainViewList.heroic_racing.uptime
	end

	-- for i, v in pairs(self.mainViewList) do
	-- 	for k, j in pairs(v) do
	-- 		print("飒飒的合格后 " .. k)
	-- 	end
	-- 	if v.key and v.key == "heroic_racing" then
	-- 		print("阿斯顿都没去烦恼")
	-- 		self.hacingUptime = v.uptime
	-- 	end
	-- end
end

function OperatingActivitiesModel:getActivityRedDotStatus()
	return self.activityRedDotStatus
end

-- 初始化数据
function OperatingActivitiesModel:initInfo(name , data, extend)
	print("进来了",name);
	self.activityList[name] = data.activity_info
	self.listData[name] = data.activity_info.extends_data
	self.configList[name] = data.activity_info.showlist

	--下面某些活动的特殊处理
	if name == _ModuleType.LOGIN_GIFT then
		--七日登陆礼包
		self:__sortForLoginGift()
	elseif name == _ModuleType.OPEN_SERVER_GIFT_BAG then
		--开服礼包
		self:__sortForServerGift()
	elseif name == _ModuleType.TOTAL_PAY then
		--累充返利第一版
		self:initToTalPayData()
	elseif name == _ModuleType.PAY_REBATE then
		--累充返利第二版
		self:initPayRebateData()
	elseif name == _ModuleType.PAY_REBATE_VIP then
		--累充返利第三版
		self:initPayRebateVipData()
	elseif name == _ModuleType.MATCH_FIGHT_POWER then
		--战力竞赛
		qy.tank.model.MatchFightPowerModel:init(data)
	elseif name == _ModuleType.UP_FUND then
		if data.activity_info.is_have_buy then
			self.is_have_buy = true
		else
			self.is_have_buy = false
		end
		self:initFund(extend)
	elseif name == _ModuleType.MONTH_CARD then
		self:monthCardInit()
	elseif name == _ModuleType.PUB then
		self:pubInit()
	-- elseif name == qy.tank.view.type.ModuleType.GUNNER_TRAIN then
	-- 	print("制度实施规划和 " .. data.free_times)
	-- 	self.activityList[name].free_times = data.free_times
	elseif name == _ModuleType.BONUS then
		self:initBonus()
	elseif name == _ModuleType.IRON_MINE then
		self:initIronMine()
	elseif name == _ModuleType.LUCKY_CAT then
		self:initLuckyCat()
	elseif name == _ModuleType.NEWYEAR_SUPPLY then
		self:initNewYearSupply()
	elseif name == _ModuleType.SPR_GIT then
		self:initSpringGiftArr()
	elseif name == _ModuleType.HEAD_TREASURE then
		self:initHeadTreasure()
	elseif name == _ModuleType.RECHARGE_DOYEN then
		self:initRechargeDoyen()
	elseif name == _ModuleType.EARTH_SOUL then
		self:initEarthSoul()
	elseif name == _ModuleType.ALL_RECHARGE then
		self:initAllRecharge()
	elseif name == _ModuleType.OUTSTANDING then
		self:initOutStanding()
	elseif name == _ModuleType.SEARCH_TREASURE then
		self:initSearchTreasure()
	elseif name == _ModuleType.QUIZ then
		self:initquiz()
	elseif name == _ModuleType.GROUPPURCHASE then
		self:initGroupPurchase()
	elseif name == _ModuleType.ACHIEVE_SHARE then
		self:initAchieveShare()
	elseif name == _ModuleType.DISCOUNT_SALE then
		self:initDiscountData()
	elseif name == _ModuleType.DIAMOND_REBATE then
		--钻石返利
		self:initDiamondRebateData()
	elseif name == _ModuleType.WAR_AID then
		self:initWarAidData()
	elseif name == _ModuleType.MILITARY_SUPPLY then
		-- 军资整备
		self:initMilitarySupplyData()
	elseif name == _ModuleType.OLYMPIC then
		-- 军奥会
		qy.tank.model.OlympicModel:init(data)
	elseif name == _ModuleType.RECHARGE_KING then
		self:initRechargeKing()
	elseif name == _ModuleType.HAPPY_NATIONAL then
		self:initHappyNational()	
	elseif name == _ModuleType.RECHARGE_SECTION then
		self:initRechargeSection()	
	elseif name == _ModuleType.LUCKY_INDIANA then
		self:initLuckyIndianaData()
	elseif name == _ModuleType.SEVEN_DAYS_HAPPY then
		self:initChristmasData()
	elseif name == _ModuleType.ANNUAL_BONUS then
		self:initAnnualBonus()
	elseif name == _ModuleType.RECRUIT_SUPPLY then
		self:initRecruitSupply()
	elseif name == _ModuleType.RED_PACKET then
		qy.tank.model.RedPacketModel:init(data)
	elseif name == _ModuleType.NATASHA_DOUBLE then
		self:initNatashaBeling() 
	elseif name == _ModuleType.NATASHA_DROP then
		self:initNatashaGift()
	elseif name == _ModuleType.MAY_PLEASURE then
		qy.tank.model.HappyFiveDayModel:init(data)
	elseif name == _ModuleType.COLLECT_DUMPLINGS then
		qy.tank.model.CollectDumpingsModel:init(data)
	elseif name == _ModuleType.MERGE_CARNIVAL then
		qy.tank.model.MergeCarnialModel:init(data)
	elseif name == _ModuleType.FIRE_REBATE then
		qy.tank.model.FireRebateModel:init(data)
  	elseif name == _ModuleType.LEGIONGENERALTIONMODEL then
    	qy.tank.model.LegionGeneraltionModel:init(data)
	end
	
end

function OperatingActivitiesModel:getActivityRedDotStatusByName(_type, _name)
	if _type and self.activityRedDotStatus[tostring(_type)] then
		for _k, _v in pairs(self.activityRedDotStatus[tostring(_type)]) do
			if _k == _name then
				return self.activityRedDotStatus[tostring(_type)][_k]
			end
		end
	end
	return "none"
end

function OperatingActivitiesModel:getActivityDataByKey(key)
	return self.listData[key]
end

function OperatingActivitiesModel:getActivityNun()
	return self.listIndex and #self.listIndex or 0
end

function OperatingActivitiesModel:getActivityIndex()
	return self.listIndex
end

function OperatingActivitiesModel:getTimeLimitActivityNun()
	return self.mainViewList and #self.mainViewList or 0
end

function OperatingActivitiesModel:getTimeLimitActivityIndex()
	return self.mainViewList
end


function OperatingActivitiesModel:getServiceActivityNun()
	return self.serviceList and #self.serviceList or 0
end

function OperatingActivitiesModel:getServiceActivityIndex()
	return self.serviceList
end


function OperatingActivitiesModel:removeNoIconActivity(name)
	local index = 0
	for i = 1, #self.listIndex do
		if name == self.listIndex[i] then
			index = i
		end
	end

	if index > 0 then
		table.remove(self.listIndex,index)
	end



	for i = 1, #self.serviceList do
		if name == self.serviceList[i] then
			index = i
		end
	end	

	if index > 0 then
		table.remove(self.serviceList,index)
	end
end

function OperatingActivitiesModel:setAward(data)
	self.award = data
end

function OperatingActivitiesModel:getAward()
	return self.award
end
--------------------------------------七日登陆礼包--------------------------------------------------------------------------
--[[--
--更新七天登陆礼包状态
--]]
function OperatingActivitiesModel:updateLoginGiftStatus(data)
	self.listData[qy.tank.view.type.ModuleType.LOGIN_GIFT] = data.activity_info.extends_data
end

function OperatingActivitiesModel:isCompleteGetTank()
	local data = self.activityList[_ModuleType.LOGIN_GIFT]
	if data and data.end_award then
		return  data.end_award
	else
		return 2
	end
end

function OperatingActivitiesModel:updateGetTankStatus(_status)
	local data = self.activityList[_ModuleType.LOGIN_GIFT]
	if data and data.end_award then
		data.end_award = _status
	end
end

--[[--
--获取某一天的状态
--]]
function OperatingActivitiesModel:getLoginGiftStatusByIndex(_idx)
	local day = self:getDayByIndexOfLoginGift(_idx)
	return self.listData[qy.tank.view.type.ModuleType.LOGIN_GIFT][day]
end

--[[--
--获取天数
--]]
function OperatingActivitiesModel:getNumOfLoginGiftDay()
	return #self.loginGiftDayIndex
end

function OperatingActivitiesModel:getAwardByIndexOfLoginGift(_idx)
	-- return self.configList[qy.tank.view.type.ModuleType.LOGIN_GIFT]["" .. day].award
	local _day = self.loginGiftDayIndex[_idx]
	local name = qy.tank.view.type.ModuleType.LOGIN_GIFT
	if self.configList[name] and self.configList[name][tostring(_day)] then
		return self.configList[name][tostring(_day)].award
	else
		return {}
	end
end

function OperatingActivitiesModel:getDayByIndexOfLoginGift(_idx)
	return self.loginGiftDayIndex[_idx]
end

--排序，已领取的放后面
function OperatingActivitiesModel:__sortForLoginGift()
	local name = qy.tank.view.type.ModuleType.LOGIN_GIFT
	self.loginGiftDayIndex = {}
	local _hasReceiveDay = {}
	for i = 1, #self.listData[name] do
		if self.listData[name][i] < 2 then
			table.insert(self.loginGiftDayIndex, i)
		else
			table.insert(_hasReceiveDay, i)
		end
	end

	for i = 1, #_hasReceiveDay do
		table.insert(self.loginGiftDayIndex, i)
	end
end

----------------------------------------------------------------------------------------------------------------

--------------------------------------英勇竞速--------------------------------------------------------------------------
-- 获取英勇竞速用户列表
function OperatingActivitiesModel:getHeroicRacingUserList()
	local userData = self.listData[qy.tank.view.type.ModuleType.HEROIC_RACING]

	-- 这里需要对list做下排序
	local tempList = {}
	local arr0 = {}
	local arr1 = {}
	local arr2 = {}
	for k,v in pairs(userData) do
		local obj = {}
		obj.id = k
		obj.status = v
		if tonumber(v) == 0 then
			table.insert(arr0 , obj)
		elseif  tonumber(v) == 1 then
			table.insert(arr1 , obj)
		elseif  tonumber(v) == 2 then
			table.insert(arr2 , obj)
		end
	end

	 table.sort(arr0, function(a, b)
        return tonumber(a.id) < tonumber(b.id)
    end)

	 table.sort(arr1, function(a, b)
        return tonumber(a.id) < tonumber(b.id)
    end)

	 table.sort(arr2, function(a, b)
        return tonumber(a.id) < tonumber(b.id)
    end)

	for i=1,#arr1 do
		table.insert(tempList , arr1[i])
	end
	for i=1,#arr0 do
		local tObj = {}
		tObj.id = arr0[i].id
		tObj.status = arr0[i].status
		tObj.index = i
		table.insert(tempList , tObj)
	end
	for i=1,#arr2 do
		table.insert(tempList , arr2[i])
	end

	return tempList
end

function OperatingActivitiesModel:setHeroicRacingStatusById( id , status )
	local userData = self.listData[qy.tank.view.type.ModuleType.HEROIC_RACING]
	userData[tostring(id)] = status
end

function OperatingActivitiesModel:isHeroicRacingHasAward()
	local userData = self.listData[qy.tank.view.type.ModuleType.HEROIC_RACING]
	for _k, _v in pairs(userData) do
		if tonumber(_v) == 1 then
			return true
		end
	end
	return false
end

-- 获取英勇竞速配置ItemData
function OperatingActivitiesModel:getHeroicRacingConfigItemDataById(id)
	return self.configList[qy.tank.view.type.ModuleType.HEROIC_RACING][tostring(id)]
end

--获取剩余时间
function OperatingActivitiesModel:getHeroicRacingLeftTime()
	local endTime = self.hacingUptime
	if not endTime and self.activityList.heroic_racing then
		endTime = self.activityList.heroic_racing.uptime
	end

	if not endTime then
		return nil
	end
	local time = endTime - qy.tank.model.UserInfoModel.serverTime
	return time
end

--  获取剩余钻石数
function OperatingActivitiesModel:getHeroicRacingLeftDiamond()
	local userData = self.listData[qy.tank.view.type.ModuleType.HEROIC_RACING]
	local leftDiamond = 0
	for k,v in pairs(userData) do
		if tonumber(v) ~= 2 then
			local itemCOnfigData = self:getHeroicRacingConfigItemDataById(k)
			leftDiamond = leftDiamond + itemCOnfigData.award[1].num
		end
	end
	return leftDiamond
end

--  获取关卡配置数据
function OperatingActivitiesModel:getCheckpointConfigDataByCheckPointId( id )
	-- local campionModel =  qy.tank.model.CampaignModel
	-- campionModel:initConfigs()
	local data = qy.Config.checkpoint
	return  data[tostring(id)]
end

-- 获取场景名称
function OperatingActivitiesModel:getSceneNameBySceneName(sceneId)
	local campionModel =  qy.tank.model.CampaignModel
	-- campionModel:initConfigs()
	local data = qy.Config.scene
	return  data[tostring(sceneId)].name
end


----------------------------------------------------------------------------------------------------------------


--------------------------------------炮手训练--------------------------------------------------------------------------

-- 获取炮手训练用户列表
function OperatingActivitiesModel:getGunnerTrainUserList()
	local ModuleType = qy.tank.view.type.ModuleType
	return self.listData[ModuleType.GUNNER_TRAIN]
end

--通过id设置炮手训练状态
function OperatingActivitiesModel:setGunnerTrainStatusById( id , status )
	local userData = self.listData[qy.tank.view.type.ModuleType.GUNNER_TRAIN]
	userData[tostring(id)] = status
end

-- 获取炮手训练配置ItemData
function OperatingActivitiesModel:getGunnerTrainConfigItemDataById(id)
	return self.configList[qy.tank.view.type.ModuleType.GUNNER_TRAIN][tostring(id)]
end

-- 获取时间戳
function OperatingActivitiesModel:canGunnerFire()
	return self.activityList[qy.tank.view.type.ModuleType.GUNNER_TRAIN].free_times > 0 and true or false
end

function OperatingActivitiesModel:updateGunnerTrainUptime(free_times)
	self.activityList.gunner_train.free_times  = free_times
end

----------------------------------------------------------------------------------------------------------------
--------------------------------------拜访名将--------------------------------------------------------------------------

-- 通过id获取拜访名将用户列表item
function OperatingActivitiesModel:getVisitGeneralUserListItemValueById(id)
	local ModuleType = qy.tank.view.type.ModuleType
	return self.listData[ModuleType.VISIT_GENERAL][tostring(id)]
end

-- 获取拜访名将配置ItemData
function OperatingActivitiesModel:getVisiGeneralConfigItemDataById(id)
	return self.configList[qy.tank.view.type.ModuleType.VISIT_GENERAL][tostring(id)]
end

--获取剩余时间
function OperatingActivitiesModel:getVisitGeneralLeftTime()
	local endTime = self.activityList.visit_general.uptime
	local time = endTime - qy.tank.model.UserInfoModel.serverTime
	return time
end

-- 获取拜访名将配置ItemData
function OperatingActivitiesModel:getVisitGeneralConfigItemDataById(id)
	return self.configList[qy.tank.view.type.ModuleType.VISIT_GENERAL][tostring(id)]
end

function OperatingActivitiesModel:updateVisitGeneralData(data)
	local ModuleType = qy.tank.view.type.ModuleType
	self.listData[ModuleType.VISIT_GENERAL] = data.activity_info.extends_data
end

----------------------------------------------------------------------------------------------------------------
--------------------------------------总部支援--------------------------------------------------------------------------
function OperatingActivitiesModel:updateHeadquartersData(data)
	local ModuleType = qy.tank.view.type.ModuleType
	self.listData[ModuleType.HEADQUATER_SUPPORT] = data.activity_info.extends_data
	self.configList[ModuleType.HEADQUATER_SUPPORT] = data.activity_info.showlist
	self.activityList[ModuleType.HEADQUATER_SUPPORT].uptime = data.activity_info.uptime
end

--获取剩余时间
function OperatingActivitiesModel:getHeadquartersLeftTime()
	local ModuleType = qy.tank.view.type.ModuleType
	local endTime = self.activityList[ModuleType.HEADQUATER_SUPPORT].uptime
	local time = endTime - qy.tank.model.UserInfoModel.serverTime
	return time
end

function OperatingActivitiesModel:getHeadquartersShowList( )
	return self.configList[qy.tank.view.type.ModuleType.HEADQUATER_SUPPORT]
end

function OperatingActivitiesModel:update( data )
	local ModuleType = qy.tank.view.type.ModuleType
	self.listData[ModuleType.HEADQUATER_SUPPORT] = data.activity_info.extends_data
	self.configList[ModuleType.HEADQUATER_SUPPORT] = data.activity_info.showlist
	self.activityList[ModuleType.HEADQUATER_SUPPORT] = data.activity_info
end
----------------------------------------------------------------------------------------------------------------

-----------------------------------开服礼包-------------------------------------------------------------------

--排序，已领取的放后面
function OperatingActivitiesModel:__sortForServerGift()
	local name = qy.tank.view.type.ModuleType.OPEN_SERVER_GIFT_BAG
	self.serverGiftDayIndex = {}
	local _hasReceiveDay = {}
	for i = 1, #self.listData[name] do
		if self.listData[name][i] < 2 then
			table.insert(self.serverGiftDayIndex, i)
		else
			table.insert(_hasReceiveDay, i)
		end
	end

	for i = 1, #_hasReceiveDay do
		table.insert(self.serverGiftDayIndex, i)
	end
end

function OperatingActivitiesModel:getNumOfServerGift()
	return #self.serverGiftDayIndex
end

function OperatingActivitiesModel:getDayByIndexOfSeverGift(_idx)
	return self.serverGiftDayIndex[_idx]
end

function OperatingActivitiesModel:getAwardByIndexOfSeverGift(_idx)
	local _day = self.serverGiftDayIndex[_idx]
	local name = qy.tank.view.type.ModuleType.OPEN_SERVER_GIFT_BAG
	if self.configList[name] and self.configList[name][tostring(_day)] then
		return self.configList[name][tostring(_day)].award
	else
		return {}
	end
end

function OperatingActivitiesModel:getCurrentStatusByDayOfServerGift(_day)
	local name = qy.tank.view.type.ModuleType.OPEN_SERVER_GIFT_BAG
	return self.listData[name][_day]
end

function OperatingActivitiesModel:updateServerGiftStatus(data)
	self.listData[qy.tank.view.type.ModuleType.OPEN_SERVER_GIFT_BAG] = data.activity_info.extends_data
end
----------------------------------------------------------------------------------------------------------------

-----------------------------------战争动员-------------------------------------------------------------------
function OperatingActivitiesModel:getRemainTimeOfArnyAssault()
	local ModuleType = qy.tank.view.type.ModuleType
	local endTime = self.activityList[ModuleType.ARNY_ASSAULT].uptime
	local remainTime = endTime - qy.tank.model.UserInfoModel.serverTime
	-- print("endTime == ".. endTime)
	-- print("serverTime == ".. qy.tank.model.UserInfoModel.serverTime)
	-- print("remainTime == ".. remainTime/60/60/24)
	if remainTime > 0 then
		return qy.tank.utils.NumberUtil.secondsToTimeStr(remainTime, 5)
	else
		return qy.TextUtil:substitute(63028)
	end
end

function OperatingActivitiesModel:updateArnyAssauktGiftCrit(num)
	self.critMultiple = num
end

function OperatingActivitiesModel:getCritMultiple()
	if self.critMultiple then
		return self.critMultiple
	else
		return 0
	end
end

function OperatingActivitiesModel:getRewardDataOfArnyAssault()
	local name = qy.tank.view.type.ModuleType.ARNY_ASSAULT
	return self.configList[name]
end

function OperatingActivitiesModel:getGiftNumOfArnyAssault()
	local name = qy.tank.view.type.ModuleType.ARNY_ASSAULT
	return self.activityList[name].giftnum
end

function OperatingActivitiesModel:getListNumOfArnyAssault()
	local name = qy.tank.view.type.ModuleType.ARNY_ASSAULT
	return #self.listData[name]
end

function OperatingActivitiesModel:getListDataByIndexOfArnyAssault(index)
	local _data = {}
	local name = qy.tank.view.type.ModuleType.ARNY_ASSAULT
	_data.name = self.listData[name][index].nickname
	_data.times = self.listData[name][index].times .. qy.TextUtil:substitute(62010)
	_data.earnings = qy.TextUtil:substitute(63029) ..  (self.listData[name][index].earnings * 100) .. qy.TextUtil:substitute(63030)
	return _data
end

function OperatingActivitiesModel:getMyEarningsStr()
	local name = qy.tank.view.type.ModuleType.ARNY_ASSAULT
	return qy.TextUtil:substitute(63031) .. " "..self.activityList[name].times.." " .. qy.TextUtil:substitute(63032) .. " " ..(self.activityList[name].my_earnings * 100) .. qy.TextUtil:substitute(63030)
end

--[[--
--UI中补给列表的数量
--]]
function OperatingActivitiesModel:getSupplyViewNum()
	return 10
end

function OperatingActivitiesModel:getEarningsPercent()
	local name = qy.tank.view.type.ModuleType.ARNY_ASSAULT
	local _data = self.configList[name]
	local supplyList = {}
	for i = 1, self:getSupplyViewNum() do
		if i <= #_data then
			for _k, _v in pairs(_data[i]) do
				table.insert(supplyList, tonumber(_k))
			end
		end
	end

	local times = self.activityList[name].times
	local percent = 0
	--补给次数超过最大的高度
	if times >= supplyList[#supplyList] then
		return 100
	end

	--补给次数没超过第一格的高度
	if times <= supplyList[1] then
		return times / supplyList[1] * 10
	end

	for i = 1, self:getSupplyViewNum() do
		if i <= #supplyList then
			if times <= supplyList[i] then
				percent = (times - supplyList[i - 1]) /(supplyList[i] - supplyList[i - 1]) * 10 + (i - 1) * 10
				return percent
			end
		end
	end
	return percent
end

function OperatingActivitiesModel:updateArnyAssauktGiftStatus(num)
	if num then
		local name = qy.tank.view.type.ModuleType.ARNY_ASSAULT
		self.activityList[name].giftnum = num
	else
		self.activityList[name].giftnum = 0
	end
end

----------------------------------------------------------------------------------------------------------------

--------------首充---------------------------------------------------
function OperatingActivitiesModel:getFirstPayData()
	return self.activityList[_ModuleType.FIRST_PAY]
end

function OperatingActivitiesModel:hasFirstPayData()
	-- if self.mainViewList == nil then
		-- return false
	-- end
	-- for i = 1, #self.mainViewList do
	-- 	for _k, _v in pairs(self.mainViewList[i]) do
	-- 		if _ModuleType.FIRST_PAY == _k then
	-- 			return true
	-- 		end
	-- 	end
	-- end
	return self.mainViewList[_ModuleType.FIRST_PAY] and true or false
end

-------------------------------------------------------------------------
------------充值返利------------------------------------------------------

function OperatingActivitiesModel:initToTalPayData()
	local data = self.activityList[qy.tank.view.type.ModuleType.TOTAL_PAY]
	self.totalPayData = {}
	local hasReData = {}
	self.cash = data.cash or 0 --现在充了多少
	self.uptime = data.uptime
	self.lessCash = 0 --差多少到下一级领奖
	local extends_data = data.extends_data or {}
	local _cash = 0

	local function __isReceive()
		for j = 1, #extends_data do
			if extends_data[j] == _cash then
				return true
			end
		end
		return false
	end

	if data and data.award then
		for i = 1, #data.award do
			_cash = data.award[i].cash
			if self.cash >= _cash then
				if __isReceive() then
					--已领取
					data.award[i].status = 2
					table.insert(hasReData, data.award[i])
				else
					--可领取
					data.award[i].status = 1
					table.insert(self.totalPayData, data.award[i])
				end
			else
				--不可领取
				data.award[i].status = 0
				table.insert(self.totalPayData, data.award[i])
				if self.lessCash <= 0 then
					self.lessCash = data.award[i].cash - self.cash
				end
			end
		end
	end

	for i = 1, #hasReData do
		table.insert(self.totalPayData, hasReData[i])
	end
end

function OperatingActivitiesModel:updatePayDataStatusByIdx(_idx)
	if self.totalPayData[_idx] then
		self.totalPayData[_idx].status = 2
	end
end

function OperatingActivitiesModel:getToTalPayAwardByIndex(_idx)
	return self.totalPayData[_idx]
end

function OperatingActivitiesModel:getTotalPayAwardNum()
	return #self.totalPayData
end

function OperatingActivitiesModel:getRechargeNum()
	return self.cash
end

function OperatingActivitiesModel:getLessCash()
	return self.lessCash
end

function OperatingActivitiesModel:getTotalPayRemainTime()
	local time = self.uptime - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end

------------累充返利第二版------------------------------------------------------

function OperatingActivitiesModel:initPayRebateData()
	local data = self.activityList[_ModuleType.PAY_REBATE]
	self.payRebateData = {}
	local hasReData = {}
	self.re_cash = data.cash or 0 --现在充了多少
	self.uptime = data.uptime
	self.re_less_cash = 0 --差多少到下一级领奖
	local extends_data = data.extends_data or {}
	local _cash = 0

	local function __isReceive()
		for j = 1, #extends_data do
			if extends_data[j] == _cash then
				return true
			end
		end
		return false
	end

	if data and data.award then
		for i = 1, #data.award do
			_cash = data.award[i].cash
			if self.re_cash >= _cash then
				if __isReceive() then
					--已领取
					data.award[i].status = 2
					table.insert(hasReData, data.award[i])
				else
					--可领取
					data.award[i].status = 1
					table.insert(self.payRebateData, data.award[i])
				end
			else
				--不可领取
				data.award[i].status = 0
				table.insert(self.payRebateData, data.award[i])
				if self.re_less_cash <= 0 then
					self.re_less_cash = data.award[i].cash - self.re_cash
				end
			end
		end
	end

	for i = 1, #hasReData do
		table.insert(self.payRebateData, hasReData[i])
	end
end

function OperatingActivitiesModel:upRebateDataStaByIdx(_idx)
	if self.payRebateData[_idx] then
		self.payRebateData[_idx].status = 2
	end
end

function OperatingActivitiesModel:getPayRebateAwardByIndex(_idx)
	return self.payRebateData[_idx]
end

function OperatingActivitiesModel:getPayRebateAwardNum()
	return #self.payRebateData
end

function OperatingActivitiesModel:getRebateRechargeNum()
	return self.re_cash
end

function OperatingActivitiesModel:getRebateLessCash()
	return self.re_less_cash
end

function OperatingActivitiesModel:getPayRebateRemainTime()
	local time = self.uptime - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end



------------累充返利第三版------------------------------------------------------

function OperatingActivitiesModel:initPayRebateVipData()
	local data = self.activityList[_ModuleType.PAY_REBATE_VIP]
	self.payRebateVipData = {}
	local hasReData = {}
	self.rev_cash = data.cash or 0 --现在充了多少
	self.vip_uptime = data.uptime
	self.rev_less_cash = 0 --差多少到下一级领奖
	local extends_data = data.extends_data or {}
	local _cash = 0

	local function __isReceive()
		for j = 1, #extends_data do
			if extends_data[j] == _cash then
				return true
			end
		end
		return false
	end

	if data and data.award then
		for k,v in pairs(qy.Config.vip_price) do
		    local data2 = v["amount"]
		    local min_data = 0
		    for i = 1, #data.award do
				_cash = data.award[i].cash
		        if _cash >= data2 and (_cash < min_data or min_data == 0) then
		        	min_data = _cash
		            data.award[i].vip_lv = k
		        end
		    end
		end

		for i = 1, #data.award do
			_cash = data.award[i].cash
			if self.rev_cash >= _cash then
				if __isReceive() then
					--已领取
					data.award[i].status = 2
					table.insert(hasReData, data.award[i])
				else
					--可领取
					data.award[i].status = 1
					table.insert(self.payRebateVipData, data.award[i])
				end
			else
				--不可领取
				data.award[i].status = 0
				table.insert(self.payRebateVipData, data.award[i])
				if self.rev_less_cash <= 0 then
					self.rev_less_cash = data.award[i].cash - self.rev_cash
				end
			end
		end
	end

	for i = 1, #hasReData do
		table.insert(self.payRebateVipData, hasReData[i])
	end
end

function OperatingActivitiesModel:upRebateDataVipStaByIdx(_idx)
	if self.payRebateVipData[_idx] then
		self.payRebateVipData[_idx].status = 2
	end
end

function OperatingActivitiesModel:getPayRebateVipAwardByIndex(_idx)
	return self.payRebateVipData[_idx]
end

function OperatingActivitiesModel:getPayRebateVipAwardNum()
	return #self.payRebateVipData
end

function OperatingActivitiesModel:getRebateVipRechargeNum()
	return self.rev_cash
end

function OperatingActivitiesModel:getRebateVipLessCash()
	return self.rev_less_cash
end

function OperatingActivitiesModel:getPayRebateVipRemainTime()
	local time = self.vip_uptime - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end

-------------------------------------------------------------------------
-- 成长基金

OperatingActivitiesModel.fundList_ = {}
OperatingActivitiesModel.fundList = {}
function OperatingActivitiesModel:initFund(extend)
	-- self.fundList = {}
	local data = qy.Config.up_fund

	for i, v in pairs(data) do
		if not self.fundList_[tostring(v.level)] then
			local entity = qy.tank.entity.UpFundEntity.new(v)
			self.fundList_[tostring(entity.level)] = entity
			table.insert(self.fundList, entity)
		-- else
		-- 	self.fundList_[tostring(entity.level)]:upData(v)
		end
		if self.listData.up_fund and self.listData.up_fund[tostring(v.level)] then
			self.fundList_[tostring(v.level)].status = 1
		end
	end

	if not extend or extend ~= 1 then
		self.fundList = {}

		for i, v in pairs(self.fundList_) do
			table.insert(self.fundList, v)
		end

		table.sort(self.fundList, function(a, b)
			return a.level < b.level
		end)
		self:sortFund()
	end
end

function OperatingActivitiesModel:updateFund(data)
	if data.up_fund and data.up_fund.is_have_buy == 1 then
		self.is_have_buy = true
	end

	if data.up_fund and data.up_fund.extends_data then
		self.listData.up_fund = data.up_fund.extends_data
	end

	self:initFund() -- 重新初始化列表
end

function OperatingActivitiesModel:sortFund()
	local temp = {}
	local temp2 = {} -- 已领取
	for i, v in pairs(self.fundList) do
		if v.status == 1 then
			table.insert(temp2, v)
		else
			table.insert(temp, v)
		end
	end
	for i, v in pairs(temp2) do
		table.insert(temp, v)
	end

	self.fundList = temp
end

function OperatingActivitiesModel:atFund(idx)
	return self.fundList[idx + 1]
end

--------------------------------------------------------------
-- 月卡
--  1 未购买 2 未领取 3 已领取 4 终身月卡

function OperatingActivitiesModel:monthCardInit(data)
	self.monthCardRewardList = {}
	self.monthCardStatus1 = self.activityList["month_card"]["1"].status
	self.monthCardStatus2 = self.activityList["month_card"]["2"].status
	self.monthCardDays1 = self.activityList["month_card"]["1"].count_down_day
	self.monthCardDays2 = self.activityList["month_card"]["2"].count_down_day

	for i, v in pairs(qy.Config.month_card) do
		for q, p in pairs(v.award) do
			if not self.monthCardRewardList[tostring(i)] then
				self.monthCardRewardList[tostring(i)] = {}
				local item = qy.tank.view.common.AwardItem.getItemData(p)
				table.insert(self.monthCardRewardList[tostring(i)], item)
			else
				local item = qy.tank.view.common.AwardItem.getItemData(p)
				table.insert(self.monthCardRewardList[tostring(i)], item)
			end
		end
	end
end

-- 获取奖励显示
function OperatingActivitiesModel:atMonthCardAward(idx)
	return self.monthCardRewardList[tostring(idx)]
	-- return (self["monthCardStatus" .. idx] ~= 4 and self["monthCardStatus" .. idx] ~= 5) and self.monthCardRewardList[tostring(idx)] or {}
end

-- 获取钻石数据
function OperatingActivitiesModel:atMonthCardDiamond(idx)
	local num = qy.Config.month_card[tostring(idx)].diamond
	return qy.tank.view.common.AwardItem.getItemData({["type"] = 1, ["num"] = num})
end

-- 获取状态
--  1 未购买 2 未领取 3 已领取 4 终身月卡
function OperatingActivitiesModel:atMonthCardStatus(idx)
	return self["monthCardStatus" .. idx]
end
-----------------黑市商人------------------------------------------

function OperatingActivitiesModel:getCellInfoByIndex(_index)
	local name = _ModuleType.MARKET
	return self.activityList[name]["list"][_index .. ""]
end

function OperatingActivitiesModel:updateMarkData(data)
	local name = _ModuleType.MARKET
	for _k, _v in pairs(data) do
		self.activityList[name]["list"][_k] = _v
	end
end

function OperatingActivitiesModel:getFreeRefreshTimes()
	local free_times = self.activityList[_ModuleType.MARKET].ftimes
	print("free_times ==", free_times )
	if free_times then
		return free_times
	else
		return 0
	end
end

function OperatingActivitiesModel:getTickVisible()
	local viArr = {}
	--本地缓存
	for i = 1, 3 do
		local _str = cc.UserDefault:getInstance():getStringForKey(userinfoModel.userInfoEntity.kid .."_maket_t_"..i)
		if _str == "1" then
			viArr[i] = true
		elseif _str == "0" then
			viArr[i] = false
		end
		print("viArr==["..i.."]===>>>>>", viArr[i])
	end
	if viArr[1] ~= nil then
		return viArr
 	end
	--如果没有本地缓存，则用服务器的
	local arr = {}
	viArr = {true,true,true}
	if self.activityList[_ModuleType.MARKET] and self.activityList[_ModuleType.MARKET].position then
		local pos = self.activityList[_ModuleType.MARKET].position
		arr = qy.tank.utils.String.split(pos, "-")
	else
		return {false,false,false}
	end
	for _k,_v in pairs(arr) do
		if _v == "" then
			return {true,true,true}
		end
		viArr[tonumber(_v)] = false
	end

	return viArr
end

function OperatingActivitiesModel:updateFreeRefreshTimes(data)
	if self.activityList[_ModuleType.MARKET] == nil then
		self.activityList[_ModuleType.MARKET] = {}
	end
	self.activityList[_ModuleType.MARKET].ftimes = data.ftimes
end

function OperatingActivitiesModel:getMarketPayRemainTime()
	local endTime = self.activityList[_ModuleType.MARKET].uptime
	local time = endTime - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return "00:00:00"
	end
end

function OperatingActivitiesModel:getColorByDis(_dis)
	if _dis == 0.85 then
		return _ColorMapUtil.qualityMapColor(2)
	elseif _dis == 0.8 then
		return _ColorMapUtil.qualityMapColor(3)
	elseif _dis == 0.75 then
		return _ColorMapUtil.qualityMapColor(4)
	elseif _dis == 0.7 then
		return _ColorMapUtil.qualityMapColor(5)
	else
		return _ColorMapUtil.qualityMapColor(1)
	end
end

-------------------------------------------------------------
-- 酒馆
function OperatingActivitiesModel:pubInit()
	local static = qy.Config.pub
	local data = self.activityList["jiuguan"]

	self.pubListPosition = {
	    ["1"] = cc.p(-84, 225),
	    ["2"] = cc.p(27, 225),
	    ["3"] = cc.p(138, 225),
	    ["4"] = cc.p(249, 225),
	    ["5"] = cc.p(249, 113),
	    ["6"] = cc.p(249, 1),
	    ["7"] = cc.p(249, -111),
	    ["8"] = cc.p(138, -111),
	    ["9"] = cc.p(27, -111),
	    ["10"] = cc.p(-84, -111),
	    ["11"] = cc.p(-84, 1),
	    ["12"] = cc.p(-84, 113)
	}

   	self.pubAwardList = {}
   	self.pubAwardList_ = {}
   	self.pubSpecialTimes = data.special_times
   	self.pubFreeTimes = data.free_times
   	self.pubRank = data.rank
   	self.pubType = data.special_times == 0 and 2 or 1
   	self.pubServerTime = data.server_time
   	self.pubUpTime = data.uptime
   	self.pubLevelTime = self.pubUpTime - self.pubServerTime
   	self.pubTotalTimes = data.total_times or 0

   	self.pubAchieveList = {}

   	for i, v in pairs(static) do
        local entity = qy.tank.entity.PubEntity.new(v)
        if not self.pubAwardList[tostring(v.type)] then
            self.pubAwardList[tostring(v.type)] = {}
            table.insert(self.pubAwardList[tostring(v.type)], entity)
        else

            table.insert(self.pubAwardList[tostring(v.type)], entity)
        end
        self.pubAwardList_[tostring(v.id)] = entity
   	end

   	table.sort(self.pubAwardList[tostring(1)], function(a, b)
        return a.id < b.id
    end)
   	table.sort(self.pubAwardList[tostring(2)], function(a, b)
        return a.id < b.id
    end)


    -- 干杯成就
    self.pubAchieveGetList = table.keys(self.listData["jiuguan"] or {}) or {}

    for i, v in pairs(qy.Config.pub_achieve) do
    	local entity = qy.tank.entity.PubAchieveEntity.new(v)
    	table.insert(self.pubAchieveList, entity)

    	if table.keyof(self.pubAchieveGetList, tostring(entity.times)) then
    		entity.status = 2
    	else
    		if entity.times <= self.pubTotalTimes then
    			entity.status = 1
    		else
    			entity.status = 0
    		end
    	end
    end

    table.sort(self.pubAchieveList, function(a, b)
    	return a.times < b.times
    end)
end

-- 获取数据
function OperatingActivitiesModel:pubAtType(idx)
    return self.pubAwardList[tostring(self.pubType)][tonumber(idx)]
end

--
function OperatingActivitiesModel:pubAtById(id)
    return self.pubAwardList_[tostring(id)]
end

-- 获取序列号
function OperatingActivitiesModel:pubGetIdx()
    local entity = self:pubAtById(self.pubKey)
    return table.keyof(self.pubAwardList[tostring(self.oldPubType)], entity)
end

-- 获取排序
function OperatingActivitiesModel:getRank()
	return self.pubRank
end

-- 获取成就
function OperatingActivitiesModel:pubAtAchieveId(idx)
	return self.pubAchieveList[idx + 1]
end

function OperatingActivitiesModel:testPubAwardRedPoint()
	for i, v in pairs(self.pubAchieveList) do
		if v.status == 1 then
			return true
		end
	end
	return false
end

-- 获取奖励
function OperatingActivitiesModel:updatePub(data)
	self.pubSpecialTimes = data.special_times
	self.oldPubType = self.pubType
	self.pubType = data.special_times == 0 and 2 or 1
	self.pubFreeTimes = data.free_times
	self.pubRank = data.rank
	self.pubKey = data.key
	self.pubAward = data.award
	self.pubServerTime = data.server_time
	self.pubLevelTime = self.pubUpTime - self.pubServerTime

	self.pubTotalTimes = data.total_times or 0

	for i, entity in pairs(self.pubAchieveList) do
    	if table.keyof(self.pubAchieveGetList, tostring(entity.times)) then
    		entity.status = 2
    	else
    		if entity.times <= self.pubTotalTimes then
    			entity.status = 1
    		else
    			entity.status = 0
    		end
    	end
    end
end

function OperatingActivitiesModel:getMyRank()
	for i, v in pairs(self.pubRank) do
		if v.kid == qy.tank.model.UserInfoModel.userInfoEntity.kid then
			return i
		end
	end
end

----------------------------------------------国庆快乐
function OperatingActivitiesModel:initHappyNational(  )
	self.happy_nationallist = qy.Config.noface
	local data = self.activityList["happy_festival"]
	self.nationaldaystatus = data.state
end

---------------------------------------------- 充值红利

function OperatingActivitiesModel:initBonus()
	local staticData = qy.Config.recharge_bonus
	local data = self.activityList["recharge_bonus"]
	self.bonusEndTime = data.end_time
	self.bonusBeginTime = data.start_time
	self.bonusDay = data.day
	self.bonusBuyList = data.buy_list

	self.bonusList = {}

	for i = 1, 6 do
		local item = qy.tank.entity.RechargeBonusEntity.new(staticData[tostring(i)], i)
		if table.keyof(self.bonusBuyList, i) then
			item.idx = i + 7
		end

		table.insert(self.bonusList, item)
	end

	table.sort(self.bonusList, function(a, b)
		return a.idx < b.idx
	end)

	local item = qy.tank.entity.RechargeBonusEntity.new(staticData[tostring(7)], 7)
	if table.keyof(self.bonusBuyList, i) then
		item.idx = i + 7
	end
	table.insert(self.bonusList, 1, item)
end

----------------------------------------------------  精铁矿脉
function OperatingActivitiesModel:initIronMine()
	local staticData = qy.Config.iron_mine_double
	local data = self.activityList["iron_mine"]

	self.ironMineType = data.type
	self.ironMineNum = data.num
	self.ironMineStatus = data.status
	self.oldIronMineTimes = self.ironMineTimes
	self.ironMineTimes = data.times
	self.ironMinePrice = data.price or 0
	self.ironMineSuccess = data.is_success
	if data.end_time then
		self.ironMineEndtime = data.end_time
	end

	self.ironMineData = data
end

------------------------------------------------------- 招财猫
function OperatingActivitiesModel:initLuckyCat()
	local data = self.activityList["lucky_cat"]
	self.luckyEndTime = data.end_time
	self.luckyStartTime = data.start_time
	self.vipLevel = data.vip_level
	self.luckyCatTimes = data.times
	self.luckyCatLog = data.log
end

----集结号-----
function OperatingActivitiesModel:getAssemblyInfo()
	return self.activityList[_ModuleType.ASSEMBLY]
end

function OperatingActivitiesModel:updateAssembly(data)
	self.activityList[_ModuleType.ASSEMBLY] = data
end

function OperatingActivitiesModel:getAssOtherAward()
	local index = tostring(self.activityList[_ModuleType.ASSEMBLY].id)
	local data = qy.Config.assembly_award
	local num = math.random(userinfoModel.serverTime) % 6 + 1
	local awardArr = {}
	local _k = ""
	local _order = 1
	local _max = num + 5
	for i = num, _max do
		if tostring(i%6+1) ~= index then
			awardArr[_order] = data[tostring(i%6+1)].award
			_order = _order + 1
		end
	end
	return awardArr
end

--------------------------------------------------------------- 春节特供
function OperatingActivitiesModel:initNewYearSupply()
	local data = self.activityList["spring_festival"]

	self.newYearSupplyEndTime = data.end_time

	self.newYearSupplyRecharge = data.recharge_list
	self.newYearSupplyAwardList = data.award_list

	self.newYearSupplyList = {}

	for i, v in pairs(qy.Config.spring_festival) do
		local entity = qy.tank.entity.NewYearSupplyEntity.new(v)
		table.insert(self.newYearSupplyList, entity)

		if table.keyof(self.newYearSupplyRecharge, entity.product_id) then
			if table.keyof(self.newYearSupplyAwardList, entity.product_id) then
				entity.status = 3
			else
				entity.status = 2
			end
		else
			entity.status = 1
		end
	end

	self:newYearSupplySort()
end

function OperatingActivitiesModel:getNewYearSupplyStaticData(key)
	return qy.Config.spring_festival[key]
end

function OperatingActivitiesModel:atNewYearSupply(idx)
	return self.newYearSupplyList[idx]
end

function OperatingActivitiesModel:newYearSupplySort()
	table.sort(self.newYearSupplyList, function(a, b)
		return a.idx < b.idx
	end)
end

-- 索引 (优先找可以领取的，如果没有找到则找可以充值的，如果都没有，直接跳到 1)
function OperatingActivitiesModel:getNewYearSupplyIdx()
	local idx = 1
	local flag = false -- 是否已找到

	for i, v in pairs(self.newYearSupplyList) do
		if v.status == 2 then
			flag = true
			idx = i
			break
		end
	end

	if not flag then
		for i, v in pairs(self.newYearSupplyList) do
			if v.status == 1 then
				flag = true
				idx = i
				break
			end
		end
	end

	return idx
end

---猴年吉祥----
function OperatingActivitiesModel:initSpringGiftArr()
	local ser_data = self.activityList[_ModuleType.SPR_GIT]

	local function __find(_date)
		if ser_data.award_list then
			for i = 1, #ser_data.award_list do
				if tonumber(ser_data.award_list[i]) == tonumber(_date) then
					return true
				end
			end
			return false
		else
			return false
		end
	end

	local co_data = qy.Config.spring_gift
	self.springGiftArr = {}
	for _k,_v in pairs(co_data) do
		-- status:0:可领 1:未可领 2:已领
		if tonumber(ser_data.today) >= tonumber(_v.id) then
			--已到日期
			if __find(_k) then
				--已领
				_v.status = 2
			else
				--未领
				_v.status = 0
			end
		else
			--未到日期 不可领
			_v.status = 1
		end
		self.springGiftArr[_v.sort] = _v
	end
	table.sort(self.springGiftArr,function(a,b)
		if a.status == b.status then
			return a.id < b.id
		else
			return a.status < b.status
		end
	end)
end

function OperatingActivitiesModel:getSpriGiftNum()
	return #self.springGiftArr
end

function OperatingActivitiesModel:getSpriGiftByIndex(_idx)
	return self.springGiftArr[_idx]
end

------------------------------------------------------------ 元首的宝藏
function OperatingActivitiesModel:initHeadTreasure()
	local data = self.activityList["head_treasure"]
	self.headTreasureList = {}

	self.headTreasureEndTime = data.end_time
	self.headTreasureTimes = data.left_times
	self.headTreasureDiamond = data.diamond

	local staticData = qy.Config.head_treasure
	for i, v in pairs(staticData) do
		if not self.headTreasureList[tostring(v.type)] then
			self.headTreasureList[tostring(v.type)] = {}
			table.insert(self.headTreasureList[tostring(v.type)], v)
		else
			table.insert(self.headTreasureList[tostring(v.type)], v)
		end
	end
end

function OperatingActivitiesModel:updateHeadTreasure(data)
	self.headTreasureEndTime = data.end_time
	self.headTreasureTimes = data.left_times
	self.headTreasureDiamond = data.diamond
end

---------------------------------------------------------------- 充值达人
function OperatingActivitiesModel:initRechargeDoyen()
	local data = self.activityList["recharge_doyen"]
	self.recahrgeDoyenBeginTime = data.start_time
	self.rechargeDoyenEndTime = data.end_time

	self.rechargeDoyenAwardEndTime = data.award_end_time
	self.rechargeDoyenAwardBeginTime = data.award_start_time

	self.rechargeDoyenAmount = data.amount
	self.rechargeMyRank = data.my_rank
	self.rechargeDoyendDrawAward = data.is_draw_award
	self.rechargeDoyenRankList = data.rank_list

	table.sort(self.rechargeDoyenRankList, function(a, b)
		return a.rank < b.rank
	end)


	self.rechargeDoyenList = {}

	local staticData = qy.Config.recharge_doyen
	for i, v in pairs(staticData) do
		local entity = qy.tank.entity.RechargeDoyenEntity.new(v)

		table.insert(self.rechargeDoyenList, entity)
	end

	table.sort(self.rechargeDoyenList, function(a, b)
		return a.rank < b.rank
	end)
end

function OperatingActivitiesModel:updateRechargeDoyen(data)
	self.recahrgeDoyenBeginTime = data.start_time
	self.rechargeDoyenEndTime = data.end_time

	self.rechargeDoyenAwardEndTime = data.award_end_time
	self.rechargeDoyenAwardBeginTime = data.award_start_time

	self.rechargeDoyenAmount = data.amount
	self.rechargeMyRank = data.my_rank
	self.rechargeDoyendDrawAward = data.is_draw_award
	self.rechargeDoyenRankList = data.rank_list

	table.sort(self.rechargeDoyenRankList, function(a, b)
		return a.rank < b.rank
	end)
end

---------------------------------------------------------------- 充值之王
function OperatingActivitiesModel:initRechargeKing()
	local data = self.activityList["recharge_king"]
	self.recahrgeKingBeginTime = data.start_time
	self.rechargeKingEndTime = data.end_time

	self.rechargeKingAwardEndTime = data.award_end_time
	self.rechargeKingAwardBeginTime = data.award_start_time

	self.rechargeKingAmount = data.amount
	self.rechargeMyRank = data.my_rank
	self.rechargeKingDrawAward = data.is_draw_award
	self.rechargeKingRankList = data.rank_list

	table.sort(self.rechargeKingRankList, function(a, b)
		return a.rank < b.rank
	end)


	self.rechargeKingList = {}

	local staticData = qy.Config.recharge_king
	for i, v in pairs(staticData) do
		local entity = qy.tank.entity.RechargeDoyenEntity.new(v)

		table.insert(self.rechargeKingList, entity)
	end

	table.sort(self.rechargeKingList, function(a, b)
		return a.rank < b.rank
	end)
end

function OperatingActivitiesModel:updateRechargeKing(data)
	self.recahrgeKingBeginTime = data.start_time
	self.rechargeKingEndTime = data.end_time

	self.rechargeKingAwardEndTime = data.award_end_time
	self.rechargeKingAwardBeginTime = data.award_start_time

	self.rechargeKingAmount = data.amount
	self.rechargeMyRank = data.my_rank
	self.rechargeKingDrawAward = data.is_draw_award
	self.rechargeKingRankList = data.rank_list

	table.sort(self.rechargeKingRankList, function(a, b)
		return a.rank < b.rank
	end)
end
---------------------------------------------------------------- 区间充值
function OperatingActivitiesModel:initRechargeSection()
	local data = self.activityList["recharge_section"]
	self.recahrgesecyionBeginTime = data.start_time
	self.recahrgesecyionEndTime = data.end_time
	self.rechargecash = data.cash
	self.get_award_log = data.get_award_log

	self.rechargesetionList = {}

	local staticData = qy.Config.recharge_section
	for i, v in pairs(staticData) do
		if tonumber(self.rechargecash) >= tonumber(v.cash) then
			local status = self:getCashstatusBycash(tonumber(v.cash))
			v.status = status
		else
			v.status = 0
		end
		table.insert(self.rechargesetionList, v)
	end

	table.sort(self.rechargesetionList, function(a, b)
		return a.cash < b.cash
	end)
end
function OperatingActivitiesModel:getCashstatusBycash( cash )
	local status = 1
	for k,v in pairs(self.get_award_log) do
		if tonumber(v) == cash then
			status = -1
		end
	end
	return status
end

function OperatingActivitiesModel:getRechargeSectionLessCash()
	local cash = -1
	local totalnum = #self.rechargesetionList
	for k,v in pairs(self.rechargesetionList) do
		local num = v.cash - self.rechargecash
		if num > 0 then
			return num
		end
	end
	return cash
end

------------------------------------------------------------- 大地英魂
function OperatingActivitiesModel:initEarthSoul()
	local data = self.activityList["earth_soul"]
	self.earthSoulStartTime = data.start_time
	self.earthSoulEndTime = data.end_time
	self.earthSoulLeftTimes = data.left_free_times
	self.earthSoulRanklist = data.rank.rank_list
	self.earthSoulMyRank = data.rank.my_rank or qy.TextUtil:substitute(62006)
	self.earthSoulAchieveAward = data.achieve_award
	self.earthSoulTotalTimes = data.total_times
	table.sort(self.earthSoulRanklist, function(a, b)
		return a.rank < b.rank
	end)
end

function OperatingActivitiesModel:updateEarthSoul(data)
	self.earthSoulLeftTimes = data.left_free_times
	self.earthSoulRanklist = data.rank.rank_list
	self.earthSoulMyRank = data.rank.my_rank
	self.earthSoulStartTime = data.start_time
	self.earthSoulEndTime = data.end_time
	self.earthSoulTotalTimes = data.total_times
	self.earthSoulAchieveAward = data.achieve_award
	table.sort(self.earthSoulRanklist, function(a, b)
		return a.rank < b.rank
	end)
end

---------------------------------------------- 全民充值

function OperatingActivitiesModel:initAllRecharge()
	local staticData = qy.Config.all_recharge
	local data = self.activityList["all_recharge"]
	self.AllRechargeEndTime = data.end_time
	self.AllRechargeBeginTime = data.start_time
	self.nums = data.num
	self.award_list = data.award_list
	self.amount = data.amount
	self.realNum = data.realNum

	self.allRechargeList = {}

	for i = 1, table.nums(staticData) do
		local item = qy.tank.entity.AllRechargeEntity.new(staticData[tostring(i)])
		table.insert(self.allRechargeList, item)
	end

	table.sort(self.allRechargeList, function(a, b)
		return a.id < b.id
	end)
end
function OperatingActivitiesModel:updateAllRecharge(data)
	self.award_list = data.award_list
	self.amount = data.amount
end

---------------------------------------------- 精英招募

function OperatingActivitiesModel:initOutStanding()
	local staticData = qy.Config.mid_autumn
	local data = self.activityList["mid_autumn"]
	self.outStandingData = data
	
	self.outStandingList = {}
	for i = 1, table.nums(staticData) do
		local item = qy.tank.entity.OutStandingEntity.new(staticData[tostring(i)],self.outStandingData)
		table.insert(self.outStandingList, item)
	end

	table.sort(self.outStandingList, function(a, b)
		if a.index == b.index then
	    	return a.id < b.id
	   	end
	   	return a.index < b.index
	end)
end
function OperatingActivitiesModel:updateOutStanding(data)
	self.outStandingData = data
end

---------------------------------------------- 探宝日记

function OperatingActivitiesModel:initSearchTreasure()
	local rankCfg = qy.Config.search_treasure_rank
	local treasureCfg = qy.Config.search_treasure
	local timesCfg = qy.Config.search_treasure_times

	self.rankAwardList = {}
	for i = 1, table.nums(rankCfg) do
		local item = qy.tank.entity.SearchTreasureEntity.new(rankCfg[tostring(i)])
		table.insert(self.rankAwardList, item)
	end
	table.sort(self.rankAwardList, function(a, b)
		return a.rank < b.rank
	end)

	self.timesAwardList = {}
	for i = 1, table.nums(timesCfg) do
		local item = qy.tank.entity.SearchTreasureEntity.new(timesCfg[tostring(i)])
		table.insert(self.timesAwardList, item)
	end
	table.sort(self.timesAwardList, function(a, b)
		return a.ID < b.ID
	end)

	self.treasureAwardList = {}
	for i = 1, table.nums(treasureCfg) do
		local item = qy.tank.entity.SearchTreasureEntity.new(treasureCfg[tostring(i)])
		table.insert(self.treasureAwardList, item)
	end
	table.sort(self.treasureAwardList, function(a, b)
		return a.id < b.id
	end)

	local data = self.activityList["search_treasure"]
	self.endTime = data.end_time
	self.beginTime = data.start_time
	self.diamond = data.diamond
	self.award_list = data.award_list
	self.isRankAward = data.rank_award -- 是否可领取排行奖励
	self.rank_award_get = data.rank_award_get
	self.myrank = data.myrank
	self.free_times = data.free_times
	self.times = data.times
	self.searchTreasureCost = data.cost
	self.searchRankList = data.rank_list
end

function OperatingActivitiesModel:updateSearchTreasure(data)
	self.diamond = data.diamond -- 消耗钻石数
	self.award_list = data.award_list
	self.isRankAward = data.rank_award -- 是否可领取排行奖励
	self.rank_award_get = data.rank_award_get
	self.myrank = data.myrank
	self.free_times = data.free_times
	self.searchRankList = data.rank_list
	self.times = data.times -- 抽取次数
	self.searchTreasureCost = data.cost
end

--单笔充值(白虎来袭)
function OperatingActivitiesModel:getSingleRechargeStatus()
	if self.activityList[_ModuleType.SINGLE_RECHARGE] then
		return self.activityList[_ModuleType.SINGLE_RECHARGE].status
	else
		return 0
	end
end

-------------------------------------------------知识竞赛

function OperatingActivitiesModel:initquiz()
	local quizCfg = qy.Config.quiz
	self.quizList = {}
	for i = 1, table.nums(quizCfg) do
		local item = qy.tank.entity.QuizEntity.new(quizCfg[tostring(i)])
		table.insert(self.quizList, item)
	end
	table.sort(self.quizList, function(a, b)
		return a.id < b.id
	end)

	local data = self.activityList["quiz"]
	self.quizEndTime = data.activity_endtime -- 活动结束时间
	self.quizCurBeginTime = data.starttime --当天活动开始答题时间
	self.quizCurEndTime = data.endtime     --当天活动开始答题时间
	self.quizTitleId = data.titleid --答题号
	self.quizRankList = data.rank_list -- 排名 字典格式

	self.quizCurScore = data.userinfo.score -- 当前积分
	self.quizRank = data.userinfo.rank -- 当前排名
	self.quizStatus = data.userinfo.status -- 状态 100 未答题 200 答题中 300 答题结束
	self.quizTotal = data.userinfo.total -- 已答题数量
	self.quizCorrectNum = data.userinfo.correct_num -- 答对数量
	self.quizAward = nil
end

function OperatingActivitiesModel:updateQuizData(data)
	self.quizStatus = data.userinfo.status
	self.quizTotal = data.userinfo.total
	self.quizCorrectNum = data.userinfo.correct_num
	self.quizRankList = data.rank_list
	self.quizRank = data.userinfo.rank
	self.quizCurScore = data.userinfo.score
	self.quizTitleId = data.titleid
	self.quizAward = data.award
end

-------------------------------------------------超值购物(VIP团购)

function OperatingActivitiesModel:initGroupPurchase()
	local grouppurchaseCfg = qy.Config.grouppurchase
	self.groupPurchaseList = {}
	for i = 1, table.nums(grouppurchaseCfg) do
		local item = qy.tank.entity.GroupPurchaseEntity.new(grouppurchaseCfg[tostring(i)])
		table.insert(self.groupPurchaseList, item)
	end
	table.sort(self.groupPurchaseList, function(a, b)
		return a.id < b.id
	end)

	local data = self.activityList["grouppurchase"]
	self.grouppurchaseEndTime = data.endtime
	self.goodlist = data.goodlist
end
-------------------------------------------------分享有礼
function OperatingActivitiesModel:initAchieveShare()
	local data = self.activityList["achieve_share"]
	self.shareData = data.list
	self.achieve_shareData = self:sortForAchieveShare(self.shareData)
	self.sharecfg = qy.Config.achieve_share
	self.tempcfg = {}
	 print("分享有礼data%s",self.sharecfg["2"]);

	-- {"activity_info":{"list":[{"status":0,"id":1},{"status":1,"id":2},{"status":0,"id":3},{"status":0,"id":4},{"status":0,"id":5},{"status":0,"id":6}]}}

end
--排序
function OperatingActivitiesModel:sortForAchieveShare(data)
	local tempList = {}
	for i, v in pairs(data) do
	 	local status =  v.status;
       	if status == 2 then
        	table.insert(tempList,v);
    	end
    end
	for i, v in pairs(data) do
	 	local status =  v.status;
       	if status == 1 then
        	table.insert(tempList,v);
    	end
    end
    for i, v in pairs(data) do
	 	local status =  v.status;
        if status == 0 then
        	table.insert(tempList,v);
        end
    end
    for i, v in pairs(data) do
	 	local status =  v.status;
        if status == 3 then
        	table.insert(tempList,v);
        end
    end
    return tempList
end
function OperatingActivitiesModel:getShareAwardByIndex(_idx)
	return self.achieve_shareData[_idx]
end

function OperatingActivitiesModel:getShareAwardNum()
	return #self.achieve_shareData
end
function OperatingActivitiesModel:getLocalShareByIndex(_idx)
	local id = self.achieve_shareData[_idx].id
	return self.sharecfg[tostring(id)]
end
function OperatingActivitiesModel:setShareAwardByIndex(_idx)
	-- local id = self.achieve_shareData[_idx].id
	self.tempcfg = self.sharecfg[tostring(_idx)]
end
function OperatingActivitiesModel:getTempData(  )
	print("hhhhhh%s",self.tempcfg)
		return self.tempcfg
end
function  OperatingActivitiesModel:updateTempData(data)
		self.achieve_shareData = self:sortForAchieveShare(data)

end

function OperatingActivitiesModel:updateGroupPurchase(data)
	self.grouppurchaseEndTime = data.endtime
	self.goodlist = data.goodlist
end
--------------------------------钻石返利
function OperatingActivitiesModel:initDiamondRebateData( data )
	local data = self.activityList["diamond_rebate"]
	print("返回的数据",json.encode(data))
	self.diamond_rebate_endtime = data.end_time
	self.consume = data.consume
	self.server_list = {}
	self.endlist = {}
	local serverdata = data.list
	self.diamondrebatecfg = {}
	
	self.diamondrebatecfg = qy.Config.diamond_rebate--本地表
	-- print("钻石返利表",json.encode(self.diamondrebatecfg))
	for i, v in pairs(serverdata) do
		table.insert(self.server_list, v)
	end
	table.sort(self.server_list, function(a, b)
		return a.id < b.id
	end)
	local staticData = self:sortForDiamondRebate(self.server_list)
	
	for i, v in pairs(staticData) do
		local entity = qy.tank.entity.DiamondRebateEntity.new(v)
		table.insert(self.endlist, entity)
	end


end
function OperatingActivitiesModel:sortForDiamondRebate(data)
	local tempList = {}
	for i, v in pairs(data) do
	 	local status =  v.status;
       	if status == 1 then
        	table.insert(tempList,v);
    	end
    end
	for i, v in pairs(data) do
	 	local status =  v.status;
       	if status == 0 then
        	table.insert(tempList,v);
    	end
    end
    for i, v in pairs(data) do
	 	local status =  v.status;
        if status == -1 then
        	table.insert(tempList,v);
        end
    end
    return tempList
end

--------------------------------幸运夺宝
function OperatingActivitiesModel:initLuckyIndianaData( data )

	self.indianaListPosition = {
	    ["1"] = cc.p(70, 420),
	    ["2"] = cc.p(209, 420),
	    ["3"] = cc.p(350, 420),
	    ["4"] = cc.p(490, 420),
	    ["5"] = cc.p(630, 420),
	    ["6"] = cc.p(630, 301),
	    ["7"] = cc.p(630, 184),
	    ["8"] = cc.p(630, 68),
	    ["9"] = cc.p(490, 68),
	    ["10"] = cc.p(350, 68),
	    ["11"] = cc.p(209, 68),
	    ["12"] = cc.p(70, 68),
	    ["13"] = cc.p(70, 184),
	    ["14"] = cc.p(70, 301)
	}
	local data = self.activityList["lucky_indiana"]
	self.lucky_indiana_endtime = data.next_reset
	self.fussionlist = data.fussion--聚变数据
	self.fissionlist = data.fission--裂变数据
	self.fusioncfg = {}
	local staticData = qy.Config.indiana_fusion_weight--聚变抽奖表
	self.fusionexawardcfg  =  qy.Config.indiana_fusion_exaward--聚变额外奖励表
	self.fusionshopcfg = qy.Config.indiana_fusion_shop --聚变商店道具表
	for i, v in pairs(staticData) do
        table.insert(self.fusioncfg,v);
    end
   	table.sort(self.fusioncfg, function(a, b)
		return a.id < b.id
	end)
	self.fissioncfg = {}
	local staticData1 = qy.Config.indiana_fission_weight--裂变抽奖表
	self.fissionexawardcfg  =  qy.Config.indiana_fission_exaward--裂变额外奖励表
	self.fissionshopcfg = qy.Config.indiana_fission_shop --裂变商店道具表
	print("初始化了",table.nums(self.fusionshopcfg))
		for i, v in pairs(staticData1) do
        table.insert(self.fissioncfg,v);
    end
   	table.sort(self.fissioncfg, function(a, b)
		return a.id < b.id
	end)
end
function OperatingActivitiesModel:updateLuckyIndianaData( data )
	print("gengxin===================",json.encode(data))
	self.fussionlist = data.fussion--聚变数据
	self.fissionlist = data.fission--裂变数据
end
function OperatingActivitiesModel:initAnnualBonus(  )
	self.annual_bonuslist = qy.Config.annual_bonus
	local data = self.activityList["annual_bonus"]
	self.annual_bonus_status = data.status
	self.annual_bonus_starttime = os.date("*t",data.start_time)
	self.annual_bonus_endtime = os.date("*t",data.end_time)
end

--------------------------圣诞七天乐
function OperatingActivitiesModel:initChristmasData( )
	local data = self.activityList["seven_days_happy"]
	print("初始化圣诞节",json.encode(data))
	self.christmasaward = {}
	self.christmascfg = qy.Config.seven_days_happy--本地表每天都有什么任务
	self.christmastaskcfg = qy.Config.seven_days_happy_task--任务表
	local staticData  = qy.Config.seven_days_happy_award--总奖励表
	for i, v in pairs(staticData) do
        table.insert(self.christmasaward,v);
    end
   	table.sort(self.christmasaward, function(a, b)
		return a.id < b.id
	end)
	self.christmas_endtime = data.end_time
	self.christmas_awardstarttime = data.award_start_time
	self.christmas_awardendtime = data.award_end_time
	self.christmas_day = data.day--当前到达的天数
	self.christmasfinishinum = data.seven_day_happy.finish_num--完成了多少条
	self.christmasfinalid = data.seven_day_happy.final_award_id--目标奖励是否领取
	self.tasklist = data.seven_day_happy.counters--某个任务完成的数量
	self.awardlist  = data.seven_day_happy.award_list--任务是否被领取如果领取过就在里面
end
function OperatingActivitiesModel:updatechrismasdata( data )
	self.christmas_endtime = data.end_time
	self.christmas_awardstarttime = data.award_start_time
	self.christmas_awardendtime = data.award_end_time
	self.christmas_day = data.day--当前到达的天数
	self.christmasfinishinum = data.seven_day_happy.finish_num--完成了多少条
	self.christmasfinalid = data.seven_day_happy.final_award_id--目标奖励是否领取
	self.tasklist = data.seven_day_happy.counters--某个任务完成的数量
	self.awardlist  = data.seven_day_happy.award_list--任务是否被领取如果领取过就在里面
end
function OperatingActivitiesModel:getDaydate( taskid )
	local list  = {}
	for i,v in pairs(self.christmastaskcfg) do
		if v.group_id == taskid then
			table.insert(list,v)
		end
	end
	 table.sort(list, function(a, b)
		return a.task_id < b.task_id
	end)
	 return list
end
--------------------------------------娜塔莎的祝福
function OperatingActivitiesModel:initNatashaBeling(  )
	local data = self.activityList["natasha_double"]
	self.natasha_endtime = data.end_time
end
--------------------------------------娜塔莎的礼物
function OperatingActivitiesModel:initNatashaGift(  )
	local data = self.activityList["natasha_drop"]
	self.natashagift_endtime = data.end_time
	self.giftlist = qy.Config.natasha_drop
end
--------------------------------------新兵特供
function OperatingActivitiesModel:initRecruitSupply(  )
	local data = self.activityList["recruit_supply"]
	-- print("初始化了",json.encode(data))
	self.recruitsupplycfg = {}
	self.recruitsupplylist = {}
	for i, v in pairs(data.list) do
		local entity = qy.tank.entity.RecruitSupplyEntity.new(v)
		table.insert(self.recruitsupplylist, entity)

	end
	table.sort(self.recruitsupplylist, function(a, b)
		return a.id < b.id
	end)
	self.recruitsupplyendtime = data.end_time
	local staticData  = qy.Config.recruit_supply--总奖励表
	for i, v in pairs(staticData) do
        table.insert(self.recruitsupplycfg,v);
    end
   	table.sort(self.recruitsupplycfg, function(a, b)
		return a.id < b.id
	end)
end
function OperatingActivitiesModel:getRecruitday( )
	local status1 = self.recruitsupplylist[1].status
	local status2 = self.recruitsupplylist[2].status
	local status3 = self.recruitsupplylist[3].status
	if status1 == 1 then
		return 1
	elseif status1 == 0 then
		return 1
	else
		if status2 == 0 or status2 == 1 then
			return 2
		else
			if status3 == 0 or status3 == 1 then
				return 3
			else
				return 1
			end
		end
	end
end
-- ===========[战地援助]=================================
OperatingActivitiesModel.GROUND_AID_ACTION = "ground" 	--地面援助
OperatingActivitiesModel.COAST_AID_ACTION = "coast" 	--海岸援助
OperatingActivitiesModel.AIR_AID_ACTION = "air" 		--空中援助

function OperatingActivitiesModel:initWarAidData()
	self.war_aid_end = false
	self.aid_action_list = {self.AIR_AID_ACTION,self.GROUND_AID_ACTION,self.COAST_AID_ACTION}
	self.prop_id_list = {52,53,54,55}
	self.war_aid_end_time = self.activityList[_ModuleType.WAR_AID].end_time
	self.endt_war_aid_award = self.activityList[_ModuleType.WAR_AID].award_end_time
end

function OperatingActivitiesModel:isEndOfWarAid()
	return self.war_aid_end
end

function OperatingActivitiesModel:getAidData()
	local arr = {}
	for i = 1, #self.prop_id_list do
		table.insert(arr,{["type"]=14,["id"]=self.prop_id_list[i]})
	end
	return arr
end

function OperatingActivitiesModel:getPropNumArr()
	local arr = {}
	local entity
	for i = 1, #self.prop_id_list do
		entity = _StorageModel:getEntityByID(self.prop_id_list[i])
		if entity then
			arr[i] = entity.num
		else
			arr[i] = 0
		end
	end
	return arr
end

function OperatingActivitiesModel:updateAidList(one,two,three)
	local arr = {self.aid_action_list[one],self.aid_action_list[two],self.aid_action_list[three]}
	self.aid_action_list = arr
end

function OperatingActivitiesModel:getCurAid()
	if self.aid_action_list then
		return self.aid_action_list[2]
	else
		return self.GROUND_AID_ACTION
	end
end

function OperatingActivitiesModel:getWarAidInfo(_action)
	return self.activityList[_ModuleType.WAR_AID][_action]
end

function OperatingActivitiesModel:getAidRankData(_cur_aid, _idx)
	if _cur_aid == self.COAST_AID_ACTION then
		--海岸援助 21~40
		_idx = _idx + 20
	elseif _cur_aid == self.AIR_AID_ACTION then
		--空中援助 41~60
		_idx = _idx + 40
	end
	local data = qy.Config.war_aid_rank[tostring(_idx)].award[1]

	return data
end

function OperatingActivitiesModel:updateWarAidInfo(data)
	self.activityList[_ModuleType.WAR_AID] = data
end

function OperatingActivitiesModel:getAidEndTime()
	local time = self.war_aid_end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time,6)
	else
		self.war_aid_end = true
		time = self.endt_war_aid_award - userinfoModel.serverTime
		if time > 0 then
			return NumberUtil.secondsToTimeStr(time,6)
		else
			return "领奖已结束"
		end
	end
end

--===========[军资整备]=============
function OperatingActivitiesModel:initMilitarySupplyData()
	local function getArr(data,key)
		local index = key or "id"
		local arr = {}
		for _k, _v in pairs(data) do
			arr[_v[index]] = _v
		end
		return arr
	end
	self.military_supply_data = {}
	self.military_supply_data[1] = getArr(qy.Config.military_supply_login, "day")
	self.military_supply_data[2] = getArr(qy.Config.military_supply_recharge)
	self.military_supply_data[3] = getArr(qy.Config.military_supply_task)
	self.military_supply_data[4] = getArr(qy.Config.military_supply_discount)
	self.military_supply_data[5] = getArr(qy.Config.military_supply_shop)
	self.military_supply_dot = {false,false,false}
	self:updateMilitaryData(self.activityList[_ModuleType.MILITARY_SUPPLY],0)
	self:sortMilitaryData()
end

function OperatingActivitiesModel:sortMilitaryData()
	for i = 1, 4 do
		local arr = {}
		local done_arr = {}
		for j = 1, #self.military_supply_data[i] do
			if self.military_supply_data[i][j].status == 2 then
				-- 已领取
				table.insert(done_arr, self.military_supply_data[i][j])
			else
				-- 可领取/未达成
				table.insert(arr, self.military_supply_data[i][j])
			end
		end
		for z = 1, #done_arr do
			table.insert(arr, done_arr[z])
		end
		self.military_supply_data[i] = arr
	end
end

function OperatingActivitiesModel:updateMilitaryData(_data,_type)
	-- 0 表示全部更新[打开界面时的初始化]
	-- 其他数则表示领取奖励的更新
	self.activityList[_ModuleType.MILITARY_SUPPLY] = _data
	local ser_data = self.activityList[_ModuleType.MILITARY_SUPPLY].military_supply

	if _type == 0 or _type == 1 then
		-- 1累计登录
		self.military_supply_dot[1] = self:__updateMilitaryForThreeStatus({
			["data"] = self.military_supply_data[1],
			["num"] = ser_data.login.days,
			["list"] = ser_data.login.list,
			["s_compare"] = "day",
			["id"] = "day",
		})
	end
	if _type == 0 or _type == 2 then
		-- 2充值豪礼
		self.military_supply_dot[2] = self:__updateMilitaryForThreeStatus({
			["data"] = self.military_supply_data[2],
			["num"] = ser_data.recharge.diamond,
			["list"] = ser_data.recharge.list,
			["s_compare"] = "diamond",
			["id"] = "id",
		})
	end
	if _type == 0 or _type == 3 then
		-- 3整备行动
		local data = self.military_supply_data[3]
		local s_data
		for i = 1, #data do
			if data[i].type == 1 or data[i].type == 8 then
				-- 经典战役
				data[i].num = 1
			else
				-- 其他
				data[i].num = data[i].arg
			end
			s_data = self:__getMilitaryTaskById(ser_data.action.task,data[i].id)
			if s_data.is_draw == 1 then
				data[i].status = 2
			elseif s_data.num >= data[i].num then
				data[i].status = 1
				self.military_supply_dot[3] = true
			else
				data[i].status = 0
			end
			data[i].has_num = s_data.num


		end
	end
	if _type == 0 or _type == 4 then
		-- 4超值折扣
		self:__updateMilitaryCostData(self.military_supply_data[4],ser_data.discount)
	end
	if _type == 0 or _type == 5 then
		-- 5军资商店
		self:__updateMilitaryCostData(self.military_supply_data[5],ser_data.shop)
	end
end

function OperatingActivitiesModel:__isMilitaryAwardGet(_list, _id)
	for i = 1, #_list do
		if _list[i] == _id then
			return true
		end
	end
	return false
end

--status 0:未达成 1：可领取 2:已领取 3:已售罄
function OperatingActivitiesModel:__updateMilitaryForThreeStatus(param)
	local flag = false
	for i = 1, #param.data do
		if param.num >= param.data[i][param.s_compare] then
			-- prin
			if self:__isMilitaryAwardGet(param.list, param.data[i][param.id]) then
				param.data[i].status = 2
			else
				param.data[i].status = 1
				flag = true
			end
		else
			param.data[i].status = 0
		end
		param.data[i].has_num = param.num
	end
	return flag
end

function OperatingActivitiesModel:__getMilitaryTaskById(ser_data, _id)
	for i = 1, #ser_data do
		if ser_data[i].task_id == _id then
			return ser_data[i]
		end
	end

	return {["is_draw"]=0,["num"]=0}
end

function OperatingActivitiesModel:__updateMilitaryCostData(data,ser_data)
	local function getNum(s_data,id,compare)
		for i = 1, #s_data do
			if s_data[i].id == id then
				return s_data[i][compare]
			end
		end
		return 0
	end

	local buyed_num,my_num
	for i = 1, #data do
		my_num = getNum(ser_data.list,data[i].id,"num")
		if data[i].shop_type == 1 then
			buyed_num = getNum(ser_data.server_list,data[i].id,"buyed_num")
		else
			buyed_num = my_num
		end

		if data[i].shop_type == 4 then
			-- 不限购
			data[i].status = 1
		elseif buyed_num >= data[i].num then
			data[i].status = 3
		elseif my_num >= 1 and data[i].shop_type == 1 then
			data[i].status = 2
		-- elseif my_num >= 1 and data[i].shop_type == 3 then
			-- data[i].status = 2
		else
			data[i].status = 1
		end

		data[i].has_num = buyed_num
	end
end

function OperatingActivitiesModel:getMilitaryDataByIdx(tab_idx,cell_idx)
	if self.military_supply_data[tab_idx] then
		return self.military_supply_data[tab_idx][cell_idx]
	else
		return nil
	end
end

function OperatingActivitiesModel:getMilitaryNumByIdx(tab_idx)
	if self.military_supply_data[tab_idx] then
		return #self.military_supply_data[tab_idx]
	else
		return 0
	end
end

function OperatingActivitiesModel:getMilitaryMaxNumByIdx(tab_idx,cell_idx)
	if tab_idx == 1 then
		return self:getMilitaryNumByIdx(tab_idx)
	elseif tab_idx == 2 then
		return self:getMilitaryDataByIdx(tab_idx,cell_idx).diamond
	elseif tab_idx == 3 then
		return self:getMilitaryDataByIdx(tab_idx,cell_idx).num
	else
		return self:getMilitaryDataByIdx(tab_idx,cell_idx).number
	end
end

function OperatingActivitiesModel:getMilitaryGoodsNum()
	if self.military_supply_data[5] then
		return #self.military_supply_data[5]
	else
		return 0
	end
end

function OperatingActivitiesModel:getMilitaryGoodsByIndex(_idx)
	return self.military_supply_data[5][_idx]
end

function OperatingActivitiesModel:getMilitaryEndTime()
	local time = self.activityList[_ModuleType.MILITARY_SUPPLY].end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time,6)
	else
		return "活动已结束"
	end
end
------------------------------------------折扣贩售
function OperatingActivitiesModel:initDiscountData(  )
	local data = self.activityList["discount"]
	self.discountData = data.goodlist--请求的数据
	self.discountcfg = qy.Config.discount--读表
	self.Endtime = data.end_time
end
function OperatingActivitiesModel:getDiscountByIndex(_idx)
	return self.discountData[_idx..""]
end

function OperatingActivitiesModel:getDiscountNum()
	return table.nums(self.discountData)
end
function OperatingActivitiesModel:updateDiscountData( data )
	self.discountData = data--购买后重新初始化数据
end

return OperatingActivitiesModel
