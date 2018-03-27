--[[--
--矿区model
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local MineModel = qy.class("MineModel", qy.tank.model.BaseModel)

function MineModel:ctor()
end

--[[--
--获取自己的矿区信息
--]]
function MineModel:initUserMine(data)
	self.mineEntity = qy.tank.entity.MiningAreaEntity.new(data)
	self:getVipLevelByUpgrade()
end

function MineModel:getVipLevelByUpgrade()
    self.plunderVipLevel = {0,0,0,0,0,0}
    self.productVipLevel = {0,0,0,0,0,0}
    local timer = qy.tank.utils.Timer.new(0.1,1,function()
        local data = qy.Config.vip_privilege
        for k,v in pairs(data) do
            for i = 1, 6 do
                if data[k]["type_" .. i] == 8 then
                    local index = data[k]["param_" .. i]
                    self.productVipLevel[index] = data[k].vip_level
                end
                if data[k]["type_" .. i] == 9 then
                    local index = data[k]["param_" .. i]
                    self.plunderVipLevel[index] = data[k].vip_level
                end
            end
        end
    end)
    timer:start()
end

--[[--
--初始化掠夺信息
--]]
function MineModel:initPlunderInfo(data)
	--更新军团id
	self.mineEntity:updateLegionId(data.legion_id or 0)
	--掠夺列表
	self:initPlunderList(data)
	--油量
	self:updateUserOil(data)
	--更新免费刷新次数
	self:updateUserFreeRefresh(data.free_times)
end

--[[--
--初始化稀有矿信息
--]]
function MineModel:initRareMineInfo(data)
	--稀有矿区等级参数(用于计算产量)
	self.mineLevelParam = data.calc_level
	--稀有矿列表
	self:initRareMineList(data)
	--油量
	self:updateUserOil(data)
	--更新当前页
	self:updateCurPage(data.current_page)
end

--[[--
--获取稀有矿区等级参数
--]]
function MineModel:getRareMineLevelParam()
	return self.mineLevelParam
end

--[[--
--更新当前页
--]]
function MineModel:updateCurPage(page)
	self.curPage = page
end

--[[--
--获取当前页
--]]
function MineModel:getCurPage()
	return self.curPage
end

--[[--
--初始化稀有矿列表
--]]
function MineModel:initRareMineList(data)
	local entity = nil
	self.mineList = {}
	local entityData = nil
	for i = 1, #data.list do
		entity = qy.tank.entity.MiningAreaEntity.new(data.list[i])
		table.insert(self.mineList, entity)
		for j = 1, #data.revenge_list do
			if data.plunderList[i].owner_id == data.revenge_list[j] then
				entity.owner:updateRevengeStatus(1)
				break
			end
		end
	end
end

function MineModel:setSuccessfulPlunder(flag)
	if  flag then
		self.plunderResult = 1
	else
		self.plunderResult = 0
	end
end

--[[--
--根据稀有矿区ID获取矿区实体
--]]
function MineModel:getMineEntityById(nId)
	for i = 1, #self.mineList do
		if self.mineList[i].id == nId then
			 return self.mineList[i]
		end
	end
	return nil
end

--[[--
--更新稀有矿区
--]]
function MineModel:updateRareMine(data, mineId)
	local entity = self:getMineEntityById(mineId)
	if entity then
		entity:updateRareMine(data.raremineral_info)
	end
end

--[[--
--刷新掠夺信息
--]]
function MineModel:refreshPlunderInfo(data)
	--掠夺列表
	self:initPlunderList(data)
	--更新免费刷新次数
	self:updateUserFreeRefresh(data.free_times)
end

--[[--
--初始化掠夺列表
--]]
function MineModel:initPlunderList(data)
	local entity = nil
	self.plunderList = {}
	for i = 1, #data.plunderList do
		entity = qy.tank.entity.MiningAreaEntity.new(data.plunderList[i])
		table.insert(self.plunderList, entity)
		for j = 1, #data.revenge_list do
			if data.plunderList[i].id == data.revenge_list[j] then
				entity.owner:updateRevengeStatus(1)
				break
			end
		end
	end
end

--[[--
--掠夺稀有矿的结果
--]]
function MineModel:setPlunderRareMineResult(data, mineId)
	self.plunderResult = data.is_win
	if self.plunderResult ==1 then
		self:harvestRareMine(data, mineId)
	end
	self:updateUserOil(data)
end

--[[--
--掠夺结果
--]]
function MineModel:setPlunderResult(data)
	self.plunderResult = data.is_win
	self:updateUserOil(data)
	if data.award then
		self.plunderAward = data.award
	end
end

function MineModel:getPlunderAward()
	return self.plunderAward
end

function MineModel:updatePlunderResult()
	self.plunderResult = 0
end

--[[--
--掠夺是否成功
--]]
function MineModel:isSuccessfulPlunder()
	if  self.plunderResult == 1 then
		return true
	else
		return false
	end
end

--[[--
--复工
--]]
function MineModel:setToWorkResult(data)
	self.mineEntity:updateProductInfo(data.silver_info)
	self.remainSilver = data.outSilverNum
	self.awardSilver = data.award_silver
end

--[[--
--获取复工奖励
--]]
function MineModel:getToWorkReward()
	local str  = ""
	-- if self.remainSilver > 0 then
	-- 	str = str .. "收获银币" .. self.remainSilver .. "，"
	-- end
	if self.awardSilver > 0 then
		str = self.awardSilver
	end
	return str
end

--[[--
--更新油量
--]]
function MineModel:updateUserOil(data)
	self.mineEntity.owner:updateOil(data.oil)
	self.mineEntity.owner:updateAddOilTime(data.oil_uptime)
end

--[[--
--更新用户最大产量
--]]
function MineModel:updateUserMaxProduct(data)
	self.mineEntity.owner:updateMaxProduct(data)
end

--[[--
--更新免费刷新次数
--]]
function MineModel:updateUserFreeRefresh(data)
	self.mineEntity.owner:updateFreeRefresh(data)
end

--[[--
--收获成功
--]]
function MineModel:harvestSuccess(data)
	--更新生产信息
	self.mineEntity:updateProductInfo(data.silver_info)
	self.harvestSilver = data.outSilverNum
end

--[[--
--收获稀有矿
--]]
function MineModel:harvestRareMine(data, mineId)
	--更新生产信息
	self:updateRareMine(data, mineId)
	self.harvestSilver = data.silver
	self.harvestAward = data.award
	self.isFullHarvest = data.is_full
	self.eventId =data.event_id
	self.coefficient =data.silver_coefficient
end

function MineModel:getSilverCoefficient()
	--TODO
	-- self.coefficient = 100
	return self.coefficient
end

--[[--
--获取收获的奖励
--]]
function MineModel:getHarvestAward()
	return self.harvestAward
end

--[[--
--是否满矿收获
--]]
function MineModel:isFullMineHarvest()
	if self.isFullHarvest == 1 then
		return true
	else
		return false
	end
end

--[[--
--获取收获银币
--]]
function MineModel:getHarvestSilver()
	local award = {{["type"] = 3, ["num"] = self.harvestSilver}}
end

--[[--
--更新生产信息
--]]
function MineModel:updateMineProductInfo(data)
	self.mineEntity:updateProductInfo(data.silver_info)
	self.mineEntity:updateSecondProduct(data.perSecondNum)
	self.mineEntity:updateMaxProduct(data.maxSilverNum)
end

--[[--
--更新掠夺信息
--]]
function MineModel:updateUserPlunderInfo(data)
	self.mineEntity.owner:updatePlunderInfo(data.plunder_jie)
end

--[[--
--获取自己矿区
--]]
function MineModel:getmineEntity()
	return self.mineEntity
end

--[[--
--获取掠夺列表
--]]
function MineModel:getPlunderList()
	return self.plunderList
end

--[[--
--获取稀有矿列表
--]]
function MineModel:getMineList()
	return self.mineList
end

--[[--
--设置进度条百分比
--]]
function MineModel:setProgressPercent(num)
	self.progressPercent = num
end

--[[--
--设置进度条百分比减1
--]]
function MineModel:getProgressPercent()
	if self.progressPercent > 0 then
		self.progressPercent = self.progressPercent - 1
	else
		self.progressPercent = 0
	end

	return self.progressPercent
end

--[[--
--获取显示矿堆的百分数
--]]
function MineModel:getPercentForShowOreHeap(index)
	if index == 1 then
		return 10
	elseif index == 2 then
		return 50
	elseif index == 3 then
		return 80
	end
	return 0
end

-- function MineModel:getColorFor3b(level)
-- 	if level == 1 then
-- 		--1级升到2级
-- 		return （46, 190, 83）
-- 	elseif level == 2 then
-- 		--2级升到3级
-- 		return {36, 174, 242}
-- 	elseif level == 3 then
-- 		--3级升到4级
-- 		return {174, 53, 248}
-- 	elseif level == 4 then
-- 		--4级升到5级
-- 		return {192, 89, 42}
-- 	end
-- end

--[[--
--获取稀有矿区等级段描述
--]]
function MineModel:getMineLevelDes()
	local firstNum = math.floor(self.mineList[1].levelKey / 10)
	if firstNum == 2 then
		return qy.TextUtil:substitute(21064)
	else
		if firstNum >= 13 and firstNum <= 14 then
			return ("130-149级稀有矿区")
		elseif firstNum >= 15 and firstNum <= 19 then
			return ("150-199级稀有矿区")
		elseif firstNum >= 20 and firstNum <= 25 then
			return ("200-259级稀有矿区")
		else
			return (qy.InternationalUtil:isShowLv()) .. firstNum .. "0-" .. firstNum .. qy.TextUtil:substitute(21065)
		end
	end
end

function MineModel:setEventId(_eventId)
	self.eventId = eventId
end

function MineModel:getEventTitleAndInfo()
	--TODO
	-- self.eventId = 1
	return qy.Config.raremining_event["" .. self.eventId]
end

function MineModel:initLog(data)
	self.logData = {}
	if data.log then
		for _k, _v in pairs(data.log) do
			if data.log[_k].mineType == 1 then
				data.log[_k].mineName = qy.TextUtil:substitute(21066)
			else
				data.log[_k].mineName = qy.TextUtil:substitute(21067)
			end
			table.insert(self.logData,data.log[_k])
		end
	end
end

function MineModel:getLog()
	return self.logData
end

return MineModel
