--[[--
	合金服务器
	Author: H.X.Sun
--]]

local AlloyService = qy.class("AlloyService", qy.tank.service.BaseService)

local AlloyModel = qy.tank.model.AlloyModel

--嵌入
function AlloyService:embed(params, callback)
	local _pos = "p_" .. params.alloyEntity.alloy_id
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "alloy.embed",
        ["p"] = {
        	["type"] = params.equipEntity:getComponentEnglishName(),
    		["equip_unique_id"] = params.equipEntity.unique_id,
    		["pos"] = _pos,
    		["alloy_unique_id"] = params.alloyEntity.unique_id,
        },
    })):send(function(response, request)
        AlloyModel:updateAlloyPos(response.data.alloy)
        AlloyModel:setAddFightPower(response.data.add_fight_power)
        params.equipEntity:updateAlloy(_pos,params.alloyEntity.unique_id)
        callback(response.data)
    end)
end

--卸下
function AlloyService:unload(params, callback)
    local _pos = "p_" .. params.alloyEntity.alloy_id
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "alloy.unload",
        ["p"] = {
            ["type"] = params.equipEntity:getComponentEnglishName(),
            ["equip_unique_id"] = params.equipEntity.unique_id,
            ["pos"] = _pos,
        },
    })):send(function(response, request)
        AlloyModel:updateAlloyPos(response.data.alloy)
        AlloyModel:setAddFightPower(response.data.add_fight_power)
        params.equipEntity:updateAlloy(_pos,0)
        callback(response.data)
    end)
end

--升级
-- 需要升级的合金唯一ID:unique_id:int:
-- 被吞噬的合金唯一ID列表:eated_ids:string:
function AlloyService:upgrade(entity, callback)
    -- print("AlloyModel:getSelectUpStr()====>>>",AlloyModel:getSelectUpStr(entity.alloy_id))
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "alloy.upgrade",
        ["p"] = {
            ["unique_id"] = entity.unique_id,
            ["eated_ids"] = AlloyModel:getSelectUpStr(entity.alloy_id),
        },
    })):send(function(response, request)
        AlloyModel:afterUpgradToRefresh(response.data.alloy,entity)
    	AlloyModel:setAddFightPower(response.data.add_fight_power)
        callback(response.data)
    end)
end

--一键合金
function AlloyService:batchUpgrade(entity, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "alloy.batchUpgrade",
        ["p"] = {
            ["unique_id"] = entity.unique_id,
        },
    })):send(function(response, request)
		AlloyModel:afterUpgradToRefresh(response.data.alloy,entity)
    	AlloyModel:setAddFightPower(response.data.add_fight_power)
        callback(response.data)
    end)
end

return AlloyService
