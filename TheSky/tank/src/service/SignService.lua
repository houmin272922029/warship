
 --[[
	签到
	Author: fq
	Date: 2016年08月05日15:02:10
]]

local SignService = qy.class("SignService", qy.tank.service.BaseService)

local model = qy.tank.model.SignModel



-- 获取
function SignService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "sign"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end




function SignService:getAward(callback, _type, _id)
    local param = {}

    param = {["type"] = _type} 

    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.sign_award",
       ["p"] = param
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end





return SignService



