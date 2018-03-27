--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local BattleFieldStoreService = qy.class("BattleFieldStoreService", qy.tank.service.BaseService)

local model = qy.tank.model.BattleFieldStoreModel
-- 获取
function BattleFieldStoreService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "battlefield_store"}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


function BattleFieldStoreService:buy(callback, id)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "battlefield_store", ["id"] = id}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end



return BattleFieldStoreService



