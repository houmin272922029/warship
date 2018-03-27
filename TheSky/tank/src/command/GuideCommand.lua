--[[--
--新手引导command
--]]--

local GuideCommand = qy.class("GuideCommand", qy.tank.command.BaseCommand)

local userInfoModel = qy.tank.model.UserInfoModel
local guideModel = qy.tank.model.GuideModel

--[[--
--注册Ui，用于新手引导的点击
--@param ui 注册的控件
--@param
--]]
function GuideCommand:addUiRegister(data)
	if not qy.isNoviceGuide then
		--不是新手引导，不用注册
		return
	end
	if self.uiList == nil then
		self.uiList = {}
	end
	local _targetUi = nil
	local _step = 0 --大步骤
	local _subStep = 0 --小步骤
	local _stepData = {}
	for _i = 1, #data do
		_targetUi = data[_i].ui
		-- self.uiList[_stepData] = _targetUi
		_stepData = data[_i].step
		for _j = 1, #_stepData do
			_step_key = _stepData[_j]
			self.uiList[_step_key] = _targetUi
		end
	end
end

--[[--
--移除ui注册
--]]
function GuideCommand:removeUiRegister(data)
	if not qy.isNoviceGuide then
		--不上新手引导，不用移除
		return
	end
	local _step = 0 --大步骤
	local _subStep = 0 --小步骤
	for _i = 1, #data do
		_step_key = data[i]
		if self.uiList[_step_key] then
			self.uiList[_step_key] = nil
		end
	end
end

--[[--
--获取当前ui
--]]
function GuideCommand:getTargetUi()
	local key = guideModel:getCurrentStepKey()
	if key == "" then
		return nil
	elseif self.uiList and self.uiList[key] then
		return self.uiList[key]
	else
		return nil
	end
end


--战斗加速按钮
function GuideCommand:addRegBatSpeedBtn(_ui)
	self.speedBtn = _ui
	print("self.speedBtn = _ui====", tolua.cast(_ui,"cc.Node"))
end

function GuideCommand:removeRegBatSpeedBtn()
	self.speedBtn = nil
end

function GuideCommand:getRegBatSpeedBtn()
	return self.speedBtn
end

-- [[--
-- 显示新手引导
-- @param #number step 步数
-- @param #number type 1【对话】2【点击】3【战斗】4【支援】5【空白】
-- ]]
function GuideCommand:gotoAndPlay(_step, _subStep)
	local _type = qy.tank.model.GuideModel:getGuideDataArr()[_step][_subStep].type
	print("新手引导步骤：" .. qy.tank.model.GuideModel:getGuideDataArr()[_step][_subStep].des)
	print("引导类型[1:对话][2:点击][3:战斗][4:支援][5:空白]:" .. _type)
	-- self:playGuide(_step,_subStep)
	local container = qy.GuideManager:getContainer()
	if self.clickGuide then
		self.clickGuide:hideMark()
	end
	self:__removeSelectTankGuide(container)
	self:__removeRoleGuide(container)
	if _type == 1 then
		--对话界面
		self:__removeClickGuide(container)
		self:__createDialogueGuide(container)
		self:updateDialogueGuide(_step,_subStep)
	elseif _type == 6 then
		--选坦克
		self:__removeClickGuide(container)
		self:__removeDialogueGuide(container)
		self:__createSelectTankGuide(container)
	elseif _type == 7 then
		--指挥官命名
		self:__removeClickGuide(container)
		self:__removeDialogueGuide(container)
		self:__createRoleGuide(container)
	else
		--点击界面
		self:__removeDialogueGuide(container)
		self:__createClickGuide(container)
		self:updateClickGuide(_step, _subStep)
	end

	qy.GuideModel:setThroughSteps(_step, _subStep)
end

function GuideCommand:createFirstMask()
	print("创建新手引导遮罩：防止消息初始化前被点击")
	local container = qy.GuideManager:getContainer()
	self:__createClickGuide(container)
end

function GuideCommand:updateDialogueGuide(_step, _subStep)
	self.dialogueGuide:update(qy.tank.model.GuideModel:getGuideDataArr()[_step][_subStep])
end

function GuideCommand:updateClickGuide(_step, _subStep)
	local data = qy.tank.model.GuideModel:getGuideDataArr()[_step][_subStep]
	local _type = data.type
	-- local _rolePos = data.role_pos
	-- local _roleRes = data.role_res

	local targetUi = self:getTargetUi()
	local data = {["type"] = _type, ["ui"] = targetUi, ["step"] = _step, ["subStep"] = _subStep, ["guideData"] = data}
	self.clickGuide:updateRect(data)
end

--[[----对话引导-----]]--
function GuideCommand:__createDialogueGuide(container)
	if self.dialogueGuide == nil then
		self.dialogueGuide = qy.tank.view.guide.noviceGuide.DialogueGuide.new()
		self.dialogueGuide:setTag(10001)
		container:addChild(self.dialogueGuide)
	end
end

function GuideCommand:__removeDialogueGuide(container)
	if self.dialogueGuide and container:getChildByTag(10001) then
	-- if tolua.cast(self.dialogueGuide,"cc.Node") then
		container:removeChild(self.dialogueGuide)
	end
	self.dialogueGuide = nil
end

--[[---点击引导--]]
function GuideCommand:__createClickGuide(container)
	if self.clickGuide == nil then
		self.clickGuide = qy.tank.view.guide.noviceGuide.ClickGuide.new()
		self.clickGuide:setTag(10002)
		container:addChild(self.clickGuide)
	end
end

function GuideCommand:__removeClickGuide(container)
	-- if self.clickGuide then
	if self.clickGuide and container:getChildByTag(10002) then
	-- if tolua.cast(self.clickGuide,"cc.Node") then
		container:removeChild(self.clickGuide)
	end
	self.clickGuide = nil
end

--[[---选tank引导--]]
function GuideCommand:__createSelectTankGuide(container)
	if self.selectTankGuide == nil then
		self.selectTankGuide = qy.tank.view.guide.noviceGuide.SelectOneTank.new()
		self.selectTankGuide:setTag(10003)
		container:addChild(self.selectTankGuide)
	end
end

function GuideCommand:__removeSelectTankGuide(container)
	-- if tolua.cast(self.selectTankGuide,"cc.Node") then
	if self.selectTankGuide and container:getChildByTag(10003) then
		container:removeChild(self.selectTankGuide)
	end
	self.selectTankGuide = nil
end

--[[---创建角色引导--]]
function GuideCommand:__createRoleGuide(container)
	if self.createRoleGuide == nil then
		self.createRoleGuide = qy.tank.view.guide.noviceGuide.CreateRole.new()
		self.createRoleGuide:setTag(10004)
		container:addChild(self.createRoleGuide)
	end
end

function GuideCommand:__removeRoleGuide(container)
	-- if self.createRoleGuide then
	-- if tolua.cast(self.createRoleGuide,"cc.Node") then
	if self.createRoleGuide and container:getChildByTag(10004) then
		container:removeChild(self.createRoleGuide)
	end
	self.createRoleGuide = nil
end

function GuideCommand:removeAllGuideLayer(flag)
	local container = qy.GuideManager:getContainer()
	if container then
		self:__removeSelectTankGuide(container)
		self:__removeRoleGuide(container)
		self:__removeClickGuide(container)
		self:__removeDialogueGuide(container)
	end
    if flag then
        print("新手引导完成！！！")
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.FINISH_GUIDE)
    end
end

--[[--
--是否中途停止战斗
--]]
function GuideCommand:isStopBattleInTheMiddle()
	local _step = qy.tank.model.GuideModel:getCurrentBigStep()
	if _step == 1 then
		--如果当前是第1大步骤，则在中间停止战斗
		return true
	else
		return false
	end
end

---------------触发式引导----------------------------------------------------
function GuideCommand:addTriggerUiRegister(data)
	if self.uiList == nil then
		self.uiList = {}
	end
	local _targetUi = nil
	local _step_key = ""
	local _stepData = {}
	for _i = 1, #data do
		_targetUi = data[_i].ui
		_stepData = data[_i].step
		for _j = 1, #_stepData do
			_step_key = _stepData[_j]
			self.uiList[_step_key] = _targetUi
		end
	end

end

function GuideCommand:removeTriggerUiRegister(data)
	local _step_key = ""
	for _i = 1, #data do
		_step_key = data[i]
		if self.uiList[_step_key] then
			self.uiList[_step_key] = nil
		end
	end
end

function GuideCommand:getTriggerGuideUi(_key)
	return self.uiList[_key]
end

function GuideCommand:playTriggerGuide(_subStep)
	local _level = userInfoModel.userInfoEntity.level
	local data = qy.GuideModel:getTriggerGuideData()[_subStep]

	local container = qy.GuideManager:getContainer()
	self:__createClickGuide(container)
	-- self:updateClickGuide(_step, _subStep)
	print("step_key ====" .. data.step_key)
	local targetUi = self:getTriggerGuideUi(data.step_key)
	local data = {["type"] = data.type, ["ui"] = targetUi, ["step"] = _level, ["subStep"] = _subStep, ["guideData"] = data}
	self.clickGuide:updateRect(data)

end

return GuideCommand
