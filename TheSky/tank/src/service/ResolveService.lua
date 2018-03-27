--[[
    分解
    Author: mingming
    Date: 2015-09-14
]]

local ResolveService = qy.class("ResolveService", qy.tank.service.BaseService)

local model = qy.tank.model.ResolveModel

function ResolveService:resolve(idx, callback) 
    qy.Http.new(qy.Http.Request.new({
        ["m"] = idx == 2 and "equip.apart" or "tank.apart",
        ["p"] = {
            ["id"] = model:getSelectParams(idx)
        }
    })):send(function(response, request)
        if idx == 1 then
            if response.data.eated_tank then
                qy.tank.model.GarageModel:removeResolveList(response.data.eated_tank)
                model:removeResolveList(response.data.eated_tank, idx)
            end

            if response.data.tank then
                for i, v in pairs(response.data.tank) do
                    qy.tank.model.GarageModel.unselectedTanks_[tostring(i)]:__initByData(v)
                end
            end
        else
            if response.data.unset_equip then
                qy.tank.model.EquipModel:removeResolveList(response.data.unset_equip)
                model:removeResolveList(response.data.unset_equip, idx)
            end

            if response.data.update_equip then
                qy.tank.model.EquipModel:updateResolveList(response.data.update_equip)
                model:removeResolveList(response.data.update_equip, idx)
            end         
        end
        -- self.model:getList(response.data)
        callback(response.data)
    end)
end

return ResolveService