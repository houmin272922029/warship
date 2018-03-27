
 --[[
	签到
	Author: fq
	Date: 2016年08月05日15:02:10
]]

local AnniverPayService = qy.class("AnniverPayService", qy.tank.service.BaseService)

local model = qy.tank.model.AnniverPayModel



-- 获取
function AnniverPayService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "anniver_pay"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end






return AnniverPayService



