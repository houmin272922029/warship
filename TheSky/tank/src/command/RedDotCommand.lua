--[[--
--红点
--]]--

local RedDotCommand = qy.class("RedDotCommand", qy.tank.command.BaseCommand)

function RedDotCommand:init()
	self.lastUpdateRedDotTime = qy.tank.model.UserInfoModel.serverTime
	self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
		if qy.tank.model.UserInfoModel.serverTime - self.lastUpdateRedDotTime > 60 then
			self.lastUpdateRedDotTime = qy.tank.model.UserInfoModel.serverTime
			local service = qy.tank.service.RedDotService
            	service:get(function (data)
            end)
		end
	end)
end

--[[--
--添加信号
--]]
function RedDotCommand:addSignal(signalTable)
	if self._redDotSignal == nil then
		self._redDotSignal = {}
	end

	for _k, _v in pairs(signalTable) do
		self._redDotSignal[_k] = signalTable[_k]
	end
end

--[[--
--移除信号
--]]
function RedDotCommand:removeSignal(signalTable)
	if self._redDotSignal == nil then
		return
	end

	for i = 1,#signalTable do
		local signal = signalTable[i]
		self:emitSignal(signal, false)
		self._redDotSignal[signal] = nil
	end
end

--[[--
--分发信息
--@param #string signal 信号 在RedDotType中定义
--@param #boolean isAdd 是否属于加红点，是则增加红点，否则 删除红点
--@param #boolean 是否是New 是：new 否：红点 , 默认 否
--]]
function RedDotCommand:emitSignal(signal, isAdd, isNew)
	--print(signal, isAdd)

	if isNew == nil then
		isNew = false
	end
	if isAdd == nil then
		isAdd = false
	end

	if self._redDotSignal == nil then
		return
	end

	if tolua.cast(self._redDotSignal[signal],"cc.Node") then
		if isAdd then
			self:__addRedDot(self._redDotSignal[signal], signal, isNew)
		else
			self:__removeRedDot(self._redDotSignal[signal], signal)
		end
	end
end

--[[--
--加红点
--]]
function RedDotCommand:__addRedDot(targetUi, signal, isNew)
	if not tolua.cast(self[signal],"cc.Node") then
		self[signal] = qy.tank.view.common.RedDot.new({
			["type"] = signal,
		})
		targetUi:addChild(self[signal])
	end
	self[signal]:update(isNew)
end

--[[--
--删红点
--]]
function RedDotCommand:__removeRedDot(targetUi, signal)
	if self[signal] then
		targetUi:removeChild(self[signal])
		self[signal] = nil
	end
end

--[[--
--初始化主界面红点
--]]
function RedDotCommand:initMainViewRedDot()
	local model = qy.tank.model.RedDotModel
	print("wwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	self:emitSignal(qy.RedDotType.M_TASK, model:isTaskHasRedDot())
	self:emitSignal(qy.RedDotType.M_GARAGE, model:getGarageRedDot(),  model:getGarageHasNew())
	self:emitSignal(qy.RedDotType.M_SUPPLY, model:isSupplyHasRedDot())
	self:emitSignal(qy.RedDotType.M_EX_CARD, model:isExtCardHasRedDot())
	self:emitSignal(qy.RedDotType.M_TRAIN, model:isTranHasRedDot())
	self:emitSignal(qy.RedDotType.M_MAIL, model:isMailHasDot(), true)
	self:emitSignal(qy.RedDotType.M_TECH, model:isTechnologyHasRedDot())
	self:emitSignal(qy.RedDotType.M_MINE, model:isMineHasDot())
	self:emitSignal(qy.RedDotType.M_BATTLE_R, model:isBattleRoomHasDot())
	self:emitSignal(qy.RedDotType.M_LEGION, model:isMLegionHasDot())
	self:emitSignal(qy.RedDotType.M_PASSENGER, model:isPassengerHasRedDot())--可以在乘员model做处理
	model:updateServiceActivitiesRedDot()
	model:updateTimeLimitRedDot()
	model:changeEquipRedDot()
	model:updateOpActivityRedDot()
	model:updateCrossSerRedDot()
end

--[[--
--更新车库红点
--]]
function RedDotCommand:updateGarageViewRedDot(tankUid)
	local model = qy.tank.model.RedDotModel
	local equipHasDot = model:isGarageEquipHasRedDot(tankUid)
	-- self:emitSignal(qy.RedDotType.G_CHANGE, model:getGarageHasNew(), true)
	self:emitSignal(qy.RedDotType.G_LOAD, model:isGarageLoadHasRedDot(tankUid))
	for i = 1, 4 do
		self:emitSignal(qy.RedDotType["G_EQUIP_" .. i], equipHasDot[i])
	end
end

--[[--
--更新科技模板红点
--]]
function RedDotCommand:updateTechTemplateRedDot()
	-- print("查查查查 ===1")
	local model = qy.tank.model.RedDotModel
	local tempDotList = model:getTechTempRedDotList()
	local tempDotList2 = model:getTechTempRedDotList2()
	for i = 1, 2 do
		self:emitSignal(qy.RedDotType["TECH_TEMP_" .. i], tempDotList[i])
	end

	for i = 1, 2 do
		self:emitSignal(qy.RedDotType["TECH_TEMP_" .. i + 2], tempDotList2[i])
	end
end

-------------------------------------------------------------------------------------
--[[--
--初始化运营活动红点
--]]
function RedDotCommand:initActivitiesRedDot()
	local opModel = qy.tank.model.OperatingActivitiesModel
	local actIndexArr = opModel:getActivityIndex()
	for i = 1, #actIndexArr do
		local _status = opModel:getActivityRedDotStatusByName("2", actIndexArr[i])
		if "new" == _status then
			self:emitSignal(actIndexArr[i], true, true)
		elseif "red" == _status or "1" == tostring(_status) then
			self:emitSignal(actIndexArr[i], true)
		else
			self:emitSignal(actIndexArr[i], false)
		end
	end
end


--[[--
--初始化跨服活动红点
--]]
function RedDotCommand:initServiceActivitiesRedDot()
	local model = qy.tank.model.RedDotModel
	local actIndexArr = qy.tank.model.OperatingActivitiesModel:getServiceActivityIndex()
	for i = 1, #actIndexArr do
		local _status = model.redDot[actIndexArr[i]]
		if "red" == _status or "1" == tostring(_status) then
			self:emitSignal(actIndexArr[i], true)
		else
			self:emitSignal(actIndexArr[i], false)
		end
	end
end

--初始化限时活动
function RedDotCommand:initTimeLimitRedDot()
   	local opModel =	qy.tank.model.OperatingActivitiesModel
	local actIndexArr = opModel:getTimeLimitActivityIndex()

	for i = 1, #actIndexArr do
		local _status = opModel:getActivityRedDotStatusByName("3", actIndexArr[i])
		if "new" == _status then
			self:emitSignal(actIndexArr[i], true, true)
		elseif "1" == tostring(_status) or "red" == tostring(_status) then
			self:emitSignal(actIndexArr[i], true)
		else
			self:emitSignal(actIndexArr[i], false)
		end
	end
end


--火炬行动
function RedDotCommand:updateTorchRedDot(_day)
	local model = qy.tank.model.RedDotModel
	local redArr = model:getTorchRedArr()
	for i = 1, 4 do
		self:emitSignal(qy.RedDotType["TORCH_TAB_"..i],redArr[_day .. "_" ..i])
	end
	for i = 1, 7 do
		self:emitSignal(qy.RedDotType["TORCH_D_"..i],redArr[i .. "_0"])
	end
end

return RedDotCommand
