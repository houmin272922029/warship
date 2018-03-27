--[[--
--红点 service
--Author: H.X.Sun
--Date: 2015-05-04
--]]

local RedDotService = qy.class("RedDotService", qy.tank.service.BaseService)

RedDotService.model = qy.tank.model.RedDotModel

--[[--
--一分钟获取一次红点通知
--]]
function RedDotService:get(onSuccess)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "RedPoint.get",
		["p"] = {}
	}))
	:setShowLoading(false)
	:send(function(response, request)
		print("one min get redDot")
		qy.tank.model.RedDotModel:init(response.data)
		onSuccess(response.data)
	end)
end

-- 获取消息
function RedDotService:getRemind(mType, onSuccess)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "RedPoint.getRemind",
		["p"] = {
			["type"] = mType,
		}
	}))
	:setShowLoading(false)
	:send(function(response, request)
		print("one min get message list")
		qy.tank.model.MessageModel:setMessageList(response.data.list)
		onSuccess(response.data.list)
	end)
end

return RedDotService