--[[
	限时秒杀
]]
local Service = qy.class("Service", qy.tank.service.BaseService)
Service.model = require("time_limit_spike.src.Model")


function Service:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getInfo",
        ["p"]= {["activity_name"]= "limit_seckill"}
    })):send(function(response, request)
       self.model:init(response.data.activity_info)
        callback()
    end)
end

--
function Service:getAward(step,id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getaward",
        ["p"]= {["activity_name"]= "limit_seckill",
        ["id"]= id,
        ["step"]=step     }
    })):send(function(response, request)
        
        callback(response)        
    end)
end

function Service:getList(step,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getaward",
        ["p"]= {["activity_name"]= "limit_seckill",
        ["step"]=step     }
    })):send(function(response, request)
        self.model:initlist(response.data.list)
        callback(response.data.list)        
    end)
end



return Service
