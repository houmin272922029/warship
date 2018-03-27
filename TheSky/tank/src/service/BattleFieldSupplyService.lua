--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local BattleFieldSupplyService = qy.class("BattleFieldSupplyService", qy.tank.service.BaseService)

local model = qy.tank.model.BattleFieldSupplyModel
-- 获取
function BattleFieldSupplyService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "battlefield_supply"}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


function BattleFieldSupplyService:buy(callback, id)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "battlefield_supply", ["id"] = id}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end



return BattleFieldSupplyService

