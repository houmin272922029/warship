--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local KeluboTreasuryService = qy.class("KeluboTreasuryService", qy.tank.service.BaseService)

local model = qy.tank.model.KeluboTreasuryModel
-- 获取
function KeluboTreasuryService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "kelubo_treasury"}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end




return KeluboTreasuryService



