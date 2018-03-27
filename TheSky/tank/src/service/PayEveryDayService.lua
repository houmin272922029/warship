--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local PayEveryDayService = qy.class("PayEveryDayService", qy.tank.service.BaseService)

local model = qy.tank.model.PayEveryDayModel
-- 获取
function PayEveryDayService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "pay_everyday"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


function PayEveryDayService:getAward(callback, _type, _cash)
    local param = {}

    param = _type == 200 and   {["activity_name"] = "pay_everyday", ["type"] = _type} or {["activity_name"] = "pay_everyday", ["type"] = _type, ["cash"] = _cash}

    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = param
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


return PayEveryDayService



