--[[
	战狼归来
]]
local Service = qy.class("Service", qy.tank.service.BaseService)
Service.model = require("fight_the_wolf.src.Model")

--[[function Service:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.getInfo",
        ["p"] = {["activity_name"]="super_limit_time_sale"}
    })):send(function(response, request)
        self.model:init(response.data.activity_info)
        callback()
    end)
end]]

function Service:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getInfo",
        ["p"]= {["activity_name"]= "war_wolf"}
    })):send(function(response, request)
        self.model:init(response.data.activity_info)    
        callback()
    end)
end
--攻打
function Service:getAward(copy_id,id,type_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getaward",
        ["p"]= {["activity_name"]= "war_wolf",
             ["fight_id"]=id,
              ["type"]=type_id     }
    })):send(function(response, request)
        self.model:update(copy_id,id,response.data)
        qy.tank.model.BattleModel:init(response.data.fight_result)
        qy.tank.manager.ScenesManager:pushBattleScene()
        callback(response)        
    end)
end
--领奖
function Service:getAward1(id,type_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getaward",
        ["p"]= {["activity_name"]= "war_wolf",
             ["fight_id"]=id,
              ["type"]=type_id     }
    })):send(function(response, request)
        self.model:update1(id,response.data)              
        callback(response)
    end)
end

return Service
