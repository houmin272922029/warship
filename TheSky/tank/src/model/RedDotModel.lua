--[[--
	红点model
	Author: H.X.Sun
	Date: 2015-06-09
--]]--

local RedDotModel = qy.class("RedDotModel", qy.tank.model.BaseModel)

local BattleRoomModel = qy.tank.model.BattleRoomModel
local AchievementModel = qy.tank.model.AchievementModel
local OperatingActivitiesModel = qy.tank.model.OperatingActivitiesModel

function RedDotModel:getPositionByType(_t)
	local data = qy.Config.red_dot_position
	if data[_t] then
		return cc.p(data[_t].pos[1])
	else
		--找不到对应的_t,则使用默认数据
		return cc.p(83, 85)
	end
end

function RedDotModel:init(data)
	local redDotData = {}
	if data.main and data.main.red_point then
		redDotData = data.main.red_point
	elseif data.red_point then
		redDotData = data.red_point
	else
		redDotData = data
	end

	self.redDot = redDotData
	print("RedDotModel:init(data) RedDotModel:init(data) RedDotModel:init(data)====>>>>",qy.json.encode(self.redDot))
	self.gmmailDot = redDotData.gmmail
	self.mailDot = redDotData.mail
	if redDotData.mail or redDotData.gmmail then
        qy.RedDotCommand:emitSignal(qy.RedDotType.M_MAIL, self:isMailHasDot(), true)
    end

    if redDotData.mining or redDotData.raremineral then
        qy.RedDotCommand:emitSignal(qy.RedDotType.M_MINE, self:isMineHasDot())
    end

    if redDotData.arena_rank then
    	if tonumber(qy.tank.model.ArenaModel.rank) ~= redDotData.arena_rank then
    		-- qy.tank.model.ArenaModel.rank_:set(redDotData.arena_rank)
    		qy.tank.model.ArenaModel.rank = redDotData.arena_rank
    		qy.Event.dispatch(qy.Event.ARENA_RANK_UPDATE)
    	end
    end

	if redDotData.legion then
		self:setLegionApplyRed(redDotData.legion)
		qy.RedDotCommand:emitSignal(qy.RedDotType.M_LEGION, self:isMLegionHasDot())
	end
	self.interservice_legionbattle = 0--跨服军团战红点
	if redDotData.interservice_legionbattle then
		self.interservice_legionbattle = redDotData.interservice_legionbattle
	end

   self:updateOpActivityRedDot()
   self:updateCrossSerRedDot()

   	if data then
    	self:checkMessage(self.redDot )
	end

	self:updateBattleRoomDot()
	qy.RedDotCommand:emitSignal(qy.RedDotType.HER_RAC, self:isHeroicRacingHasDot())
	qy.RedDotCommand:emitSignal(qy.RedDotType.TORCH, self:isTorchHasDot())
end

---作战室----
function RedDotModel:isRoomCellHasDot(_name)
	if self.redDot and self.redDot[_name] == 1 then
		return true
	else
		return false
	end
end

function RedDotModel:isBattleRoomHasDot()
	local arr = BattleRoomModel:getListIndex()
	for i = 1, #arr do
		if self:isRoomCellHasDot(arr[i]) then
			return true
		end
	end

	return false
end


--跨服玩法
function RedDotModel:isServiceHasDot()
	local arr = OperatingActivitiesModel:getServiceActivityIndex()
	for i = 1, #arr do
		if self:isRoomCellHasDot(arr[i]) then
			return true
		end
	end

	return false
end





function RedDotModel:updateBattleRoomDot()
	if self:isBattleRoomHasDot() then
		print("self:isBattleRoomHasDot() ========true")
	else
		print("self:isBattleRoomHasDot() ========false")
	end
	qy.RedDotCommand:emitSignal(qy.RedDotType.M_BATTLE_R, self:isBattleRoomHasDot())
end

----------矿区-----------------------------------------------------------
function RedDotModel:isMineHasDot()
	if self.redDot then
		if self.redDot.mining == 1 or self.redDot.raremineral == 1 then
			return true
		else
			return false
		end
	else
		return false
	end

	return true
end

function RedDotModel:isRareMineHasDot()
	if self.redDot and self.redDot.raremineral == 1 then
		return true
	else
		return false
	end
end

function RedDotModel:cancelRareMineDot()
	if self.redDot == nil then
		self.redDot = {}
	end
	self.redDot.raremineral = 0
end

function RedDotModel:cancelMineDot()
	if self.redDot == nil then
		self.redDot = {}
	end
	self.redDot.mining = 0
end

----------邮件---------------------------------------------------------------------------
function RedDotModel:setMailStatus(_status)
	self.mailDot = _status
end

function RedDotModel:setGmMailStatus(_status)
	self.gmmailDot = _status
end

function RedDotModel:updateMailRedDot(data)
	if data then
		if data.mail then
			self.mailDot = data.mail
			print("data.mail ==" ..data.mail)
			qy.RedDotCommand:emitSignal(qy.RedDotType.M_TAB, self:isMailTab2HasDot(), true)
		end

		if data.gmmail then
			self.gmmailDot = data.gmmail
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_TAB_4, self:isMailTab4HasDot(), true)
		end
		qy.RedDotCommand:emitSignal(qy.RedDotType.M_MAIL, self:isMailHasDot(),true)
		qy.Event.dispatch(qy.Event.MAIL_NEW)
	end
end

function RedDotModel:isMailHasDot()
	if self:isMailTab2HasDot() then
		return true
	elseif self:isMailTab4HasDot() then
		return true
	else
		return false
	end
end

function RedDotModel:isMailTab2HasDot()
	if self.mailDot and self.mailDot == 1 then
		--print("RedDotModel:isMailTab2HasDot() true")
		return true
	else
		--print("RedDotModel:isMailTab2HasDot() false")
		return false
	end
end

function RedDotModel:isMailTab4HasDot()
	if self.gmmailDot and self.gmmailDot == 1 then
		print("RedDotModel:isMailTab4HasDot() true")
		return true
	else
		print("RedDotModel:isMailTab4HasDot() false")
		return false
	end
end

----------训练场---------------------------------------------------------------------------
function RedDotModel:isTranHasRedDot()
	local list = qy.tank.model.TrainingModel.trainList
	if list and #list > 0 then
		for i = 1, #list do
			if list[i]:isCompleted() then
				return true
			end
		end
	elseif self.redDot.train == 1 then
		return true
	else
		return false
	end
	return false
end

----------抽卡------------------------------------------------------------------------------
function RedDotModel:reduceExtCardFreeTimes(key)
	if self.redDot[key] then
		self.redDot[key] = self.redDot[key] - 1
	end
	qy.RedDotCommand:emitSignal(qy.RedDotType.M_EX_CARD, self:isExtCardHasRedDot())
end

function RedDotModel:isExtCardHasRedDot()
	if self.redDot.battlefield and self.redDot.battlefield > 0 then
		return true
	elseif self.redDot.reinforce and self.redDot.reinforce > 0 then
		return true
	else
		return false
	end
end

----------补给-------------------------------------------------------------------------------
function RedDotModel:isSupplyHasRedDot()
	local model = qy.tank.model.SupplyModel
	if model.supplyData then
		if model.supplyData.supply_num and model.supplyData.supply_num > 0 then
			return true
		else
			return false
		end
	elseif self.redDot.supply == 1 then
		return true
	else
		return false
	end
end


----------装备------------------------------------------------------------------------------

--[[--
--装备是否有红点
--]]
function RedDotModel:isEquipHasRedDot()
	local equipList = qy.tank.model.EquipModel.totalEquipList
	if equipList == 0 then
		return false
	else
		for i =1, #equipList do
			-- if equipList[#equipList + 1 - i].level < qy.tank.model.UserInfoModel:getMaxEquipLevelByUserLevel() then
			-- 	return true
			-- end

			--return equipList[#equipList + 1 - i]:hasRedDot()

			if equipList[#equipList + 1 - i]:hasRedDot() or equipList[#equipList + 1 - i]:reformHasDot() or equipList[#equipList + 1 - i]:advanceHasDot() then
				return true
			end
		end

		return false
	end
end


function RedDotModel:changeEquipRedDot()
	local isNew = false
	local equipList = qy.tank.model.EquipModel.totalEquipList
	for i = 1, #equipList do
		if equipList[i]:getNew() then
			isNew = true
			break
		end
	end
	qy.RedDotCommand:emitSignal(qy.RedDotType.M_EQUIP, self:isEquipHasRedDot(), isNew)
end

----------乘员-------------------------------------------------------------------------------
function RedDotModel:isPassengerHasRedDot()
	local model = qy.tank.model.PassengerModel
	if model.status1 == 100 or model.status2 == 100 then
		return true
	else
		return false
	end
	--TODO
end

-----------任务------------------------------------------------------------------------------

local TaskModel = qy.tank.model.TaskModel
--[[--
--每日任务任务是否有红点
--]]
function RedDotModel:isDailyTaskHasRedDot()
	local taskList = TaskModel.taskList[1]
	for i = 1 , #taskList do
		if taskList[i].status == 1 then
			return true
		end
	end
	return false
end

--[[--
--一次性任务任务是否有红点
--]]
function RedDotModel:isOneTimesTaskHasRedDot()
	local taskList = TaskModel.taskList[2]
	for i = 1 , #taskList do
		if taskList[i].status == 1 then
			return true
		end
	end
	return false
end

--主界面任务是否有红点
function RedDotModel:isTaskHasRedDot()
	if self:isDailyTaskHasRedDot() then
		return true
	elseif self:isOneTimesTaskHasRedDot() then
		return true
	else
		return false
	end
end

----------消息----------------------------------------------------------------------------------
--  消息相关状态
function RedDotModel:checkMessage(data)
	local messages = {}
	if data then
		if data.remind_zbhd == 1 then
			table.insert(messages, 1)
		end

		if data.remind_arena == 1 then
			table.insert(messages, 2)
		end
		if data.remind_rare ==1 then
			table.insert(messages, 3)
		end

		if data.remind_escort == 1 then
			table.insert(messages, 4)
		end
		if data.camp_war == 1 then
			table.insert(messages, 6)
		end

		table.sort(messages, function(a, b)
			return a < b
		end)
		if data.camp_war == 0 then
			qy.Event.dispatch(qy.Event.MESSAGE_UPDATE, {["mType"] = 6, ["flag"] = false})
		end
		for i, v in pairs(messages) do
			qy.Event.dispatch(qy.Event.MESSAGE_UPDATE, {["mType"] = v, ["flag"] = true, ["messages"] = messages})
		end
	end

	self.messages = messages
end

function RedDotModel:getMessages()
	return self.messages
end

-----------科技-------------------------------------------------------------------------------
function RedDotModel:isTechnologyHasRedDot()
	--到达某个等级是否开启
	-- print("=====================================1")
	local model = qy.tank.model.TechnologyModel
	local typeConfig = model.technologyTypeConfig
	local entity = nil

	for _k, _v in pairs(typeConfig) do
		-- print("typeConfig[_k].level ===" ..typeConfig[_k].level )
		-- print("qy.tank.model.UserInfoModel.userInfoEntity.level ===" ..qy.tank.model.UserInfoModel.userInfoEntity.level)
		if typeConfig[_k].level <= qy.tank.model.UserInfoModel.userInfoEntity.level then
			entity = model:getTechnologyEntityByTemplateId(typeConfig[_k].id)
			--如果到达开启的等级
			if entity then
				-- print("=====================================true",entity.id)
				--科技开启
				if model:canUpgradeOrNotByTechId(entity.id) then
					--等级可升级--给红点
					return true
				end
			else
				-- print("=====================================true","nil")
				--科技没开启--给红点
				return true
			end
		end
	end

	return false
end

function RedDotModel:getTechTempRedDotList()
	local dotList = {}
	-- print("查查查查====2")
	local userLevel = qy.tank.model.UserInfoModel.userInfoEntity.level
	--到达某个等级是否开启
	local model = qy.tank.model.TechnologyModel
	local typeConfig = qy.Config.technology_type
	local entity = nil
	local template = -1
	for _k, _v in pairs(typeConfig) do
		template = typeConfig[_k].template
		if dotList[template] == nil then
			if typeConfig[_k].level <= userLevel then
				entity = model:getTechnologyEntityByTemplateId(typeConfig[_k].id)
				-- 如果到达开启的等级
				if entity then
					--科技开启
					if model:canUpgradeOrNotByTechId(entity.id) then
						--等级可升级--给红点
						-- print("=template ==" .. template .. " entity.id==" ..entity.id)
						dotList[template] = true
					end
				else
					-- print("=template =no entity=" .. template)
					--科技没开启--给红点
					dotList[template] =  true
				end
			end
		end
	end

	--for i = 1, 4 do
	for i = 1, 2 do
		if dotList[i] == nil then
			dotList[i] = false
		end
	end
	return dotList
end


function RedDotModel:getTechTempRedDotList2()
	local dotList = {}
	local num = qy.tank.model.UserInfoModel.userInfoEntity.technologyHammer
	local userLevel = qy.tank.model.UserInfoModel.userInfoEntity.level
	local model = qy.tank.model.TechnologyModel


	if model.base and userLevel >= model.open3 then
		for i = 1, 6 do
			if num >= model.armed_forces_consume_1[model.base["p_"..i].stage].technology_hammer_1 then
				dotList[1] = true
				break
			end
		end
	end

    if model.special and userLevel >= model.open4 then
    	for i = 1, 6 do
			if num >= model.armed_forces_consume_2[model.special["p_"..i].stage].technology_hammer_1 then
				dotList[2] = true
				break
			end
		end
    end

    for i = 1, 2 do
		if dotList[i] == nil then
			dotList[i] = false
		end
	end

	return dotList

end

-----------车库-------------------------------------------------------------------------------------

-- function RedDotModel:setGarageHasNew(flag)
-- 	self.isGarageHasNew = flag
-- end
-- qy.tank.model.RedDotModel:setResolveStatus(true)

function RedDotModel:setResolveStatus(_status)
	self.isResolve = _status
end

function RedDotModel:getGarageHasNew()
	if self.isResolve then
		--已经分解，则删除new
		return false
	end
	if AchievementModel:getPicAddListNum() > 0 then
		return true
	else
		return false
	end
end

function RedDotModel:getGarageRedDot()
	local list = qy.tank.model.GarageModel.formation
	if self.isGarageHasNew then
		return true
	else
		for i = 1, #list do
			if type(list[i]) == "table" then
				if self:isGarageLoadHasRedDot(list[i].unique_id) then
					return true
				else
					local flag = self:isGarageEquipHasRedDot(list[i].unique_id)
					for j = 1, 4 do
						if flag[j] then
							return true
						end
					end
				end
			end
		end
	end

	return false

end

function RedDotModel:changeTankCellRedDot()
	qy.RedDotCommand:emitSignal(qy.RedDotType.G_CHANGE, self.isGarageHasNew, true)
end

--[[--
--一键装备红点
--]]
function RedDotModel:isGarageLoadHasRedDot(tankUid)
	if tankUid == nil or tankUid == 0 then
		--print("RedDotModel:isGarageLoadHasRedDot =1= false")
		return false
	else
		local equipTable = qy.tank.model.EquipModel:getEquipmentData(tankUid)
		for i = 1, #equipTable do
			if equipTable[i] > 0 then
				--print("RedDotModel:isGarageLoadHasRedDot =2= true")
				return true
			end
		end
	end
	--print("RedDotModel:isGarageLoadHasRedDot =3= false")
	return false
end

--[[--
--车库装备是否有红点
--]]
function RedDotModel:isGarageEquipHasRedDot(tankUid)
	local equipHasDot = {}
	if tankUid == nil or tankUid == 0 then
		return {false, false, false,false}
	else
		local tankEntity = qy.tank.model.GarageModel:getEntityByUniqueID(tankUid)
		if tankEntity == nil then
			return {false, false, false,false}
		end
		local equipTable = tankEntity:getEquipEntity()
		for i = 1, #equipTable do
			if equipTable[i] == -1 then
				if qy.tank.model.EquipModel:getFirstFreeEquip(i) then
					equipHasDot[i] = true
				else
					equipHasDot[i] = false
				end
			else
				equipHasDot[i] = equipTable[i]:hasRedDot() or equipTable[i]:reformHasDot() or equipTable[i]:advanceHasDot()
			end
		end

		return equipHasDot
	end
end

----------运营活动-----------------------------------
function RedDotModel:updateOpActivityRedDot()
	local data = OperatingActivitiesModel:getActivityRedDotStatus()
	local _hasDot = false
	if data then
		local opModel =	qy.tank.model.OperatingActivitiesModel
		local actIndexArr = opModel:getActivityIndex()

		for i = 1, #actIndexArr do
			local _status = opModel:getActivityRedDotStatusByName("2", actIndexArr[i])
			if "new" == _status then
				qy.RedDotCommand:emitSignal(qy.RedDotType.M_OP_ACTIVI, true, true)
				return
			elseif "1" == tostring(_status) or "red" == tostring(_status) then
				_hasDot = true
			end
		end

		if _hasDot then
			qy.RedDotCommand:emitSignal(qy.RedDotType.M_OP_ACTIVI, true)
		else
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_OP_ACTIVI, false)
    	end
	elseif self.redDot.activity then
		
    	if self.redDot.activity == "new" then
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_OP_ACTIVI, true, true)
    	elseif self.redDot.activity == "red" then
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_OP_ACTIVI, true)
    	else
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_OP_ACTIVI, false)
    	end
    else
   		qy.RedDotCommand:emitSignal(qy.RedDotType.M_OP_ACTIVI, false)
    end
end




--[[--
--更新跨服活动红点
--]]
function RedDotModel:updateServiceActivitiesRedDot()
	local opModel = qy.tank.model.OperatingActivitiesModel
	local actIndexArr = opModel:getServiceActivityIndex()
	local _hasDot = false
	for i = 1, #actIndexArr do
		local _status = self.redDot[actIndexArr[i]]
		if _status == "new" then
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_SER, true, true)
    		return
    	elseif tostring(_status) == "1" or _status == "red" then
    		_hasDot = true
    	end
	end

	if _hasDot then
		qy.RedDotCommand:emitSignal(qy.RedDotType.M_SER, true)
	else
    	qy.RedDotCommand:emitSignal(qy.RedDotType.M_SER, false)
    end
end


	

	


function RedDotModel:updateTimeLimitRedDot()
	local data = OperatingActivitiesModel:getActivityRedDotStatus()
	local opModel =	qy.tank.model.OperatingActivitiesModel
	local actIndexArr = opModel:getTimeLimitActivityIndex()

	if data and actIndexArr then
		local _hasDot = false
		for i = 1, #actIndexArr do
			local _status = opModel:getActivityRedDotStatusByName("3", actIndexArr[i])
			if "new" == _status then
				qy.RedDotCommand:emitSignal(qy.RedDotType.M_TIME_LIMIT, true, true)
				return
			elseif "1" == tostring(_status) or "red" == tostring(_status) then
				_hasDot = true
			end
		end

		if _hasDot then
			qy.RedDotCommand:emitSignal(qy.RedDotType.M_TIME_LIMIT, true)
		else
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_TIME_LIMIT, false)
    	end
	elseif self.redDot.deadline then
    	if self.redDot.deadline == "new" then
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_TIME_LIMIT, true, true)
    	elseif self.redDot.deadline == "red" or self.redDot.deadline == "1" then
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_TIME_LIMIT, true)
    	else
    		qy.RedDotCommand:emitSignal(qy.RedDotType.M_TIME_LIMIT, false)
    	end
    else
   		qy.RedDotCommand:emitSignal(qy.RedDotType.M_TIME_LIMIT, false)
    end
end




function RedDotModel:getOpActivityListOpenStatus()
	if self.opActivityListOpening then
		return true
	else
		return false
	end
end

-- function RedDotModel:updateOpActivityListOpenStatus(flag)
	-- self.opActivityListOpening = flag
	-- self:updateOpActivityRedDot()
-- end

--军团--
function RedDotModel:setLegionApplyRed(_status)
	if _status == 0 then
		self.r_legion_apply = false
	else
		self.r_legion_apply = true
	end
	qy.RedDotCommand:emitSignal(qy.RedDotType.LE_T_APPLY,self.r_legion_apply)
end

function RedDotModel:getLegionAppluRed()
	return self.r_legion_apply
end

function RedDotModel:isMLegionHasDot()
	if self.r_legion_apply == nil then
		if self.redDot.legion and self.redDot.legion == 1 then
			return true
		else
			return false
		end
	else
		return self.r_legion_apply
	end
end

--主角面运营活动
function RedDotModel:isHeroicRacingHasDot()
	if self.redDot.heroic_racing and tonumber(self.redDot.heroic_racing) == 1 then
		return true
	else
		return false
	end
end

function RedDotModel:isTorchHasDot()
	if not self.torchRedArr then
		if self.redDot.torch and tonumber(self.redDot.torch) == 1 then
			return true
		else
			return false
		end
	else
		for _k, _v in pairs(self.torchRedArr) do
			if _v then
				return _v
			end
		end
		return false
	end
end

function RedDotModel:getTorchRedArr()
	if not self.torchRedArr then
		local tModel = require("torch.src.TorchModel")
		tModel:updateRedot()
		self.torchRedArr = {}
		for i = 1, 7 do
			self:updateTRedDotByDay(i)
		end
	end

	return self.torchRedArr
end

function RedDotModel:updateTRedDotByDay(_day,_isUpdate)
	local tModel = require("torch.src.TorchModel")
	if _isUpdate then
		tModel:updateRedot()
	end
	self.torchRedArr[_day.."_0"] = tModel:getRedByDay(_day)
	for j = 1, 4 do
		self.torchRedArr[_day.."_"..j] = tModel:getRedByTab(_day,j)
	end
end

--单笔充值
function RedDotModel:isSingleRechargeHasDot()
	if self.redDot then
		if self.redDot.single_recharge == 1 then
			return true
		else
			return false
		end
	else
		return false
	end
end

---跨服玩法[目前只有一个跨服玩法，所以只针对最强之战，以后要改成像运营活动一样]----
function RedDotModel:updateCrossSerRedDot()
	-- if self.redDot.cross_service == "new" then
	-- 	qy.RedDotCommand:emitSignal(qy.RedDotType.M_CROSS_SER, true, true)
	-- elseif self.redDot.cross_service == "red" then
	-- 	qy.RedDotCommand:emitSignal(qy.RedDotType.M_CROSS_SER, true)
	-- else
	-- 	qy.RedDotCommand:emitSignal(qy.RedDotType.M_CROSS_SER, false)
	-- end
end

-- 现在是当打开最强之战时，把new 消除，以后这里可能改成跨服玩法列表，逻辑需要更改
function RedDotModel:changeCrossSerRedRod()
	-- if self.redDot.cross_service == "new" then
	-- 	self.redDot.cross_service = "red"
	-- end
end

return RedDotModel
