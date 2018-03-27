--[[
	每日好礼
]]
local Service = qy.class("Service", qy.tank.service.BaseService)
Service.model = require("sign_in_gifts.src.Model")



function Service:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getInfo",
        ["p"]= {["activity_name"]= "day_mark"}
    })):send(function(response, request)
        self.model:init(response.data.activity_info)
        callback()
    end)
end

function Service:getAward(type_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getaward",
        ["p"]= {["activity_name"]= "day_mark",
        ["type"]=type_id     }
    })):send(function(response, request)
        -- self.model:update(copy_id,id,response.data)
        -- qy.tank.model.BattleModel:init(response.data.fight_result)
        -- qy.tank.manager.ScenesManager:pushBattleScene()
        callback(response)        
    end)
end


return Service
