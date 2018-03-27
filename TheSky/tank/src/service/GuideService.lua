--[[--
    新手引导 service
    Author: H.X.Sun
    Date: 2015-05-04
--]]

local GuideService = qy.class("GuideService", qy.tank.service.BaseService)


-- function GuideService:chooseTank(callFunc)
-- 	local model =  qy.tank.model.LoginModel
-- 	qy.Http.new(qy.Http.Request.new({
-- 		["m"] = "Guide.chooseTank",
-- 		["p"] = {
-- 			["ftue"] = qy.GuideModel:getCurrentBigStep(),
-- 		}
-- 	}))
-- 	:setShowLoading(false)
-- 	:send(function(response, request)
-- 		-- qy.tank.command.AwardCommand:add(response.data.award)
-- 		-- qy.tank.model.GarageModel:automaticToFormation(response.data.formation)
-- 		callFunc()
-- 	end)
-- end

-- function GuideService:getSupplies(callFunc)
-- 	local model =  qy.tank.model.LoginModel
-- 	qy.Http.new(qy.Http.Request.new({
-- 		["m"] = "guide.sendItem",
-- 		["p"] = {["ftue"] = qy.GuideModel:getCurrentBigStep()}
-- 	})):send(function(response, request)
-- 		qy.tank.command.AwardCommand:add(response.data.award)
-- 		qy.tank.command.AwardCommand:show(response.data.award)
-- 		callFunc()
-- 	end)
-- end


function GuideService:guideComplete()
	qy.Http.new(qy.Http.Request.new({
		["m"] = "guide.complete",
		["p"] = {}
	}))
	:setShowLoading(false)
	:send(function(response, request)
	end)
end

function GuideService:createRoleName(nickname,headIcon,onSuccess,onError,ioError)
	local model =  qy.tank.model.LoginModel
    if headIcon == nil then
        headIcon = "head_1"
    end
	qy.Http.new(qy.Http.Request.new({
		["m"] = "guide.setNickName",
		["p"] = {
			["nickname"] = nickname,
            ["headicon"] = headIcon,
			["ftue"] = qy.GuideModel:getCurrentBigStep()
		}
	}))
	:setShowLoading(false)
	:send(function(response, request)
		-- qy.tank.model.LoginModel:updateNickName(response.data.nickname)
		qy.tank.model.UserInfoModel.userInfoEntity.name_:set(response.data.nickname)
        qy.tank.model.UserInfoModel.userInfoEntity.headicon_:set(response.data.headicon)
        qy.Event.dispatch(qy.Event.USER_BASE_INFO_DATA_UPDATE)
		onSuccess()
	end,onError,ioError)
end

function GuideService:getCurrentStep(_current)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Guide.getStep",
		["p"] = {["kid"] = qy.tank.model.UserInfoModel.userInfoEntity.kid}
	}))
	:setShowLoading(false)
	:send(function(response, request)
		qy.hint:show(qy.TextUtil:substitute(15006) .. _current .. "   " .. qy.TextUtil:substitute(15007) .. response.data.current_step_id)
		print("客户端下一步" .. _current .. "   后端下一步：" .. response.data.current_step_id)
	end)
end


function GuideService:submitGuideStepSer(onSuccess,onError,ioError)
	-- local stepData = clone(qy.GuideModel:getThroughSteps())
	local stepData = qy.GuideModel:submitThStepsData()
	print("进行完的新手引导：" .. qy.json.encode(stepData))
	qy.Http.new(qy.Http.Request.new({
		["m"] = "stat.guide",
		["p"] = {["step"] = stepData}
	}))
	:setShowLoading(false)
	:send(function(response, request)
		-- qy.GuideModel:initThroughSteps()
		onSuccess()
	end,onError,ioError)
end

return GuideService