--[[

]]--

local FireRebateService = qy.class("FireRebateService", qy.tank.service.BaseService)

local model =  qy.tank.model.FireRebateModel




--[[
    领取界面的奖励
]]--
function FireRebateService:GetgetawardData(type,extend,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.getaward",
        ["p"] = {["activity_name"] = "fire_line_rebate",["type"]=type,["extend"]=extend}
    })):send(function(response, request)
        model:getawardData(response.data,type)
        callback(response.data)
    end)
end

-- 获取道具&装备列表
function FireRebateService:propsList( param, callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "shop.propsList",
    })):send(function(response, request)
        self.propModel:updateAllConsume(response.data.list)
        callback()
    end)
end

return FireRebateService
