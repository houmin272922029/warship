--[[
    进阶服务
    Author: Your Name
    Date: 2015-05-26 16:12:18
]]

local AdvanceService = qy.class("AdvanceService", qy.tank.service.BaseService)

function AdvanceService:doAdvance(entity, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "tank.advance",
        ["p"] = {["id"] = entity.unique_id}
    })):send(function(response, request)
        -- qy.tank.model.ArenaModel:init(response.data)
        entity:__initByData(response.data.tank[tostring(entity.unique_id)])

        local param = {}
                
        param["100"] = response.data.add_fight_power
        local data_ = qy.tank.model.AdvanceModel:getAddAttribute(param)
        qy.tank.utils.HintUtil.showSomeImageToast(data_)
        callback()
    end)
end

return AdvanceService