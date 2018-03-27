--[[
--新手引导流程管理器
--Author: H.X.Sun
--Date: 2015-06-27
]]

local GuideManager = class("GuideManager")

--[[--
--绑定当前新手引导所在容器
--]]
function GuideManager:registerContainer(c)
	qy.GuideCommand:removeAllGuideLayer()
	self:pushContainer(c)
	self.model = qy.tank.model.GuideModel
	self.command = qy.tank.command.GuideCommand
end

function GuideManager:getContainer()
	if self.container == nil then
		self.container = {}
	end
	print("#self.container==="..#self.container)
	return self.container[#self.container]
end

function GuideManager:pushContainer(_c)
	print("注册新手引导显示容器")
	table.insert(self.container,_c)
	if qy.isNoviceGuide then--||||||
		qy.tank.command.GuideCommand:createFirstMask()
	end
end

function GuideManager:popContainer()
	qy.tank.command.GuideCommand:removeAllGuideLayer()
	table.remove(self.container,#self.container)
	if qy.isNoviceGuide then--||||||
		qy.tank.command.GuideCommand:createFirstMask()
	end
end

--[[--
--开始新手引导，或者执行下一大步
--]]
function GuideManager:start(step)
	if qy.isNoviceGuide and self._hasStart == nil then --||||||
		print("++++++++++++++++++++++++++++++++++++++++++++start")
		self._hasStart = true
		if not self:isCtepExists(step) then
			step = self.model:__getNextBigStepByConfig(step)
		end
		print("启动新手引导第一步：【大步骤】==".. step .. "..-->【小步骤】== 1")
		if step == 1 then
			local _plat = cc.Application:getInstance():getTargetPlatform()
			if (_plat == cc.PLATFORM_OS_IPHONE or _plat == cc.PLATFORM_OS_ANDROID) and (qy.tank.utils.SDK:channel() ~= "pengyouwan") then
				print("===========开场引导===============")
				qy.tank.view.guide.noviceGuide.CGView.new(function ()
					self:startFirstBattle()
        		end):show(true)
			else
				self:startFirstBattle()
			end
		elseif step == -1 then
			--没有步数
			self:ended()
		else
			self.command:gotoAndPlay(step,1)
		end
	end
end

--[[--
--当前步是否存在，防止策划删除新手引导步骤报错
--]]
function GuideManager:isCtepExists(_step)
	if self.model:getGuideDataArr()[_step] == nil or self.model:getGuideDataArr()[_step][1] == nil then
		print("++++++++++++++++++++++++++++++++++++++++++++isCtepExists false")
		return false
	else
		print("++++++++++++++++++++++++++++++++++++++++++++isCtepExists true")
		return true
	end
end

function GuideManager:startFirstBattle()
	qy.tank.model.BattleModel:init(self.model:getFirstBattleData())
	qy.tank.manager.ScenesManager:showBattleScene()
	print("startFirstBattle==================")
	self.command:gotoAndPlay(1,1)
	qy.tank.service.BattleService:new():getGuideBattle(function() end)
end

function GuideManager:startOtherBattle()
	qy.tank.model.BattleModel:init(self.model:getOtherBattleData())
	-- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
	qy.tank.manager.ScenesManager:pushBattleScene()
	-- self.command:gotoAndPlay(1,1)
	self:next()
	-- qy.tank.service.BattleService:new():getGuideBattle(function() end)
end

--[[--
--新手引导结束
--]]
function GuideManager:ended()
	qy.isNoviceGuide = false --||||||
	self.command:removeAllGuideLayer(true)
	qy.tank.service.GuideService:guideComplete()
    qy.GuideModel:submitGuideStep(0)
end

-- function GuideManager:__getNextBigStepByConfig(_curStep)
-- 	local data = qy.Config.step_guide
-- 	for _k, _v in pairs(data) do
-- 		if data[_k].step_id == _curStep then
-- 			print("配置表的下一步：【大步骤】" .. data[_k].next_step_id)
-- 			return data[_k].next_step_id
-- 		end
-- 	end

-- 	return -1
-- end

--[[--
--获取下一步(返回大步，小步)
--]]
function GuideManager:getNextStep(_step,_subStep)
	local nextSubStep = _subStep + 1
	local nextStep = _step
	local data = self.model:getGuideDataArr()
	if data and data[_step] and tonumber(#data[_step]) and nextSubStep > #data[_step] then
		--小步骤结束
        -- qy.tank.service.GuideService:getCurrentStep(nextStep)
		nextStep = self.model:__getNextBigStepByConfig(_step)
		if nextStep < 1 then
			return -1, -1
		-- elseif nextStep > #self.model:getGuideDataArr() then
		-- 	--大步骤结束
		-- 	-- self:ended()
		-- 	return -1, -1
		else
			--进行下一大步
			--qy.tank.service.GuideService:getCurrentStep(nextStep)
			return self:getNextStep(nextStep,0)
		end
	else
		if self.model:getFirstStep() == nextStep then
			--本次第一大步
			return nextStep,nextSubStep
		else
			--不是第一步
			if data[nextStep][nextSubStep].is_perform == 0 then
				--不执行
				return self:getNextStep(nextStep,nextSubStep)
			else
				--执行
				return nextStep,nextSubStep
			end
		end
	end
end

--[[--
--执行下一步
--]]
function GuideManager:next(num)
	print("=======next=====", num)
	if qy.isNoviceGuide then --||||||
		local step,subStep = self:getNextStep(self.model:getCurrentStep())
		if step > 0 and subStep > 0 then
			self.model:setCurrentStep(step, subStep)
			print("下一步：【大步骤】==".. step .. "..-->【小步骤】=="..subStep)
			qy.Analytics:onEvent({["name"] = "GUIDE_" .. step .. "_" .. subStep})
			self.command:gotoAndPlay(step,subStep)
		else
			self:ended()
		end
	end
end

--------------------触发式引导----------------------------------------------------
local userInfoModel = qy.tank.model.UserInfoModel

--[[--
--开始触发式引导
--]]
function GuideManager:startTiggerGuide(data)
	if qy.isNoviceGuide then --||||||
		return
	end
	print("开始触发式引导:" .. data.des)
	qy.isTriggerGuide = true
	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.FUNCTION_OPEN_TIP)
	self:nextTiggerGuide()
end

--[[--
--执行下一步
--]]
function GuideManager:nextTiggerGuide()
	if qy.isNoviceGuide then --||||||
		return
	end
	if qy.isTriggerGuide then
		local nextStep = qy.GuideModel:getTriggerGuideStep()
		if nextStep > 2 then
			qy.GuideCommand:playTriggerGuide(nextStep)
		elseif nextStep == -1 then
			qy.GuideCommand:removeAllGuideLayer()
			qy.isTriggerGuide = false
		end
	end
end

return GuideManager
